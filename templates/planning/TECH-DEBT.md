# TECH-DEBT

Use this file for working behavior with poor structure, maintainability risk, missing tests for working code, weak observability, or fragile design. If the code breaks its contract, it is a bug — use `BUGS.md`.

When debt is paid, delete its entry; the account goes to `DONE.md`.

## Bundles

<!-- Group small entries that touch the same subsystem into one claimable parent.
     Only the bundle slug goes into the NEXT.md Queue. See docs/artifact-contract.md `Bundles`. -->

## Critical

## High

## Medium

## Low

## Entry Format

```markdown
### [priority][area][estimate] DEBT-SLUG

- **Title:** short title
- **Problem:** what makes maintenance risky
- **Impact:** why it matters
- **Fix:** likely direction
- **Refs:** code, issue, task, or review links
- **Status:** open | in-progress | blocked
```

## Bundle Format

```markdown
### AREA-CLEANUP-BUNDLE

- [priority][area][combined estimate] AREA-CLEANUP-BUNDLE
- **Combined verify:** <one command; exit 0 means the whole batch is done>
- **Members (ordered):**
  - [ ] DEBT-SLUG-ONE
  - [ ] DEBT-SLUG-TWO
```

Members keep their own full entries. The parent's priority is the maximum of its members.
