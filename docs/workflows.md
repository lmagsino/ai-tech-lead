# ATHENA — Workflows

Standard workflows for greenfield and brownfield projects.

---

## Greenfield Workflow

Building something new from scratch.

```
/challenge → /spec → /forge → /guard → /vision (if UI) → ship
```

### Step by step

**1. /challenge — Should we build this?**
Before writing a line of code, challenge the feature. Is this the right solution to the right problem? What's the smallest version that validates the hypothesis?

**2. /spec — Write the contract**
Define acceptance criteria, edge cases, API changes, data model changes, and what's explicitly out of scope. Review section by section. Approve before building.

**3. /forge — Build it**
Implement exactly what the spec says. Test first. Clean code gate before each commit. Verify against spec acceptance criteria when done.

**4. /guard — Review before merging**
Run the 5-pass scorecard: structural integrity, code smells, anti-patterns, security, spec conformance. Fix CRITICAL and HIGH findings.

**5. /vision — Check the UI (if applicable)**
Multi-viewport screenshot, console error scan, accessibility check, spec UI criteria verification.

**6. Ship**

---

## Brownfield Workflow

Working on an existing codebase.

### Adding a new feature

```
/challenge → /spec → /forge (with impact analysis) → /guard → /vision (if UI) → ship
```

The key difference from greenfield: `/forge` always runs an impact analysis first — mapping affected files, dependents, and existing tests — and gets user approval before touching anything.

### Fixing a bug

```
/investigate → fix + regression test → /guard (optional, for larger fixes) → ship
```

**1. /investigate** — Trace the bug to its root cause. Never patch symptoms.

**2. Fix + regression test** — Minimum change that fixes the root cause. Regression test that reproduces the bug before the fix and passes after.

**3. /guard** — For larger fixes (3+ files), run a guard pass to ensure the fix didn't introduce new issues.

### Refactoring

```
/retro (identify target) → /evolve → /guard → ship
```

**1. /retro** — Identify which modules are tech debt hotspots worth addressing. Don't refactor randomly.

**2. /evolve** — Write behavior tests first. Migrate one pattern at a time. Verify parity after each step.

**3. /guard** — Confirm the refactored code meets the quality bar.

### Trivial changes

```
/patch → ship
```

One step. Three-file max. Lightweight gate (no new smells, no broken tests). Commit and done.

---

## Decision Tree

```
User request arrives
        ↓
Is it a trivial fix (< 3 files, no new tests needed)?
  YES → /patch
  NO  ↓
Is it a bug or incident?
  YES → /investigate
  NO  ↓
Is it a question about whether to build something?
  YES → /challenge
  NO  ↓
Is it a refactor or modernization task?
  YES → /evolve
  NO  ↓
Is it a code review request?
  YES → /guard
  NO  ↓
Is it a visual/UI check?
  YES → /vision
  NO  ↓
Does a spec already exist for this feature?
  YES → /forge
  NO  → /spec (then /forge when approved)
```

---

## Human Checkpoints

ATHENA never builds without alignment. The required checkpoints per mode:

| Mode | Checkpoint |
|------|-----------|
| `/challenge` | GO / RETHINK / KILL recommendation — user decides whether to proceed |
| `/spec` | Section-by-section review — user approves each section |
| `/forge` | Impact analysis approval before touching files |
| `/forge` | Task breakdown approval before implementation |
| `/evolve` | Pattern list approval before migration begins |
| `/investigate` | Root cause confirmation before applying fix |

Checkpoints are not optional. An agent that builds without alignment is an agent that builds the wrong thing.

---

## lessons.md Pattern

ATHENA maintains a `lessons.md` in the project root. It's updated by `/retro` and read by every mode via the hot tier.

Format:
```markdown
# Lessons

## [Module / Area]
- When [doing X], always [do Y] because [reason]
- Pattern [X] caused [problem] — prefer [Y]
- [Component] has [hidden behavior] — check [thing] before modifying

## General
- [Project-wide lessons]
```

Good lessons are specific and actionable. Bad lessons are vague warnings ("be careful with the auth module").
