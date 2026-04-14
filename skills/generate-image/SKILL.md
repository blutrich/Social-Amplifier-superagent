---
name: generate-image
description: Optional. Generates a branded social image for an approved draft via nano-banana (Google Imagen 3). Triggers on "generate image", "make visual", only when image_suggestion.needed is true.
---

# generate-image

Optional Phase 6+ step. Generates a branded social image for a Voice Guardian-approved draft using nano-banana (Google Imagen 3) with Base44 brand composites.

## When To Run

Only after the deliver-via-slack skill identifies an image suggestion with `needed: true` AND the champion has approved (manually or via their preferences).

Most LinkedIn posts perform better text-only. Don't auto-generate images for every delivery. This skill is explicitly opt-in per draft.

## What It Does

1. Reads the image_suggestion from Phase 6 of the waterfall
2. Picks the right generator: feature_screenshot (manual), stat_visual (nano-banana), diagram (excalidraw), source_screenshot (manual)
3. For nano-banana images:
   - Calls Imagen 3 via Google API to generate the base photo/illustration
   - Composites into a Base44 brand template with correct colors, typography, logo
   - Returns the image URL or file path
4. Attaches the image to the Slack delivery OR returns it for champion to add manually

## Prerequisites

- `GOOGLE_API_KEY` in Superagent **Settings → Secrets & Keys**
- Python libs: `google-genai`, `Pillow`, `cairosvg` (installed via Base44 Python environment)
- Base44 brand reference files (colors, fonts, logo SVG)

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
