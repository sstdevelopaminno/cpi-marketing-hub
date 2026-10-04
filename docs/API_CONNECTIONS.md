# API Connections — Implementation order

## 1. Google Search Console (first live integration)
Read-only first: sites, search analytics, sitemap/index information where supported.
Reason: low operational risk and immediately useful for the company's website SEO.

## 2. Google Analytics 4
Read-only acquisition and conversion metrics.

## 3. Meta Marketing API
Phase A: read ad accounts/campaigns/insights.
Phase B: create and update campaigns after permissions and app review are ready.

## 4. Google Ads API
Phase A: reporting.
Phase B: campaign/keyword/budget writes with safeguards.

## 5. YouTube
Channel/video analytics and metadata workflows. Advertising remains under Google Ads.

## OAuth connection records
Store provider, external_account_id, encrypted_refresh_token, granted_scopes, expires_at, status and last_sync_at.
