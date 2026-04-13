# AI TECH LEAD — Workflows

Standard workflows for greenfield AI-native projects.

---

## Full Startup Workflow

Starting a new product from scratch.

```
/strategist → /designer → /challenge → /blueprint → /forge → /guard → /launch
```

### Step by step

**1. /strategist — Is this worth building?**
Challenge the idea before anything else. Market research, competitive analysis, AI opportunity, monetization, distribution. GO or STOP with reasoning. Produces `STRATEGY.md`.

**2. /designer — What's the experience?**
User journeys before screens. AI-first interactions — where does AI replace a manual flow? Screen-by-screen specs detailed enough to build without design questions. Produces `DESIGN.md`.

**3. /challenge — Should we build this feature?**
For each feature in the MVP, challenge the scope. Is there an AI-native version? What's explicitly out? Produces `scopes/[feature].md` on GO.

**4. /blueprint — Define the contract**
Acceptance criteria, AI components (model, prompts, fallbacks, cost), data model changes, API design. Review section by section. Produces `specs/[feature].md` on approval.

**5. /forge — Build it**
AI infrastructure first. Then tests. Then implementation — exactly what the spec says. Clean code gate before each commit. Spec verification when done.

**6. /guard — Gate before merging**
5-pass review: structural integrity, code smells, security (including prompt injection), clean code, AI component quality. CRITICAL and HIGH block merge.

**7. /launch — Ship it**
Pre-launch checklist: functionality, AI systems (timeouts, fallbacks, rate limits, cost), security, infrastructure. GO or NO-GO.

---

## Engineering-Only Workflow

When strategy and design are already settled — working on a specific feature.

```
/challenge → /blueprint → /forge → /guard → /launch
```

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

AI TECH LEAD never builds without alignment. Required checkpoints per mode:

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
| `/strategist` | raw idea | `STRATEGY.md` |
| `/designer` | `STRATEGY.md` | `DESIGN.md` |
| `/challenge` | idea / ticket | `scopes/[feature].md` |
| `/blueprint` | `scopes/[feature].md` or idea | `specs/[feature].md` |
| `/forge` | `specs/[feature].md` | committed code + tests |
| `/guard` | path / diff | scorecard (in conversation) |
| `/hunt` | bug report | fix + `docs/rca/[date]-[name].md` |
| `/launch` | codebase | GO / NO-GO (in conversation) |
