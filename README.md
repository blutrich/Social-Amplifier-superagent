# Social Amplifier — Base44 Superagent Bundle

Personal social content agent for Base44 champions. Each champion gets their own Base44 Superagent that drafts LinkedIn posts in their voice, every weekday morning, without a single manual command.

> **Looking for the Claude Code plugin version?** See [Social-Amplifier-agent](https://github.com/blutrich/Social-Amplifier-agent). Same logic, different surface.

## What This Does

You install this bundle into your own Base44 Superagent. From then on:

- Mon/Wed/Fri at 9am local time, your agent runs a 7-phase content waterfall
- It searches your Slack for fresh feature signals + your recent messages
- It reads the shared `#social-champions-octolens-feed` channel to see what your inspirations posted this week
- It loads your tone-of-voice rules
- It generates 2-3 LinkedIn drafts in your specific voice
- It scores them against the Voice Guardian (10-point quality gate, no AI tells)
- It generates a branded image per approved draft using Base44's built-in image tool
- It DMs you the approved drafts + images via Slack
- You reply with feedback, the agent updates your voice profile

Total daily effort from you: 30 seconds to read drafts + post the one you like.

## Install (5-7 Minutes, Zero Placeholders)

### Prerequisites

- Base44 account (any tier)
- Slack workspace access (to receive DMs + read the shared feed channel)
- Operator-side only (one-time, not per champion): the Apify Inspiration Feeder App running. See `docs/setup-apify-feeder.md`.

---

### The Install Flow (Interview → Auto-pilot → Summary)

1. Create a new Superagent in [Base44](https://app.base44.com)
2. Paste this **exact** short message (no placeholders, no edits):

```
Install Social Amplifier for me. Follow BOOTSTRAP-PROMPT.md in the cloned repo from https://github.com/blutrich/Social-Amplifier-superagent. Start with the Interview phase (ask me personal questions first, one message, preview the steps and time estimate), then auto-pilot all 12 install steps without pausing, then deliver the dry-run drafts, then send me the end-of-install Summary. Do not execute any install step until I reply to the Interview.
```

3. The agent clones the repo, reads `BOOTSTRAP-PROMPT.md`, and sends you **one Interview message**: a 5-7 minute time estimate, the 12-step preview, and 6 personal questions (name, role, persona, timezone, Slack handle, inspirations with "skip" fallback).
4. You reply with your 6 answers in one message, then ignore it.
5. The agent auto-pilots all 12 install steps with ✅ progress markers.
6. It shows you 2-3 real LinkedIn drafts from a dry-run.
7. It sends you a final **Summary**: what it learned about you (voice + 3 quotes + banned words + inspirations), what's installed, what's scheduled, how to correct it, and any gaps.

From paste to Summary: 5-7 minutes. Zero placeholder confusion, no manual intervention after you answer the Interview.

See `BOOTSTRAP-PROMPT.md` for the full protocol. See `RECOVERY-PROMPTS.md` if something goes wrong mid-install.

## How It Works

Two distinct flows. Onboarding happens **once**. The waterfall runs **Mon/Wed/Fri** forever after.

### Flow 1: Onboarding (one-time, ~5-7 minutes)

```
┌──────────────────────────────────────────────────────────────┐
│ CHAMPION                          SUPERAGENT                 │
├──────────────────────────────────────────────────────────────┤
│                                                              │
│ 1. Creates new Superagent in Base44                          │
│                                                              │
│ 2. Pastes the self-contained  ──▶  reads all 10 Design Rules │
│    install message (one block)     + Phase B/C/D inline      │
│                                                              │
│                               ◀──  PHASE B: Sends ONE        │
│                                    message                   │
│                                    • Time estimate (~5-7min) │
│                                    • 12-step preview         │
│                                    • 6 questions:            │
│                                      name/role/persona/      │
│                                      timezone/slack/         │
│                                      inspirations            │
│                                                              │
│ 3. Replies ONCE with all 6   ──▶  PHASE C (autopilot,        │
│    answers                         12 steps, no pauses)      │
│                                                              │
│    Goes silent.                    Step 1:  Clone repo       │
│                                    Step 2:  Apply Soul       │
│                                    Step 3:  Set identity     │
│                                    Step 4:  Install 6 knowl. │
│                                             files            │
│                                             (write_file)     │
│                                    Step 5:  Install 8 skill  │
│                                             folders          │
│                                             + run_skill test │
│                                    Step 6:  Connect Slack    │
│                                             + join feed      │
│                                             channel          │
│                                             C0ATMPHHM40      │
│                                    Step 7:  Profile voice    │
│                                             from Slack hist. │
│                                    Step 8:  Load inspiration │
│                                             list             │
│                                    Step 9:  Create Mon/Wed/  │
│                                             Fri 9am cron     │
│                                    Step 10: Create feedback  │
│                                             trigger          │
│                                    Step 11: Silent verify    │
│                                    Step 12: Dry-run waterfall│
│                                                              │
│                               ◀──  Shows 2-3 LinkedIn drafts │
│                                    in chat (dry-run only,    │
│                                    not sent to Slack)        │
│                                                              │
│                               ◀──  PHASE D: Summary          │
│                                    message (5 sections):     │
│                                    1. What I learned (voice  │
│                                       + 3 real quotes)       │
│                                    2. What's installed       │
│                                    3. What's scheduled       │
│                                    4. How to correct me      │
│                                    5. What I can't do yet    │
│                                                              │
│ 4. Reads Summary, goes quiet.                                │
│    Waits until next Monday 9am.                              │
│                                                              │
└──────────────────────────────────────────────────────────────┘
```

**Champion total effort: one paste + one reply. Everything else is automatic.**

---

### Flow 2: Daily Waterfall (Mon/Wed/Fri 9am, ~60-90s unattended)

```
┌──────────────────────────────────────────────────────────────┐
│ SCHEDULED TASK FIRES (Base44 cron, 9am local timezone)       │
├──────────────────────────────────────────────────────────────┤
│                                                              │
│ PHASE 1: search-slack-context                                │
│   • Search champion's own Slack messages (last 48-72h)       │
│   • Read feature announcement channels                       │
│   • Return 3-10 scored signals                               │
│                                                              │
│         ▼                                                    │
│                                                              │
│ PHASE 2: check-inspirations                                  │
│   • Read #social-champions-octolens-feed (last 7 days)       │
│     (OctoLens and Apify Feeder post here centrally)          │
│   • Filter by champion_inspirations list                     │
│   • Return top 5 mentions with suggested response angles     │
│                                                              │
│         ▼                                                    │
│                                                              │
│ PHASE 3: load-voice                                          │
│   • Read champion's tone-of-voice profile                    │
│   • Read style preferences (em dashes, emoji, banned words)  │
│   • Read last 30 days of delivered content (avoid dupes)     │
│                                                              │
│         ▼                                                    │
│                                                              │
│ PHASE 4: write-content                                       │
│   • Pick strongest signal from Phases 1+2                    │
│   • Generate 2-3 variations using DIFFERENT angles:          │
│     - Personal experience (internal anchor)                  │
│     - Echo response (built on an inspiration's post)         │
│     - Reflection (synthesis across signals)                  │
│                                                              │
│         ▼                                                    │
│                                                              │
│ PHASE 5: voice-guard                                         │
│   • Score each variation on 10-point checklist               │
│   • Apply champion overrides (em dashes, emoji, etc.)        │
│   • Auto-rewrite 7-8 scores (max 2 attempts)                 │
│   • Drop anything below 9/10                                 │
│   • If 0 pass → SKIP THE DAY, log reason, silence            │
│                                                              │
│         ▼                                                    │
│                                                              │
│ PHASE 5.5: generate-image (only for passed drafts)           │
│   • Base44 built-in image tool (no API key)                  │
│   • Attach to draft object                                   │
│                                                              │
│         ▼                                                    │
│                                                              │
│ PHASE 6: deliver-via-slack                                   │
│   • Format drafts with daily-digest template                 │
│   • DM champion via Slack                                    │
│   • Log to content history                                   │
│                                                              │
└──────────────────────────────────────────────────────────────┘
          │
          ▼
    CHAMPION'S SLACK DM:
    "Good morning Ofer! Here are today's drafts:

    Option 1 — Personal experience angle
    [draft + optional image]

    Option 2 — Echo response to @aakashg0's post
    [draft + optional image]

    Reply 1 or 2 to mark posted,
    or 'not my style' + feedback."
          │
          ▼
    CHAMPION REPLIES (any time)
          │
          ▼
┌──────────────────────────────────────────────────────────────┐
│ FEEDBACK TRIGGER FIRES (Slack connector, on any DM reply)    │
├──────────────────────────────────────────────────────────────┤
│                                                              │
│   handle-feedback skill classifies the reply:                │
│                                                              │
│   "1" / "2" / "3"              → mark approved, log          │
│   "not my style"               → update tone-of-voice        │
│   "too formal"                 → formality = casual          │
│   "I'd never say X"            → add X to banned_words       │
│   paste of past LinkedIn post  → learn from it               │
│   silence                      → that's fine, no nagging     │
│                                                              │
│   Updates champion's voice profile in Memory                 │
│   Next Mon/Wed/Fri run uses the updated profile              │
│                                                              │
└──────────────────────────────────────────────────────────────┘
```

**Daily champion effort: 30 seconds to read, copy, paste to LinkedIn.**

---

### Key properties of both flows

- **Onboarding** touches everything once: secrets, skills, knowledge, schedule, verify, dry-run, summary
- **Daily** is read-only on secrets/config — it only reads what onboarding wrote
- **Silence is acceptable** at every decision point: Phase 5 can drop the day, champion can ignore the DM, feedback is optional
- **No per-day operator involvement** — once onboarded, the agent is invisible until the champion chooses to engage
- **The shared feed channel is the one central dependency** — OctoLens and the Apify Feeder App both post into `#social-champions-octolens-feed`, all champion agents read from that one channel

## File Reference

| File | Purpose |
|------|---------|
| `README.md` | This file - install instructions |
| `BOOTSTRAP-PROMPT.md` | First message to send your new Superagent |
| `identity-template.md` | Name, persona, communication style (you fill in) |
| `soul.md` | Behavioral principles (same for all champions) |
| `knowledge/voice-guardian-checklist.md` | 10-point quality scoring rubric |
| `knowledge/universal-ai-tells.md` | 80+ banned patterns (em dashes, "thrilled to announce", etc.) |
| `knowledge/platform-rules.md` | LinkedIn + X format specs |
| `knowledge/waterfall-overview.md` | How the 6 phases connect |
| `knowledge/inspiration-seeds.json` | Persona → influencer mapping with banned competitors |
| `knowledge/champion-tone-template.md` | Template for YOUR personal tone-of-voice file |
| `skills/*.md` | The 7 skills implementing the waterfall phases |
| `tasks/daily-waterfall.md` | Scheduled task description |
| `tasks/feedback-on-reply.md` | Reply trigger description |
| `connectors-required.md` | Which Base44 connectors to enable |
| `verify-install.md` | How to test the install worked |

## Customizing for Yourself

The bundle ships with templates. To make it actually yours:

1. Fill in `identity-template.md` with your name, role, communication style
2. Create your own tone-of-voice file based on `champion-tone-template.md`
   - The agent can do this for you in chat: "Look at my last 50 Slack messages and my last 5 LinkedIn posts, then generate my tone-of-voice file"
3. Add your inspirations to your profile by chat: "These are the people I want to learn from: [list 3-5 names with LinkedIn URLs]"
4. Optionally override style preferences via chat: "I never use hashtags. Em dashes are fine. Maximum 1 emoji per post."

The Superagent's Memory captures all of this and uses it on every future generation.

## Banned Inspirations

Per Base44 brand rules, the bundle blocks competitor CEOs from being used as inspirations:

- Amjad Masad (Replit) — banned
- Anton Osika (Lovable) — banned
- Eric Simons (Bolt/StackBlitz) — banned
- Albert Pai (Bolt/StackBlitz) — banned

The Anthropic team (Mike Krieger, Jack Clark, Alex Albert, Karina Nguyen, Amanda Askell, Dario Amodei, Sam Bowman) is always allowed and weighted as Tier-1 inspirations for relevant personas.

## Getting Help

- **Install issues:** See `verify-install.md` for common problems
- **Voice doesn't sound like you:** Run `/audit-voice` in your Superagent chat — it will analyze recent drafts vs your real writing and suggest profile updates
- **Slack DMs not arriving:** Check Slack connector permissions in **Brain → Integrations**
- **Daily schedule not firing:** Check **Tasks** tab in your Superagent for the scheduled task
- **General questions:** DM @oferbl in Base44 Slack

## License

MIT — internal Base44 use, free to fork and adapt.
