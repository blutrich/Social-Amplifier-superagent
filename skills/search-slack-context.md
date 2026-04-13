# Skill: search-slack-context

Phase 1 of the waterfall. Mines Slack for fresh, champion-relevant signals before any content gets written.

## When To Run

Always at the start of the waterfall, before generating any content. Also runnable on demand if the champion asks "what's happening in my Slack right now?".

## What It Does

1. Resolves the champion's Slack user ID (cached or via `slack_search_users`)
2. Pulls the champion's last 20-50 substantive messages from `slack_search_public_and_private` with `from:@username` filter
3. Reads recent activity from feature announcement channels (#features-intel-changelog-4marketing, #product-marketing-sync)
4. Reads activity from #feat-* channels matching the champion's declared topics
5. Filters out bot output, pure links, single-word acknowledgments
6. Scores remaining signals by recency, champion involvement, specificity, cross-source confirmation
7. Returns top 5-10 signals as structured candidates

## Required Tools

- Slack connector (read access to user messages and channels)

## Output Format

```yaml
slack_signals:
  - signal_type: feature_ship | thread_discussion | champion_message | shared_link
    source_channel: "#feat-credits-rollover"
    permalink: "https://workspace.slack.com/archives/..."
    timestamp: "2026-04-12T18:30:00+03:00"
    age_hours: 18
    score: 8
    body_excerpt: "First 200 chars of the message"
    why_relevant: "Champion is in this channel and topic matches..."
    champion_involved: true
    related_topics: ["AI agent infrastructure", "Base44 product"]
```

## Filter Rules

Drop messages that are:
- Bot output (Auto-Waterfall scans, Slackbot notifications)
- Pure links with no commentary
- Single-word acknowledgments ("ok", "thanks", "👍")
- Body shorter than 30 characters
- Older than 72 hours (or 7 days for ops persona)

Keep messages where the champion explained something, argued for something, shared a link with their take, or where a feature ship was announced in their topic area.

## Score Rubric

| Factor | Weight | Notes |
|--------|--------|-------|
| Recency | 3 | Fresh > stale |
| Champion involvement | 4 | Did the champion participate in the thread? Highest signal. |
| Specificity | 2 | Specific feature/number > vague discussion |
| Cross-source confirmation | 1 | Mentioned in multiple channels = stronger signal |

Sort signals by score, return top 5-10 to the next phase.

## When To Skip

- Slack connector not configured → log "slack_unavailable" and continue waterfall without Slack signals
- Champion has zero Slack messages in the last 7 days → log "no_recent_activity" and continue
- All channel reads return empty → log "empty_channels" and continue

The waterfall always continues — Slack signals are valuable but not blocking.

## Integration With Phase 4 (Write Content)

Slack signals become the primary grounding for the "personal experience" variation angle. The writer uses the body_excerpt as a direct anchor: "I saw a [feature] ship in #feat-X yesterday. Here's what I noticed."

Without Slack signals, Phase 4 falls back to inspiration echoes (Phase 2 output) or evergreen topics from the champion's profile.
