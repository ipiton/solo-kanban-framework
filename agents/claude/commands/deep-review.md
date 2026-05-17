---
description: Independent multi-perspective review for Solo Kanban tasks with mandatory or discretionary triggers.
allowed-tools:
  - Read
  - Write
  - Edit
  - Glob
  - Grep
  - Bash
  - Task
user-invocable: true
---

# Deep Review

Run an independent review pass. Testing checks that code matches the spec; deep review checks that the spec matches reality and that the implementer's blind spots are not also the test suite's blind spots.

## When To Run

**Mandatory** — `finalize` cannot proceed without recorded findings:

- `S` signal: security, auth, permissions, privacy, PII;
- `M` signal: migration, backfill, data integrity, irreversible op;
- pre-release review for any externally visible release;
- three or more risk signals in any combination (Full tier by signal count).

**Discretionary** — may be skipped with a recorded reason:

- diff exceeds approximately 200 changed lines without `S` or `M`;
- combined `C` and `X` signals;
- novel pattern, first-time use of a library or framework, or first-of-its-kind change;
- author has reasoned doubt about a non-obvious decision.

If none of the above apply, do not run `deep-review`. The pipeline is intentionally lighter.

## Steps

1. Read `requirements.md` (note Risk Profile), `research.md`, `Spec.md` (note Deep Review section), `tasks.md`, test results, and the full current diff.
2. Confirm trigger classification: mandatory, discretionary-running, or discretionary-skipped. If skipped, record reason and stop.
3. Define review lenses relevant to the signals present:
   - `S` → auth, ownership, input validation, secret handling, supply chain;
   - `M` → migration safety, backfill correctness, reversibility, concurrent-write behavior;
   - `C` → contract compatibility, wire format, version negotiation, client impact;
   - `X` → cross-boundary invariants, ownership of failure modes, integration tests;
   - `R` → observability coverage, rollout/rollback, perf regression, alert wiring.
   Always add at least: correctness, tests adequacy, and maintainability.
4. Review only the task scope. Use independent perspective — do not anchor on the author's stated rationale.
5. Classify each finding:
   - **Severity:** `blocker` (must fix before finalize) | `major` (fix or explicit defer with follow-up) | `minor` | `nit`.
   - **Disposition:** `fix-here` | `defer-bug` | `defer-tech-debt` | `defer-backlog` | `reject` (with reason).
6. Fix blockers in the current task or stop with a clear blocker note. Resolve majors or open the follow-up entry.
7. Record findings in `tasks/<slug>/review-findings.md` using the output schema below.
8. Move deferred follow-ups into `BUGS.md`, `TECH-DEBT.md`, or `BACKLOG.md` during `finalize`.

## Output Schema

`tasks/<slug>/review-findings.md`:

```markdown
# Deep Review Findings: <Task Title>

**Trigger classification:** <mandatory | discretionary-running | discretionary-skipped>
**Reviewer perspective:** <agent name or human reviewer>
**Reviewed at:** YYYY-MM-DD

## Findings

### F1 — <one-line title>
- **Severity:** blocker | major | minor | nit
- **Location:** `path/to/file.go:42`
- **Issue:** <what is wrong or risky>
- **Recommendation:** <what to do>
- **Disposition:** fix-here | defer-bug | defer-tech-debt | defer-backlog | reject (reason: ...)
- **Follow-up:** <link/path to BUGS.md / TECH-DEBT.md entry, or "n/a">

### F2 — ...

## Skip Register

<!-- Discretionary triggers consciously not run. Omit section if none. -->

- <trigger>: <reason for skip>

## Anti-Pattern Check

- [ ] Self-audit was not treated as a substitute for independent review.
```

## Anti-Pattern: Self-Audit As Substitute

A self-review pass by the implementer is additive, not substitutive. The same mind that wrote the code and tests cannot reliably challenge the assumption both of them share. If only the implementer has reviewed mandatory-trigger work, deep review has not actually run — escalate to an independent reviewer (agentic or human).
