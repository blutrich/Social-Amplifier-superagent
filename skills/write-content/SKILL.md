---
name: write-content
description: Phase 4 of waterfall. Generates 2-3 LinkedIn draft variations grounded in real Slack/inspiration signals and champion voice. Triggers on "write content", "phase 4", "generate drafts", "draft posts".
---

# write-content

Phase 4 of the waterfall. Synthesizes Slack signals + inspiration activity + champion voice into 2-3 distinct LinkedIn drafts.

## When To Run

After Phases 1-3 (Slack, inspirations, voice loaded). Before Phase 5 (Voice Guardian scoring).

## Inputs

- `slack_signals` from Phase 1 (3-10 fresh signals)
- `inspiration_activity` from Phase 2 (per-inspiration recent posts)
- `voice_context` from Phase 3 (complete voice profile)
- Optional: explicit topic from operator if provided

## What It Does

1. Picks the strongest signal across all sources (rank by leverage)
2. Generates 2-3 variations using DIFFERENT angles
3. Each variation grounded in real specific source material
4. Each variation respects the champion's voice and style preferences
5. Returns the variations to Phase 5 for scoring

## Strongest Signal Selection

Rank signals by leverage:

| Source | Leverage | Why |
|--------|---------|-----|
| Champion's own Slack message about a topic | 10 | They already cared enough to write about it |
| Inspiration is currently posting about a topic | 9 | Built-in audience overlap, network effects |
| Slack feature ship in champion's topic area | 9 | Concrete artifact, internal credibility |
| External trending topic | 7 | Current narrative, no internal anchor |
| Operator-provided topic | 5 | Picked for a reason but no auto-grounding |
| No signal | 0 | Skip the day - silence is better than noise |

If no signal scores 5 or higher, return empty and skip generation. Don't fabricate.

## The 3 Standard Angles

### Angle 1: Personal Experience / Internal Anchor

**Best when:** Slack signals provide a specific recent feature, project, or moment

**Template:**
```
[Hook: news-trigger or personal action]
[Concrete specific detail from Slack or work]
[The math or numbers that show why it matters]
[Aphoristic close]
```

### Angle 2: Echo Response

**Best when:** An inspiration just posted about a topic the champion has authority on

**Template:**
```
[Hook: respond to or build on what an inspiration said]
[Quote or paraphrase the inspiration's point]
[Champion's specific add — what the inspiration missed or got right]
[Grounded in champion's actual work]
[Aphoristic close]
```

### Angle 3: Reflection / Connecting Threads

**Best when:** Multiple signals point to the same theme

**Template:**
```
[Hook: observation across multiple recent things]
[Specific examples - reference 2-3 concrete things that connect]
[The pattern that connects them]
[What this means going forward]
```

## Generation Constraints

For every variation, the writer must:

- Use the champion's actual sentence patterns from voice_context
- Stay within word count limits from style preferences (LinkedIn 150-300, X 280 chars)
- Respect banned words (universal + champion-specific add list)
- Respect structural rules (em dashes, rule of three, hashtags, emojis)
- Ground in a specific real source — never write from generic LLM knowledge
- Avoid angles already used in the last 7 days (per voice_context.recent_history)

## Self-Check Before Output

Before passing variations to Phase 5, run a quick self-check:

```
for each variation:
  if any banned word from style_preferences.banned_words_add appears: regenerate
  if "thrilled to announce" or similar HARD-BAN phrase: regenerate
  if hashtag count > champion's hashtag_max: regenerate
  if em dash count > 2 AND em_dashes:deny: regenerate
  if word count below word_count_min: regenerate
  if word count above word_count_max: trim
```

Max 2 regeneration attempts per variation. If still failing after 2, drop the variation.

## Output Format

```yaml
variations:
  - rank: 1
    angle: personal-experience
    primary_signal_source: slack
    grounded_in:
      - "Slack message: 'Shipped Voice Guardian this week' (#feat-voice-guardian)"
      - "Inspiration: Aakash Gupta posted about Anthropic ship button (6h ago)"
    text: |
      [Full draft text - LinkedIn-ready, no markdown]
    estimated_voice_match: 9
    word_count: 220
  
  - rank: 2
    angle: echo-response
    primary_signal_source: inspiration
    grounded_in:
      - "Aakash Gupta tweet about Anthropic ship button (6h ago, 650 reactions)"
    text: |
      [Full draft text]
    estimated_voice_match: 8
    word_count: 240
```

## When To Generate Fewer Than 3

- If no inspiration activity → skip the echo-response variation
- If no Slack signals → skip the personal-experience variation
- If no signal at all → return empty, don't generate generic content
- If only 1 strong signal → return 1-2 variations on different angles of that signal

The minimum is 1 strong variation. The maximum is 3. Better to deliver 1 great draft than 3 mediocre ones.

## Integration With Phase 5 (Voice Guardian)

Each variation gets scored by Phase 5. The Voice Guardian applies the 10-point checklist with per-champion overrides. Variations scoring 9+ pass through to Phase 6 (delivery). 7-8 get auto-rewritten. Below 7 gets dropped.

If after Phase 5 zero variations have scores 9+, the writer (this skill) is asked to regenerate from scratch with feedback on what failed. Max 1 regeneration cycle, then the day is skipped.
