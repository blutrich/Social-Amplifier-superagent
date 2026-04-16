---
name: check-inspirations
description: Phase 2 of waterfall. Reads the shared #social-champions-octolens-feed Slack channel for echo-worthy posts. Champion's heroes get priority but all feed content is fair game. Triggers on "check inspirations", "phase 2", "inspiration activity".
---

# check-inspirations

Phase 2 of the waterfall. Reads the shared inspiration feed and picks the 2-3 posts that best complement the champion's Phase 1 Slack signals.

## When To Run

After `search-slack-context` (Phase 1), before `load-voice` (Phase 3).

## Source: Shared Slack Feed Channel

Read `knowledge/inspiration-seeds.json` → `social_amplifier_feed` for the channel config.

**The only source is** `#social-champions-octolens-feed` (channel ID `C0ATMPHHM40`). Two feeder systems post into it server-side:
- **OctoLens** posts brand mentions and tagged social content
- **Apify Inspiration Feeder** (a separate Base44 app) posts LinkedIn + X profile scrapes on a 6h cron

The channel IS the filter. Everything in it is pre-curated inspiration content. The agent reads ALL posts and picks the best ones for this champion's draft angles.

**No champion agent holds an Apify token, an OctoLens token, or calls web search.** All scraping runs server-side in the feeders.

## Champion's Heroes = Soft Preference, Not Filter

The champion's `champion_inspirations` list (from Interview answer #6) is a **preference signal**, not a hard filter. Posts from the champion's named heroes get a relevance boost, but a strong signal from any other author in the feed can still win if it connects better to the champion's Phase 1 Slack signals and topics.

**Why soft preference:** the champion's heroes are the people they admire, so echoing them feels natural. But a great post from someone they didn't name can also produce a strong draft. Don't throw away good signals just because the author isn't on the list.

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
**Filtering:**
- Drop mentions older than 7 days (`oldest` filter + post-parse check)
- Drop messages with no parseable author (skip, don't fail)

**Selection (soft preference, not hard filter):**
- Read ALL posts from the feed. Everything there is fair game.
- Posts from the champion's `champion_inspirations` list (Interview answer #6) get a soft relevance boost — these are the champion's heroes, echoing them feels natural
- But any post from the feed can win if it connects strongly to the champion's Phase 1 Slack signals or topics
- Pick the 2-3 posts with the strongest signal for draft angles — consider topic overlap with Phase 1, recency, engagement, and whether the post enables a personal-experience or echo-response angle
- No hard author-based filtering. The channel is already curated by the Feeder.

## Fallback: Phase 1 signals only

If the shared feed channel returns zero matches for the champion's inspirations this week, **do not** attempt any other source. The champion agent does NOT:
- Hold an Apify token (Apify runs server-side in the Feeder app — a separate Base44 app)
- Hold an OctoLens token (OctoLens posts directly into the feed channel; no direct MCP call)
- Call web search during scheduled runs (web search produces low-signal content that poisons Voice Guardian scoring)

Instead, return `status: partial` with `source_used: slack_feed` and an empty `top_mentions` array. Phase 4 then generates variations using **only** the Phase 1 Slack signals. No echo-angle draft, just personal-experience and reflection angles grounded in the champion's own Slack activity.

**Why no fallback scraping:** the whole v3 architecture moves scraping server-side to keep champion agents stateless and tokenless. Re-adding a per-champion scrape path would contradict that. If the feed is empty, the correct answer is honesty (partial output), not fabrication from alternate sources.

**If the feed channel is unreachable entirely** (agent not a member, channel archived, Slack outage), return `status: error` with the specific reason. Phase 4 still runs on Phase 1 signals. The error surfaces in the Phase D Summary gaps section so the operator knows to fix the Feeder.

## When To Skip The Phase Entirely

- Slack feed has 0 messages in the last 7 days → return `status: empty`, waterfall continues with Phase 1 signals only
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
