---
name: check-inspirations
description: Phase 2 of waterfall. Checks what champion inspirations posted on LinkedIn/X this week via OctoLens or Bright Data. Triggers on "check inspirations", "phase 2", "inspiration activity".
---

# check-inspirations

Phase 2 of the waterfall. Checks what the champion's inspirations are posting on LinkedIn/X this week.

## When To Run

After search-slack-context (Phase 1), before loading champion voice (Phase 3).

## What It Does

1. Loads the champion's inspirations list (from Memory or knowledge file)
2. For each top 3-5 inspiration:
   - Tries OctoLens batch query first (cheap)
   - Falls back to Bright Data scrape if not in OctoLens (expensive, cached daily)
3. Extracts what topics each inspiration posted about in the last 7 days
4. Identifies which inspiration topics overlap with the champion's interests
5. Returns a per-inspiration map of recent activity + suggested response angles

## Required Tools

- OctoLens connector (preferred, fast)
- Bright Data connector (fallback, expensive)
- Web search (last-resort fallback)

## Why This Matters

Inspirations are people the champion explicitly wants to learn from or sound like. When they post:

1. The topic is current (worth their time today)
2. The angle is one the champion's audience cares about (shared readership)
3. The voice patterns are validated (the inspirations write the way the champion aspires to)

When the champion responds to or builds on an inspiration's post, the response gets:
- Built-in audience (the inspiration's followers might engage)
- Pre-validated topic relevance
- Network effects (the inspiration might respond back)

This is the highest-leverage external signal.

## Approach 1: OctoLens (Try First)

```
mcp__octolens__list_mentions(
  filters={
    "startDate": "{7_days_ago_ISO}"
  },
  limit=100
)
```

Filter response by `author` matching any of the inspiration handles. Single call covers all inspirations at once.

## Approach 2: Bright Data Scrape (Fallback)

For inspirations not indexed in OctoLens:

```
mcp__brightdata__scrape_as_markdown(
  url="https://www.linkedin.com/in/{inspiration_handle}/"
)
```

Parse posts from last 7 days. Cache results for 24 hours per inspiration.

## Caching Rule

Cache inspiration scrapes for 24 hours:

```
.cache/inspiration-activity/{handle}-{YYYY-MM-DD}.json
```

Multiple champions sharing inspirations all read from the same cache, so checking 5 champions with the same inspiration only costs 1 scrape.

## Output Format

```yaml
inspiration_activity:
  status: ok | partial | empty
  inspirations_checked: 5
  inspirations_with_recent_activity: 3
  
  active_inspirations:
    - rank: 1
      name: "Aakash Gupta"
      handle: "@aakashgupta"
      relevance_score: 9
      recent_posts:
        - timestamp: "2026-04-13T04:00:00Z"
          age_hours: 6
          body_excerpt: "Anthropic is about to mass-extinction event..."
          engagement: high
          topics: ["AI startup landscape", "vibe coding category"]
      summary: "Aakash dominating the 'Anthropic killing vibe coding' narrative this week"
      suggested_response_angle: "As someone building at one of those startups, here's what the narrative misses..."
  
  inactive_inspirations:
    - name: "Mike Krieger"
      reason: "No posts in last 7 days"
```

## Banned Inspirations Check

Before processing any inspiration, check the banned list from `inspiration-seeds.json`. If an inspiration matches:
- Banned person directly → skip
- Banned company pattern → skip CEO/marketing roles, allow individual engineers case-by-case
- Banned via champion's own preferences → skip

Never include banned inspirations in output. Log skips with reason.

## When To Skip

- No inspirations configured for this champion → return empty status with recommendation to enrich profile
- All inspirations inactive in last 7 days → return empty, waterfall continues without inspiration grounding
- OctoLens + Bright Data both unavailable → return error, waterfall continues with Slack signals only

## Integration With Phase 4 (Write Content)

Inspiration activity becomes the primary grounding for the "echo response" variation angle. The writer uses an inspiration's recent post as the anchor: "[Inspiration] said X this morning. I'd add Y from my work on Z."

The `suggested_response_angle` field is consumed directly by Phase 4 — it's a preview of how the variation should be framed.
