# Verify Install

How to test that your Social Amplifier Superagent is set up correctly and producing useful output.

## Test 1: Skills Loaded

Send your Superagent in chat:

```
List the skills you have access to. Specifically check that you have:
- search-slack-context
- check-inspirations
- load-voice
- write-content
- voice-guard
- deliver-via-slack
- handle-feedback
```

**Expected:** Agent confirms all 7 skills are present.

**If failed:** Re-upload skills via **Brain → Integrations → Skills → Add**.

## Test 2: Knowledge Files Loaded

```
What knowledge files do you have? Confirm you can read:
- voice-guardian-checklist.md
- universal-ai-tells.md
- platform-rules.md
- waterfall-overview.md
- inspiration-seeds.json
```

**Expected:** Agent lists all 5 files and can quote from them.

**If failed:** Re-upload via **Brain → Knowledge → Knowledge files**.

## Test 3: Connectors Working

```
Verify all my connectors:
1. Slack: read my profile and tell me my display name
2. OctoLens: list my saved views (if available)
3. Bright Data: fetch https://news.ycombinator.com title (if available)
4. Send me a Slack DM saying "Connector test - ignore"

Report which connectors passed.
```

**Expected:** Slack passes (mandatory). OctoLens and Bright Data may be skipped if not configured.

**If Slack failed:** Re-connect Slack in **Brain → Integrations → Connectors**. Make sure permissions include "send messages to your own DMs".

## Test 4: Voice Profile Loaded

```
Read my voice profile and summarize:
- My voice in one sentence
- My banned words list
- My em dash preference (allow or deny)
- My maximum emoji count per post
- My typical sentence length
```

**Expected:** Agent returns specifics from your champion-tone-template.md (filled in).

**If failed:** Make sure you filled in the champion-tone-template.md and uploaded it as a Knowledge file.

## Test 5: Dry Run The Waterfall

This is the most important test. Run the full waterfall without actually delivering:

```
Run the full Social Amplifier waterfall right now as a dry run. Don't send via Slack — just show me the drafts in this chat. 

Show me:
1. What Slack signals you found (Phase 1)
2. What inspiration activity you saw (Phase 2)
3. The 2-3 draft variations you generated (Phase 4)
4. The Voice Guardian scores for each (Phase 5)
5. Which variations would have been delivered (Phase 6 dry run)

Don't actually send any DMs.
```

**Expected within ~60 seconds:**
- Phase 1: 3-10 Slack signals listed
- Phase 2: 1-5 inspiration activity items (or "no inspirations active")
- Phase 4: 2-3 LinkedIn drafts ready to read
- Phase 5: Each draft scored 9+ (or rewritten)
- Phase 6: List of which drafts would have been sent

**If the drafts feel wrong:**
- "Doesn't sound like me" → run Test 6 (voice match diagnosis)
- "Topic isn't relevant" → check if Slack/inspirations had any signal at all
- "Generic content" → Phase 1 + 2 returned no specific grounding, agent fell back to evergreen

## Test 6: Voice Match Diagnosis

If Test 5 produced drafts that don't sound like you:

```
Compare these draft texts to my actual writing:

Draft 1: [paste draft from Test 5]

My recent real LinkedIn posts:
1. [paste a real recent post of yours]
2. [paste another]

What's different? Where did the draft fail to match my voice? Be specific about sentence patterns, vocabulary, structure, and tone.
```

**Expected:** Agent identifies specific gaps (e.g., "Your real posts use period-fragments like 'Not asks. Tells.' but the draft uses long flowing sentences. Your real posts never use 'humbled' but the draft does.").

Use the diagnosis to update your champion-tone-template.md and rerun the dry run.

## Test 7: Feedback Loop

Once Test 5 produces drafts you're happy with, test the feedback loop:

```
Pretend I just received Draft 1 via Slack and I replied "too formal, more casual please". Process that feedback as if I had actually said it.

Show me:
1. Your classification of the reply
2. The voice profile updates you would make
3. The acknowledgment message you would send back
```

**Expected:** Agent classifies as "tone correction", updates style preferences (formality field), shows the Template 4 ack message.

## Test 8: Real Delivery (Final)

Once Tests 1-7 all pass:

```
Run the full Social Amplifier waterfall right now and DM me the drafts via Slack for real this time.
```

**Expected:** Within 60-90 seconds, you receive a Slack DM with 2-3 LinkedIn drafts using the daily-digest template.

If the DM arrives correctly and the drafts feel like you, your Superagent is fully operational.

## Test 9: Schedule Verification

```
Show me my scheduled tasks. When is my daily waterfall set to run next?
```

**Expected:** Lists the daily-waterfall task with the next run time in your local timezone.

If no scheduled task exists, run:

```
Create the scheduled task per the instructions in tasks/daily-waterfall.md
```

## Test 10: Banned Inspiration Block

Verify the agent enforces banned competitor inspirations:

```
Add Amjad Masad as one of my inspirations.
```

**Expected:** Agent refuses and explains: "Amjad Masad is on the banned list as a direct competitor CEO (Replit). I can't use him as an inspiration source. Want me to suggest alternatives in the same space?"

If the agent accepts the addition, your inspiration-seeds.json wasn't loaded correctly. Re-upload it.

## Common Issues

### "Voice Guardian rejects everything"

The Voice Guardian is too strict for your current draft quality. Causes:
- Phase 1 + 2 returned no real signals → drafts fall back to generic content → Voice Guardian fails them
- Your style preferences are too restrictive → relax `banned_words_add` if it's blocking common words you use
- Your tone-of-voice file is empty or generic → fill it in with real samples

### "Drafts always use the same angle"

Phase 4 isn't varying angles. Check:
- Voice context loaded recent_history (otherwise it doesn't know which angles are stale)
- At least 2 of {Slack signals, inspiration activity, evergreen topics} are populated
- The write-content skill has the angle variation rules from the template

### "Slack signals are empty every day"

Slack search isn't returning results. Check:
- Slack connector permissions (read messages in channels you're in)
- Your Slack username matches the configured handle
- You actually have substantive Slack messages in the last 48 hours
- Feature channels exist and are accessible

### "Drafts are too formal"

Voice profile defaults too professional. Send your agent:

> "Update my voice profile: formality casual, energy measured, vocabulary register casual_technical. Apply to next generation."

### "Daily task didn't run this morning"

Check **Tasks** tab in your Superagent:
- Is the task enabled?
- What's the next scheduled run time?
- Did it fail with an error?
- Are all required connectors still connected?

If task missed for an unknown reason, run manually and check the logs.

## When To Ask For Help

DM @oferbl in Base44 Slack if:
- Tests 1-4 fail and you can't resolve via the troubleshooting above
- The voice match never improves no matter how much you update the profile
- The Voice Guardian rejects everything for 3+ consecutive days
- You need help configuring OctoLens or Bright Data MCP

For general questions, ask your Superagent first — it knows the install runbook and can guide you.
