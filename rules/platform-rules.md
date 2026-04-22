# Platform Format Rules

Format specs for each supported platform. Used by item 8 of the Voice Guardian checklist.

## LinkedIn

### Format
- Length: 150-300 words (sweet spot for engagement)
- Short paragraphs (1-3 sentences each)
- Line breaks between paragraphs
- Hook lands in first 2 lines (before "see more" fold)
- No external links in main post body (put in first comment if needed)

### What works
- Personal stories with a professional insight
- Behind-the-scenes of building something
- Lessons from specific experiences
- Contrarian takes backed by personal experience
- "I did X. Here's what happened." format with real details

### What fails
- Generic motivational content
- Engagement bait ("Like if you agree", "Thoughts?")
- Pure self-promotion without value
- Wall of text with no line breaks
- External links in main post body (kills reach ~50%)
- More than 2 hashtags

### Emoji
- Maximum 2 per post
- Never as bullet points
- Only at natural emphasis points

### Hashtags
- Maximum 2
- Only at the end
- Use broad topics, not niche phrases

## X (Twitter)

### Format
- Single tweet: 280 characters max
- Thread: numbered tweets (1/ 2/ 3/), max 7 tweets
- Thread hook: first tweet stands alone AND signals the thread (🧵 or "thread 👇")
- Avoid links in first tweet of a thread

### What works
- Sharp observations in 1-2 sentences
- Hot takes with evidence
- "I just [did thing]. [Surprising result]." format
- Threads that tell a story with a payoff
- Replies to trending conversations in your space

### What fails
- Threads longer than 7 tweets (engagement drops fast after tweet 5)
- Generic advice without specifics
- Pure promotion
- Too many hashtags (max 1-2)
- Engagement bait

### Emoji
- Maximum 2-3 per tweet
- Functional only (🧵 for threads, 👇 for thread signal)

## Format Detection

When scoring a draft:

1. Read the content length (words, characters)
2. Check the target platform from generation request
3. Compare against the rules above
4. Flag specific violations (too long, wrong structure, link in body, emoji overload, etc.)

## Format-Specific Rewrite Rules

### LinkedIn → too long (400+ words)
Cut the middle. Preserve hook (first 2 lines) and payoff (last 2-3 lines). Trim supporting detail.

### LinkedIn → too short (under 100 words)
Usually means content is too sparse. Reject and regenerate.

### LinkedIn → wall of text
Add line breaks between logical sections. Target 1-3 sentence paragraphs.

### X → tweet over 280 chars
Remove filler words. If still too long, convert to 2-tweet mini-thread.

### X → thread too long
Merge redundant tweets. Most threads can be cut by 30-40% without losing substance.

## Hook Patterns

### LinkedIn (first 2 lines visible before "see more")

**Works:**
- Unexpected number: "$100M ARR. Definitely the fastest without VC backing."
- Specific observation: "Spent 3 days this week debugging something I thought would take 20 minutes."
- Bold opinion: "Unpopular opinion: your AI strategy doesn't need more tools."
- Story opener: "3 years ago I got fired. Best thing that ever happened."

**Fails:**
- Generic questions: "What if I told you..."
- Corporate announcement: "Excited to share..."
- Clickbait numbers: "5 lessons I learned..."

### X (full tweet visible, 280 chars)

**Works:**
- Hot take: "Every vibe coding startup has 90 days to live. They don't."
- Observation: "Spent this week in a vibe coding startup. Here's what the 'ship button' narrative misses:"
- Specific number: "8,000 users. $483K. 120 req/min rate limit. A queue is not optional."

**Fails:**
- Listicle: "5 things I learned this week"
- Generic motivation: "Keep pushing"
- Vague hooks: "Wild week"
