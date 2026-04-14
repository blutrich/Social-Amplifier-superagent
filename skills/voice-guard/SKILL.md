---
name: voice-guard
description: Phase 5 of waterfall. Scores each draft on the 10-point Voice Guardian rubric with per-champion overrides. Rejects anything below 9. Triggers on "voice guard", "phase 5", "score drafts", "check voice".
---

# voice-guard

Phase 5 of the waterfall. Scores each generated variation against the 10-point Voice Guardian checklist with per-champion overrides.

## When To Run

After Phase 4 (write content), before Phase 6 (deliver). Once per variation.

## What It Does

1. Loads the universal AI tells list from knowledge files
2. Loads the champion's per-champion style preferences
3. Loads the platform rules (LinkedIn vs X format)
4. Scores the variation on each of the 10 checklist items
5. Decides verdict: APPROVED, REWRITE, or REJECT
6. If REWRITE, applies fixes and re-scores (max 2 attempts)
7. Returns final verdict + score to caller

## Required Knowledge Files

- `voice-guardian-checklist.md` (the 10-point checklist with criteria)
- `universal-ai-tells.md` (banned words, phrases, structures)
- `platform-rules.md` (LinkedIn + X format specs)
- Champion's tone-of-voice file
- Champion's style-preferences file

## The 10-Point Checklist

See `voice-guardian-checklist.md` for full criteria. Quick summary:

1. No AI vocabulary
2. No AI structure (em dashes, rule of three, etc.)
3. No AI phrases (corporate announcements, engagement bait)
4. Matches champion tone
5. Uses champion topics
6. Feels personal (specific details)
7. The Champion Test (would they actually post this?)
8. Correct format (length, paragraphs, hook position)
9. No link/emoji violations
10. Not corporate

Each scores PASS (1) or FAIL (0). Total: 0-10.

## Verdict Thresholds

- **9-10/10 → APPROVED.** Ship it. Return to caller with verdict and score.
- **7-8/10 → REWRITE.** Apply rewrite patterns to fix failing items. Re-score. If 9+, ship. If still 7-8, try once more. Drop after 2 attempts.
- **Below 7 → REJECT.** Don't try to fix. Return verdict to caller with feedback for regeneration.

## Per-Champion Override Logic

Universal rules apply to all champions. But per-champion overrides relax SOME rules:

- `em_dashes: allow` → item 2 ignores em dashes
- `emoji_max: 5` → item 9 allows up to 5 emojis instead of 2
- `hashtag_max: 0` → item 9 fails ANY hashtag
- `banned_words_add: ["frankly"]` → item 1 also fails on "frankly"
- `banned_words_remove: ["deep dive"]` → item 1 ignores "deep dive" if champion uses it naturally

Hard-ban items (corporate phrases, engagement bait, contrast framing) cannot be overridden. Always fail on these regardless of preferences.

## Rewrite Patterns

When a variation scores 7-8 and needs rewriting:

### Fix banned vocabulary (item 1)
Replace each banned verb/adjective with a specific concrete word from the champion's actual vocabulary. Never replace with another generic AI word.

### Fix em dashes (item 2)
Check champion preferences first. If `em_dashes: deny`, replace each em dash with comma, period, or parentheses based on context.

### Fix rule of three (item 2)
Add a 4th item to break the triple, OR remove the structure entirely and write a single concrete sentence.

### Fix self-narration (item 2)
Delete the "Here's why this matters:" type opener. The sentence after it almost always works better on its own.

### Fix corporate tone (item 10)
Switch from "we" (brand voice) to "I" (champion voice). Replace announcements with personal observations.

### Fix generic content (item 6)
Add a specific named person, real number, or concrete scenario. If you can't add specifics, reject instead of rewriting.

### Fix length violations (item 8)
- Too long: cut the middle, preserve hook and payoff
- Too short: usually means content is too thin → reject
- Wall of text: add line breaks between logical sections

### Fix tone mismatch (item 4)
Re-read 2-3 of the champion's real samples. Rewrite the variation as if the champion were writing it from scratch. Keep the core point and structure, change the voice completely.

## Output Format

```yaml
voice_guardian_review:
  champion: "Dor Blech"
  platform: "linkedin"
  variation_text: "[full text]"
  score: 9
  verdict: APPROVED | REWRITE | REJECT
  
  checklist:
    - item: 1
      name: "No AI vocabulary"
      status: PASS | FAIL
      note: "..."
    - item: 2
      name: "No AI structure"
      status: PASS | FAIL
      note: "Em dashes present but champion has em_dashes:allow override"
    # ... all 10 items
  
  rewrite_attempted: true | false
  rewrite_attempts: 1
  
  if_reject:
    reason: "Specific explanation of what went wrong"
    regeneration_feedback: "Try a different angle - this one failed because..."
```

## When To Reject Without Rewriting

Reject (don't rewrite) when:

- Score below 7 on first pass
- Two rewrite attempts both fail
- Core angle doesn't match champion's topics (item 5 fail)
- Content requires adding specific details that don't exist in source material
- Tone mismatch can't be fixed without actually knowing the champion better

When rejecting, return specific feedback so Phase 4 can regenerate with a different approach.

## Calibration Note

After deployment, track correlation between Voice Guardian scores and actual champion approval rates (did they post the draft?). If 9-scored drafts routinely get rejected by champions, the scoring is too lenient on something. If 7-scored drafts routinely get approved, the scoring is too strict.

Adjust per-champion overrides based on this signal over time. The Voice Guardian gets better at predicting "would Dor actually post this?" through real feedback.
