# ATHENA — Workflows

Standard workflows for greenfield AI-native projects.

---

## Standard Workflow

```
/challenge → /blueprint → /forge → /guard → /launch
```

### Step by step

**1. /challenge — Should we build this?**
Before writing a line of code, challenge the feature. Is this the right solution to the right problem? Is there an AI-native version that's fundamentally better? What's the smallest version that validates the hypothesis? Produces `scopes/[feature].md` on GO.

**2. /blueprint — Design the contract**
Define acceptance criteria, AI components, edge cases, API changes, data model changes, and what's explicitly out of scope. Includes AI component design: model selection, prompt design, fallbacks, cost estimate. Review section by section. Produces `specs/[feature].md` on approval.

**3. /forge — Build it**
AI infrastructure first. Then tests. Then implementation — exactly what the spec says. Clean code gate before each commit. Spec verification when done. Tells you to run `/guard` when complete.

**4. /guard — Gate before merging**
5-pass review: structural integrity, code smells, anti-patterns, security (including prompt injection), AI component quality. CRITICAL and HIGH findings block merge. Tells you to run `/launch` when clear.

**5. /launch — Ship it**
Pre-launch checklist: functionality, AI systems (timeouts, fallbacks, rate limits, cost), security, infrastructure. GO or NO-GO. On GO, confirms before running any deploy commands.

---

## Bug workflow

```
/hunt → fix + regression test → /guard (optional for larger fixes)
```

**1. /hunt** — Classify first (CODE / AI / INFRASTRUCTURE), trace to root cause, propose minimum fix with regression test.

**2. /guard** — For fixes touching 3+ files, run a guard pass to verify the fix didn't introduce new issues.

---

## Quick fix (trivial changes)

For changes under 3 files with no new logic — typos, config updates, copy changes:

Skip `/challenge` and `/blueprint`. Start directly in `/forge` with an inline 5-line spec confirmed by the user.

---

## Human checkpoints

ATHENA never builds without alignment. Required checkpoints per mode:

| Mode | Checkpoint |
|------|-----------|
| `/challenge` | GO / RETHINK / KILL — user decides whether to proceed |
| `/blueprint` | Section-by-section review — user approves each section |
| `/forge` | Task breakdown approval before any file is touched |
| `/guard` | CRITICAL / HIGH findings listed — user confirms fixes before merge |
| `/launch` | GO confirmed by user before any deploy commands run |
| `/hunt` | Root cause confirmed before fix is applied |

Checkpoints are not optional. An agent that builds without alignment builds the wrong thing.

---

## Artifact map

| Mode | Input | Output |
|------|-------|--------|
| `/challenge` | idea / ticket | `scopes/[feature].md` |
| `/blueprint` | `scopes/[feature].md` or idea | `specs/[feature].md` |
| `/forge` | `specs/[feature].md` | committed code + tests |
| `/guard` | path / diff | scorecard (in conversation) |
| `/hunt` | bug report | fix + `docs/rca/[date]-[name].md` |
| `/launch` | codebase | GO / NO-GO (in conversation) |
