# Recovery Prompts

When the install goes sideways, use these prompts to fix specific problems without starting over.

---

## Recovery 1: Skills Weren't Installed

**Symptom:** You see Identity/Soul/User set correctly in Brain, but `.agents/skills/` is empty and skills don't show up in Brain → Integrations → Skills.

**Root cause:** The initial bootstrap set the Brain fields but didn't explicitly create custom skills from the repo files. Base44 Superagents need each skill created by name, not uploaded as a bulk file dump.

**Send this to your Superagent:**

```
Skills never got installed. Fix this now:

1. The repo is at https://github.com/blutrich/Social-Amplifier-superagent — clone it again if you don't still have it locally

2. Read the contents of EACH of these files from the skills/ folder:
   - skills/search-slack-context.md
   - skills/check-inspirations.md
   - skills/load-voice.md
   - skills/write-content.md
   - skills/voice-guard.md
   - skills/deliver-via-slack.md
   - skills/handle-feedback.md
   - skills/generate-image.md

3. For each file, create a custom skill with:
   - Skill name: filename without .md extension (e.g., "search-slack-context")
   - Description: the first paragraph of the file (the one right after the frontmatter)
   - Body: the entire file contents verbatim, including frontmatter

Use your skill creation tool directly. If you have create_skill, use_skill, or equivalent, call it once per skill.

4. After all 8 skills are created, run: ls .agents/skills/
   Report what you see.

5. If any skill creation failed, tell me the specific error. Don't skip silently.

Execute now. Report progress with ✅ markers per skill.
```

---

## Recovery 2: Knowledge Files Not Loaded

**Symptom:** You installed skills but when the agent runs the waterfall, it says "I don't have access to voice-guardian-checklist.md" or similar missing file errors.

**Send this:**

```
Knowledge files aren't loaded. Fix this now:

From the cloned repo, read these 6 files and add each one to your Knowledge files in Brain:

1. knowledge/voice-guardian-checklist.md
2. knowledge/universal-ai-tells.md
3. knowledge/platform-rules.md
4. knowledge/waterfall-overview.md
5. knowledge/inspiration-seeds.json
6. knowledge/champion-tone-template.md

For each file:
- Read the contents
- Save to .agents/knowledge/ with the same filename
- Add to Brain → Knowledge → Knowledge files (via your upload mechanism)

After loading, verify you can query each one. Test: "Read voice-guardian-checklist.md and tell me the 10 checklist items." You should be able to answer.

Report ✅ per file.
```

---

## Recovery 3: Agent Is Still Chatty (Soul Didn't Override Personality)

**Symptom:** Agent still writes things like "Love it", "Interesting opener", "I respect that", or over-explains what it's about to do before doing it.

**Send this:**

```
Your default personality is overriding Soul. Re-apply Soul strictly:

1. Re-read soul.md from the cloned repo
2. The CRITICAL: Personality Override section is non-negotiable. Apply it completely.
3. Your personality is REPLACED by Soul, not blended with it. Drop the default Base44 bot vibe.
4. From now on:
   - One-line acknowledgments when executing
   - ✅ markers for progress
   - No commentary on my messages
   - No self-congratulation
   - No "let me..." or "I'll go ahead and..." openers
5. Confirm Soul is applied with a single short response. Don't explain it back to me.

Test: describe what you just did in 10 words or less. If you can't, your Soul didn't stick.
```

---

## Recovery 4: Schedule Is Wrong (5x/Week Instead of 3x/Week)

**Symptom:** The scheduled task runs every weekday (Mon-Fri) instead of Mon/Wed/Fri.

**Send this:**

```
Update the Social Amplifier Waterfall scheduled task:
- Change schedule from daily to Monday, Wednesday, Friday only
- Time: 9:00 AM [YOUR_TIMEZONE]
- Frequency: 3 times per week, NOT 5x

Confirm the change by showing me the updated schedule.
```

---

## Recovery 5: Voice Profiling Was Skipped

**Symptom:** The agent finished install but your champion-tone-template.md is still blank — it never analyzed your real Slack messages.

**Send this:**

