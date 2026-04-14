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
