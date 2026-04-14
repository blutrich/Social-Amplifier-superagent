# Bootstrap Prompt

The exact message to send your new Base44 Superagent to install Social Amplifier in one shot. The new agent should EXECUTE, not chat. Fill in your name, role, persona, and timezone, then paste into your Superagent chat.

---

## Critical Design Rules For The Agent

When the agent receives this message, it MUST:

1. **Explain the full plan first.** Tell the user all 10 steps before executing any of them. One message, numbered list, no questions yet. The user should see "here's what I'm about to do" before anything changes.
2. **Get minimal inputs in one batch.** After the plan summary, ask for Slack username + optional MCP tokens IN ONE MESSAGE. Don't drip questions one at a time.
3. **Execute everything in order.** After the user confirms, run all 10 steps sequentially without stopping to chat. Report progress with ✅ markers.
4. **Profile the voice automatically.** Don't ask "do you want me to profile your voice?" — always do it. It's part of the install.
5. **Default to 3x/week schedule.** Monday, Wednesday, Friday at 9am local time. Not weekdays. 3 posts/week is realistic for busy champions.
6. **No chatty commentary.** Soul.md says direct, short, factual. If the agent sounds like "Social Amplifier — love it, straight to the point", it didn't load Soul correctly. Re-read soul.md and apply strictly.

---

## The Template (Copy & Paste)

