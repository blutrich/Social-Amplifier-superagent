# CLAUDE.md

Project memory for any AI agent (Claude, Base44 Superagent, etc.) working with this repo.

## What This Repo Is

A bundle of Base44 Superagent configuration files that turns any new Superagent into a personalized social content agent for a Base44 champion. Each champion installs this bundle into their own Superagent and gets daily LinkedIn drafts written in their voice.

**Companion repo:** [Social-Amplifier-agent](https://github.com/blutrich/Social-Amplifier-agent) — same logic packaged as a Claude Code plugin instead of Base44 Superagent. Use that one for operator-driven installs in Claude Code.

## Core Concept: The 6-Phase Waterfall

Every content generation runs this exact sequence:

```
PHASE 1: search-slack-context     → mine recent Slack messages + feature channels
PHASE 2: check-inspirations       → see what champion's inspirations posted this week
PHASE 3: load-voice               → load champion's tone-of-voice + style preferences
PHASE 4: write-content            → generate 2-3 variations grounded in real signals
PHASE 5: voice-guard              → score each variation on 10-point Voice Guardian rubric
PHASE 6: deliver-via-slack        → send approved drafts via Slack DM
```

Optional Phase 6+: `generate-image` for branded visuals (defaults off, most posts are text-only).

Total runtime per generation: 45-90 seconds.

## Repo Structure

```
Social-Amplifier-superagent/
├── README.md                       # Install guide (clone-repo + manual paths)
├── BOOTSTRAP-PROMPT.md             # The single message champions send their new Superagent
├── RECOVERY-PROMPTS.md             # 8 recovery flows for broken installs
├── CLAUDE.md                       # This file
├── identity-template.md            # Per-champion identity (name, role, timezone)
├── soul.md                         # Behavioral principles (same for all champions)
├── connectors-required.md          # Slack mandatory, OctoLens + Bright Data optional
├── verify-install.md               # 10-test verification checklist
├── knowledge/
│   ├── voice-guardian-checklist.md # 10-point quality scoring rubric
│   ├── universal-ai-tells.md       # 80+ banned patterns
│   ├── platform-rules.md           # LinkedIn + X format specs
│   ├── waterfall-overview.md       # How the 6 phases connect
│   ├── inspiration-seeds.json      # Persona → influencer mapping (Anthropic auto-include, competitors banned)
│   └── champion-tone-template.md   # Template for per-champion voice profile
├── skills/
│   ├── search-slack-context.md     # Phase 1
│   ├── check-inspirations.md       # Phase 2
│   ├── load-voice.md               # Phase 3
│   ├── write-content.md            # Phase 4
│   ├── voice-guard.md              # Phase 5
│   ├── deliver-via-slack.md        # Phase 6
│   ├── handle-feedback.md          # Reply parsing + voice profile updates
│   └── generate-image.md           # Optional branded image generation (nano-banana wrapper)
└── tasks/
    ├── daily-waterfall.md          # Scheduled task: Mon/Wed/Fri 9am local (3x/week default)
    └── feedback-on-reply.md        # Connector trigger: when champion replies to DM
```

## Critical Design Rules

These are non-negotiable. Every change to the bundle must respect these.

### 1. The Champion Is The Brand

Each Superagent serves ONE specific person. It writes in THEIR voice, not the brand's. It DMs THEM, not the team. It learns THEIR feedback, not group preferences.

**Never:**
- Speak as if you were a Base44 brand account
- Use "we" when the champion would say "I"
- Apply Maor's brand voice rules to other champions
- Share voice data between champions

### 2. Per-Champion Voice Overrides

Universal rules in `universal-ai-tells.md` apply to all champions. But each champion's `style-preferences.md` (in their own profile, not in this bundle) can override structural rules:

- `em_dashes: allow|deny` — Maor bans them, Ofer uses them naturally
- `emoji_max: 0|1|2|5` — varies per champion
- `hashtag_max: 0|2` — most champions are 0
- `banned_words_add: [...]` — champion-specific extras
- `banned_words_remove: [...]` — champion uses some "banned" words naturally

**Hard-ban items can never be overridden:** corporate announcement phrases, engagement bait, contrast framing, "I'm thrilled to announce", "humbled to share". These read as bot output regardless of context.

### 3. Voice Guardian Floor: 9/10

Every draft must score 9+ on the 10-point checklist before delivery. Drafts scoring 7-8 get auto-rewritten (max 2 attempts). Drafts below 7 get rejected and the day is skipped if no variation can pass.

**Silence > weak content.** Champions trust the agent because it doesn't ship garbage. Better to skip a day than deliver a 7/10 draft.

### 4. Banned Competitor Inspirations

These people can NEVER be used as voice inspirations for any champion:

- **Amjad Masad** (CEO, Replit)
- **Anton Osika** (CEO, Lovable)
- **Eric Simons** (CEO, Bolt/StackBlitz)
- **Albert Pai** (Co-founder, Bolt/StackBlitz)

Banned company patterns: Replit, Lovable, Bolt, StackBlitz, v0, Cursor, Windsurf. CEOs and marketing leads at these companies are blocked. Individual engineers writing about general industry topics are case-by-case.

**Always-included exception:** Anthropic team members are TIER-1 inspirations for relevant personas. Mike Krieger, Jack Clark, Alex Albert, Karina Nguyen, Amanda Askell, Dario Amodei, Sam Bowman.

### 5. 3x/Week Default Schedule

Default is Monday/Wednesday/Friday at 9am local time. NOT Monday-Friday daily.

**Why 3x/week:**
- Realistic for busy champions (5x/week becomes 2-3x/week in practice)
- Better content quality (more signal accumulation between runs)
- Avoids LinkedIn algorithm throttling for over-posting
- Recovery buffer for missed days

Champions can override to 5x/week, 2x/week, or 1x/week per their preference.

### 6. Silence Is Acceptance

Champions are busy. They will not always reply to drafts. They will not always post the suggested content. None of these are problems. Send the next batch on schedule. Do not nag, do not check in, do not ask "did you see my drafts?".

The product is a butler, not an assistant. Set down the tray, step back, say nothing.

### 7. Real Signal, Never Fabricated

Every draft must be grounded in a real specific source — a Slack message, an inspiration's actual post, a feature that actually shipped. Generic content from LLM knowledge fails the Voice Guardian regardless of polish.

**Never invent:**
- Topics that aren't trending in OctoLens or Slack
- Engagement numbers ("trending right now with 5K likes!")
- Quotes from inspirations
- Internal Base44 details not in Slack
- Feature ships that didn't happen

If there's no signal, say so and skip the day.

## How Champions Install This

**Two paths documented in README.md:**

1. **Clone-repo install (recommended):** Champion creates a new Superagent, sends one bootstrap message that tells the Superagent to clone this repo and configure itself. Total time: ~5 minutes.

2. **Manual install:** Champion uploads Knowledge files, creates custom skills one-by-one, and configures connectors via the Base44 UI. Total time: ~10 minutes.

The bootstrap prompt template is in `BOOTSTRAP-PROMPT.md`. It includes filled-in examples for Ofer (marketing persona) and Dor (comms persona), plus per-persona OctoLens view mappings.

## Critical Install Gotcha (Learned Hard Way)

**Base44 Superagents do NOT automatically install files from a cloned repo as skills.**

When the bootstrap says "clone the repo and configure yourself", the Superagent will:
- ✅ Set Brain → Soul, Identity, User from the markdown files
- ✅ Connect Slack via OAuth
- ❌ NOT auto-install knowledge files to `.agents/knowledge/`
- ❌ NOT auto-create custom skills from `skills/*.md` files

**The bootstrap prompt must explicitly tell the Superagent to:**

1. For each file in `knowledge/`, read it and add to Brain → Knowledge files
2. For each file in `skills/`, read it and CREATE A CUSTOM SKILL with that name and content (using the agent's skill creation tool, not "upload")
3. Verify by running `ls .agents/skills/` and `ls .agents/knowledge/`

The current `BOOTSTRAP-PROMPT.md` (Steps 5 and 6) handles this explicitly with CRITICAL markers. If you're updating the bootstrap, do not regress this — the Superagent will silently set Brain fields and skip files otherwise.

**Recovery if it happens anyway:** See `RECOVERY-PROMPTS.md` Recovery 1 and Recovery 2.

## Critical Personality Override (Learned From Real Install)

Default Base44 Superagents are chatty by default. They write things like:

- "Love it"
- "Interesting opener — dropping a GitHub link right away, no messing around. I respect that"
- "Let me go ahead and..."
- "Here's the thing..."
- Meta-commentary on the user's messages

This is wrong for the Social Amplifier agent. The `soul.md` file has a `CRITICAL: Personality Override` section at the top that REPLACES the default personality completely.

**If you're editing soul.md:** Do not weaken the override section. The default Base44 personality leaks through if Soul isn't explicit and forceful.

**Test the agent:** "Describe what you just did in 10 words or less." If the agent can't, Soul didn't apply correctly.

## Conventions For Editing This Repo

### When adding a new skill

1. Create `skills/{name}.md` with the standard skill format
2. Add it to the BOOTSTRAP-PROMPT.md Step 6 list
3. Add it to README.md file reference table
4. Add it to verify-install.md Test 1 expected list
5. Update CLAUDE.md (this file) repo structure section
6. Test the install with a fresh Superagent before committing

### When adding a new knowledge file

1. Create `knowledge/{name}.md`
2. Add to BOOTSTRAP-PROMPT.md Step 5 list
3. Add to README.md file reference
4. Add to verify-install.md Test 2 expected list
5. Update CLAUDE.md repo structure
6. Make sure the file is referenced by at least one skill (otherwise why does it exist?)

### When changing universal AI-tells

`knowledge/universal-ai-tells.md` is the source of truth for banned patterns. When adding a new banned word/phrase/structure:

1. Add to the appropriate section (verbs, adjectives, phrases, structures)
2. Mark `[HARD BAN]` if it's never overridable per-champion
3. Mark with override key if it's overridable
4. Update the Override Table at the bottom

### When changing the schedule

The default is 3x/week (Mon/Wed/Fri). To change the default:

1. Update `tasks/daily-waterfall.md` schedule section
2. Update `BOOTSTRAP-PROMPT.md` Step 9 schedule line
3. Update `README.md` "What This Does" section
4. Update CLAUDE.md (this file) Critical Design Rule #5
5. Document the change rationale

Don't change the default without good reason. 3x/week is a deliberate choice based on real champion behavior.

### When updating soul.md

`soul.md` defines how every champion's agent behaves. Changes affect every champion equally.

**Safe changes:**
- Adding new banned chatty phrases to the Personality Override section
- Adding examples to existing principles
- Clarifying ambiguous language

**Dangerous changes:**
- Removing the CRITICAL: Personality Override section (default Base44 chatty bot will leak through)
- Adding contradictory principles
- Making the agent more talkative
- Removing hard rules ("never auto-post", "never below 9/10", "never use banned competitors")

If you change soul.md, test with a fresh Superagent install to verify the personality override still kills the default chatty bot.

## Critical External Dependencies

| Dependency | Purpose | Required | Fallback |
|------------|---------|----------|----------|
| Base44 Superagent | The runtime | Yes | None - this whole bundle assumes Base44 |
| Slack workspace | Source signals + delivery | Yes | None - Slack is mandatory |
| OctoLens MCP | Phase 2 inspiration activity | No | Bright Data scrape, then web search |
| Bright Data MCP | Phase 2 fallback + champion onboarding | No | Web search (lower quality) |
| Google Gemini API | Phase 6+ image generation | No | Skip images, text-only delivery |
| Anthropic models | All generation (handled by Base44) | Yes | Auto-selected by Base44 |

## Per-Persona OctoLens View Mapping

This is referenced in multiple files. Source of truth lives in `knowledge/inspiration-seeds.json`. Quick reference:

| Persona | Primary OctoLens Views | Secondary Filter |
|---------|----------------------|------------------|
| comms | 20496 (Brand Monitoring), 20500 (Crisis Management) | negative sentiment for crisis |
| marketing | 20498 (Competitor Intelligence), 20497 (Buy Intent) | min_engagement |
| dev | 20499 (Industry Insights) | tag:product_question |
| product | 20499 (Industry Insights) | tag:user_feedback |
| founder | 20511 (Positive) | minXFollowers: 5000 |
| builder_indie | 20499 (Industry Insights) | keywords: base44, lovable, replit, anthropic |
| ops | tag:industry_insights | tag:bug_report, 7-day window |

These view IDs are specific to the Base44 OctoLens organization. When expanding to other orgs, the mapping needs to be re-built per-org.

## Common Operations

### "I want to add a new champion"

1. Operator (Ofer/Dor) does the install themselves OR sends the new champion the bootstrap prompt
2. Champion creates a new Superagent in Base44
3. Champion pastes the filled-in bootstrap prompt with their info
4. Superagent runs the 12-step install
5. After verify-install passes, champion is live

### "I want to update the voice profile for an existing champion"

The champion sends their existing Superagent feedback in DMs:
- "too formal" → updates `formality` field
- "I'd never say 'leverage'" → adds to `banned_words_add`
- "more like my last post" → analyzes the referenced post
- The `handle-feedback` skill processes the reply and updates the profile in Memory

### "I want to change the schedule for an existing champion"

Champion sends their Superagent:
> "Change my Social Amplifier Waterfall to run only Tuesday and Thursday at 10am."

The Superagent updates the scheduled task automatically.

### "I want to pause delivery for a week"

Champion sends:
> "Pause my drafts for the next 7 days."

Superagent sets `paused_until` to 7 days from now and skips the daily runs until that date.

### "I need to debug why a draft is bad"

Run the verify-install.md Test 6 (Voice Match Diagnosis) — the agent compares a problem draft against the champion's real writing samples and identifies specific gaps.

## What To Watch Out For

1. **Skill creation requires explicit chat commands.** Cloning the repo doesn't auto-install skills. The bootstrap prompt must tell the Superagent to create each one.

2. **Soul override must be forceful.** Default Base44 Superagents are chatty. The CRITICAL section in soul.md is what kills the default personality.

3. **Per-champion overrides are mandatory.** Universal Voice Guardian rules will fail real Ofer's content (he uses em dashes naturally). Always create the champion's `style-preferences.md` during install.

4. **Voice profiling is not optional.** It must run during install, not as an afterthought. Skipping it leads to generic drafts that don't match the champion.

5. **Banned competitors are HARD blocks.** Never accept user requests like "add Amjad Masad as inspiration". The agent should refuse and explain.

6. **3x/week is the default for a reason.** Don't silently change to 5x/week without operator approval.

7. **Tasks may fail to create on first try.** Base44's `create_automation` tool sometimes fails. Recovery 6 in RECOVERY-PROMPTS.md handles this.

## Recent Architectural Decisions (2026-04-13)

These are decisions the operator (Ofer Blutrich) has made in conversation. Future agents working on this repo should preserve them unless explicitly told to change them.

- **Two repos, not one.** This Base44 Superagent bundle is separate from the Claude Code plugin (`Social-Amplifier-agent`) so each can evolve independently.
- **Champions are Base44 employees only for v1.** Not external customers. Expanding later.
- **Voice profiling auto-runs during install.** Don't ask permission, just do it.
- **Schedule defaults to 3x/week.** Changed from 5x/week based on realistic champion behavior.
- **Anthropic team always included as inspirations.** Tier-1 priority for relevant personas.
- **Competitor CEOs are banned via shared/inspiration-seeds.json.** Hard block, no overrides.
- **Image generation is opt-in per champion.** Defaults to text-only because most posts perform better that way.
- **Bright Data is the only reliable LinkedIn/X scraper.** WebFetch hits 999/402 errors. OctoLens is preferred when authors are indexed.
- **Personal champion data is gitignored.** Real profiles, content history, and eval workspaces never go into the public repo.

## When In Doubt

- Read `README.md` for the install flow
- Read `BOOTSTRAP-PROMPT.md` for the exact install commands
- Read `RECOVERY-PROMPTS.md` for fixing broken installs
- Read `verify-install.md` for testing
- Read `soul.md` for behavioral rules
- Read individual skill files for phase-specific details

If something here contradicts the actual files, the actual files win. This CLAUDE.md is a high-level map, not the source of truth for every detail.

## Companion Repo

For the Claude Code plugin version (operator-driven, runs in Claude Code/Cowork):
https://github.com/blutrich/Social-Amplifier-agent

Same logic, different surface. Some champions prefer the Claude Code plugin if they're already operating in that environment. Most champions should use this Base44 Superagent version.
