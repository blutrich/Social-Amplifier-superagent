# Task: Feedback On Reply

The connector trigger that activates whenever the champion replies to a delivered Slack DM. Calls the handle-feedback skill to process the reply and update the voice profile.

## How To Create

In your Base44 Superagent chat, send this exact message:

```
Create a connector trigger with these settings:

Trigger: When a message arrives on Slack DM (message.im event)
Connector: Slack
Description: Process my feedback on delivered drafts and update my voice profile

CRITICAL FILTER — PRIVACY BOUNDARY:
Before doing ANYTHING with an incoming message, check if message.channel matches my DM channel with you (the agent). My DM channel ID is stored in your Memory as champion_dm_channel_id (resolved during install Step 6).

- If message.channel == champion_dm_channel_id → process normally (steps 1-5 below)
- If message.channel != champion_dm_channel_id → IGNORE COMPLETELY. Do not read, respond, classify, or log. This is someone else's private conversation.

When the channel matches, do these steps:
1. Read my reply message
2. Run the handle-feedback skill with the reply text
3. Classify the reply (approval, rejection, feedback, rewrite, pause, question, silence)
4. Update my voice profile or status based on the classification
5. Send a brief acknowledgment if appropriate (Template 4 from deliver-via-slack)

Don't process replies that aren't related to a delivered draft. Don't double-process the same reply twice.
```

The Superagent will create the trigger automatically. Verify in the Tasks tab.

## What The Trigger Does

Whenever you reply to a draft DM with feedback like:

- "1" → mark variation 1 as approved, log positive signal
- "too formal" → update style preferences (casual register), send confirmation
- "I'd never use 'leverage'" → add to banned words, send confirmation
- "more like my last post" → analyze your last approved post, weight similar patterns
- "pause" → set status to paused for 7 days
- "stop" → archive the agent
- A rewritten version of the draft → diff against original, learn from changes

The trigger fires within seconds of your reply. The voice profile updates immediately. Tomorrow's drafts reflect the change.

## What It Doesn't Do

- It doesn't reprocess your reply if the trigger already handled it (idempotent)
- It doesn't trigger on messages from other people in shared channels
- It doesn't trigger on messages older than 24 hours from delivery time
- It doesn't auto-regenerate drafts — only updates the profile for next time

## Manual Override

If the trigger doesn't fire automatically (Slack connector hiccup, network issue, etc.), you can manually trigger feedback processing in chat:

> "Process my last Slack reply as feedback. The reply was: '[paste reply text]'"

This runs the same handle-feedback skill but bypasses the connector trigger.

## Edge Case: Non-feedback Replies

Sometimes you reply to the agent for unrelated reasons:

- Asking a question ("what's trending in my space today?")
- Operational requests ("change my schedule to 10am")
- General chat ("how does this work?")

The handle-feedback skill classifies these as Category 6 (Question) and routes them to a general response handler instead of voice profile updates. Your reply gets a useful answer without polluting your voice profile.
