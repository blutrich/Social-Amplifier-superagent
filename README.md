# Social Amplifier — Base44 Superagent Bundle

Personal social content agent for Base44 champions. Each champion gets their own Base44 Superagent that drafts LinkedIn posts in their voice, every weekday morning, without a single manual command.

> **Looking for the Claude Code plugin version?** See [Social-Amplifier-agent](https://github.com/blutrich/Social-Amplifier-agent). Same logic, different surface.

## What This Does

You install this bundle into your own Base44 Superagent. From then on:

- Every weekday at 9am local time, your agent runs a 6-phase content waterfall
- It searches your Slack for fresh feature signals + your recent messages
- It checks what your inspirations are posting this week (LinkedIn + X)
- It loads your tone-of-voice rules
- It generates 2-3 LinkedIn drafts in your specific voice
- It scores them against the Voice Guardian (10-point quality gate, no AI tells)
- It DMs you the approved drafts via Slack
- You reply with feedback, the agent updates your voice profile

Total daily effort from you: 30 seconds to read drafts + post the one you like.

## Install (2 Minutes With Clone Repo, 10 Minutes Manual)

### Prerequisites

- Base44 account (any tier)
- Slack workspace access (to receive DMs from your agent)
- LinkedIn profile (optional but recommended — better voice profiling)

---

### Option A: One-Message Install (Recommended)

Base44 Superagents can clone GitHub repos directly. This is the fastest install:

**Step 1:** Create a new Superagent
1. Log in to [Base44](https://app.base44.com)
2. Click **Superagents** in the sidebar
3. Click **Create new Superagent**
4. Name it (e.g., "DorAgent" or "MySocial")

**Step 2:** Send this single message:

```
Clone https://github.com/blutrich/Social-Amplifier-superagent and configure yourself based on the files there.

Read the README.md and BOOTSTRAP-PROMPT.md first to understand your role.

Then:
1. Set your Identity from identity-template.md (ask me for my name, role, timezone)
2. Set your Soul from soul.md
3. Upload all knowledge/ files as Knowledge files
4. Add all skills/ files as Skills
5. Walk me through connecting Slack
6. Walk me through OctoLens and Bright Data MCP setup (use my secrets if I have them)
7. Create the daily-waterfall scheduled task per tasks/daily-waterfall.md
8. Create the feedback-on-reply trigger per tasks/feedback-on-reply.md
9. Run the verify-install.md tests and report results

Walk me through each step and ask for the info you need.
```

The Superagent reads the repo, configures itself, asks you for your name and Slack info, sets up everything, and runs the verification tests. Total time: 2-5 minutes.

---

### Option B: Manual Install (10 Minutes)

If your Superagent can't clone the repo, follow these steps manually:

**Step 1:** Create the Superagent (same as above)

**Step 2:** Configure Identity
In **Brain → Knowledge → Identity**, paste `identity-template.md` and fill in your name, role, timezone.

**Step 3:** Configure Soul
In **Brain → Knowledge → Soul**, paste `soul.md` (same for all champions).

**Step 4:** Upload Knowledge Files
In **Brain → Knowledge → Knowledge files**, upload all 6 files from `knowledge/`:
- `voice-guardian-checklist.md`
- `universal-ai-tells.md`
- `platform-rules.md`
- `waterfall-overview.md`
- `inspiration-seeds.json`
- `champion-tone-template.md` (fill in your own info)

**Step 5:** Add Skills
In **Brain → Integrations → Skills**, click **Add** and upload all 7 skill files from `skills/`.

**Step 6:** Connect Tools
In **Brain → Integrations → Connectors**, connect Slack (required) and optionally OctoLens + Bright Data. See `connectors-required.md`.

**Step 7:** Create Tasks
In chat, ask your Superagent to create the daily task per `tasks/daily-waterfall.md` and the feedback trigger per `tasks/feedback-on-reply.md`.

**Step 8:** Verify
Run the tests in `verify-install.md`.

## How It Works

```
Daily 9am local time (Base44 scheduled task)
      │
      ▼
PHASE 1: Search Slack
  - Your recent messages (last 48h)
  - Feature announcement channels (#features-intel, #feat-*)
  - Channels you're active in
      │
      ▼
PHASE 2: Check inspirations
  - Top 5 inspirations from your profile
  - What they posted on LinkedIn/X this week
  - Topics they're hot on right now
      │
      ▼
PHASE 3: Load your voice
  - tone-of-voice rules
  - banned words and patterns
  - last 30 days of your delivered content (avoid duplicates)
      │
      ▼
PHASE 4: Write 2-3 variations
  - Personal experience angle
  - Echo response to inspiration
  - Reflection across signals
  - All grounded in real Phase 1+2 source material
      │
      ▼
PHASE 5: Voice Guardian
  - 10-point checklist with your overrides
  - Score 9+: ship
  - Score 7-8: auto-rewrite
  - Score <7: drop and regenerate
      │
      ▼
PHASE 6: Deliver via Slack DM
  - "Good morning, here are today's drafts:"
  - Drafts ready to copy-paste
  - Reply 1/2/3 to mark posted
  - Reply "not my style" to train your voice
```

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
