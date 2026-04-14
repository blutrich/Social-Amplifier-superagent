# Task: Social Amplifier Waterfall (3x/week)

The scheduled task that runs the full content waterfall on Monday, Wednesday, and Friday mornings.

## Default Schedule: 3x/Week (Mon/Wed/Fri)

**Why 3x/week instead of 5x/week daily:**

1. **Realistic for busy champions.** Most champions skip days — 5x/week becomes 2-3x/week in practice anyway. Better to plan for reality.
2. **Better content quality.** More time between deliveries = more signal accumulation in OctoLens/Slack = stronger subject candidates per delivery.
3. **Audience fatigue.** LinkedIn algorithm throttles authors who post too often with mediocre content. 3 strong posts/week beats 5 okay ones.
4. **Recovery time.** If Monday's post missed, Wednesday catches up without the "broken streak" guilt trip.
5. **Cost efficient.** Fewer Bright Data scrapes, OctoLens queries, Slack API calls. Lower operational cost per champion.

## How To Create The Task

In your Base44 Superagent chat, send this exact message:

```
Create a scheduled task with these settings:

Name: Social Amplifier Waterfall
Schedule: Monday, Wednesday, and Friday at 9:00 AM in my local timezone (3 times per week)
Description: Run the full 6-phase content waterfall and deliver LinkedIn drafts via Slack DM

When this task runs, do these steps in order:
1. Run search-slack-context skill to gather fresh Slack signals from last 48-72 hours
2. Run check-inspirations skill to see what my inspirations posted this week
3. Run load-voice skill to load my voice profile and last 30 days of delivered content
4. Run write-content skill to generate 2-3 LinkedIn draft variations using different angles
5. Run voice-guard skill to score each variation and reject anything below 7
6. For each variation that scored 9+, run generate-image skill (uses Base44's built-in image generation — no API key needed) to attach a branded image to the draft
7. If at least one variation scored 9+, run deliver-via-slack skill to send approved drafts (with images) to my Slack DM
8. Log the full run to my content history

If any phase produces no usable output, log the specific reason and skip the day. Better silence than weak content.

Don't notify me if the run was successful - I'll see the Slack DM. Only notify me if the run failed entirely (e.g., Slack connector broken).
```

The Superagent creates the task automatically. Verify in the Tasks tab.

## Alternative Schedules

### 5x/week (Mon-Fri) — Higher cadence

For champions who can handle 5 posts/week:

```
Change the Social Amplifier Waterfall schedule to Monday through Friday at 9:00 AM (5 times per week).
```

**When to use:** Founders in launch mode, comms leads during crisis/announcement periods, builders shipping daily.

### 2x/week (Tue/Thu) — Lower cadence

For champions who want minimal cadence:

```
Change the Social Amplifier Waterfall schedule to Tuesday and Thursday at 9:00 AM (2 times per week).
```

**When to use:** Champions who only post on "big news" days, execs who treat LinkedIn as occasional commentary.

### Weekly digest (Mon only) — Minimal

For champions who want one strong post per week:

```
Change the Social Amplifier Waterfall schedule to Monday at 9:00 AM (1 time per week). Increase the signal gathering window to 7 days instead of 48 hours.
```

**When to use:** Thought leaders, writers, anyone who wants less quantity for more synthesis.

## Time-Zone Notes

The schedule uses your local timezone (from your Identity settings). Examples:

- Asia/Jerusalem: 9am local = 6am UTC (winter) / 7am UTC (summer)
- America/New_York: 9am local = 13-14 UTC
- Europe/London: 9am local = 8-9 UTC

The Superagent handles DST transitions automatically.

## What The Task Does On Each Run

```
Start (Mon/Wed/Fri 9am local)
    ↓
Phase 1: search-slack-context
    ↓ (3-10 Slack signals)
Phase 2: check-inspirations
    ↓ (1-5 inspiration activity items)
Phase 3: load-voice
    ↓ (voice context loaded)
Phase 4: write-content
    ↓ (2-3 draft variations)
Phase 5: voice-guard
    ↓ (scoring + rewrite if needed)
Phase 6: deliver-via-slack
    ↓ (Slack DM sent)
End (log to content history, update Memory)

Total runtime: 45-90 seconds
```

## When The Task Doesn't Run

- Today is not Mon, Wed, or Fri → skipped
- Champion status is "paused" or "archived" → skipped
- `paused_until` is set to a future date → skipped
- Slack connector is disconnected → fails with operator notification
- All Voice Guardian scores below 9+ → skips delivery, logs "no shippable content"

## Manual Trigger

Run the waterfall outside the schedule:

> "Run my Social Amplifier Waterfall right now and send me drafts via Slack DM"

Or to test without delivering:

> "Run my Social Amplifier Waterfall as a dry run. Show drafts in this chat only, don't send via Slack."

Same code path, different output destination.

## Pausing

Temporarily pause without deleting:

> "Pause my Social Amplifier Waterfall for the next 7 days. Resume automatically on [date]."

Full stop:

> "Stop sending me drafts until I explicitly ask you to resume."

Restart:

> "Resume my Social Amplifier Waterfall with the 3x/week schedule."
