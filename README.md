# CPI Marketing Hub

Marketing operations platform for **CUTTING POINT INNOVATION CO., LTD.**

Current release: **V0.1 prototype**. This build establishes the dashboard, product modules, integration boundaries and secure database model before live provider credentials are connected. It does **not** spend advertising budget or call third-party advertising APIs yet.

## Current modules

- Marketing overview dashboard
- Meta Ads workspace
- Google Ads workspace
- SEO / Google Search Console workspace
- YouTube workspace
- Content AI workspace
- Automation rule preview
- Connection center / OAuth preparation

## Database target

This repository is assigned to **Supabase: CpiPOS-Communications**.

- Project ref: `wznixoeezgyhtwurcswb`
- Project URL: `https://wznixoeezgyhtwurcswb.supabase.co`
- Initial schema: `supabase/schema.sql`

The schema enables Row Level Security on every public table and intentionally ships with no browser-access policies yet. Real provider tokens and Supabase secret keys must never be committed to GitHub.

## Run locally

```bash
npm start
```

Open `http://localhost:3000`.

## Environment variables

Copy `.env.example` to `.env` and fill credentials locally or in the deployment environment. The repository only contains placeholders; no live secrets should be committed.

## Application model

CPI Marketing Hub is a **web application first**. It will run centrally on Vercel so OAuth callbacks, webhooks, scheduled jobs and background sync continue even when a user's computer is off. A PWA/installable desktop-like shell can be added later without creating a separate backend.

## Production roadmap

1. Migrate the validated UI to Next.js App Router + TypeScript.
2. Connect Supabase Auth and tenant-scoped RLS policies.
3. Connect Google Search Console read-only OAuth first.
4. Add GA4 read-only reporting.
5. Add Meta Ads read-only insights.
6. Add Google Ads / YouTube reporting.
7. Enable campaign writes only after audit logs, approvals and dry-run controls are verified.
