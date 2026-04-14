# Verify Install

How to test that your Social Amplifier Superagent is set up correctly and producing useful output.

## Test 1: Skills Loaded

Send your Superagent in chat:

```
Run: find /app/.agents/skills -type f
I expect exactly 8 SKILL.md files under .agents/skills/{name}/SKILL.md and nothing else. No loose .md files at the root. No scripts/ subfolders.
```

**Expected:** 8 paths, one per skill (search-slack-context, check-inspirations, load-voice, write-content, voice-guard, generate-image, deliver-via-slack, handle-feedback).

**If failed:** Re-run Step 5 of BOOTSTRAP-PROMPT.md using `write_file` — do NOT use bash `cat >`, `cp`, or shell redirects. Those write to an ephemeral sandbox.

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
Verify Slack is working:
1. Read my profile and tell me my display name
2. Read the last 5 messages in #social-champions-octolens-feed (channel ID C0ATMPHHM40)
3. Send me a Slack DM saying "Connector test - ignore"

Report which steps passed.
```

**Expected:** All three pass. The shared feed channel is the Phase 2 source for inspirations — if the agent can't read it, the waterfall falls back to Phase 1 signals only.

**If Slack failed:** Re-connect Slack in **Brain → Integrations → Connectors**. Make sure permissions include "send messages to your own DMs" + `channels:history` for the feed channel.

**If feed channel read failed (but other steps passed):** the agent isn't a member of `#social-champions-octolens-feed`. Ask your agent to run `conversations.join` on channel `C0ATMPHHM40`, or have an operator add @{your_handle} manually.

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

## Test 10: End-Of-Install Summary (Phase D)

After the auto-pilot finishes and the dry-run drafts are displayed, the agent MUST send a final Summary message with five mandatory sections. Confirm the message you received contains:

1. **What I learned about you** — voice summary (1 sentence), 3 real sample quotes from your Slack, banned words list, inspirations loaded
2. **What's installed** — 8 skills, 7 knowledge files, Slack connected
3. **What's scheduled** — Mon/Wed/Fri at 9am your timezone, first real delivery date, feedback listener active
4. **How to correct me** — reply with 1/2/3, "not my style", "too formal", or paste past LinkedIn posts
5. **What I can't do yet** — explicit list of gaps (e.g. "no LinkedIn scraping configured — voice confidence 7/10 until you share 2-3 past posts")

**Expected:** All 5 sections are present and filled with real data (not placeholders).

**If failed:** the agent skipped Phase D. Send:

```
You forgot the end-of-install Summary. Send it now with all 5 sections from BOOTSTRAP-PROMPT.md Phase D: What I learned, What's installed, What's scheduled, How to correct me, What I can't do yet. Include my real voice summary + 3 real quotes.
```

Trust-building relies on this message. Never ship an install without it.

## Test 11: Banned Inspiration Block

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
- The shared `#social-champions-octolens-feed` channel isn't reachable and the Apify Feeder App needs re-wiring

For general questions, ask your Superagent first — it knows the install runbook and can guide you.
