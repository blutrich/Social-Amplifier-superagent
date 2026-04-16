# Setup: Apify Inspiration Feeder App

**One-time operator task.** This is NOT done per champion. Once set up, every Social Amplifier champion agent reads the same feed without ever holding an Apify token.

## Architecture

```
ChampionInspiration list  →  Apify Feeder App (scheduled 6h)  →  #social-champions-octolens-feed  →  All champion agents
                              ↓
                              APIFY_TOKEN lives here, nowhere else
```

Champions never touch `APIFY_TOKEN`. It stays in the Feeder App's env vars.

## Prerequisites

- Base44 account with the Apify Inspiration Feeder app created (create via Base44 MCP or manually)
- Apify account with API token ([apify.com](https://apify.com) → Settings → Integrations)
- Slack Bot connector attached to the Feeder App with `chat:write` for `#social-champions-octolens-feed`

## Step 1: Secrets & Connectors

**Secrets** — in Feeder App → Settings → Secrets:

| Key | Value | Notes |
|-----|-------|-------|
| `APIFY_TOKEN` | your real Apify token | From Apify → Settings → Integrations |
| `FEED_CHANNEL_ID` | `C0ATMPHHM40` | The `#social-champions-octolens-feed` channel |

**Connectors** — in Feeder App → Brain → Integrations → Connectors:

- **Slack Bot** — connected via OAuth. The backend function uses the connector's OAuth token automatically. No `SLACK_BOT_TOKEN` secret needed.

**Do NOT commit `APIFY_TOKEN` anywhere.** It lives in the app env only, and no champion agent ever sees it.

## Step 2: Seed ChampionInspiration

Before the first run, seed the master inspirations list. Open the Feeder App admin UI and add rows for each inspiration across all champions:

| handle | platform | display_name | persona_tags | added_by |
|--------|----------|--------------|--------------|----------|
| aakashg0 | linkedin | Aakash Gupta | marketing, product | ofer |
| harrydry | linkedin | Harry Dry | marketing | ofer |
| jackclarkSF | x | Jack Clark | comms, marketing, founder | ofer |
| simonw | x | Simon Willison | dev, builder_indie | ofer |
| ... | ... | ... | ... | ... |

Start with the 10-15 most-requested inspirations across the team. New champions' lists are merged in as they onboard.

## Step 3: Test Run

From the admin UI, click **"Run feed now"** to trigger the backend function once.

Expected behavior:
1. Function reads all `active=true` ChampionInspiration rows
2. For each LinkedIn handle: calls `apimaestro/linkedin-profile-posts` sync endpoint
3. For each X handle: calls `apidojo/tweet-scraper` sync endpoint
4. Dedupes against `InspirationPost` table by `post_id`
5. For each new post: creates the record AND posts to `#social-champions-octolens-feed`
6. Message format in Slack:
   ```
   📣 @aakashg0 on linkedin
   AI product building in 2026 looks nothing like 2024. The builders winning right now are...
   https://linkedin.com/posts/aakashg0_...
   _6 hours ago_
   ```

**Verify in Slack:** open `#social-champions-octolens-feed`, confirm new messages appeared.

## Step 4: Schedule

Enable the cron in the app Tasks tab:
- Schedule: every 6 hours (or 4x/day — 00:00, 06:00, 12:00, 18:00 UTC)
- Frequency rationale: more frequent = more Apify cost, less frequent = stale feed when champion agents run at 9am

3x/week champion runs × 6h cron = every champion sees fresh posts when their agent fires.

## Step 5: Cost Monitoring

Watch for the first 7 days:

- **Apify dashboard → Consumption tab.** Expected ~$15-30/month total for 10-20 inspirations, 4 runs/day, 5 posts/run.
- **Slack channel.** If it becomes too noisy, reduce `maxItems` in the actor calls (edit the Feeder backend function) or lower the cron frequency.
- **InspirationPost table.** Grows indefinitely — add a monthly cleanup task that deletes records older than 30 days.

## Step 6: Add/Remove Inspirations

When a new champion onboards and lists specific inspirations in Interview answer #6 that aren't in the master list:

1. Open the Feeder App admin UI
2. Add the new handles to `ChampionInspiration` with the champion's persona tag
3. Next cron run picks them up — no restart needed

When a champion leaves or changes inspirations:
1. Mark old entries `active=false` (keep for audit trail, don't delete)
2. Add replacement entries

## Failure Modes

| Symptom | Fix |
|---------|-----|
| No new messages in the channel after 6h | Check Feeder App logs → last_run_error. Usually bad Apify token, expired Slack token, or Apify rate limit. |
| Feeder posts duplicates | Dedupe broken — check `InspirationPost.post_id` uniqueness constraint in the entity schema |
| Apify returns empty for a handle | Profile went private, handle changed, or Apify actor is down. Mark the row `active=false` temporarily. |
| Slack returns `not_in_channel` | Bot user was removed from the channel — re-invite via `/invite @feeder-bot` in Slack |

## Banned Handles

Never add these to ChampionInspiration (hard block, see `knowledge/inspiration-seeds.json`):
- Amjad Masad (Replit CEO)
- Anton Osika (Lovable CEO)
- Eric Simons (Bolt/StackBlitz CEO)
- Albert Pai (Bolt/StackBlitz co-founder)

The Feeder App should validate against this list before inserting new rows.

## Maintenance

- Monthly: review `InspirationPost` cost vs. channel value, delete stale records
- Quarterly: refresh banned competitors list from `knowledge/inspiration-seeds.json`
- When onboarding new personas: add default seed inspirations from the persona defaults

---

**That's it.** Once this runbook is complete, every new Social Amplifier champion automatically benefits from the shared feed without any per-champion scraping setup.
