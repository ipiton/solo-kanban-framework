---
id: USERS-ME-LAST-LOGIN
slug: users-me-last-login
stream: API
status: complete
created_at: 2026-04-12
updated_at: 2026-04-12
based_on:
  - requirements.md
---

# Research: Add `last_login_at` to `/users/me`

## TL;DR

The existing `dto.UserMe` struct already serializes `*time.Time` fields via `omitempty`. Adding `LastLoginAt *time.Time` with the same tag will produce `null` JSON for users who have never logged in. No helper changes needed.

## Questions

1. Does any existing DTO serialize a nullable timestamp, and how does it render `null`?
2. Is there a shared serializer or formatter for ISO-8601 we must use?
3. Is the `users.last_login_at` column nullable in the schema?

## Findings

### Q1 — Nullable timestamps in existing DTOs

`internal/api/users/dto.go:42` declares `EmailVerifiedAt *time.Time` with tag `json:"email_verified_at,omitempty"`. With the standard `encoding/json` marshaller and `*time.Time`, a `nil` pointer renders as `null`, not omitted — confirmed by `dto_test.go:88` which asserts `"email_verified_at": null` for unverified users. The `omitempty` tag is misleading here but harmless.

### Q2 — Shared ISO-8601 formatter

`internal/api/users/dto.go` relies on `time.Time.MarshalJSON()`, which uses RFC 3339 — equivalent to ISO-8601 for our purposes. No custom formatter exists or is needed. The frontend already parses RFC 3339 (`Date.parse` and `dayjs` accept it).

### Q3 — Column nullability

`db/schema.sql:118` declares `last_login_at TIMESTAMPTZ NULL DEFAULT NULL`. The `User` ORM model in `internal/db/users.go:34` types it as `*time.Time`. Legacy users created before auth-v3 (2025-Q4) have `NULL`. New users have a value after first login.

## Options

| Option | Description | Trade-off |
|---|---|---|
| A. Add `LastLoginAt *time.Time` to `dto.UserMe` directly | Mirror the `EmailVerifiedAt` pattern. | Smallest diff; consistent with existing code. |
| B. Add a computed `LastSeen` field with humanized string ("2 hours ago") | Move humanization server-side. | Couples the API to UX phrasing; client-locale-sensitive. Rejected. |
| C. Introduce a shared `Timestamps` sub-object grouping `created_at`, `updated_at`, `last_login_at` | Refactor toward a nested timestamps shape. | Out of scope; breaks compatibility with existing clients. Rejected. |

## Decision

**Option A.** Add `LastLoginAt *time.Time` to `dto.UserMe` with tag `json:"last_login_at"`. Omit `omitempty` so the field is always present in the response (either an ISO-8601 string or `null`) — frontend prefers explicit `null` over absent.

## Spec Inputs

- DTO field: `LastLoginAt *time.Time` with `json:"last_login_at"` (no `omitempty`).
- Mapping: `dto.UserMe.LastLoginAt = userModel.LastLoginAt` in the handler.
- OpenAPI: add `last_login_at: { type: string, format: date-time, nullable: true }` to the `UserMe` schema.
- Test cases: present value, null value, RFC 3339 format.

## References

- `internal/api/users/dto.go:42` — existing `EmailVerifiedAt` pattern.
- `internal/api/users/dto_test.go:88` — assertion for null timestamp serialization.
- `db/schema.sql:118` — column definition.
- `tasks/archive/users-me-add-locale/Spec.md` — prior worked example of the same endpoint.
