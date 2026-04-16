# Workflows

Standard workflows for each persona. Pick the one that fits your role.

---

## Founder Workflow

From idea to developer handoff.

```
/start → /strategist → /designer → /roadmap → handoff
```

**1. /start** — Set up your project. Tell her what you're building and who you are. Creates `AI-TECH-LEAD.md`.

**2. /strategist** — Validate the idea. Market, competition, AI opportunity, business model, technical feasibility. Produces `STRATEGY.md` with GO or STOP.

**3. /designer** — Design the product experience. User journeys, AI interactions, screen-by-screen specs. Produces `DESIGN.md`.

**4. /roadmap** — Prioritize what to build. MVP scoping, sequencing, build vs buy. Produces `ROADMAP.md` with a developer handoff brief.

**5. Handoff** — Give your developer `STRATEGY.md`, `DESIGN.md`, and `ROADMAP.md`. Have them install AI Tech Lead and run `/blueprint` to start speccing.

### Ongoing founder tasks

```
/review "Here's the PRD for notifications..."    — review a plan or requirement
/strategist "Should we pivot to B2B?"             — re-evaluate strategy
/roadmap                                          — re-prioritize after new learnings
```

---

## Developer Workflow

From feature idea to shipped code.

```
/start → /challenge → /blueprint → /forge → /guard → /launch
```

**1. /start** — Set up your project (if not already done). Creates `AI-TECH-LEAD.md` with your stack.

**2. /challenge** — Should we build this? Challenges the feature, suggests AI-native alternatives, gives GO / RETHINK / KILL. Produces `scopes/[feature].md` on GO.

**3. /blueprint** — Write the spec. Acceptance criteria, AI components, edge cases, cost estimates. Section-by-section review. Produces `specs/[feature].md`.

**4. /forge** — Build it. AI infrastructure first, tests first, clean code gate. Exactly what the spec says.

**5. /guard** — Code review. 5-pass: structure, smells, security, clean code, AI components. CRITICAL/HIGH block merge.

**6. /launch** — Pre-launch checklist. Functionality, AI systems, security, infrastructure. GO or NO-GO.

### Bug workflow

```
/hunt → fix + regression test → /guard (if fix touches 3+ files)
```

### Quick fixes

For trivial changes (typos, config, copy) — skip challenge and blueprint:

```
/forge "Update the error message to 'Email or password is incorrect'"
```

---

## Technical Founder Workflow

Full journey — product thinking to shipped code.

```
/start → /strategist → /designer → /roadmap → /challenge → /blueprint → /forge → /guard → /launch
```

Use the founder modes when you're thinking about product. Use the developer modes when you're writing code.

### Common shortcuts

**Strategy is done, building a new feature:**
```
/challenge → /blueprint → /forge → /guard → /launch
```

**Something broke:**
```
/hunt "description" → /guard (if large fix)
```

**Re-evaluating direction:**
```
/strategist "new hypothesis" → /roadmap
```

---

## Artifact Map

Every mode produces an artifact that the next mode reads.

| Mode | Input | Output |
|------|-------|--------|
| `/start` | nothing | `AI-TECH-LEAD.md` |
| `/strategist` | idea | `STRATEGY.md` |
| `/designer` | `STRATEGY.md` | `DESIGN.md` |
| `/roadmap` | `STRATEGY.md`, `DESIGN.md` | `ROADMAP.md` |
| `/review` | any document or plan | assessment (in conversation) |
| `/challenge` | idea / ticket | `scopes/[feature].md` |
| `/blueprint` | `scopes/[feature].md` or idea | `specs/[feature].md` |
| `/forge` | `specs/[feature].md` | committed code + tests |
| `/guard` | path / diff | scorecard (in conversation) |
| `/hunt` | bug report | fix + `docs/rca/[date]-[name].md` |
| `/launch` | codebase | GO / NO-GO (in conversation) |

---

## Checkpoints

Every mode has a moment where she stops and waits for you. These are not optional.

| Mode | Checkpoint |
|------|-----------|
| `/strategist` | Your answers to her challenges before GO/STOP |
| `/designer` | User journey and screen spec confirmation |
| `/roadmap` | Feature inventory confirmation before prioritizing |
| `/challenge` | GO / RETHINK / KILL — you decide whether to proceed |
| `/blueprint` | Section-by-section spec approval |
| `/forge` | Task breakdown approval before any file is touched |
| `/guard` | CRITICAL/HIGH findings confirmed fixed before merge |
| `/launch` | Your GO before any deploy commands run |
| `/hunt` | Root cause confirmed before fix is applied |
