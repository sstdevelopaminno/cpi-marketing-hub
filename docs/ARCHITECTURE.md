# CPI Marketing Hub — Architecture

## V1 goal
Use internally for CUTTING POINT INNOVATION first, then expand to a multi-tenant client platform.

## Modules
1. Overview dashboard
2. Meta Ads
3. Google Ads
4. SEO / Google Search Console
5. YouTube
6. Content workspace
7. Automation rules
8. Connections / OAuth

## Delivery model
- Primary product: Web App (responsive, installable as PWA later)
- No Windows-only desktop dependency for V1
- OAuth callbacks, webhooks, scheduled sync and automation remain server-side and continue when user devices are offline

## Planned production stack
- Web: Next.js App Router + TypeScript
- Database/Auth: Supabase PostgreSQL + Auth + RLS (`CpiPOS-Communications`, ref `wznixoeezgyhtwurcswb`)
- Marketing tables must be isolated from the existing support/contact domain
- Hosting: Vercel
- Scheduled jobs: Vercel Cron or Supabase scheduled jobs
- Integrations: Meta Marketing API, Google Ads API, Search Console API, GA4 Data API, YouTube Data/Analytics APIs

## Multi-tenant model
organizations -> workspaces -> connections -> ad_accounts / sites / channels
organizations -> users -> memberships
workspaces -> campaigns / seo_pages / keywords / content_items / conversions / automation_rules

Every business record must carry organization_id and workspace_id. Production tables must use RLS.

## Security rules
- Never expose provider app secrets or refresh tokens to the browser.
- Encrypt provider refresh tokens at rest.
- OAuth callback and API operations run server-side.
- Use least-privilege provider scopes.
- Record audit logs for connection changes, campaign writes, budget changes and automation actions.
- Automation must support dry-run and human approval before autonomous budget changes are enabled.
