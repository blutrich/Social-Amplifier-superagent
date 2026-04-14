#!/usr/bin/env bash
# Fail if any banned term appears in any bundle file (except allowed exceptions).
# Usage: scripts/lint-banned-terms.sh
#
# Exit codes:
#   0 — clean
#   1 — one or more banned terms found
#
# Maintained because the repo keeps accumulating stale references when a
# deprecated tool or pattern is replaced. This catches regressions on commit.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO_ROOT"

BANNED_FILE=".banned-terms"
if [[ ! -f "$BANNED_FILE" ]]; then
  echo "ERROR: $BANNED_FILE not found"
  exit 2
fi

# Files to scan: everything tracked by git, except the banned-terms file itself,
# the lint script, any CHANGELOG.md, and files in docs/setup-apify-feeder.md
# (which legitimately documents APIFY_TOKEN as a Feeder-side secret).
EXCLUDE='\.banned-terms$|scripts/lint-banned-terms\.sh$|CHANGELOG\.md$|docs/setup-apify-feeder\.md$|\.git/'

fail=0

while IFS= read -r term; do
  # Skip blank lines and comments
  [[ -z "$term" ]] && continue
  [[ "$term" =~ ^# ]] && continue

  # grep for the term across tracked files, excluding the allowlist above
  matches=$(git ls-files | grep -Ev "$EXCLUDE" | xargs grep -Hn -- "$term" 2>/dev/null || true)

  if [[ -n "$matches" ]]; then
    echo "❌ Banned term found: \"$term\""
    echo "$matches" | sed 's/^/    /'
    echo ""
    fail=1
  fi
done < "$BANNED_FILE"

if [[ "$fail" -eq 1 ]]; then
  echo "Lint failed. Remove the banned terms above, or if one is legitimately"
  echo "needed, update .banned-terms and the allowlist in scripts/lint-banned-terms.sh."
  exit 1
fi

echo "✅ Lint clean — no banned terms found"
exit 0
