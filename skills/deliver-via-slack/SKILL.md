---
name: deliver-via-slack
description: Phase 6 of waterfall. Sends approved drafts to the champion via Slack DM with reply-to-approve pattern. Triggers on "deliver via slack", "phase 6", "send drafts", "dm drafts".
---

# deliver-via-slack

Phase 6 of the waterfall. Sends approved drafts to the champion via Slack DM.

## When To Run

After Phase 5 (Voice Guardian scoring) and Phase 5.5 (generate-image). Only delivers variations that passed ALL gates.

## Pre-Delivery Gate (mandatory, ALL surfaces)

Before presenting ANY draft to the champion on ANY surface — Slack DM, dry-run in chat, WhatsApp, Telegram, or any direct conversation where the champion asks "write me a post about X":

1. Confirm the draft has a Voice Guardian score of 9+ attached
2. Confirm the draft passed the anti-AI-tells scan with 0 violations (cross-checked against `knowledge/universal-ai-tells.md`)
3. Confirm the draft contains no competitor company or CEO names

This gate applies to:
- Scheduled waterfall deliveries (Slack DM)
- Dry-run drafts during install (Step 12, shown in chat)
- On-demand generation when the champion asks for content in any messaging platform
- Rewrites and revisions triggered by feedback

If any draft is missing these confirmations, do NOT present it. Return it to Phase 5 for scoring, or drop it. The champion never sees an ungated draft, period.

## What It Does

1. Validates that at least 1 variation scored APPROVED
2. Resolves the champion's DM channel (cached or fresh lookup)
3. Picks the right template based on context (daily digest, single draft, welcome, etc.)
4. Substitutes variables (champion name, drafts, angle labels, image suggestions)
5. Sends via slack_send_message
6. Writes a delivery log to content history
7. Returns the message timestamp + delivery status

## Required Tools

- Slack connector (send DM)

## Required Inputs

- `champion_id` — which champion is receiving content
- `approved_variations` — list of variations that passed Voice Guardian (1-3)
- `image_suggestion` (optional) — output from the image suggestion step
- `template_name` — daily-digest, single-draft, welcome, revision, pause, apology

## DM Templates

### Template 1: Daily Digest (default)

```
Good morning {first_name}! Here are today's {variation_count} drafts:

*Option 1 — {angle_label_1}*

{variation_1_text}

---

*Option 2 — {angle_label_2}*

{variation_2_text}

---

*Option 3 — {angle_label_3}*

{variation_3_text}

---

Reply *1*, *2*, or *3* to mark one as posted.

Reply *"not my style"* + feedback to teach me your voice.

Or just copy whichever you like and post it. Silence is fine.
```

### Template 2: Single Draft (post-feedback revision)

```
{first_name}, here's a revised draft based on your feedback:

{draft_text}

What changed: {one-line summary}

Post, reject, or give me more feedback. No hurry.
```

### Template 3: Welcome (first delivery for new champion)

```
Hey {first_name}! I'm your Social Amplifier agent.

I analyzed your Slack activity and figured out your voice. Here's what I picked up:

• {observation 1 from voice profile}
• {observation 2}
• {observation 3}

Your first drafts are ready:

[Template 1 content here]

---

Quick notes:
• I'll send new drafts every weekday morning at 9am
• Reply with feedback anytime to adjust your voice
• Reply "pause" to stop for a week, "stop" to opt out entirely
```

### Template 4: Profile Update Confirmation

```
Got it — updated your voice profile:

{1-2 line description of what changed}

Your next drafts will reflect this. Keep the feedback coming.
```

### Template 5: Pause/Resume/Stop

```
Paused for a week. I'll resume on {date}. Reply "resume" to restart earlier.
```

### Template 6: Pipeline Failure Apology

```
{first_name}, no drafts this morning - the content pipeline hit an error. I'll try again tomorrow. No action needed.
```

## Variable Substitution Rules

- `{first_name}` from champion identity, first word only
- `{variation_count}` integer (2 or 3)
- `{variation_N_text}` clean post text, no markdown
- `{angle_label_N}` human-readable angle from Phase 4 output (e.g., "Personal experience angle", "Echo response angle", "Reflection angle")
- Never hardcode angle labels — always use Phase 4's labels

## Format Rules for Slack

Slack supports markdown via the `markdown=true` flag:
- `*text*` is bold
- `---` creates visual separator
- Blank lines between paragraphs
- `•` for bullets (not `-` or `*`)
- No code blocks around drafts (so triple-click-copy works)
- No emoji in agent messages (except optional 👋 in welcome)

## Send Logic

```
mcp__plugin_slack_slack__slack_send_message(
  channel_id="{cached_dm_channel_or_user_id}",
  text="{formatted template text}",
  markdown=true
)
```

Cache the returned channel_id back to the champion profile for next time.

## Idempotency

Before sending, check if a delivery for this champion + today's date already exists in content history. If yes:
- Skip (don't double-send)
- Log "duplicate_delivery_skipped"
- Return success with note that it was a no-op

## Failure Handling

If `slack_send_message` fails:
- Catch the error
- Log to delivery failures with timestamp + champion + error
- Don't retry immediately — wait for next scheduled run
- Preserve drafts in Memory so they can be retrieved manually
- Send template 6 (apology) on the next successful day

## Output Format

```yaml
delivery_result:
  status: sent | failed | dry_run | duplicate_skipped
  champion_id: dor-blech
  template_used: daily-digest
  variations_sent: 2
  message_ts: "1776055326.645449"
  channel_id: "{champion_dm_channel_id}"
  failure_reason: null
  log_path: "content-history/2026-04-13-daily-digest.md"
```

## Delivery Log Schema

After successful send, write to `content-history/{YYYY-MM-DD}-{topic-slug}.md`:

```markdown
---
champion_id: dor-blech
date: 2026-04-13
delivered_at: 2026-04-13T09:00:12+03:00
dm_channel: {champion_dm_channel_id}
template: daily-digest
trigger: scheduled
variations_delivered: 2
voice_guardian_scores: [10, 9]
delivery_status: sent
message_ts: 1776055326.645449
---

# Draft 1: Personal experience angle
[full text]

# Draft 2: Echo response angle
[full text]

# Reply
(populated when champion responds)
```

## Trust Rules

- Silence is acceptance — don't nag if champion doesn't reply
- No drafts without Voice Guardian approval (9+ only)
- Respect timezones (use schedule_message for local 9am if running outside that window)
- Never retry failed sends immediately
- Never send the same content twice (idempotency check)
- No internal metrics in champion-facing messages (don't mention scores)
