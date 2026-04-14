# Connectors Required

Connectors your Base44 Superagent needs to run the Social Amplifier waterfall.

## Required Connectors

### 1. Slack (mandatory)

**Why:** Read your messages for Phase 1 (Slack context), read the shared `#social-champions-octolens-feed` channel for Phase 2 (inspirations), send DMs for Phase 6 (delivery), receive replies for the feedback trigger.

**Permissions needed:**
- Read messages in channels you're a member of (incl. the shared feed channel)
- Read your own DMs
- Search messages
- Send messages to your own DM
- Read channel list
- Join public channels (`conversations.join`) — needed so the agent can auto-join the feed channel during install

**How to connect:**
1. In your Superagent, go to **Brain → Integrations → Connectors**
2. Find Slack
3. Click **Connect**
4. Authorize for your workspace
5. Set permissions to read + send for your own DMs

**Shared feed channel membership:** during install Step 6, the agent auto-joins `#social-champions-octolens-feed` (ID `C0ATMPHHM40`) via `conversations.join`. If the call fails (e.g. private channel or insufficient scope), the Phase D Summary flags it as a gap and falls back to per-champion inspirations from Interview answer #6.

**Verify:** Send your Superagent: "Read my own Slack profile and tell me my display name, then read the last 5 messages in #social-champions-octolens-feed." If both work, Slack is fully wired.

## NOT Required Per-Champion: Apify

**Important:** champions do NOT need an Apify token. The Apify API token is never given to champion Superagents.

Apify profile scraping (LinkedIn + X) runs inside a separate **Base44 Feeder App** built once by operations. That app:
- Holds `APIFY_TOKEN` in its own env vars
- Runs `apimaestro/linkedin-profile-posts` and `apidojo/tweet-scraper` on a shared inspirations list 3x per day
- Posts new items into `#social-champions-octolens-feed` formatted like OctoLens mentions
- Dedupes so the same post never hits the channel twice

Champion agents read from the Slack channel only — single source, no secrets. See `docs/setup-apify-feeder.md` for the Feeder App runbook.

## Recommended Connectors

### 2. OctoLens MCP (optional — legacy direct access)

**Why:** Direct MCP access to OctoLens as a per-champion fallback. Most champions won't need this because the shared `#social-champions-octolens-feed` channel already delivers OctoLens mentions via Slack. Keep for workspaces that want a direct query path.

**Setup:** If you want it, follow the OctoLens MCP docs to add the MCP server to your Superagent. Not required for the standard install.

## Optional Connectors

### 4. WhatsApp / Telegram (for alternative delivery channels)

**Why:** Some champions prefer delivery via WhatsApp or Telegram instead of (or in addition to) Slack.

**Setup:** See Base44 Superagent docs → Channels section. WhatsApp uses scan-to-connect, Telegram uses BotFather token.

**Use case:** "Send my drafts via WhatsApp instead of Slack" → update the `deliver-via-slack` skill with alternate routing.

### 5. Google Drive (optional, for export)

**Why:** Save delivered drafts to a Google Drive folder for archive purposes.

**Setup:** Standard Base44 Google Drive connector.

## Connector Permission Settings

In your Superagent's **Settings → Tools Permission**, set:

```
Update Data: ON  (let agent update Memory and content history)
Delete Data: OFF (never delete - only update)

Connector Rules:
- Slack: Read your own messages, read #social-champions-octolens-feed, DM you.
         Never delete messages. Never post in shared channels without explicit permission.
- Apify: Read-only actor runs. No actor creation or modification.
```

These rules keep the agent from doing anything destructive while still letting it operate the waterfall fully.

## Verifying The Full Connector Setup

Run this verification in chat:

```
Verify Slack is working:
1. Read my own profile and tell me my display name
2. Read the last 5 messages in #social-champions-octolens-feed
3. DM me a "connector test" message
Report which passed and which failed.
```

If all three pass, the agent is fully wired. (Apify stays out of the champion agent — it runs inside the separate Base44 Feeder App.)

## Connector Costs

- **Slack:** Free, no credit cost
- **Apify:** Pay-per-use. Runs inside the Feeder App, not per-champion. ~$15-30/month total for the whole team regardless of champion count.
- **OctoLens (optional direct):** Counts against your OctoLens monthly query limit
