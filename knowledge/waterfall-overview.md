# Waterfall Overview

The 6-phase content waterfall that runs every time the agent generates content for its champion. Each phase feeds the next sequentially.

## The Phases

```
PHASE 1: SEARCH SLACK CONTEXT
  - Search the champion's recent Slack messages (last 48h, substantive only)
  - Read feature announcement channels (#features-intel-changelog, #product-marketing-sync)
  - Scan #feat-* channels matching the champion's topics
  - Filter, score, return 3-10 fresh signals

PHASE 2: CHECK INSPIRATION ACTIVITY
  - Load champion's inspirations (3-5 people they follow)
  - For each: check what they posted on LinkedIn/X in the last 7 days
  - Use OctoLens for indexed authors (cheap)
  - Use Bright Data scrape for non-indexed (expensive, cached daily)
  - Return per-inspiration recent posts + suggested response angles

PHASE 3: LOAD CHAMPION VOICE
  - Read champion's identity, tone-of-voice, style preferences, rules
  - Read last 30 days of delivered content (avoid duplicate angles)
  - All voice context now in working memory

PHASE 4: WRITE CONTENT (2-3 variations)
  - Synthesize Phases 1+2+3 into the strongest signal
  - Pick the angle: Slack feature? Inspiration echo? Personal experience?
  - Generate 2-3 variations using DIFFERENT angles
  - Each variation grounded in a specific real source

PHASE 5: VOICE GUARDIAN SCORING
  - Score each variation on the 10-point checklist
  - Apply per-champion overrides
  - Auto-rewrite 7-8 scores (max 2 attempts)
  - Drop variations scoring below 7
  - Require at least 1 variation passes 9+ before delivery

PHASE 6: DELIVER VIA SLACK
  - Format approved drafts with the daily-digest template
  - Send DM to the champion
  - Log to content history
  - Listen for replies (handled by feedback skill)
```

## Why The Order Matters

**Phase 1 before Phase 2:** Slack signals are internal and specific. Inspiration activity is external and broader. We want internal context first because it's more grounding.

**Phase 2 before Phase 3:** We need to know what's hot in the champion's network BEFORE loading their voice — otherwise we might write a perfectly-voiced post about something nobody is talking about.

**Phase 3 before Phase 4:** Voice loading must happen before writing. Otherwise the writer falls back to generic LLM patterns.

**Phase 4 before Phase 5:** Generation must precede scoring. Generate broadly, score strictly.

**Phase 5 before Phase 6:** Score before delivery. Never deliver content that hasn't passed Voice Guardian 9+.

## Phase Independence

Each phase can be skipped if its dependencies aren't available:

- **Phase 1 skipped** if Slack MCP unavailable → continue with Phase 2 + champion knowledge
- **Phase 2 skipped** if no inspirations configured → continue with Phase 1 + champion knowledge
- **Phase 3 skipped** never — voice context is required
- **Phase 4 skipped** never — generation is required
- **Phase 5 skipped** never — scoring is required
- **Phase 6 skipped** if Slack delivery fails → preserve drafts in chat for manual review

## Total Runtime

- Phase 1: 15-30 seconds (Slack searches)
- Phase 2: 10-50 seconds (depends on cache hit rate)
- Phase 3: 1-2 seconds (file reads)
- Phase 4: 15-30 seconds (LLM generation)
- Phase 5: 10-20 seconds (per-variation scoring)
- Phase 6: 2-5 seconds (Slack DM send)

Total: ~45-90 seconds per champion per generation.

## Failure Modes

| Failure | Recovery |
|---------|----------|
| Slack MCP down | Skip Phase 1, continue with inspirations only |
| OctoLens MCP down | Skip OctoLens in Phase 2, fall back to Bright Data |
| Bright Data quota exhausted | Use cached inspiration data from earlier in day |
| All variations score < 7 | Drop the day, log "no shippable content" |
| Slack DM send fails | Preserve drafts in Memory, retry on next run |
| Champion has no Slack history | Phase 1 returns empty, agent proceeds with Phase 2 only |

## What The Champion Sees

The champion sees nothing about the waterfall. They get a Slack DM at 9am that says:

> "Good morning [Name]! Here are today's drafts:
> 
> Option 1 — Personal experience angle
> [draft text]
> 
> Option 2 — Industry insight angle
> [draft text]
> 
> Reply 1 or 2 to mark posted, or 'not my style' + feedback."

The 90 seconds of waterfall execution happens silently in the background. The champion's experience is: open Slack, see drafts, copy one, post it.
