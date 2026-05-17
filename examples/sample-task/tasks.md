---
id: USERS-ME-LAST-LOGIN
slug: users-me-last-login
stream: API
status: complete
created_at: 2026-04-13
updated_at: 2026-04-13
based_on:
  - requirements.md
  - research.md
  - Spec.md
---

# Tasks: Add `last_login_at` to `/users/me`

## Touched Files

- `internal/api/users/dto.go`
- `internal/api/users/dto_test.go`
- `internal/api/users/handler.go`
- `internal/api/users/handler_test.go`
- `openapi/users.yaml`

## Phase 1 — DTO and handler

- [x] **1.1** Add `LastLoginAt *time.Time \`json:"last_login_at"\`` to `dto.UserMe`. <!-- verify: go build ./internal/api/users/... -->
- [x] **1.2** Assign `out.LastLoginAt = user.LastLoginAt` in the existing `buildUserMe` constructor. <!-- verify: go build ./internal/api/users/... -->

**Phase verification:** `go build ./...` passes; existing tests still pass.

## Phase 2 — Tests

- [x] **2.1** Add table-driven case to `dto_test.go`: `LastLoginAt = &past` → JSON `"last_login_at": "<RFC3339>"`. <!-- mode: tdd | verify: go test -run TestUserMeJSON ./internal/api/users/... -->
- [x] **2.2** Add table-driven case: `LastLoginAt = nil` → JSON `"last_login_at": null`. <!-- mode: tdd | verify: go test -run TestUserMeJSON ./internal/api/users/... -->
- [x] **2.3** Add `handler_test.go` case asserting the field is propagated from the DB model to the response. <!-- verify: go test ./internal/api/users/... -->

**Phase verification:** `go test ./internal/api/users/...` passes.

## Phase 3 — OpenAPI

- [x] **3.1** Add `last_login_at: { type: string, format: date-time, nullable: true }` to the `UserMe` schema in `openapi/users.yaml`. <!-- verify: make openapi-lint -->
- [x] **3.2** Regenerate client SDKs (frontend pulls on next build). <!-- verify: make openapi-generate -->

**Phase verification:** `make openapi-lint` clean; generated SDKs build.

## Phase 4 — Full validation

- [x] **4.1** `make quality-gates` (lint, vet, test, build). <!-- verify: make quality-gates -->
- [x] **4.2** Smoke-test against local stack: `curl localhost:8080/api/users/me -H "Cookie: session=..." | jq '.last_login_at'`. <!-- verify: manual -->

## Definition of Done

- [x] All success criteria from `requirements.md` met.
- [x] `make quality-gates` passes.
- [x] OpenAPI updated and regenerated.
- [x] Frontend ticket FE-2104 unblocked (notified in channel).
- [x] `Spec.md` deviations recorded — none (implementation matched spec).
- [x] No follow-ups for `BUGS.md`, `TECH-DEBT.md`, or `BACKLOG.md`.