```
Install Social Amplifier for me. Here's everything you need in one shot:

MY INFO:
- Name: [YOUR_FULL_NAME]
- Role: [YOUR_ROLE] at [YOUR_TEAM]
- Persona: [comms|marketing|dev|product|founder|builder_indie|ops]
- Timezone: [YOUR_TIMEZONE e.g. Asia/Jerusalem]
- Slack username: @[YOUR_SLACK_HANDLE]

REPO:
https://github.com/blutrich/Social-Amplifier-superagent

WHAT I WANT YOU TO DO (in this exact order, no detours):

STEP 1: EXPLAIN THE PLAN FIRST
Before touching anything, send me ONE message that lists all 10 steps you're about to take and what the end result will be. Don't start executing until I confirm "go".

STEP 2: CLONE THE REPO
Clone https://github.com/blutrich/Social-Amplifier-superagent and read README.md, BOOTSTRAP-PROMPT.md, soul.md, identity-template.md, and knowledge/waterfall-overview.md first. That's the minimum context.

STEP 3: APPLY SOUL STRICTLY
Load soul.md and replace your default personality with it completely. Direct, short, factual. No filler. No "love it", no "interesting opener", no commentary. Test this by sending me one short confirmation message after Soul loads. If you're still chatty, re-read Soul.

STEP 4: SET IDENTITY
Use my info above to fill in identity-template.md. Set your name to [FirstName]Agent.

STEP 5: INSTALL KNOWLEDGE FILES (CRITICAL - DO NOT SKIP)
For each file in the knowledge/ folder of the cloned repo, do this:
1. Read the file contents
2. Save it to your .agents/knowledge/ folder with the same filename
3. ALSO add it to Brain → Knowledge → Knowledge files via your upload mechanism

Files to install (all 6):
- knowledge/voice-guardian-checklist.md
- knowledge/universal-ai-tells.md
- knowledge/platform-rules.md
- knowledge/waterfall-overview.md
- knowledge/inspiration-seeds.json
- knowledge/champion-tone-template.md

After installing, verify by running `ls .agents/knowledge/` — you must see all 6 files. If the ls command fails, tell me the specific error.

STEP 6: INSTALL SKILLS (CRITICAL - DO NOT SKIP)
The skills/ folder in the cloned repo has 8 skill folders. Base44 Superagent skills are pure markdown SKILL.md files inside a folder named after the skill — verified against base44-dev/apper production skills. DO NOT create .sh, .py, or .js scripts. DO NOT flatten to loose .md files at the root of .agents/skills/.

For each skill, execute this exact pattern:
1. Read the file from the cloned repo at skills/{name}/SKILL.md (already has YAML frontmatter)
2. Create directory /app/.agents/skills/{name}/
3. Write the full SKILL.md contents verbatim to /app/.agents/skills/{name}/SKILL.md
4. Do NOT create a scripts/ subfolder. Do NOT create run.sh/run.py/run.js. The markdown IS the skill.

Skills to install (all 8):
- search-slack-context
- check-inspirations
- load-voice
- write-content
- voice-guard
- deliver-via-slack
- handle-feedback
- generate-image (optional, skip if no Google API key)

Verify layout:
  find /app/.agents/skills -type f
  Expected output: exactly 8 SKILL.md files under /app/.agents/skills/{name}/SKILL.md and nothing else. No loose .md at the root. No scripts/ anywhere.

Test one skill: run_skill load-voice — it must return the SKILL.md body without any "no executable script" error. If it errors, stop and tell me the exact error.

STEP 7: CONNECT SLACK
Walk me through connecting Slack. Verify by reading my own profile and telling me my display name.

STEP 8: PROFILE MY VOICE (AUTOMATICALLY, DO NOT SKIP)
This is NOT optional. Execute this without asking:
- Search Slack for my last 50-100 substantive messages (from:@[MY_SLACK_HANDLE])
- If I have LinkedIn URL, scrape it via web search or Bright Data
- Generate my tone-of-voice file by analyzing those real samples
- Save it as part of my Knowledge files
- Show me the summary (voice in one sentence + 3 sample quotes + my banned words list)

STEP 9: CREATE THE DAILY WATERFALL SCHEDULE
Create a scheduled task named "Social Amplifier Waterfall":
- Schedule: Monday, Wednesday, Friday at 9:00 AM [MY_TIMEZONE]
- Frequency: 3 times per week (NOT 5x)
- Action: Run search-slack-context → check-inspirations → load-voice → write-content → voice-guard → deliver-via-slack in order
- If any phase returns no usable output, log the reason and skip the day. Better silence than weak content.

STEP 10: CREATE THE FEEDBACK TRIGGER
Create a Slack connector trigger that fires when I reply to your DMs. The trigger should call handle-feedback skill to classify my reply and update my voice profile.

STEP 11: VERIFY INSTALL
Run through verify-install.md tests and report which passed/failed in one summary message.

STEP 12: DRY-RUN THE WATERFALL
Run the full waterfall in "dry-run" mode — show me 2-3 LinkedIn drafts in this chat, do NOT send via Slack yet. I want to see the first batch before the real delivery happens.

RULES FOR THIS INSTALL:
- Execute steps 2-12 sequentially after I confirm "go". Don't chat in between.
- Report each step with ✅ when done and move to the next.
- If a step fails, log the specific error and continue to the next step. Only stop if Slack connection fails (that's a blocker).
- Don't ask me intermediate questions unless absolutely required. Use my info above.
- Don't auto-send any Slack DMs to me during the install. The dry-run in Step 12 stays in chat.
- If I have OctoLens or Bright Data tokens, prompt for them in Step 7 alongside Slack. If I don't, skip them and use web search as fallback.

Start with Step 1 now. Show me the plan, wait for my "go", then execute.
```

---

## Filled-In Example: Ofer (marketing persona)

```
Install Social Amplifier for me. Here's everything you need in one shot:

MY INFO:
- Name: Ofer Blutrich
- Role: AI Product Builder at Base44 Marketing
- Persona: marketing
- Timezone: Asia/Jerusalem
- Slack username: @oferbl

REPO:
https://github.com/blutrich/Social-Amplifier-superagent

WHAT I WANT YOU TO DO (in this exact order, no detours):

[... same 12 steps as template ...]

Start with Step 1 now. Show me the plan, wait for my "go", then execute.
```

---

## Filled-In Example: Dor (comms persona)

```
Install Social Amplifier for me. Here's everything you need in one shot:

MY INFO:
- Name: Dor Blech
- Role: Head of Communications at Base44
- Persona: comms
- Timezone: Asia/Jerusalem
- Slack username: @dorbl

REPO:
https://github.com/blutrich/Social-Amplifier-superagent

WHAT I WANT YOU TO DO (in this exact order, no detours):

[... same 12 steps as template ...]

Start with Step 1 now. Show me the plan, wait for my "go", then execute.
```

