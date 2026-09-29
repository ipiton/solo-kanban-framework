# BUGS

Use this file for behavior that is broken or violates a contract the code promises: a security policy, an ownership filter, a schema constraint, a test suite that does not do its job. A security gap is a bug even if nobody exploited it. Working-but-costly code belongs in `TECH-DEBT.md`.

When a bug is fixed, delete its entry; the account goes to `DONE.md`.

## Critical

## High

## Medium

## Low

## Entry Format

```markdown
### [severity][area][estimate] BUG-SLUG

- **Title:** short title
- **Problem:** what is broken
- **Impact:** who or what is affected
- **Fix:** likely direction
- **Refs:** code, issue, task, or log links
- **Status:** open | in-progress | blocked
```

Owner inbox markers, each at the start of its own line when needed: `Blocked-by: <party>`, `Waiting-on: <event or date>`, `Trigger: owner ready`. An estimate may contain `owner action`.
