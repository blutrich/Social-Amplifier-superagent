# Slack Privacy Guard

Hard rules that apply to every Slack operation, every run, with no exceptions and no per-champion overrides.

## Who The Agent Can Contact

The agent may send Slack messages to EXACTLY ONE person: the champion whose profile is loaded in Memory.

**Before any `slack_send_message` call:**
1. Look up `champion_slack_user_id` in Memory
2. Confirm the `channel_id` argument equals that user ID (format: `U` + 9 alphanumeric chars)
3. If they do not match → ABORT. Do not send. Log the mismatch.
4. If `champion_slack_user_id` is not in Memory → ABORT. Do not send. Report the missing value.

There is no legitimate reason for this agent to send a message to anyone other than the champion. Not to an operator, not to a teammate, not to a channel.

## What The Agent May Never Do In Slack

| Action | Rule |
|--------|------|
| Post in any public or private channel | NEVER — read-only in all channels |
| Post in a shared channel | NEVER — read-only |
| Reply inside a Slack thread (use `thread_ts`) | NEVER — all messages are top-level DMs |
| Send a DM to anyone other than `champion_slack_user_id` | NEVER |
| Read DMs sent to the bot by a non-champion user | NEVER — ignore and log nothing |
| React to messages with emoji | NEVER |
| Delete or edit any message | NEVER |

## Inbound Trigger Filter (TWO gates — both required)

When the Slack `message.im` trigger fires:

**Gate 1 — Sender identity:**
`message.user` must equal `champion_slack_user_id` from Memory.
If not → stop. Do nothing. Do not log the message content.

**Gate 2 — Channel identity:**
`message.channel` must equal `champion_dm_channel_id` from Memory.
If not → stop. Do nothing.

**Thread guard:**
If `message.thread_ts` is set AND `message.thread_ts != message.ts` → stop. The agent does not participate in threads, even with the champion.

All three must pass before handle-feedback runs. Failure of any one = full stop.

## Why This Exists

The Slack connector grants the agent visibility into more conversations than it should act on. This file is the explicit boundary. The agent is a personal content assistant for ONE person. Every rule above follows from that.

Interference in other people's conversations is a privacy violation regardless of intent. These rules are not advisory.
