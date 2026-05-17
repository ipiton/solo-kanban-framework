---
id: USERS-ME-LAST-LOGIN
slug: users-me-last-login
stream: API
type: feature
priority: medium
status: archived
created_at: 2026-04-12
updated_at: 2026-04-13
---

# Requirements: Add `last_login_at` to `/users/me`

## Problem Framing

- **Symptom:** The profile page on the web client shows "Last seen: —" because the API does not expose `last_login_at`. Support tickets reference users not knowing when their session was refreshed.
- **Root Cause:** The `users.last_login_at` column is populated on each successful auth but is not serialized into the `/users/me` response.
- **Why Now:** A frontend ticket (FE-2104) is blocked on this field. Backfill is unnecessary — the column has been populated since auth-v3 rollout in 2025-Q4.
- **How We Measure:** `GET /users/me` returns `last_login_at` as ISO-8601 UTC. Frontend ticket FE-2104 unblocks.

## Risk Profile

- **Signals:** `C R`
  - `C` — adds a new field to a public REST contract.
  - `R` — runtime impact, requires a deploy for clients to see the new field.
- **Tier:** Standard
- **Notes:** No `S` (auth path unchanged, no new permission), no `M` (column already exists and is populated), no `X` (single service, no cross-boundary impact).

## User Stories

1. As a user viewing my profile page, I want to see when I last logged in, so that I know whether my current session is fresh.
2. As a frontend engineer, I want `last_login_at` available in `/users/me`, so that I can finish FE-2104.

## Success Criteria

- [x] `GET /users/me` includes `last_login_at` for authenticated users.
- [x] Value is ISO-8601 UTC, e.g. `2026-04-12T18:34:11Z`.
- [x] `last_login_at` is `null` for users who have never logged in (legacy or seed accounts).
- [x] OpenAPI schema is updated; clients regenerated successfully.
- [x] Unit and contract tests cover present, null, and serialization cases.

## Non-Goals

- No new endpoint.
- No backfill or migration — column already exists.
- No exposure of `last_login_at` for *other* users (only `/users/me`).
- No audit log or analytics event for reads.

## Constraints

- **Scope:** `api/users/me` handler and its DTO only. No service-layer changes.
- **Security:** Existing auth on `/users/me` is sufficient. No new permission check.
- **Compatibility:** Additive change — no existing client breaks. Field is optional in the OpenAPI schema.

## Discovery Notes

- Similar tasks: `tasks/archive/users-me-add-locale/` (2026-02) added `locale` to the same endpoint — same pattern.
- Relevant patterns: `internal/api/users/dto.go` already serializes `created_at` and `updated_at` as ISO-8601 — reuse the same time formatter.
- Open unknowns: One — whether any existing serialization helper handles `*time.Time` nullability cleanly, or whether the handler needs a manual nil-check. Resolved in `research.md`.
