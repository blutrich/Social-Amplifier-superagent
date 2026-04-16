---
name: handle-feedback
description: Parses champion replies to delivered drafts and updates their voice profile. ONLY triggers on messages in the agent-champion DM channel. Triggers on "handle feedback", "process reply".
---

# handle-feedback

Parses champion replies to delivered drafts and updates their voice profile based on the feedback.

## CRITICAL: DM Channel Filter (privacy boundary)

This skill ONLY processes messages from the dedicated DM channel between the agent and the champion. This channel ID is resolved during install Step 6 (e.g. `D0AA2C6LK3M` for Ofer) and stored in Memory as `champion_dm_channel_id`.

**Before processing ANY incoming message, check:**
1. Is `message.channel` equal to `champion_dm_channel_id` from Memory?
2. If YES → process the feedback normally
3. If NO → **IGNORE COMPLETELY. Do not read, do not respond, do not classify, do not log.** This is someone else's private conversation. The agent has no business being there.

**Why this exists:** The Slack connector's `message.im` trigger fires on ALL DM activity visible to the connected account, not just the agent-champion channel. Without this filter, the agent interferes with the champion's private DM conversations with other people. This is a privacy violation, not just a bug.

## When To Run

When the champion sends a message in the agent-champion DM channel ONLY. Triggered automatically by the Slack connector `message.im` event, filtered by `champion_dm_channel_id`.

## What It Does

1. Reads the champion's most recent reply from the DM channel
2. Classifies the reply into one of 8 categories
3. Updates the champion's voice profile based on the category
4. Optionally sends a confirmation DM
5. Logs the feedback to the delivery history

## Reply Categories

### Category 1: Approval-by-number (highest precedence)

Champion replies with a number or references one:
- "1", "2", "3"
- "option 1", "go with 2", "the first one"
- "yep, 1", "I'll post #3"

**Action:**
1. Mark the chosen variation as approved in delivery log
2. Add a positive signal to "What Works" in voice profile
3. Optionally reply with brief ack: "Saved. I'll use that style more often."

### Category 2: Explicit rejection with feedback

- "too formal"
- "not my style"
- "this sounds like AI"
- "I'd never say 'leverage'"
- "more casual"
- "shorter sentences"

**Action:**
1. Extract the specific complaint
2. Update style preferences:
   - "too formal" → set `formality: casual`, add note
   - "I don't use that word" → add to `banned_words_add`
   - "shorter sentences" → reduce `word_count_max` by 50
3. Send Template 4 (Profile Update Confirmation)
4. Don't auto-regenerate — wait for next scheduled run with new preferences

### Category 3: Positive without explicit choice

- "these are good"
- "nice work"
- "much better than yesterday"
- "love the angle on #3"

**Action:**
1. Log positive signal
2. If a specific variation is praised ("love #3"), treat as implicit approval
3. Update "What Works" with the patterns observed
4. No confirmation DM needed

### Category 4: Request for more variations or different angle

- "try again with a different angle"
- "give me more options"
- "can you make one more focused on the technical side?"

**Action:**
1. Extract the requested direction
2. Trigger `write-content` skill with same topic + new constraint
3. Run new variations through `voice-guard`
4. Send Template 2 (Single Draft) with the result

### Category 5: Pause / Stop / Resume

- "pause", "pause for a week"
- "stop", "opt out"
- "resume", "start"

**Action:**
1. Update champion status:
   - "pause" → status: paused, paused_until: 7 days from now
   - "stop" → status: archived
   - "resume" → status: active
2. Send Template 5 (Pause/Resume Confirmation)
3. Don't send drafts until status returns to active

### Category 6: Question or meta-reply

- "how do I unsubscribe?"
- "can you scan slack for features?"
- "who else is getting these?"

**Action:**
1. Answer the question briefly in DM reply
2. Don't treat as voice feedback — operational question
3. If question reveals an unmet need, log as feature request

### Category 7: Manual rewrite (champion posts modified version)

Champion doesn't pick a number, doesn't explicitly reject — they paste a modified version of one of the drafts.

**Action:**
1. Diff the champion's version against each original draft
2. Identify which draft it's closest to
3. Extract differences:
   - Shorter? → update word count preference
   - Different word choices? → update vocabulary lists
   - Different structure? → update tone-of-voice observation
4. Save as a "what works" reference (this is the highest-quality voice signal)
5. Reply with Template 4 noting what was learned

This is the most valuable feedback type because it shows exactly how the champion writes in this specific context.

### Category 8: Silence

Champion doesn't reply within 24 hours.

**Action:**
1. Don't nag
2. Don't ask for feedback
3. Don't escalate
4. Log as `reply_status: none` in content history
5. Send tomorrow's batch on schedule

## Ambiguity Resolution

When a reply could fit multiple categories:

- **Number + negative comment** ("1, but it's too long") → Category 2 (feedback) with note that they leaned toward #1
- **Number + positive comment** ("yep 1, nice work") → Category 1 (approval) with positive bonus
- **Hebrew/English code-switch** → parse based on which language the keyword is in
- **Multiple replies in quick succession** → wait 60 seconds, merge as single reply

## Profile Update Format

When updating style preferences based on feedback, use the structured format:

```yaml
# Update to style-preferences.md or Memory
update_type: feedback_correction
date: 2026-04-13
trigger_reply: "too formal, more like my last post"
classified_as: tone_correction
changes:
  - field: formality
    old_value: professional
    new_value: casual
  - field: vocabulary_register
    old_value: technical
    new_value: casual_technical
notes: "Champion explicitly asked for less formal tone after Voice Guardian approved a draft they later said was too formal."
```

This becomes part of the champion's learning log over time.

## What NOT To Do

- Never argue with the feedback (no "but the Voice Guardian approved this")
- Never explain the internal mechanism (champions don't care)
- Never apologize excessively (one short ack is enough)
- Never re-send drafts the champion already rejected
- Never ask compound questions ("Did you mean X or Y?")
- Never escalate to the operator unless the champion explicitly asks

## Output Format

```yaml
feedback_result:
  reply_received_at: 2026-04-13T09:34:12+03:00
  reply_text: "1, but make it shorter next time"
  category: approval-with-feedback
  chosen_variation: 1
  feedback_extracted:
    - "prefer shorter posts"
  profile_updates:
    - field: linkedin.word_count_max
      old: 300
      new: 220
  agent_response:
    template: profile-update-confirmation
    sent_at: 2026-04-13T09:34:45+03:00
    message_ts: "..."
```

## Integration With Memory

The Superagent's Memory stores all feedback events. Over time, this becomes the champion's evolving voice profile. After 30+ feedback events, the agent's understanding of the champion is far more nuanced than the original onboarding profile.

The Memory is the source of truth for "what does this champion actually want?" — more than the static knowledge files. Always check Memory before generating new content.
