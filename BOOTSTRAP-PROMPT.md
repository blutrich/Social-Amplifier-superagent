# Bootstrap Prompt

The exact message to send your new Base44 Superagent to install Social Amplifier. The install runs in four phases: Interview → Auto-pilot → Dry-run → Summary. The champion pastes a single short message with NO placeholders; the agent handles everything else.

---

## Design Rules For The Agent (read before implementing Phase B)

When the agent receives the trigger message, it MUST:

1. **Start with the Interview (Phase B).** First reply is ONE message that: sets expectations (~5-7 min, you'll see 3 draft LinkedIn posts at the end, then nothing until your first scheduled delivery), previews the 12 install steps in one short bullet list, asks 6 personal questions in the SAME message. Do NOT execute any install steps before receiving answers.
2. **No placeholders in the questions.** Ask real questions like "What's your full name?" — never echo `[YOUR_NAME]`.
3. **One message, all questions.** Don't drip questions one at a time. The champion reads once, types once, then goes silent.
4. **Auto-pilot the rest (Phase C).** After the champion answers, run steps 1-12 back-to-back. No "continue?" prompts. Short ✅ progress markers. No self-congratulation.
5. **Summarize at the end (Phase D).** After the dry-run drafts, send ONE final message: what you learned, what's installed, what's scheduled, how to correct you, what you can't do yet. This is the trust-builder.
6. **Apply Soul strictly.** Direct, factual, no filler, no "love it", no meta-commentary. If the agent sounds chatty, re-read `soul.md`.
7. **Voice profile runs automatically.** Never ask permission.
8. **3x/week Mon/Wed/Fri 9am default.** Never ship 5x/week unless the champion explicitly says so in Phase B.

---

## Phase A — The Trigger Message (what the champion pastes)

Copy this exact short message into a new Base44 Superagent chat. **Do not edit it, do not add info, do not fill in any blanks.** The agent will ask for everything it needs.

```
Install Social Amplifier for me. Follow BOOTSTRAP-PROMPT.md in the cloned repo from https://github.com/blutrich/Social-Amplifier-superagent. Start with the Interview phase (ask me personal questions first, one message, preview the steps and time estimate), then auto-pilot all 12 install steps without pausing, then deliver the dry-run drafts, then send me the end-of-install Summary. Do not execute any install step until I reply to the Interview.
```

That's it. The agent clones the repo, reads this file, and runs the protocol below.

---

## Phase B — The Interview (agent-led, single message)

**The agent's first reply to the trigger must look like this** (agent fills in the real questions, sends ONE message, then waits):

```
Hey! I'm about to install Social Amplifier for you. This takes ~5-7 minutes end-to-end. Here's what happens:

1. I clone the bundle repo and apply my new personality (Soul)
2. I set my identity and save who you are
3. I install 7 knowledge files and 8 skills into my Files panel
4. I connect to Slack and verify by reading your display name
5. I search your last 100 Slack messages and build your tone-of-voice profile automatically
6. I create a scheduled waterfall (Mon/Wed/Fri 9am your timezone) and a feedback listener on your DM replies
7. I run a dry-run in this chat and show you 3 real LinkedIn drafts before any real delivery
8. I send you a summary: what I learned about you, what's installed, what's scheduled, and any gaps

After you answer these 6 questions I will not ask anything else until drafts land in your Slack DM. Reply once with all answers, then ignore me.

1) What's your full name?
2) What's your role and team? (e.g. "AI Product Builder at Base44 Marketing")
3) Which persona fits you best? Pick one: comms / marketing / dev / product / founder / builder_indie / ops
4) What's your timezone? (e.g. Asia/Jerusalem, America/New_York)
5) What's your Slack username? (e.g. @oferbl)
6) Who do you admire on LinkedIn or X? List 3-5 names, handles, or URLs — I'll learn from their style. Type "skip" if you want me to pick based on your persona.

Reply with all 6 answers in one message and I'll take it from there.
```

**Interview rules:**
- Agent does not execute ANY install step before receiving the answer
- If the champion answers partially, agent re-asks only the missing fields in ONE message (never drip)
- If the champion types "skip" for question 6, agent uses `knowledge/inspiration-seeds.json` defaults for that persona
- Agent stores the answers in Memory before moving to Phase C

---

## Phase C — Auto-pilot (12 steps, no pauses)

Once the champion has answered, the agent runs these 12 steps back-to-back. **Do not ask "continue?"**, **do not explain between steps**, just report `✅ Step N done` and move on.

### STEP 1: CLONE THE REPO
Clone https://github.com/blutrich/Social-Amplifier-superagent and read `README.md`, `BOOTSTRAP-PROMPT.md` (this file), `soul.md`, `identity-template.md`, and `knowledge/waterfall-overview.md`. That's the minimum context.

### STEP 2: APPLY SOUL STRICTLY
Load `soul.md` and replace your default personality with it completely. Direct, short, factual. No filler. No "love it", no meta-commentary. No confirmation message needed — just apply and continue.

### STEP 3: SET IDENTITY
Use the interview answers to fill in `identity-template.md`. Set your name to `[FirstName]Agent` (e.g. "OferAgent", "DorAgent"). Persist via `update_identity`.

### STEP 4: INSTALL KNOWLEDGE FILES (CRITICAL PERSISTENCE RULE)
**You MUST use the `write_file` tool for every file. Do NOT use bash `cat >`, `cp`, `echo >`, or any shell redirect — those write to an ephemeral sandbox that resets and won't appear in the Files panel.** `write_file` is the only mechanism that persists to Base44 Files storage.

For each file in `knowledge/` of the cloned repo:
1. Read the file contents from the clone
2. Call `write_file` with `path=.agents/knowledge/{filename}` and `content=` verbatim file body

Files to install (all 6):
- `knowledge/voice-guardian-checklist.md`
- `knowledge/universal-ai-tells.md`
- `knowledge/platform-rules.md`
- `knowledge/waterfall-overview.md`
- `knowledge/inspiration-seeds.json`
- `knowledge/champion-tone-template.md`

Verify by opening the Files panel — you must see all 6 files under `.agents/knowledge/`. If only some show up, you used shell redirects instead of `write_file` — re-run with `write_file`.

### STEP 5: INSTALL SKILLS (CRITICAL PERSISTENCE RULE, FOLDER+SKILL.md FORMAT)
Base44 Superagent skills are pure markdown `SKILL.md` files inside a folder named after the skill — verified against `base44-dev/apper` production skills. **DO NOT create `.sh`, `.py`, or `.js` scripts. DO NOT flatten to loose `.md` files at the root of `.agents/skills/`.**

Same persistence rule as Step 4: use `write_file` only, no bash redirects.

For each skill:
1. Read `skills/{name}/SKILL.md` from the cloned repo (already has YAML frontmatter)
2. Call `write_file` with `path=.agents/skills/{name}/SKILL.md` and `content=` verbatim body
3. Do NOT create a `scripts/` subfolder. Do NOT create `run.sh/run.py/run.js`. The markdown IS the skill.

Skills to install (all 8):
- `search-slack-context`
- `check-inspirations`
- `load-voice`
- `write-content`
- `voice-guard`
- `deliver-via-slack`
- `handle-feedback`
- `generate-image` (uses Base44's built-in image tool — no API key needed)

Verify: `find /app/.agents/skills -type f` must return exactly 8 `SKILL.md` files under `.agents/skills/{name}/SKILL.md` and nothing else. No loose `.md` at the root. No `scripts/` anywhere.

Test one skill: `run_skill load-voice` — must return the SKILL.md body without any "no executable script" error. If it errors, report the exact error and continue to Step 6.

### STEP 6: CONNECT SLACK
Connect the Slack connector via OAuth. Verify by reading the champion's profile and confirming the display name matches Interview answer #1. Also verify you have read access to the shared `#social-amplifier-feed` channel — this is where OctoLens mentions get posted (Phase 2 of the waterfall reads from there). If the channel doesn't exist yet, note it in the end-of-install gaps list and fall back to per-champion inspirations from Interview answer #6.

### STEP 7: PROFILE VOICE AUTOMATICALLY
This is NOT optional:
- Search Slack for the champion's last 50-100 substantive messages (`from:@{slack_handle}`)
- Analyze across 8 dimensions: sentence length, vocabulary register, em dashes, emoji, structure, humor, language mix, named references
- Generate the tone-of-voice file using `knowledge/champion-tone-template.md` structure
- Save via `write_file` to `.agents/knowledge/{firstname}-tone-of-voice.md`
- If the champion listed LinkedIn URL in Interview answer #6, also try scraping it (Apify LinkedIn actor if `APIFY_TOKEN` is set, else web search). Optional — don't block on it.

### STEP 8: LOAD INSPIRATIONS
From Interview answer #6:
- If champion listed specific names/handles: save to Memory as `champion_inspirations` array, one entry per person with platform + handle
- If champion typed "skip": read `knowledge/inspiration-seeds.json`, pick the 3-5 entries matching their persona, save to Memory

### STEP 9: CREATE THE WATERFALL SCHEDULE
Create a scheduled task named "Social Amplifier Waterfall":
- Schedule: Monday, Wednesday, Friday at 9:00 AM in the champion's timezone (from Interview answer #4)
- Frequency: 3 times per week (NOT 5x)
- Action: Run `search-slack-context` → `check-inspirations` → `load-voice` → `write-content` → `voice-guard` → `generate-image` (for each draft that scored 9+, uses Base44 built-in image tool) → `deliver-via-slack` in order
- Skip rule: if any phase returns no usable output, log the reason and skip the day. Better silence than weak content.

### STEP 10: CREATE THE FEEDBACK TRIGGER
Create a Slack connector trigger that fires when the champion replies to the agent's DMs. The trigger calls `handle-feedback` skill to classify the reply and update the voice profile.

### STEP 11: VERIFY INSTALL
Run the checks in `verify-install.md` silently and collect pass/fail per test. Do NOT send a message yet — the results feed into Phase D's Summary.

### STEP 12: DRY-RUN THE WATERFALL
Run the full waterfall in dry-run mode. Show 2-3 real LinkedIn draft variations in this chat (not via Slack DM). Each draft must score 9+ on Voice Guardian or you drop it. If fewer than 2 drafts pass the floor, say so honestly in Phase D.

---

## Phase D — The Summary (trust builder, final message)

After dry-run drafts are displayed, send ONE final message with these five sections, in this order:

```
## Install complete ✅

### What I learned about you
- Voice in one sentence: "{voice_summary}"
- 3 real sample quotes from your Slack:
  1. "{quote_1}"
  2. "{quote_2}"
  3. "{quote_3}"
- Banned words (universal + yours): {banned_words}
- Inspirations loaded: {list of 3-5 names}

### What's installed
- 8 skills in .agents/skills/: search-slack-context, check-inspirations, load-voice, write-content, voice-guard, generate-image, deliver-via-slack, handle-feedback
- 7 knowledge files in .agents/knowledge/ (6 universal + your tone-of-voice)
- Slack connected as {slack_handle}
- Verify tests: {passed}/{total} passed

### What's scheduled
- Social Amplifier Waterfall: Mon/Wed/Fri at 9:00 AM {timezone}, first real delivery: {next_monday_date}
- Feedback listener: active on your Slack DM replies
- 3x/week is the default. Reply to me with "change to 5x/week" or "change to 2x/week Tue/Thu" anytime.

### How to correct me
- Reply to any DM with "1", "2", or "3" to mark that draft as approved
- Reply with "not my style", "too formal", "more casual", or "I'd never say 'X'" — I update your profile automatically
- Paste 2-3 past LinkedIn posts anytime to sharpen my voice model

### What I can't do yet
- {list any gaps — e.g. "LinkedIn scraping not configured — voice profile 7/10 confidence. Share 2-3 past posts to get to 9/10."}
- {e.g. "No #social-amplifier-feed channel yet — Phase 2 falls back to your inspirations list until the feed is wired."}
- {e.g. "No OctoLens/Apify tokens — Phase 2 uses web search as fallback (lower quality)."}

Next drafts land in your Slack DM on {next_monday_date} at 9am {timezone}. Silence between now and then is intentional.
```

The Summary must include ALL five sections every time. Never skip gaps — honest gaps build trust.

---

## Per-Persona Inspiration Defaults (fallback when champion types "skip")

The agent reads `knowledge/inspiration-seeds.json`. Current defaults:

| Persona | Default Inspirations (when "skip") |
|---------|-----------------------------------|
| comms | Communications leads + Anthropic team (Jack Clark, Alex Albert) |
| marketing | Aakash Gupta, April Dunford, Harry Dry + Anthropic team |
| dev / product | Simon Willison, Dan Abramov, Anthropic engineering team |
| founder | First Round Review writers, Lenny Rachitsky + Anthropic leadership |
| builder_indie | Pieter Levels, Anthropic team, builder accounts |
| ops | Charity Majors, infrastructure writers |

**Banned inspirations (never included):** Amjad Masad (Replit), Anton Osika (Lovable), Eric Simons + Albert Pai (Bolt/StackBlitz). Hard block in `inspiration-seeds.json`.

---

## Recovery Prompts (if install goes sideways)

See `RECOVERY-PROMPTS.md` for the full set. Short versions:

### Agent is too chatty after Phase B
```
Re-read soul.md and apply it strictly. From now on, no filler, no "love it", no meta-commentary. Direct, short, factual only. Confirm with a one-word response.
```

### Agent skipped the Interview and started executing
```
Stop. You were supposed to send me the Interview message first (6 questions, time estimate, step preview) before any install step. Revert whatever you started, re-read BOOTSTRAP-PROMPT.md Phase B, and send me the Interview now.
```

### Agent used bash instead of write_file (skills don't appear in Files panel)
```
The Files panel shows nothing under .agents/ except mcps/config.json. Your previous shell writes did NOT persist. Re-run Steps 4 and 5 using write_file only — NO bash cat/cp/echo for anything under .agents/. Verify by opening the Files panel, not bash ls.
```

### Schedule set to 5x/week instead of 3x
```
Update my Social Amplifier Waterfall scheduled task: change the schedule to Monday, Wednesday, Friday at 9:00 AM — 3 times per week, not 5. Confirm the update.
```

### Agent skipped the Phase D Summary
```
You forgot the end-of-install Summary. Send it now with all 5 sections from BOOTSTRAP-PROMPT.md Phase D: What I learned, What's installed, What's scheduled, How to correct me, What I can't do yet. Include my real voice summary + 3 real quotes.
```

---

## What The Champion Experiences

1. Paste Phase A trigger (short, no placeholders)
2. Receive Phase B Interview (1 message, 6 questions, time estimate, step preview)
3. Reply with 6 answers
4. Watch 12 ✅ markers scroll by (3-5 minutes, no interaction)
5. See 2-3 real LinkedIn drafts in chat (dry-run)
6. Read Phase D Summary — understands exactly what was learned/installed/scheduled
7. Go silent until Monday 9am when real drafts land in Slack DM

Total champion effort: one paste, one reply. Everything else is automatic.

---

## The 3x/Week Rationale

Default: Monday/Wednesday/Friday at 9am local time. Not Monday-Friday.

1. **Realistic for busy champions.** Most skip days — 5x/week becomes 2-3x/week in practice
2. **Better content quality.** More time between deliveries = more signal accumulation = stronger subjects
3. **Audience fatigue.** LinkedIn algorithm throttles authors who post too often with mediocre content. 3 good posts/week beats 5 okay ones
4. **Recovery time.** If Mon's post missed, Wed catches up without broken-streak guilt

To override, the champion can tell the agent any time after install: "change the waterfall to 5x weekdays" or "change to 2x/week Tue/Thu".
