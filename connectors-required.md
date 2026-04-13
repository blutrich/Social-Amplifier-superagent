# Connectors Required

Connectors your Base44 Superagent needs to run the Social Amplifier waterfall.

## Required Connectors

### 1. Slack (mandatory)

**Why:** Read your messages for Phase 1 (Slack context), send DMs for Phase 6 (delivery), receive replies for the feedback trigger.

**Permissions needed:**
- Read messages in channels you're a member of
- Read your own DMs
- Search messages
- Send messages to your own DM
- Read channel list

**How to connect:**
1. In your Superagent, go to **Brain → Integrations → Connectors**
2. Find Slack
3. Click **Connect**
4. Authorize for your workspace
5. Set permissions to read + send for your own DMs

**Verify:** Send your Superagent: "Read my own Slack profile and tell me my display name." If it returns your name, Slack is connected.

## Recommended Connectors

### 2. OctoLens (recommended for Phase 2)

**Why:** Pre-indexed social mentions across LinkedIn, Twitter, Reddit, Dev.to, etc. Used in Phase 2 to check what your inspirations are posting this week.

**Setup:**

OctoLens is an external MCP server, not a built-in Base44 connector. You configure it via the Superagent's MCP configuration:

1. Get your OctoLens API token from your OctoLens dashboard
2. In your Superagent, go to **Settings → Secrets & Keys**
3. Add: `OCTOLENS_TOKEN` = `your-token-here`
4. Send your Superagent in chat: "Connect to OctoLens MCP at https://app.octolens.com/api/mcp using my OCTOLENS_TOKEN secret"
5. The Superagent configures the MCP connection and stores it in `.agents/mcp-config.json`

**Verify:** Send your Superagent: "List my OctoLens saved views." If it returns the views (Brand Monitoring, Crisis Management, etc.), OctoLens is connected.

### 3. Bright Data (recommended for Phase 2 fallback)

**Why:** Scrape LinkedIn/X profiles when OctoLens doesn't index a specific inspiration. Used when an inspiration isn't in OctoLens's indexed authors.

**Setup:**

Bright Data is also an external MCP server.

1. Get your Bright Data API token from your Bright Data dashboard
2. Add to **Settings → Secrets & Keys**: `BRIGHTDATA_TOKEN` = `your-token-here`
3. In chat: "Connect to Bright Data MCP using my BRIGHTDATA_TOKEN secret"

**Verify:** Send your Superagent: "Use Bright Data to scrape this URL as markdown: https://news.ycombinator.com" — should return the HN front page.

## Optional Connectors

### 4. WhatsApp / Telegram (for alternative delivery channels)

**Why:** Some champions prefer delivery via WhatsApp or Telegram instead of (or in addition to) Slack.

**Setup:** See Base44 Superagent docs → Channels section. WhatsApp uses scan-to-connect, Telegram uses BotFather token.

**Use case:** "Send my drafts via WhatsApp instead of Slack" → update the deliver-via-slack skill with WhatsApp routing.

### 5. Google Drive (optional, for export)

**Why:** Save delivered drafts to a Google Drive folder for archive purposes.

**Setup:** Standard Base44 Google Drive connector.

## Connector Permission Settings

In your Superagent's **Settings → Tools Permission**, set:

```
Update Data: ON  (let agent update Memory and content history)
Delete Data: OFF (never delete - only update)

Connector Rules:
- Slack: Only read your own messages and DM you. Never delete messages. Never post in shared channels without explicit permission.
- OctoLens: Read-only.
- Bright Data: Read-only. Use only for explicit URLs the agent provides.
```

These rules keep the agent from doing anything destructive while still letting it operate the waterfall fully.

## Verifying The Full Connector Setup

Run this verification in chat:

```
Verify all my connectors are working. Specifically:
1. Test Slack: read my profile and tell me my name
2. Test OctoLens: list my saved views
3. Test Bright Data: fetch the title of https://news.ycombinator.com
4. Test that you can DM me on Slack (send a test message saying "Connector test - ignore")

Report which connectors passed and which failed.
```

If all 4 pass, your agent is fully wired. If any fail, see the troubleshooting section in `verify-install.md`.

## Connector Costs

- **Slack:** Free, no credit cost
- **OctoLens:** Counts against your OctoLens monthly query limit (usually high)
- **Bright Data:** ~$0.005-0.015 per scrape (cached daily so cost is bounded)

For 1 champion with daily scheduled runs:
- Slack: 5-10 calls/day = free
- OctoLens: 3-5 calls/day = well within limits
- Bright Data: 0-3 scrapes/day (cached) = ~$0.05-0.15/month per champion

For a team of 10 champions: ~$1-2/month total Bright Data spend.
