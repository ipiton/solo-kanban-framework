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

Run an independent review pass. Testing checks that code matches the spec and that the pieces are consistent; tests written under a wrong premise confirm it. Deep review checks that the spec matches reality — against the Design Premises, git history of the touched code, and domain checklists — so the implementer's blind spots are not also the test suite's.

## Position

After `implement`, before `write-tests`. Run it when every implementation step in `tasks.md` is checked; reviewing half-built code produces findings that go stale. A design defect found after tests exist costs a rewrite of the code **and** its tests.

At this position expect normative and design findings: ownership, fail-open paths, layering, wrong premises. A behavioral finding that needs a run to confirm is deferred to `testing` rather than argued from reading code.

## When To Run

**Mandatory** — `write-tests` does not start without a `pass` verdict:

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

1. Run from the tree of the branch under review (its worktree), not from the main checkout. Read `requirements.md` (note Risk Profile), `research.md`, `Spec.md` (note Design Premises and the Deep Review section), `tasks.md`, and the full current diff.
2. Confirm trigger classification: mandatory, discretionary-running, or discretionary-skipped. If skipped, record reason and stop.
3. Define review lenses relevant to the signals present:
   - `S` → auth, ownership, input validation, secret handling, supply chain;
   - `M` → migration safety, backfill correctness, reversibility, concurrent-write behavior;
   - `C` → contract compatibility, wire format, version negotiation, client impact;
   - `X` → cross-boundary invariants, ownership of failure modes, integration tests;
   - `R` → observability coverage, rollout/rollback, perf regression, alert wiring.
   Always add at least: correctness, **premises** (is each Design Premise true, and is its class earned?), and maintainability. Use `git log` on the touched files for history the author may not know.
4. Review only the task scope. Use an independent perspective — a separate agent or a human, not the implementer's session. Do not anchor on the author's stated rationale.
5. Classify each finding:
   - **Severity:** `blocker` (must fix before finalize) | `major` (fix or explicit defer with follow-up) | `minor` | `nit`.
   - **Disposition:** `fix-here` | `defer-bug` | `defer-tech-debt` | `defer-backlog` | `reject` (with reason).
6. Record findings in `tasks/<slug>/review-findings.md` using the output schema below.
7. Write the verdict to `tasks/<slug>/review-verdict.json` (schema in `docs/artifact-contract.md`), with the reviewed branch and commit. Prefer a script that computes `gate` from the findings and exits non-zero unless `pass`:
   - `pass` — no open `blocker`, every `major` has a disposition;
   - `fix_required` — fix the `fix-here` items, then re-run the review;
   - `blocked` / `degenerate_review` — the reviewer was the author, the run crashed or returned nothing usable: re-run with a guaranteed independent reviewer;
   - `blocked` / `tree_mismatch` — the verdict was produced for another branch or commit: re-run from the reviewed branch's tree.
   None of these means "the code is clean".
8. Move deferred follow-ups into `BUGS.md`, `TECH-DEBT.md`, or `BACKLOG.md` during `finalize`.

## Output Schema

`tasks/<slug>/review-findings.md`:

```markdown
# Deep Review Findings: <Task Title>

**Trigger classification:** <mandatory | discretionary-running | discretionary-skipped>
**Reviewer perspective:** <agent name or human reviewer>
**Reviewed at:** YYYY-MM-DD
**Reviewed tree:** <branch> @ <commit>
**Verdict:** pass | fix_required | blocked (see `review-verdict.json`)

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

## Enforcement

The strongest form of this gate is a hook that refuses to write test files while the verdict is not `pass`, plus a pre-commit check for the same rule (an editor hook does not see files written from a shell). Without it, the gate is only as strong as this text. See `docs/agent-policies.md` § Enforcement Hierarchy.

## Anti-Pattern: Self-Audit As Substitute

A self-review pass by the implementer is additive, not substitutive. The same mind that wrote the code and tests cannot reliably challenge the assumption both of them share. If only the implementer has reviewed mandatory-trigger work, deep review has not actually run — escalate to an independent reviewer (agentic or human).