---

## Per-Persona OctoLens Views

The agent reads these from `knowledge/inspiration-seeds.json`, but here's the mapping for reference:

| Persona | Primary OctoLens Views | Why |
|---------|----------------------|-----|
| comms | 20496 (Brand Monitoring), 20500 (Crisis Management) | Track brand sentiment + respond to crises fast |
| marketing | 20498 (Competitor Intelligence), 20497 (Buy Intent) | See competitor moves + buying signals |
| dev | 20499 (Industry Insights) + product_question tag | Technical debates + bug reports |
| product | 20499 (Industry Insights) + user_feedback tag | Product feedback + feature requests |
| founder | 20511 (Positive) + minXFollowers: 5000 | High-reach amplification opportunities |
| builder_indie | 20499 + keywords [base44, lovable, replit, anthropic] | Builder-space narratives |
| ops | tag:industry_insights + tag:bug_report | Infrastructure discussions |

---

## What Happens After You Send This

The Superagent should:

1. Send you ONE message with the full 12-step plan (Step 1)
2. Wait for you to reply "go"
3. Execute Steps 2-12 sequentially with ✅ markers
4. Automatically profile your voice from Slack (Step 8) — no asking
5. Set up the 3x/week schedule (Mon/Wed/Fri) — NOT 5x
6. Show you 2-3 LinkedIn drafts in chat (Step 12)
7. Confirm install complete with what's next

Total time: 3-5 minutes from sending to seeing first drafts.

---

## Recovery Prompts (If Install Goes Sideways)

### If the agent is too chatty (doesn't follow Soul)

```
Re-read soul.md and apply it strictly. From now on, no filler, no commentary, no "love it" or "interesting opener". Direct, short, factual only. Confirm with a one-word response.
```

### If the agent skipped voice profiling

```
Execute Step 8 of my install now: profile my voice from my Slack messages automatically. Pull my last 50 substantive messages via Slack search, analyze my patterns across 8 dimensions (sentence length, vocabulary, em dashes, emoji, structure, humor, language, named references), generate my tone-of-voice file, and show me the summary with 3 real sample quotes.
```

### If the schedule was set to 5x/week instead of 3x/week

```
Update my Social Amplifier Waterfall scheduled task: change the schedule to Monday, Wednesday, Friday at 9:00 AM [MY_TIMEZONE] — 3 times per week, not 5. Confirm the update.
```

### If automations "failed to create"

```
Retry creating the scheduled task. Use the task description from tasks/daily-waterfall.md exactly. If the create_automation tool fails, tell me the specific error so I can diagnose.
```

### If the dry-run is hanging

```
Abort the current dry-run. Re-run the waterfall as a simplified test: just call search-slack-context, show me the top 5 signals you found, then stop. Don't run the other phases yet.
```

### If the agent didn't install the Soul correctly (still sounds like default Base44 bot)

```
Your Soul should make you direct and factual, not chatty. Test: describe what you just did in 10 words or less. If you can't, your Soul didn't apply. Re-read soul.md from the repo clone and replace your personality section entirely.
```

---

## The 3x/Week Rationale

Previously the schedule defaulted to 5x/week (weekdays). Changed to 3x/week (Mon/Wed/Fri) because:

1. **Realistic for busy champions.** Most will skip days — 5x/week becomes 2-3x/week in practice anyway
2. **Better content quality.** More time between deliveries = more signal accumulation in OctoLens/Slack = stronger subject candidates
3. **Audience fatigue.** LinkedIn algorithm throttles authors who post too often with mediocre content. 3 good posts/week beats 5 okay ones.
4. **Recovery time.** If Mon's post missed, Wed catches up without a "daily streak" guilt

To override to 5x/week: add this line at the end of your bootstrap prompt:
```
Override: schedule the waterfall 5 times per week (Mon-Fri) instead of 3x. I can handle the higher cadence.
```

Or to reduce further to 2x/week:
```
Override: schedule the waterfall 2 times per week (Tue/Thu) instead of 3x.
```
