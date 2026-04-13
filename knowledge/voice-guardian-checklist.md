# Voice Guardian Checklist

The 10-point quality gate every draft must pass before delivery. Each item scores PASS (1) or FAIL (0). Total = score out of 10.

**Thresholds:**
- 9-10/10 → APPROVED, ship it
- 7-8/10 → AUTO-REWRITE (fix failing items, re-score, max 2 attempts)
- Below 7 → REJECT, regenerate from scratch with different angle

## How to score

For each item, read the criteria, inspect the draft, and assign PASS or FAIL with a short note. Don't skim — AI content fails on items 1-3 in subtle ways that are easy to miss.

---

## Section A: Anti-AI Tells (3 items)

### 1. No AI vocabulary
**Check:** Does any word in the content appear in the universal banned list (see `universal-ai-tells.md`) AND not in the champion's `banned_words_remove` exception list?

**FAIL examples:** "We leverage AI to streamline workflows", "A truly transformative experience", "Significantly improves output"

**PASS examples:** "We use AI to make workflows simpler", "A different kind of experience", "Faster and more accurate"

### 2. No AI structure
**Check:** Does the content use banned structural patterns — em dashes (unless champion has `em_dashes: allow`), rule-of-three cadence, self-narration, contrast framing, transition openers, significance inflation?

**FAIL examples:**
- "Fast. Simple. Powerful." (rule of three)
- "It's not just a tool — it's a revolution" (contrast framing + em dash)
- "Here's why this matters:" (self-narration)
- "A testament to modern design" (significance inflation)

**PASS examples:**
- "Here's what it does: it makes you faster at the stuff you already do."
- "It's a tool. It helps you build things."

**Override:** Per-champion `style-preferences.md` can allow em dashes if the champion uses them naturally. Always check the champion's preferences before failing on em dashes alone.

### 3. No AI phrases
**Check:** Does the content use common AI-generated phrases from the universal banned list — "I'm thrilled to announce", "In today's fast-paced world", "Let that sink in", "This changes everything"?

**FAIL examples:** "I'm thrilled to announce...", "In the age of AI...", "Game-changer"

**PASS examples:** Opens with a specific fact, number, or observation. Ends with an insight, not a catchphrase.

---

## Section B: Personal Voice (4 items)

### 4. Matches champion's tone
**Check:** Compare vocabulary, sentence length, energy, and humor against the champion's tone-of-voice file. Read 2-3 of their real samples and verify the draft echoes those patterns.

**FAIL:** Sounds like a generic "tech professional" voice that could be anyone.
**PASS:** You can picture this specific person saying these exact words.

### 5. Uses champion's topics
**Check:** Is the content within the champion's declared interest areas from `profile.json.topics`?

**Edge case:** Off-topic content can pass IF the champion explicitly wrote about it recently in Slack/LinkedIn.

### 6. Feels personal
**Check:** Does it include a specific detail, anecdote, number, or personal perspective?

**FAIL:** "AI is changing how we build software" (generic)
**PASS:** "Spent 3 days this week on the Reputation Drop campaign — 8,000 users, 120 req/min Printful rate limit..." (specific)

### 7. The Champion Test (most important)
**Check:** Would this champion actually copy-paste this into LinkedIn and hit post without editing?

This is a holistic judgment, not a rule. Ask:
- Would they use these words?
- Would they take this angle?
- If their most honest friend read this, would they say "yep, that sounds like you"?

**FAIL:** "It's fine but I'd probably tweak it."
**PASS:** "Yes, I'd post this as-is."

---

## Section C: Platform Format (2 items)

### 8. Correct format
**Check:** Does the content match the target platform's format rules (see `platform-rules.md`)?

**LinkedIn:** 150-300 words, short paragraphs, hook in first 2 lines
**X:** 280 chars max, or numbered thread max 7 tweets

### 9. No link/emoji violations
- LinkedIn: no external links in main post body
- Max 2 emojis (or champion's `emoji_max` override)
- No emoji bullets
- Max 2 hashtags (or 0 if champion has `hashtag_max: 0`)

---

## Section D: Independence (1 item)

### 10. Not corporate
**Check:** Does the content sound like a brand press release?

**FAIL:** "We're thrilled to announce our latest innovation..."
**PASS:** "I built X this week. Here's what I learned..."

The champion is an individual person with their own voice. Even when discussing company work, they sound like themselves, not the brand.

---

## Output Format

After scoring, output:

```
## Voice Guardian Review

**Champion:** {name}
**Platform:** {linkedin | x}
**Score:** {X}/10

### Checklist
1. No AI vocabulary: PASS/FAIL - {brief note}
2. No AI structure: PASS/FAIL - {brief note}
3. No AI phrases: PASS/FAIL - {brief note}
4. Matches tone: PASS/FAIL - {brief note}
5. Champion topics: PASS/FAIL - {brief note}
6. Feels personal: PASS/FAIL - {brief note}
7. Champion Test: PASS/FAIL - {brief note}
8. Correct format: PASS/FAIL - {brief note}
9. No link/emoji violations: PASS/FAIL - {brief note}
10. Not corporate: PASS/FAIL - {brief note}

### Verdict: APPROVED | REWRITE | REJECT
{If REWRITE: list specific items to fix}
{If REJECT: explain what went wrong and what to change in regeneration}
```

This output is parsed by the delivery skill to decide whether to ship, retry, or drop.
