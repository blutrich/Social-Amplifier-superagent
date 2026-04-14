---
name: check-inspirations
description: Phase 2 of waterfall. Reads the shared #social-champions-octolens-feed Slack channel (primary) then per-champion inspirations list (Apify) to find what's worth echoing this week. Triggers on "check inspirations", "phase 2", "inspiration activity".
---

# check-inspirations

Phase 2 of the waterfall. Finds what the champion's inspirations posted in the last 7 days and surfaces the strongest echo opportunities.

## When To Run

After `search-slack-context` (Phase 1), before `load-voice` (Phase 3).

## Single Source: Shared Slack Feed Channel

Read `knowledge/inspiration-seeds.json` → `social_amplifier_feed` for the current channel config.

**The only source is** `#social-champions-octolens-feed` (channel ID `C0ATMPHHM40`). Two feeder systems post into it server-side:
- **OctoLens** posts brand mentions, competitor signals, and tagged social content
- **Apify Inspiration Feeder** (a separate Base44 app, app id `69de4f68f7667dfd280537e5`) posts LinkedIn + X profile scrapes for the shared inspirations list on a 6h cron

Champions read the channel via their own Slack connector. **No champion agent holds an Apify token, an OctoLens token, or calls web search.** All scraping runs server-side in the feeders.

The champion's `champion_inspirations` list (from Interview answer #6) is a **filter**, not a scraping target. It boosts relevance for matching authors when reading feed messages. If the feed has no messages matching the inspirations this week, return `status: partial` — do not attempt any other source.

## Primary Source: Shared Slack Feed

Read the channel via the Slack connector. Channel ID and name come from `inspiration-seeds.json` → `social_amplifier_feed`.

```
slack_conversations_history(
  channel="C0ATMPHHM40",
  oldest={7_days_ago_unix},
  limit=200
)
```

The messages in this channel are OctoLens mentions posted by OctoLens' Slack app. Each message typically contains:
- Author name + handle
- Source platform (Twitter/X, LinkedIn, Reddit, HN, dev.to, YouTube, etc.)
- Original post text or summary
- Permalink
- Sometimes: sentiment tag, category tag, engagement count

**Parsing rules:**
- Skip bot-only metadata messages (acks, error notices, system pings)
- Extract author handle from the message text (usually in the format `@handle`, `linkedin.com/in/X`, or `twitter.com/X`)
- Extract the original post URL (permalink or source link)
- Extract post timestamp if present, else use Slack message ts
- Match against the champion's `champion_inspirations` list — mentions from those specific authors get a relevance boost

**Filtering:**
- Drop mentions older than 7 days (`oldest` filter + post-parse check)
- Drop messages with no parseable author (skip, don't fail)
- Drop mentions flagged banned in `inspiration-seeds.json` → `banned_competitors`

**Scoring:**
- `+3` if the author matches the champion's explicit inspirations list
- `+2` if the author matches a persona-default from `inspiration-seeds.json`
- `+2` if the source platform is LinkedIn or X (what champions post to)
- `+1` if engagement count is high relative to the author's baseline
- `-1` if the mention is a retweet/share without original commentary

Keep the top 5 after scoring.

## Fallback: Phase 1 signals only

If the shared feed channel returns zero matches for the champion's inspirations this week, **do not** attempt any other source. The champion agent does NOT:
- Hold an Apify token (Apify runs server-side in the Feeder app — a separate Base44 app)
- Hold an OctoLens token (OctoLens posts directly into the feed channel; no direct MCP call)
- Call web search during scheduled runs (web search produces low-signal content that poisons Voice Guardian scoring)

Instead, return `status: partial` with `source_used: slack_feed` and an empty `top_mentions` array. Phase 4 then generates variations using **only** the Phase 1 Slack signals. No echo-angle draft, just personal-experience and reflection angles grounded in the champion's own Slack activity.

**Why no fallback scraping:** the whole v3 architecture moves scraping server-side to keep champion agents stateless and tokenless. Re-adding a per-champion scrape path would contradict that. If the feed is empty, the correct answer is honesty (partial output), not fabrication from alternate sources.

**If the feed channel is unreachable entirely** (agent not a member, channel archived, Slack outage), return `status: error` with the specific reason. Phase 4 still runs on Phase 1 signals. The error surfaces in the Phase D Summary gaps section so the operator knows to fix the Feeder.

## Banned Inspirations Check

Before processing any inspiration from ANY source, check the banned list in `inspiration-seeds.json` → `banned_competitors`. If an author matches:
- Banned person directly → skip
- Banned company pattern → skip CEO/marketing roles, allow individual engineers case-by-case
- Banned via champion's own `style-preferences.md` → skip

Never include banned inspirations in output. Log skips with reason.

## When To Skip The Phase Entirely

- Slack feed has 0 messages in the last 7 days → return `status: empty`, waterfall continues with Phase 1 signals only
- Slack feed has messages but 0 match the champion's inspirations list → return `status: partial`, same fallback
- Slack feed unreachable (channel not joined, archived, API error) → return `status: error` with reason, waterfall continues with Phase 1 data only, operator notified via Phase D Summary gaps
- Better partial than fabricated. Never invent posts. Never call web search to fill the gap.

## Output Format

```yaml
inspiration_activity:
  status: ok | partial | empty | error
  source_used: slack_feed
  feed_messages_read: 47
  inspirations_with_activity: 3

  top_mentions:
    - rank: 1
      author: "Aakash Gupta"
      handle: "@aakashg0"
      platform: linkedin
      source: slack_feed
      relevance_score: 9
      posted_at: "2026-04-13T04:00:00Z"
      age_hours: 6
      body_excerpt: "AI product building in 2026 looks nothing like..."
      post_url: "https://linkedin.com/posts/..."
      topics: ["AI product", "builder narrative"]
      suggested_response_angle: "As someone building at Base44, here's what the narrative misses..."

  inactive_inspirations:
    - name: "Mike Krieger"
      reason: "No mentions in feed this week"
```

## Integration With Phase 4 (Write Content)

Inspiration activity becomes the primary grounding for the "echo response" variation angle. The writer uses `top_mentions[0].body_excerpt` + `suggested_response_angle` as the anchor: "[Inspiration] said X this morning. Here's what I'd add from my work on Y."

If `status: empty`, Phase 4 generates 2-3 variations using only Phase 1 Slack signals (no echo angle).
