# Universal AI Tells

Patterns that make text sound AI-generated regardless of who's writing. These are the baseline rules every draft must pass. Per-champion preferences can relax SOME of these (emoji count, specific words), but the items marked **[HARD BAN]** cannot be overridden.

## Banned Verbs

leverage, utilize, craft (metaphorical), empower, streamline, curate, facilitate, harness, spearhead, pioneer, navigate (metaphorical), elevate, foster, cultivate, optimize, revolutionize, transform, drive (metaphorical), unlock, supercharge, catalyze, amplify (metaphorical), orchestrate, synergize, reimagine, democratize, delve, dive into, tapestry, weave, journey (metaphorical)

**Use instead:** use, help, write, let, simplify, pick, make easier, lead, find, improve, grow, build, explore, try

## Banned Adjectives

groundbreaking, seamless, robust, transformative, unprecedented, innovative, cutting-edge, game-changing, best-in-class, world-class, state-of-the-art, next-generation, disruptive, holistic, synergistic, bespoke, turnkey, scalable (metaphorical), actionable, impactful, pivotal, mission-critical, enterprise-grade

**Use instead:** Specific concrete words. Instead of "groundbreaking new feature", say "a feature that lets you X".

## Banned Adverbs

significantly, dramatically, fundamentally, incredibly, remarkably, ultimately, essentially, literally (when not literal), absolutely, undoubtedly, definitively, surely, clearly (as emphasis)

## Banned Phrases

### Filler openings
- "In today's [fast-paced/rapidly-evolving/digital/modern] world"
- "In the age of AI"
- "As we all know"
- "At the end of the day"
- "When it comes to..."

### Self-narration
- "Here's the thing"
- "Let me tell you"
- "Here's why this matters:"
- "Think about it"
- "Let that sink in"
- "Read that again"
- "Period." (as standalone emphasis)

### Contrast framing **[HARD BAN]**
- "It's not just X, it's Y"
- "This isn't a [thing], it's a [bigger thing]"

### Corporate announcement phrases **[HARD BAN]**
- "I'm excited to announce"
- "Thrilled to share"
- "Proud to announce"
- "Delighted to reveal"
- "Without further ado"
- "Humbled to..."

### Cliches
- "Game changer"
- "Deep dive"
- "Moving the needle"
- "Low-hanging fruit"
- "The future of X is Y"
- "This changes everything"
- "Paradigm shift"
- "At scale"
- "Best practices"

### Engagement bait **[HARD BAN]**
- "What would you build?"
- "Thoughts?"
- "Agree or disagree?"
- "Like if you agree"
- "Share if this resonates"

### Fake vulnerability **[HARD BAN]**
- "Honestly wasn't sure..."
- "Not gonna lie..."
- "I'll be real with you..."
- "Between you and me..."

### Generic self-description openers **[HARD BAN]**
Real people don't re-introduce their job in every post — their profile already says it. These openers read as ChatGPT trying to establish credibility.

- "I'm in marketing, and..."
- "I'm in software development, so..."
- "As someone in tech..."
- "As a [founder/marketer/engineer/PM]..."
- "Working in [SaaS/AI/startups]..."
- "In my role as..."
- "Having spent [N] years in [field]..."

**Why banned:** a champion posts 2-5 times per week. If every post opens with their job title, the feed reads like a résumé. Open with the specific fact, observation, or story instead — the reader infers your role from the content.

**FAIL:** "I'm in marketing, and I've seen a lot of launches fail because..."
**PASS:** "Watched 3 launches flop this month. The one thing they shared..."

**FAIL:** "As someone in software development, AI tooling has changed how..."
**PASS:** "Haven't opened a blank file in 3 weeks. Here's what that does to how you think about code..."

**Exception:** A post whose SUBJECT is explicitly the champion's career path or role identity (e.g. "I switched from PM to engineer — here's what surprised me") may open with role context because the role IS the topic. This is rare.

## Banned Structures

### Em Dashes **[HARD BAN]**
Em dashes are the single strongest AI tell in 2026. Use commas, periods, or parentheses instead. No per-champion override — even champions who use them in real writing should not have them in amplifier-generated content, because mixed human/AI-looking text in a single feed is more suspicious than either alone.

**Detect:** literal character scan for `—` (U+2014). Also flag en dashes used stylistically (`–`, U+2013) and double-hyphens `--` standing in for em dashes. Only ASCII hyphens inside compound words (`well-known`, `long-term`) are safe.

### Rule of Three
**Default: banned.** Triples like "Fast. Simple. Powerful." or "One workspace. Unlimited builders. No friction."

**Exception:** Lists of three concrete examples with elaboration are fine. The banned pattern is specifically the punchy-three-word-sentence cadence.

### Numbered lists as the entire post body
A post that's just "1. Point one. 2. Point two. 3. Point three." with no prose connecting them.

### Emoji bullets
Using 🚀 or 💡 or ✅ as list markers instead of normal bullets.

### More than 2 emojis per post
Even natural writers don't spray emojis across a post. Max 2.

### Hashtag collections
More than 2 hashtags. Default max is 2. Champion preferences can set to 0.

### Thread numbering on LinkedIn
"1/ 2/ 3/" is X/Twitter convention. On LinkedIn it looks like a copy-pasted tweet thread.

### Transition openers
"Here's what I learned.", "Here's what happened next." Real writers just tell you the next thing without announcing the transition.

## Override Table

| Rule | Default | Overridable | Override key |
|------|---------|-------------|--------------|
| Banned verbs | Banned | ❌ | N/A |
| Banned adjectives | Banned | ❌ | N/A |
| Em dashes | Banned | ❌ HARD BAN | N/A |
| Rule of three | Banned | ❌ | N/A |
| Corporate announcement phrases | Banned | ❌ HARD BAN | N/A |
| Engagement bait | Banned | ❌ HARD BAN | N/A |
| Contrast framing | Banned | ❌ HARD BAN | N/A |
| Generic self-description openers | Banned | ❌ HARD BAN | N/A |
| Emoji count | Max 2 | ✅ | `emoji_max: N` (max 5) |
| Hashtag count | Max 2 | ✅ | `hashtag_max: N` |
| Bulleted lists | Allowed | ✅ | `bullets: heavy/light/none` |

Hard-ban items can never be overridden, no matter what the champion's preferences say. They're hard tells that read as bot output regardless of context.
