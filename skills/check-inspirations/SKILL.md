---
name: check-inspirations
description: Phase 2 of waterfall. Reads the shared #social-champions-octolens-feed Slack channel (primary) then per-champion inspirations list (Apify) to find what's worth echoing this week. Triggers on "check inspirations", "phase 2", "inspiration activity".
---

# check-inspirations

Phase 2 of the waterfall. Finds what the champion's inspirations posted in the last 7 days and surfaces the strongest echo opportunities.

## When To Run

After `search-slack-context` (Phase 1), before `load-voice` (Phase 3).

## Source Chain (in priority order)

Read `knowledge/inspiration-seeds.json` → `social_amplifier_feed` for the current channel config. Then fall through the source chain:

1. **Primary — Shared Slack feed channel** (`social-champions-octolens-feed`, ID `C0ATMPHHM40`)
   Two feeder systems post into this one channel: (a) OctoLens posts social mentions, (b) an operator-run Base44 "Apify Feeder" app posts LinkedIn + X profile scrapes for the shared inspirations list. Every champion's agent reads from here. **Champions never hold an Apify token or OctoLens token — those secrets live server-side in the feeder systems only.**

2. **Fallback 1 — Per-champion inspirations list as filter keywords**
   The champion's `champion_inspirations` list (from Interview answer #6) is NOT a scraping target for this agent. It's a filter: when matching messages in the Slack feed, boost relevance for authors in this list. If the feed has zero hits for those authors this week, the skill returns `status: partial` and Phase 4 falls back to Slack-only grounding.

3. **Fallback 2 — OctoLens MCP direct** (only if `mcp__octolens__list_mentions` is available to this agent)
   Most champions won't have OctoLens MCP configured; this is legacy/optional.

4. **Fallback 3 — Web search**
   Last resort. Low signal, but never fails the waterfall.

**This agent does NOT have access to an Apify token. Never call Apify directly from this skill.** If the Slack feed is empty, accept partial status — don't try to re-scrape.

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

## Fallback 1: Per-Champion Inspirations via Apify

Triggered when:
- The Slack feed returned 0 relevant mentions
- OR the champion has specific inspirations not covered by the feed (e.g. niche accounts)

For each inspiration in Memory `champion_inspirations`:

```
# LinkedIn
Apify actor: apimaestro/linkedin-profile-posts
Input: { "username": "{handle}", "limit": 10 }

# X / Twitter
Apify actor: apidojo/tweet-scraper
Input: { "twitterHandles": ["{handle}"], "maxItems": 10, "sort": "Latest" }
```

Requires `APIFY_TOKEN` in Base44 Settings → Secrets & Keys. If not set, skip to Fallback 3.

Cache per-handle for 24 hours in Memory to avoid repeat runs across the day:
```
cache_key: inspiration:{handle}:{YYYY-MM-DD}
```

## Fallback 2: OctoLens MCP Direct

Only run if `mcp__octolens__list_mentions` is available. Single call:

```
mcp__octolens__list_mentions(
  filters={ "startDate": "{7_days_ago_ISO}" },
  limit=100
)
```

Filter response by `author` matching the champion's inspirations. Most champions won't have this connector — treat as optional.

## Fallback 3: Web Search

For any inspiration still without activity data, run a web search:
```
web_search("{inspiration_name} linkedin OR twitter last 7 days")
```

Extract 1-2 recent post mentions from the results. Low signal quality — flag in output `status: partial`.

## Banned Inspirations Check

Before processing any inspiration from ANY source, check the banned list in `inspiration-seeds.json` → `banned_competitors`. If an author matches:
- Banned person directly → skip
- Banned company pattern → skip CEO/marketing roles, allow individual engineers case-by-case
- Banned via champion's own `style-preferences.md` → skip

Never include banned inspirations in output. Log skips with reason.

## When To Skip The Phase Entirely

- Slack feed empty AND no `champion_inspirations` in Memory AND no `APIFY_TOKEN` → return `status: empty`, waterfall continues without inspiration grounding (write-content still uses Slack signals from Phase 1)
- All sources errored → return `status: error`, waterfall continues with Phase 1 data only
- Better partial than fabricated. Never invent posts.

## Output Format

```yaml
inspiration_activity:
  status: ok | partial | empty | error
  source_used: slack_feed | champion_apify | octolens | web_search | mixed
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
      reason: "No mentions in feed, not in champion list, no APIFY_TOKEN"
```

## Integration With Phase 4 (Write Content)

Inspiration activity becomes the primary grounding for the "echo response" variation angle. The writer uses `top_mentions[0].body_excerpt` + `suggested_response_angle` as the anchor: "[Inspiration] said X this morning. Here's what I'd add from my work on Y."

If `status: empty`, Phase 4 generates 2-3 variations using only Phase 1 Slack signals (no echo angle).
