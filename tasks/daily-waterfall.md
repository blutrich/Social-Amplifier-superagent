# Task: Daily Waterfall

The scheduled task that runs the full content waterfall every weekday morning.

## How To Create

In your Base44 Superagent chat, send this exact message:

```
Create a scheduled task with these settings:

Name: Daily Social Content Waterfall
Schedule: Every weekday (Monday through Friday) at 9:00 AM in my local timezone
Description: Run the full Social Amplifier content waterfall and deliver drafts via Slack DM

When this task runs, do these steps in order:
1. Run the search-slack-context skill to gather fresh Slack signals
2. Run the check-inspirations skill to see what my inspirations posted this week
3. Run the load-voice skill to load my voice profile and recent content history
4. Run the write-content skill to generate 2-3 LinkedIn draft variations using different angles
5. Run the voice-guard skill to score each variation and reject anything below 7
6. If at least one variation scored 9+, run the deliver-via-slack skill to send the approved drafts to my Slack DM

If any phase produces no usable output, log the reason and skip the day. Better silence than weak content.

Don't notify me if the run was successful - I'll see the Slack DM. Only notify me if the run failed entirely.
```

The Superagent will create the task automatically. Verify in the Tasks tab.

## What The Task Does

Every weekday at 9am local time, the task:

1. Runs all 6 phases of the waterfall sequentially
2. Sends approved drafts via Slack DM to you
3. Logs the run to content history
4. Updates Memory with what worked/failed
5. Stops silently if the run was successful

Total runtime: ~45-90 seconds per execution.

## When It Doesn't Run

- Your timezone says it's a weekend (Sat/Sun) → skipped
- Your champion status is "paused" → skipped
- Your champion status is "archived" → skipped
- Slack connector is disconnected → fails with operator notification
- All Voice Guardian scores below 9+ → skips delivery, logs "no shippable content"

## Modifying The Schedule

To change when the task runs, send your Superagent:

> "Update my daily waterfall task to run at 8am instead of 9am"

Or:

> "Change my daily waterfall to run only on Tuesday and Thursday"

The Superagent updates the task settings without you having to navigate the Tasks UI.

## Pausing The Task

To temporarily pause without deleting:

> "Pause my daily waterfall task for the next 7 days"

To resume:

> "Resume my daily waterfall task"

To delete entirely:

> "Delete my daily waterfall scheduled task"

## Manual Trigger

To run the waterfall on demand (outside the daily schedule):

> "Run my Social Amplifier waterfall right now and send me the drafts via Slack"

Or to test without sending:

> "Run my Social Amplifier waterfall but show me the drafts in this chat instead of via Slack"

This uses the same skills as the scheduled task but stays in chat for review.
