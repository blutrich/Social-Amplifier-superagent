# Champion Tone-of-Voice Template

This is the template you fill in for YOUR personal voice. Once configured, the agent uses it on every generation to make sure drafts sound like you, not generic AI.

## How To Fill This In

You have 3 options:

### Option A: Let the agent profile you (recommended)

Send your Superagent this message:

> "Profile my voice. Read my Slack messages from the last 7 days, scrape my LinkedIn profile (https://linkedin.com/in/[your-handle]), and generate my tone-of-voice file based on my actual writing patterns. Don't make anything up — only describe what you actually observe."

The agent will pull real data, analyze it across 8 dimensions, and write the file for you. Takes ~60 seconds.

### Option B: Fill in manually
Read the template below and fill in each section based on how you actually write. This is more accurate if you know your voice well, but slower.

### Option C: Hybrid
Let the agent generate a draft, then edit the sections that don't feel right. Send: "Show me my draft tone-of-voice file. I want to edit it."

---

## Voice Template

```markdown
# [Your Name] - Tone of Voice

## Voice Summary
[One sentence describing how you write. Example: "A marketing builder who writes like a senior engineer — TL;DR format, em dashes, shows the math, names collaborators, opinionated without being combative."]

## Tone
- **Register:** [casual | professional | technical | academic | mixed]
- **Energy:** [high | measured | low]
- **Formality:** [formal | conversational | casual | code-switches]
- **Humor frequency:** [frequent | occasional | rare | never]
- **Humor style:** [self-deprecating | observational | dry | absurdist | none]

## Sentence Patterns
- **Typical length:** [short (1-8 words) | medium (9-15) | long (16+) | mixed]
- **Structure:** [bullet-heavy | prose | numbered | TL;DR-first | meandering]
- **Paragraph style:** [short 1-3 sentence chunks | long dense paragraphs | mixed]
- **Opens with:** [observation | question | number | hook | story | transition]
- **Closes with:** [takeaway | question | concrete ask | silence (no CTA) | named reference]

## Vocabulary

### Words I Use Naturally
[10-15 specific words/phrases observed in your real writing. Be specific - "TL;DR", "no-brainer", "shipped", etc.]
- 
- 
- 

### Words I Conspicuously Avoid
[5-10 words you never use. These should be in addition to the universal banned list. Example: someone might add "frankly" or "quite" to their personal avoidance list.]
- 
- 

### Character Tics
[Punctuation habits, emoji usage, specific phrases you repeat]
- 
- 

## Humor
[How and when you use humor. Specific enough that the writer can replicate it. Example: "Dry, understated humor in private writing. Less humor in LinkedIn (measured, professional). Occasional self-deprecating aside about being 'two months in at Base44'."]

## Topics
[3-5 topic areas you write about, with the angle you bring]

1. **[Topic]** — [your angle on it]
2. **[Topic]** — [your angle]
3. ...

## What Works
[Empty at first. The agent fills this in as your posts get approved. Each entry is a specific pattern that landed.]

## Style References

### Real samples from my private writing (Slack, drafts, etc.)

**Sample 1** ([source], [date]):
> [Verbatim quote, 3+ sentences]

**Sample 2** ([source], [date]):
> [Verbatim quote]

**Sample 3** ([source], [date]):
> [Verbatim quote]

### Real samples from my public writing (LinkedIn/X)

**Sample 1** ([platform], [date], [engagement if known]):
> [Verbatim quote from real public post]

### Voice Delta (private vs public)
[If you write differently in private vs public, describe how. Example: "Slack: bilingual Hebrew/English, em dashes, technical jargon. LinkedIn: English-only, short fragment-rhythm, anti-corporate vocabulary. Same opinions, very different delivery."]

## The [Your Name] Test

Would I copy-paste this content into my LinkedIn and hit post without editing?

**Pass signals:**
- [List 5-7 things that signal a draft sounds like you]

**Fail signals:**
- [List 5-7 things that signal a draft does NOT sound like you]
```

---

## After You Fill It In

Save this as your champion tone-of-voice file in your Superagent's Memory or upload it as a Knowledge file. The agent reads it on every generation.

To edit it later, just chat with your Superagent: "Update my tone-of-voice. Add 'frankly' to my avoid list. Change my energy level from measured to high."

The Memory updates automatically and tomorrow's drafts reflect the change.
