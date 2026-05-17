---
id: USERS-ME-LAST-LOGIN
slug: users-me-last-login
stream: API
type: feature
status: complete
created_at: 2026-04-12
updated_at: 2026-04-13
based_on:
  - requirements.md
  - research.md
---

# Specification: Add `last_login_at` to `/users/me`

**Version:** 1.0
**Status:** Implemented

## Summary

Surface the existing `users.last_login_at` column on the authenticated profile endpoint as an ISO-8601 timestamp (or `null`). Single-handler, additive change.

## Requirements Coverage

| Requirement / Criterion | Covered by |
|---|---|
| Field present in `/users/me` | `dto.UserMe.LastLoginAt`, handler assignment |
| ISO-8601 UTC format | Standard `*time.Time` JSON marshalling (RFC 3339) |
| `null` for never-logged-in users | Pointer + no `omitempty` |
| OpenAPI updated | `openapi/users.yaml` patch |
| Tests cover present/null/format | `dto_test.go`, `handler_test.go` |

## Current State

- **Code:** `internal/api/users/handler.go` builds `dto.UserMe` from `db.User`. `dto.UserMe` already exposes `created_at`, `updated_at`, `email_verified_at`.
- **Data:** `users.last_login_at TIMESTAMPTZ NULL` exists since auth-v3. Populated by `auth/login.go` on each successful login.
- **Tests:** `dto_test.go` and `handler_test.go` cover existing fields with table-driven cases.
- **Docs:** `openapi/users.yaml` declares the `UserMe` schema.

## Target Design

`dto.UserMe` gains one field, `LastLoginAt *time.Time`, mapped 1:1 from `db.User.LastLoginAt` in the existing handler. OpenAPI schema gains one property. No service-layer change. No new package, no new helper.

## API Contracts

### GET /users/me

- **Auth:** existing user session.
- **Ownership:** unchanged — endpoint always returns the calling user.
- **Request:** unchanged.
- **Response:** existing `UserMe` shape plus:

  ```json
  {
    "last_login_at": "2026-04-12T18:34:11Z"
  }
  ```

  Or `"last_login_at": null` for users who have never logged in.
- **Errors:** unchanged.

## Data Model / Migrations

Not applicable. Column exists and is populated.

## Component Architecture

- `internal/api/users/dto.go` — add `LastLoginAt *time.Time \`json:"last_login_at"\`` to `UserMe`.
- `internal/api/users/handler.go` — assign `out.LastLoginAt = user.LastLoginAt` after existing assignments.
- `openapi/users.yaml` — add `last_login_at` property to `UserMe` schema.

## Security Design

- [x] Ownership validation required — already enforced by `RequireAuth` middleware on `/users/me`.
- [x] Input validation — not applicable, read-only field.
- [x] Sensitive data not logged — `last_login_at` is not PII per privacy policy section 3.2.
- [x] Rate limiting — inherited from existing endpoint, no change.
- [x] Auth/RBAC path defined — unchanged.

## Invariants

- [x] Field is always present in the response — `null` or ISO-8601, never missing.
- [x] Field is read-only — no PATCH path exposes it.
- [x] Existing clients that ignore unknown fields keep working — additive change.

## Edge Cases

1. User has never logged in → `last_login_at: null`.
2. User just logged in this request → `last_login_at` reflects the prior login, not the current one (the column is updated *after* the response is built for the auth handler, not for `/users/me`).
3. Timezone — column is `TIMESTAMPTZ`, output is UTC `Z` suffix.

## Impact Analysis

- **Affected modules:** `internal/api/users/`, `openapi/`.
- **Breaking changes:** none (additive).
- **New dependencies:** none.
- **Risks:** none material. Clients with strict schema validation must regenerate from the updated OpenAPI — coordinated with frontend.

## Rollout / Rollback

- **Rollout:** Standard deploy. Frontend ticket FE-2104 picks up the field next sprint.
- **Rollback:** Revert single PR — clients ignore the missing field.
- **Feature flag:** none.

## Observability

- **Logs:** unchanged.
- **Metrics:** unchanged.
- **Alerts:** unchanged.

## Deep Review

- **Mandatory triggers present:** none. No `S`, no `M`, not pre-release, only 2 signals (`C R`).
- **Discretionary triggers present:** none. Diff is well under 200 LOC, no `C+X` combination, mirrors the existing `EmailVerifiedAt` pattern (not novel), no author doubt.
- **Decision:** not applicable.

## Open Questions

- [x] Should the field be omitted when null, or always present? → Always present per research decision; matches frontend preference.
