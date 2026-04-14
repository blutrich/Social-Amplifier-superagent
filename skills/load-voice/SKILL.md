---
name: load-voice
description: Phase 3 of waterfall. Loads champion tone-of-voice, style preferences, and recent delivery history into working context. Triggers on "load voice", "phase 3", "load champion profile".
---

# load-voice

Phase 3 of the waterfall. Loads the champion's voice profile into working memory before generation.

## When To Run

After Phases 1+2 (Slack + inspirations), before Phase 4 (write content).

## What It Does

1. Reads the champion's tone-of-voice file (from Memory or Knowledge)
2. Reads style preferences (em dashes allowed, emoji max, banned words, etc.)
3. Reads any rules.md file (additional behavioral constraints)
4. Reads the last 30 days of delivered content history (avoid duplicate angles)
5. Returns the complete voice context as a single working object

## Required Tools

- File system read (built-in to Superagent)

## Output Format

```yaml
voice_context:
  identity:
    name: "Dor Blech"
    persona: "comms"
    timezone: "Asia/Jerusalem"
  
  tone_of_voice:
    voice_summary: "..."
    register: "..."
    energy_level: "..."
    sentence_length: "..."
    vocabulary_register: "..."
    humor_frequency: "..."
    sample_passages: [...]
  
  style_preferences:
    em_dashes: allow | deny
    emoji_max: 2
    hashtag_max: 0
    banned_words_add: [...]
    banned_words_remove: [...]
  
  rules:
    always: [...]
    never: [...]
    avoid: [...]
  
  recent_history:
    last_30_days_count: 12
    angles_used: ["personal-experience", "echo-response", "personal-experience", ...]
    topics_covered: ["AI infrastructure", "voice profile work", ...]
    avoid_repeating: ["voice-guardian-quality-gate (covered 5 days ago)"]
```

## Why This Phase Matters

If the writer doesn't have the champion's voice loaded BEFORE generating, it falls back to generic LLM patterns. The output sounds like a generic "tech professional" — fine but not the specific person.

Loading the voice context gives Phase 4 (writer) a complete picture of:
- How this person writes (sentence patterns, vocabulary)
- What they avoid (banned words, structures)
- What they've already covered (avoid duplicates)
- What angles they prefer (from history)

## Integration With Phase 4 (Write Content)

Phase 4 receives the full voice_context object and uses it to:

1. Set generation constraints (sentence length, emoji count, banned words)
2. Match observed patterns (TL;DR format, em dashes if allowed, etc.)
3. Avoid repeating recent angles (don't write "personal experience" 3 days in a row)
4. Apply per-champion overrides on top of universal rules

## Recent History Analysis

Read the last 30 days of `delivered_content/` files. For each file, extract:
- Date
- Subject/topic
- Angle template (personal-experience, echo-response, reflection)
- Voice Guardian score

Build a freshness map:
- Topics covered in last 7 days → high penalty in Phase 4 selection
- Topics covered in last 14 days → medium penalty
- Topics covered in last 30 days → low penalty
- Topics never covered → no penalty

Pass this map to Phase 4 so the writer can avoid repetition.

## When To Skip

Never. Voice loading is mandatory. Without it, generation falls back to generic patterns and the Voice Guardian will reject everything in Phase 5 anyway.

If voice files are missing or corrupted, use defaults from `champion-tone-template.md` and log "fallback_to_defaults" so the operator knows to fix the profile.
