-- CPI Marketing Hub initial database schema
-- Target Supabase project: CpiPOS-002
-- Project ref: kawenyvpentwgugtzqec
--
-- Security posture for V0.1:
--   * RLS enabled on every public table.
--   * No browser-access policies are created yet (default deny).
--   * Provider secrets/tokens must only be handled server-side.
--   * Explicit authenticated grants can be added together with scoped RLS policies
--     once authentication and the membership model are wired into the application.

create extension if not exists pgcrypto;

create table if not exists public.organizations (
  id uuid primary key default gen_random_uuid(),
  name text not null,
  slug text not null unique,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.organization_members (
  organization_id uuid not null references public.organizations(id) on delete cascade,
  user_id uuid not null references auth.users(id) on delete cascade,
  role text not null default 'member' check (role in ('owner','admin','marketer','analyst','member')),
  created_at timestamptz not null default now(),
  primary key (organization_id, user_id)
);

create table if not exists public.workspaces (
  id uuid primary key default gen_random_uuid(),
  organization_id uuid not null references public.organizations(id) on delete cascade,
  name text not null,
  slug text not null,
  timezone text not null default 'Asia/Bangkok',
  currency text not null default 'THB',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (organization_id, slug)
);

create table if not exists public.provider_connections (
  id uuid primary key default gen_random_uuid(),
  organization_id uuid not null references public.organizations(id) on delete cascade,
  workspace_id uuid not null references public.workspaces(id) on delete cascade,
  provider text not null check (provider in ('meta','google_ads','google_search_console','ga4','youtube')),
  external_account_id text,
  display_name text,
  status text not null default 'disconnected' check (status in ('disconnected','connected','error','expired')),
  scopes text[] not null default '{}',
  token_expires_at timestamptz,
  last_synced_at timestamptz,
  metadata jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.campaign_snapshots (
  id uuid primary key default gen_random_uuid(),
  organization_id uuid not null references public.organizations(id) on delete cascade,
  workspace_id uuid not null references public.workspaces(id) on delete cascade,
  connection_id uuid references public.provider_connections(id) on delete set null,
  provider text not null check (provider in ('meta','google_ads','youtube')),
  external_campaign_id text not null,
  campaign_name text not null,
  status text,
  objective text,
  currency text not null default 'THB',
  spend numeric(14,2) not null default 0,
  impressions bigint not null default 0,
  clicks bigint not null default 0,
  leads bigint not null default 0,
  conversions bigint not null default 0,
  revenue numeric(14,2) not null default 0,
  snapshot_date date not null,
  raw_metrics jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now(),
  unique (provider, external_campaign_id, snapshot_date)
);

create table if not exists public.seo_projects (
  id uuid primary key default gen_random_uuid(),
  organization_id uuid not null references public.organizations(id) on delete cascade,
  workspace_id uuid not null references public.workspaces(id) on delete cascade,
  site_url text not null,
  search_console_property text,
  status text not null default 'active' check (status in ('active','paused','archived')),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  unique (workspace_id, site_url)
);

create table if not exists public.seo_query_snapshots (
  id uuid primary key default gen_random_uuid(),
  organization_id uuid not null references public.organizations(id) on delete cascade,
  workspace_id uuid not null references public.workspaces(id) on delete cascade,
  seo_project_id uuid not null references public.seo_projects(id) on delete cascade,
  query text not null,
  page text,
  clicks numeric(14,2) not null default 0,
  impressions numeric(14,2) not null default 0,
  ctr numeric(9,6) not null default 0,
  position numeric(9,3),
  snapshot_date date not null,
  created_at timestamptz not null default now()
);

create index if not exists seo_query_snapshots_lookup_idx
  on public.seo_query_snapshots (seo_project_id, snapshot_date desc, query);

create table if not exists public.content_items (
  id uuid primary key default gen_random_uuid(),
  organization_id uuid not null references public.organizations(id) on delete cascade,
  workspace_id uuid not null references public.workspaces(id) on delete cascade,
  title text,
  body text,
  channel text not null check (channel in ('facebook','instagram','youtube','website','other')),
  status text not null default 'draft' check (status in ('draft','review','approved','scheduled','published','archived')),
  scheduled_at timestamptz,
  published_at timestamptz,
  metadata jsonb not null default '{}'::jsonb,
  created_by uuid references auth.users(id) on delete set null,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.automation_rules (
  id uuid primary key default gen_random_uuid(),
  organization_id uuid not null references public.organizations(id) on delete cascade,
  workspace_id uuid not null references public.workspaces(id) on delete cascade,
  name text not null,
  enabled boolean not null default false,
  dry_run boolean not null default true,
  provider text,
  conditions jsonb not null default '[]'::jsonb,
  actions jsonb not null default '[]'::jsonb,
  requires_approval boolean not null default true,
  last_run_at timestamptz,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.audit_logs (
  id bigint generated always as identity primary key,
  organization_id uuid references public.organizations(id) on delete set null,
  workspace_id uuid references public.workspaces(id) on delete set null,
  actor_user_id uuid references auth.users(id) on delete set null,
  action text not null,
  entity_type text,
  entity_id text,
  details jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now()
);

alter table public.organizations enable row level security;
alter table public.organization_members enable row level security;
alter table public.workspaces enable row level security;
alter table public.provider_connections enable row level security;
alter table public.campaign_snapshots enable row level security;
alter table public.seo_projects enable row level security;
alter table public.seo_query_snapshots enable row level security;
alter table public.content_items enable row level security;
alter table public.automation_rules enable row level security;
alter table public.audit_logs enable row level security;

-- No grants/policies yet. This intentionally leaves Data API access denied
-- until Auth + tenant authorization is implemented and reviewed.
