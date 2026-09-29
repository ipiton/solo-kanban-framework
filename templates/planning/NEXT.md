# NEXT

Queue and WIP are the current source of truth for task selection.

## Flow Rules

<!-- The single place for flow numbers. Commands and other docs point here instead of copying them. -->

- **WIP limit:** 2 — one primary task plus one urgent fix. With one worktree and one agent session per task, raise it deliberately (3 is a common ceiling) and change it only here.
- **Replenish** the Queue when it drops below three items. Check each candidate against `DONE.md` and its archives first, so closed work does not come back.
- **Balance** maintenance (`BUGS`, `TECH-DEBT`) and roadmap (`ROADMAP`, `BACKLOG`) intentionally. Example rule: look at the last five closures; if one side has more than three, take the next task from the other.
- **Owner inbox first:** at `start-task`, an unblocked owner action outranks Queue position 1. More than 5 unblocked owner items means no new roadmap pulls until the inbox is back to 5 or fewer.
- **Slice** tasks larger than two days before starting.
- **Live state only:** when an item leaves WIP or the Queue, delete its line. The account goes to `DONE.md`; do not keep it here as a comment.

## WIP

## Queue

1. `(SOURCE / Stream) task-slug` - short scope and expected outcome. `~estimate`
