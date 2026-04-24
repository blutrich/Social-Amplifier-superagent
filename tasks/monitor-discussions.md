# Task: Discussion Monitor (2x/day)

The scheduled task that runs the engagement monitor twice daily, sending the champion links to relevant social posts with suggested replies.

## Default Schedule: 2x/Day (8am + 6pm local)

**Why twice a day:**
- Morning run (8am): catch overnight and early-morning posts before the champion's workday starts
- Evening run (6pm): catch the midday-to-afternoon wave before the champion winds down
- Replies are time-sensitive — a comment posted 4 hours ago gets more visibility than one posted 48 hours ago
- Separate from the waterfall (content creation) — this is engagement, not publishing

## How To Create The Task

In your Base44 Superagent chat, send this exact message:

```
Create a scheduled task with these settings:

Name: Discussion Monitor
Schedule: Monday through Friday at 8:00 AM and 6:00 PM in my local timezone (2 times per weekday)
Description: Monitor relevant social discussions and send me reply suggestions via Slack DM

When this task runs, do these steps:
1. Run monitor-discussions skill to scan the last 12 hours of #social-champions-octolens-feed
2. Score posts by relevance to my topics and my reply authority
3. Pick the top 2-3 posts that score 5+ out of 9
4. For each, draft a 1-4 sentence suggested reply in my voice — no em dashes, no generic openers, grounded in my actual work
5. Run anti-AI-tells scan on each reply suggestion
6. If at least 2 qualifying posts found, send a Slack DM with links + suggested replies
7. If fewer than 2 qualify, skip silently — no notification

This is read-only in Slack channels. Never reply inside a thread or post to any channel. Only write to my DM.
```

## What The Task Does On Each Run

```
Start (8am or 6pm local, Mon-Fri)
    ↓
Read #social-champions-octolens-feed (last 12 hours)
    ↓
Score posts for relevance + reply authority
    ↓
< 2 qualify? → skip silently
≥ 2 qualify? → generate reply suggestions
    ↓
Anti-AI-tells scan (em dashes, generic openers, engagement bait)
    ↓
Deliver via Slack DM (link + reply text)
    ↓
Log to content history
End
```

Total runtime: 15-30 seconds.

## Format of the DM

```
Here are 2 conversations worth joining today:

*1. {Author} on {Platform}*
{1-line context of what they said}
Link: {url}

Suggested reply:
{reply text — raw, copy-paste ready}

---

*2. {Author} on {Platform}*
{1-line context}
Link: {url}

Suggested reply:
{reply text}
```

No greeting. No call to action. Just the content.

## When The Task Doesn't Run

- Champion status is `paused` or `archived` → skipped
- `paused_until` is set to a future date → skipped
- Feed has fewer than 2 qualifying posts → skips delivery (no notification)
- Anti-AI-tells scan fails all suggestions → skips delivery (no notification)
- Slack connector disconnected → fails silently (logged, no operator ping)

## Manual Trigger

Run on demand:

> "Show me what I should reply to today"

or

> "Run the discussion monitor right now"

On-demand runs use a 24-hour window instead of 12 hours.

## Pausing

Same mechanism as the waterfall:

> "Pause discussion monitoring for the next 7 days."

> "Stop sending me reply suggestions until I explicitly ask."

> "Resume discussion monitoring."

## Relationship To The Waterfall

These are separate, complementary flows:

| Waterfall (Mon/Wed/Fri 9am) | Discussion Monitor (8am + 6pm) |
|------------------------------|-------------------------------|
| Generates standalone posts | Generates replies to others' posts |
| 45-90 seconds | 15-30 seconds |
| Full Voice Guardian | Anti-AI-tells scan only |
| Stops if no signal | Stops if < 2 qualifying posts |
| 3x/week | 2x/weekday (up to 10x/week) |
| DMs with drafts | DMs with links + reply copy |

Both read from the same `#social-champions-octolens-feed` channel. That's fine — reads are cheap and the time windows are different.
