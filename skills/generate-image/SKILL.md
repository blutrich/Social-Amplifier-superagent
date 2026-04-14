---
name: generate-image
description: Phase 5.5 of the waterfall. Generates a branded social image for each voice-guard-approved draft using Base44's built-in image generation. Triggers after voice-guard, before deliver-via-slack.
---

# generate-image

Phase 5.5 of the waterfall. Generates one branded social image per Voice Guardian-approved draft using Base44 Superagent's built-in image generation (nano-banana / Imagen). No API key required — the Superagent platform provides the tool natively.

## When To Run

Automatically, as part of the waterfall, after Phase 5 (voice-guard) and before Phase 6 (deliver-via-slack). Runs once per approved draft. Attach the generated image to the draft so deliver-via-slack sends text + image together.

If a draft's `image_suggestion.type` is `feature_screenshot` or `source_screenshot`, this skill returns instructions for the champion to capture the image manually instead of generating one. Don't fake screenshots.

## What It Does

1. Reads the `image_suggestion` object produced by write-content (Phase 4)
2. Dispatches by type:
   - `stat_visual` → generates via built-in image tool with brand composite
   - `diagram` → generates a simple illustrative diagram via built-in tool
   - `feature_screenshot` / `source_screenshot` → returns manual-capture instructions, no generation
3. Applies Base44 brand guidance to the prompt (colors, typography cues, style: "clean minimal illustration, warm palette, no text unless requested")
4. Returns the image file/URL attached to the draft object so deliver-via-slack can include it

## Prerequisites

- Base44 Superagent built-in image generation (nano-banana / Imagen) — available by default, no API key required
- No external Google API key, no Python dependencies — the platform handles it

## Image Types

### stat_visual (nano-banana generates this)

Single big-number social card. Used for milestones, metrics, revenue reveals.

**Example input:**
```yaml
image_suggestion:
  type: stat_visual
  description: "$100M ARR milestone card"
  subtitle: "Definitely the fastest without VC backing"
  brand: Base44
  format: linkedin-share-card
```

**Generator flow:**
1. `python3 scripts/generate_image.py "[description]" --style illustration -o base.png`
2. `python3 scripts/composite_social.py text-card --headline "$100M ARR" --subtext "[subtitle]" --bg warm-grain -o final.png`
3. Return `final.png` as the image to attach

### feature_screenshot (manual — skill just formats the prompt)

Real screenshots beat generated ones. For feature posts, this skill returns instructions for the champion to take a screenshot manually, not an auto-generated image.

**Example output:**
```
Image suggestion for this draft:
Type: Feature screenshot
Take from: app.base44.com → settings → credits page
Dimensions needed: 1200x627 (LinkedIn) or 1600x900 (X)
Crop: Focus on the credits rollover control + 1 second of context
Save to: [champion]/content-history/screenshots/{date}.png

I'll attach it to your Slack DM once you've captured it.
```

### diagram (excalidraw or pencil — if available)

For architecture explainers. Hand-drawn diagrams feel more authentic than corporate flowcharts.

**Generator flow:**
- If Excalidraw MCP available: generate via `mcp__claude_ai_Excalidraw__create_view`
- Otherwise: return SVG instructions for manual creation

### source_screenshot (manual)

For news-trigger posts reacting to a specific tweet or LinkedIn post. The skill returns the source URL and instructs the champion to screenshot it.

### brand_creative (nano-banana)

Polished brand cards for announcements. Uses nano-banana with a branded template.

## Brand Rules (Base44 Only)

When generating nano-banana images for Base44 champions, enforce:

- **Font:** STK Miso Light 300 + Regular 400 only
- **Colors:** Base44 brand palette only (FF631F orange, #FAF3E9 cream, etc.)
- **Logo:** Base44 logo top-left, always colored (orange mark + black wordmark)
- **Backgrounds:** Warm gradients from `bg_*` tokens. No black backgrounds except terminal mockups.
- **Dimensions:** 1200x627 (LinkedIn), 1600x900 (X), 1080x1080 (square), 1080x1920 (story)

For non-Base44 champions (future), use their own brand tokens or fall back to a neutral minimal style.

## Reference Files

This skill delegates the heavy lifting to the full nano-banana skill from the base44-marketing plugin. The Superagent bundle ships a lightweight wrapper that:

1. Checks if the marketing plugin is available in the Superagent environment
2. If yes, calls `Skill(skill="base44-marketing:nano-banana", args="...")` directly
3. If not, returns the image prompt for the champion to generate manually via the marketing plugin in Claude Code

Full nano-banana reference: https://github.com/blutrich/base44-marketing-agent/tree/main/plugins/base44-marketing/skills/nano-banana

## Integration With Waterfall

```
Phase 6 (deliver-via-slack) produces:
  approved_variations: [...]
  image_suggestion: {needed: true, type: stat_visual, ...}
      ↓
If image_suggestion.needed and champion wants images:
  Skill(generate-image) runs
  Returns image URL or attaches to Slack DM
      ↓
deliver-via-slack sends the DM with image attached
```

## Cost Awareness

- Imagen 3: ~$0.03 per image generation
- Cached in content-history so repeats don't re-generate
- Default: 0 images per day per champion unless explicitly requested

For a team of 10 champions with 1 image per 5 posts average:
- ~2 images/week per champion = 20 total/week = 80/month
- Cost: ~$2.40/month across all champions

Keep image generation off by default. Champions who want images set `images.default: auto` in their style preferences.

## When To Skip

- Champion has `images.default: never` in style preferences → always skip
- Image suggestion type is `none` → no image needed
- Draft length < 100 words → text-only preferred (image would overpower)
- Champion's content history shows zero image attachments in last 30 days → respect their pattern
- Google API key not configured → log and skip
- First 5 posts for a new champion → let them establish their pattern first, skip images

## Output Format

```yaml
image_result:
  status: generated | manual_instructions | skipped | failed
  type: stat_visual | feature_screenshot | diagram | source_screenshot | brand_creative
  image_url: "https://..." or null
  manual_instructions: "..." or null
  generator_used: nano_banana | excalidraw | manual
  cost_usd: 0.03 or 0
  dimensions: "1200x627"
  cache_key: "champion-id_date_variation-hash"
```

## Fallback If Marketing Plugin Not Installed

If the champion's Superagent doesn't have access to the base44-marketing plugin, the skill returns instructions for the champion to generate the image themselves:

```
Image suggestion for Draft 1:
Type: Stat visual ($100M ARR milestone)

To generate:
1. Open Claude Code with the base44-marketing plugin installed
2. Run: /nano-banana stat_visual --headline "$100M ARR" --subtext "Definitely the fastest"
3. Save the output to content-history/screenshots/
4. Reply with "attach image" and paste the image

OR: Skip the image - this post works fine text-only.
```

Champions who want full automation install the base44-marketing plugin alongside their Superagent. Champions who don't use text-only posts or generate images via other tools.