```
Execute voice profiling now. Don't ask, just do it:

1. Search Slack for my last 50-100 substantive messages:
   - Filter: from:@[MY_SLACK_HANDLE]
   - Time range: last 30 days
   - Exclude: single-word responses, pure emoji, bot output

2. Analyze the messages across these 8 dimensions:
   - Sentence length pattern (short/medium/long/mixed)
   - Vocabulary register (casual/technical/mixed)
   - Punctuation habits (em dashes per 100 words, semicolons, ellipses)
   - Structure preferences (bullets, TL;DR format, numbered lists)
   - Humor and personality (joke frequency, self-deprecation, emoji usage)
   - Language mix (Hebrew/English %, code-switching patterns)
   - Named references (do you tag specific people)
   - Typical message length

3. Generate my tone-of-voice file using the champion-tone-template.md structure. Fill in every section with real observations from my messages.

4. Save it as "ofer-tone-of-voice.md" in your Knowledge files OR append to Memory as a saved fact.

5. Show me the summary:
   - Voice in one sentence
   - 3 real sample quotes from my Slack (verbatim)
   - My banned words list (universal + champion-specific)
   - My em dash preference (allow/deny based on actual usage)

Execute now. Report ✅ when done.
```

---

## Recovery 6: Automations Failed To Create

**Symptom:** Agent says "Failed to create automation" when trying to set up the daily waterfall task or feedback trigger.

**Send this:**

```
The automation creation failed. Try again with a different approach:

1. For the Social Amplifier Waterfall scheduled task, describe it as a simple recurring task:
   "Every Monday, Wednesday, and Friday at 9 AM Asia/Jerusalem, run these skills in order: search-slack-context, check-inspirations, load-voice, write-content, voice-guard, deliver-via-slack. Log the result to Memory."

2. For the feedback trigger, describe it as a Slack event handler:
   "When I reply to a DM from you (check messages where I'm the sender and the thread root was a message from you), run the handle-feedback skill on my reply text."

3. If create_automation still fails, tell me the specific error message — not just "failed". I need to know what Base44 is rejecting.

4. As a fallback: set up the schedule manually via Base44 UI → Tasks tab → Create scheduled task. I'll walk through the UI if needed.
```

---

## Recovery 7: Dry-Run Is Hanging

**Symptom:** You ran the dry-run and the agent is stuck at "Running commands..." for more than 2 minutes.

**Send this:**

```
Abort the current dry-run.

Then run a simplified version:

1. Just call search-slack-context skill alone
2. Show me the top 5 Slack signals you found (permalink + body excerpt + score)
3. Stop. Don't run the other phases yet.

I want to see which phase is hanging before running the full waterfall.
```

If that also hangs, the issue is the skill file itself didn't load correctly. Run Recovery 1 first.

---

## Recovery 8: Everything Is Broken — Start Over

**Symptom:** Too much is wrong to fix piece by piece.

**Option A: Rebuild skills and knowledge in place (keeps your Superagent)**

```
Wipe .agents/skills/ and .agents/knowledge/ and start fresh:

1. Delete all files in .agents/skills/ (if any)
2. Delete all files in .agents/knowledge/ (if any)
3. Clone the repo again: https://github.com/blutrich/Social-Amplifier-superagent
4. Execute Steps 5 and 6 of BOOTSTRAP-PROMPT.md (install knowledge + create skills)
5. Run verify-install.md tests
6. Report results

My Soul, Identity, User, and connectors are already correct. Only skills and knowledge need rebuilding.
```

**Option B: Delete the Superagent and create a new one**

1. In Base44 → Superagents → your Superagent → Settings → Danger Zone → Delete this agent
2. Create a new Superagent
3. Send the updated BOOTSTRAP-PROMPT.md from the latest repo version

Only do Option B if Option A fails repeatedly.

---

## After Recovery — Verify

Once you think the install is fixed, send:

```
Run the verify-install.md tests from the cloned repo. Execute tests 1, 2, 3, 4, 5, and 9. Report pass/fail for each with specific evidence.
```

Expected results:
- Test 1 (Skills): 7-8 skills listed
- Test 2 (Knowledge files): 6 files listed and readable
- Test 3 (Connectors): Slack connected, OctoLens optional
- Test 4 (Voice profile): champion-tone-of-voice loaded with real data
- Test 5 (Dry-run): 2-3 drafts in chat
- Test 9 (Schedule): 3x/week Mon/Wed/Fri confirmed

If all 6 pass, you're good to enable real delivery.
