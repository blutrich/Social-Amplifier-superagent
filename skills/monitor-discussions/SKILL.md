---
name: monitor-discussions
description: Bi-daily engagement monitor. Reads the shared #social-champions-octolens-feed, picks 2-3 posts the champion has genuine authority to reply to, drafts a short suggested reply in the champion's voice, and sends a Slack DM with the link + copy. Triggers on "monitor discussions", "reply suggestions", "what should I reply to", "engagement feed", "engagement monitor".
---

# monitor-discussions

Bi-daily engagement monitor. Surfaces posts from the social feed that are worth replying to, then drafts the reply so the champion can copy-paste or lightly edit before hitting send.

## When To Run

Triggered by the `monitor-discussions` scheduled task — twice a day at 8am and 6pm local time. Can also be run on demand: "What should I reply to today?"

## What It Does

1. Reads `#social-champions-octolens-feed` (channel `C0ATMPHHM40`) — last 24 hours always (scheduled and on-demand)
2. Filters for posts that invite a response (have a point of view, pose a question, share a take the champion can build on)
3. Scores each post for champion relevance (topic match + authority signal)
4. Picks the top 2-3 posts
5. For each, drafts a short suggested reply (1-4 sentences) in the champion's voice
6. Runs anti-AI-tells scan on each reply suggestion
7. Sends a Slack DM via deliver-via-slack with the link + suggested reply text
8. If fewer than 2 relevant posts are found, skips silently — no DM, no nag

## Source

Same feed as Phase 2 (check-inspirations): `#social-champions-octolens-feed`, channel ID `C0ATMPHHM40`. No direct scraping. No Apify token. No OctoLens token. The champion agent reads only what the server-side feeders have already posted.

```
slack_conversations_history(
  channel="C0ATMPHHM40",
  oldest={24_hours_ago_unix},
  limit=100
)
```

## Post Selection Criteria

Score each post on three dimensions (0-3 each, max 9):

| Dimension | Score 3 | Score 2 | Score 1 | Score 0 |
|-----------|---------|---------|---------|---------|
| Topic relevance | Core champion topic | Adjacent topic | Adjacent-ish | Off-topic |
| Reply authority | Champion has direct experience | Champion has related work | Generic opinion possible | No credible angle |
| Reply freshness | Post < 6h old | 6-12h old | 12-24h old | > 24h old |

Pick posts with score 5+. If fewer than 2 posts score 5+, send nothing — don't lower the bar.

## Reply Generation Rules

For each selected post:

**Length:** 1-4 sentences. This is a reply, not a post. Short beats long.

**Structure:** Start with the specific observation or point, not with the champion's role. End with either an insight or a genuine question (not engagement bait).

**Voice:** Use the champion's actual vocabulary from their tone-of-voice file. No filler. No em dashes. No generic openers.

**Ground it:** The reply must connect to the champion's actual work or specific experience. If there's no real connection, skip that post.

**Hard bans (fix surgically first, then scan):**
- Any em dash (`—`, `–`, `--` used as em dash) — **do not regenerate for this; fix in place**: replace `—` with a comma or period based on context, then re-scan. Full regeneration for a 1-character fix wastes the reply.
- Generic self-intro ("I work in marketing", "As someone in software development")
- Corporate announcement phrases ("excited to share", "thrilled to see")
- Engagement bait ("Thoughts?", "Agree or disagree?")
- Vague filler ("This is so true", "Great point", "Totally agree")

**Do not:**
- Name a competitor company or CEO in the reply
- Invent specifics that aren't grounded in the champion's real work
- Generate a reply if the post is about something the champion has no genuine angle on

## Anti-AI-Tells Scan

Before including any reply suggestion, scan against `universal-ai-tells.md`. Fix procedure:

1. **Em dashes first (surgical):** Character scan for `—` (U+2014), `–` (U+2013), `--` standing in for em dash. If found, replace in-place (comma or period by context) and re-scan. Do not regenerate the full reply for an em dash.
2. **Other violations:** Check first sentence for generic self-description openers, banned verb/adjective/adverb list, engagement bait patterns. If any hit → regenerate (max 1 retry per post, then drop that post).

Em dash gets surgical fix because it's a trivial 1-character swap that doesn't change meaning. Everything else is a voice problem that requires regeneration.

## Delivery Format

Send via `deliver-via-slack`. Always use the champion's Slack USER ID as the channel — never a cached channel_id or self-DM.

```
Here are {N} conversations worth joining today:

*1. {Author} on {Platform}*
{1-line context of what they said}
Link: {url}

Suggested reply:
{reply text — no quotes, no markdown, just the raw text to copy-paste}

---

*2. {Author} on {Platform}*
{1-line context}
Link: {url}

Suggested reply:
{reply text}
```

No "Good morning" prefix on monitoring DMs — those belong to the waterfall. Keep it clean and actionable.

No instruction to reply back to the agent. No "Let me know what you think." The champion just picks up the link, reads it, and pastes the reply if they like it.

## When To Skip Silently

- Fewer than 2 posts score 5+ → send nothing, log `monitor_result: no_qualifying_posts`. The 2-post threshold is on **qualifying posts** (score), not on deliverable replies.
- Feed channel unreachable → log error, send nothing
- All reply suggestions fail scan after surgical fix + 1 retry → send nothing, log `monitor_result: all_failed_scan`

If 2+ posts qualify but only 1 reply survives all fixes, deliver 1 reply. The threshold is about signal quality, not about padding the DM with a minimum count.

No failure DMs. No "nothing interesting today" notifications. Silence is the right signal.

## When NOT To Run

- If the champion's status is `paused` or `archived` → skip
- If the champion has a `paused_until` date in the future → skip
- If the waterfall already ran within the last 30 minutes → skip (avoid doubling up signal on same posts)

## Output Format

```yaml
monitor_result:
  status: sent | no_qualifying_posts | error | paused
  posts_read: 47
  posts_qualified: 3
  posts_sent: 2
  skipped_reason: null
  
  suggestions:
    - rank: 1
      author: "Aakash Gupta"
      platform: linkedin
      post_url: "https://linkedin.com/posts/..."
      post_excerpt: "AI product building in 2026..."
      relevance_score: 7
      reply_text: "Saw this exact thing building the Reputation Drop campaign..."
      reply_passes_scan: true
    - rank: 2
      ...
```

## Integration Notes

- This skill does NOT run as part of the waterfall. It's an independent 2x/daily task.
- It DOES share the same feed channel as Phase 2 (check-inspirations). That's fine — the read is cheap and the two tasks have different time windows.
- Reply suggestions are short-form, not standalone posts. Voice Guardian full 10-point scoring is overkill here. Use the anti-AI-tells scan + hard-ban check only.
- Content history logging: write a brief entry to `content-history/{YYYY-MM-DD}-monitor-{morning|evening}.md` with post URLs and reply texts sent.
