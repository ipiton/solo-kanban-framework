# Agent Policies

Cross-cutting policies that apply to every pipeline step. `docs/workflow.md` says *which* steps run; this document says *how* an agent behaves inside them.

**Version:** 1.1

Replace the example commands with your repository's own. Keep the rules.

## Refactoring Policy

### Refactor Means No Behavior Change

If behavior changes, it is a feature or a bugfix, not a refactor. Consequences:

- **One change type per branch:** refactor, feature, bugfix, or optimization. A diff where a move is mixed with a bug fix cannot be reviewed or reverted safely.
- Tests pass after a refactor **without changes**, except import paths. If a test has to change in substance, behavior changed.
- **Order when moving a module:** move as-is with the same contract → rewrite style or framework → fix bugs → optimize. Each is a separate task, in that order.

### Copy, Don't Rewrite, When Extracting

When extracting a module into a separate package or service, copy the files as they are and change only what the build needs: import paths and names. "While I'm here" cleanups go into follow-up tasks.

### Feature Flag As Escape Hatch

For a non-trivial migration — moving a module between services, replacing a library with a different contract, changing a storage backend — enable the new path through a config flag and keep the old one next to it until verified. Duplicated code is fine as temporary insurance. Rollback becomes a flag change, not an emergency revert. Renames and single-file cosmetic changes do not need a flag.

### Characterization Tests

Before refactoring code that has no tests, write tests that pin down its current behavior as-is. Refactor until they pass unchanged. Change behavior only afterwards, in a separate task. Skip this for pure renames or code that is already well covered.

### Small Commits And Short Branches

- Each commit is one logical step (extract, rename, move, inline), builds, passes tests, and can be reverted on its own.
- Run fast checks after each step and the full quality gate at the end.
- A refactor branch should not live longer than three days. If it does, slice it.

### Pin The Result

A refactor is not finished until the new invariant is pinned: by a test, a lint rule, an architecture check, or at least a written rule — and by a `DECISIONS.md` entry if the change is architectural. Without that, the structure drifts back.

## Retry Policy

Classify the failure before retrying it.

| Type | Examples | Strategy |
|---|---|---|
| **Transient** | network failure, rate limit, temporary unavailability | backoff, at most 3 attempts, then escalate |
| **Agent-recoverable** | malformed output, wrong tool call, syntax error the agent introduced | feed the error back and self-correct, at most 2 attempts |
| **Owner-fix** | missing credential, bad config, invalid input data, merge conflict | stop and tell the owner what is needed |
| **Unexpected** | panic, assertion failure, unknown error | stop, capture context, record an incident or bug |

| Failure | Strategy |
|---|---|
| Test failure | fix the root cause and re-run; after 2 attempts, stop |
| Build failure | read the error and fix it; no blind retry |
| Tool or search service unavailable | fall back to local tools (grep, file reads) and continue |
| Deploy failure | roll back first, then diagnose |

**Anti-pattern:** retrying the same call in a loop. Diagnose, classify, fix, then try again. Ten steps at 99% success each give about 90% end-to-end — error handling decides whether a chain of agent steps works.

## Agent Boundaries

A starting point. Tighten it in your repository's agent instructions.

### Autonomous

- Reading code and documentation.
- Creating and editing files in `tasks/<slug>/`.
- Running tests, linters, and builds.
- Creating a task branch and committing to it.
- The claim commit on the integration branch that moves a task into WIP — planning files only, never code.

### Requires Confirmation

- New packages, services, or public interfaces.
- Database migrations and schema changes.
- Deleting files or features.
- Auth, security, or permission logic.
- Pushing to a remote, except the sanctioned claim commit.
- Deploying to any environment.

### Forbidden

- Committing or pushing code directly to the integration branch.
- Editing generated files by hand.
- Logging secrets or personal data.
- Force push, `reset --hard`, or skipping hooks with `--no-verify`.

## Discovery Cost

Every tool result stays in the session context and is paid for again on every following turn. What you search *with* matters as much as what you find.

| Doing | Use | Why |
|---|---|---|
| Finding where code, a rule, or a phrase lives | semantic search over the repository, if available | one query replaces a chain of greps; the number of steps is what costs |
| Sweeping the tree, "where else is this done" | a read-only sub-agent | its heavy intermediate results stay in its own context; you get the summary |
| Collecting facts or reviewing without edits | a read-only sub-agent | same, and it cannot mutate the tree |
| Exact match: an id, a file name, an identifier | `grep` directly | semantic search loses on exact tokens |

A tool that dumps everything unfiltered is more expensive in the main context than a targeted grep. Give sub-agents that only read or generate options **no write access**: a generator with a full toolset can overwrite a shared working tree.

### Session Boundaries

- One session per task. Start a new session for the next task instead of continuing in a long one — the context from the previous task is paid for on every turn and helps nothing.
- Delegate mechanical, well-specified work (writing a function to a spec, generating tests, updating docs) to a cheaper model; keep judgment — design, review verdicts, what goes into `DONE.md` — on the stronger one.
- Measure before optimizing. If you tune cost, keep a script that counts spend per session and per step, and compare like with like.

## Enforcement Hierarchy

When a rule keeps getting broken, do not make the instruction louder. Move enforcement up to a more deterministic level:

1. **Compiler or type system** — the constraint lives in a type, an exhaustive switch, a build error.
2. **Lint rule** — static check in CI and pre-commit.
3. **Architecture check** — a custom script over the tree or AST.
4. **Hook** — a git hook or an agent pre-tool hook that refuses the action at the moment it happens.
5. **Command or skill** — makes the right behavior the path of least resistance.
6. **Agent instructions** (`AGENTS.md`, rule files) — declarative text. **The last line of defense, not the first.**

If the same mistake happens twice, look for a way to catch it at a lower level number instead of adding another warning to the instructions.

Put the gate **on the seam** where the action happens, not in the instructions that describe it. For example, "no tests before a review verdict" is enforced by a hook that refuses to write a test file, not by a sentence in `write-tests.md`. And check both paths to the seam: an editor hook does not see a file written by a shell command, so the same contract needs a pre-commit check as well.

A gate that cannot read its input must fail loudly. "Could not check" and "checked, clean" must be different exit codes. A green result caused by a missing source looks exactly like a real green.

### Where A Finding Goes

A finding that lives only in chat is lost with the session. Route it:

| What was learned | Where |
|---|---|
| A new choice between alternatives | `DECISIONS.md` |
| A preference that repeated twice | a rule in the repository's agent instructions |
| A defect | `BUGS.md` |
| Working but costly implementation | `TECH-DEBT.md` |
| An idea | `BACKLOG.md` |
| Something the owner must do | the owner inbox markers — see `docs/artifact-contract.md` |
