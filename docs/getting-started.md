# Getting Started with ATHENA

ATHENA is a set of AI agent modes for Claude Code. Each mode is a specialist: one challenges your strategy, one designs the experience, one builds the code, one reviews it, one hunts bugs, one ships it.

You don't learn ATHENA. You just describe what you're working on and call the right mode.

---

## Install

```bash
git clone https://github.com/your-org/athena.git
cd athena
./setup.sh
```

Choose **global** install to use ATHENA in every project, or **local** if you want it scoped to one project.

After install, each mode is a slash command in Claude Code: `/strategist`, `/designer`, `/challenge`, `/blueprint`, `/forge`, `/guard`, `/hunt`, `/launch`.

---

## Set up your project

Copy the project constitution template into your repo root:

```bash
cp /path/to/athena/ATHENA.md.template ./ATHENA.md
```

Open it and fill in:
- Your **stack** (framework, database, auth)
- Your **AI components** (what you're building with LLMs)
- Your **architecture decisions** (monorepo, serverless, etc.)

ATHENA reads this file at the start of every session. Without it, she'll still work — but she won't know your project.

---

## Your first session: new product

Say you have an idea: "AI-powered inventory management for restaurants."

**Step 1 — Challenge the idea**

```
/strategist "AI inventory tool for restaurants"
```

Athena acts as a skeptical investor. She'll probe: who's the user, what's the real pain, who already built this, where does AI actually help, how do you make money. She produces `STRATEGY.md`.

**Step 2 — Design the experience**

```
/designer
```

Athena reads `STRATEGY.md` and designs the product: user journeys, where AI replaces manual steps, screen-by-screen specs. She produces `DESIGN.md`.

**Step 3 — Challenge a specific feature**

```
/challenge "Add AI-powered demand forecasting"
```

Before writing any spec, Athena challenges whether this should be built and how. Is there an AI-native version? What's out of scope? She produces `scopes/demand-forecasting.md` on GO.

**Step 4 — Write the spec**

```
/blueprint scopes/demand-forecasting.md
```

Athena probes for gaps, designs the AI component (model, prompt, fallback, cost estimate), defines acceptance criteria, and produces `specs/demand-forecasting.md`. She reviews section-by-section with you before approving.

**Step 5 — Build it**

```
/forge specs/demand-forecasting.md
```

Athena builds AI infrastructure first, then tests, then implementation — exactly what the spec says. She won't start without a spec for anything non-trivial.

**Step 6 — Review the code**

```
/guard src/
```

Five-pass review: structural integrity, code smells, security (including prompt injection), clean code, AI component quality. CRITICAL and HIGH findings block merge.

**Step 7 — Ship it**

```
/launch
```

Pre-launch checklist: functionality, AI systems (timeouts, fallbacks, rate limits, cost), security, infrastructure. GO or NO-GO.

---

## Working on an existing feature

When strategy and design are already settled, skip to engineering:

```
/challenge "Add user notifications"
/blueprint scopes/notifications.md
/forge specs/notifications.md
/guard src/notifications/
/launch
```

---

## Something broke

```
/hunt "Users are seeing hallucinated product names in recommendations"
```

Athena classifies first (CODE / AI / INFRASTRUCTURE), traces to root cause, and proposes a minimum fix with a regression test. She won't close the bug without a test.

---

## Quick fixes

For trivial changes under 3 files — config updates, copy changes, typos — skip `/challenge` and `/blueprint`. Start directly in `/forge` with an inline spec:

```
/forge "Update the error message on the login page from 'Invalid credentials' to 'Email or password is incorrect'"
```

---

## What Athena won't do

- **Build without a spec** — non-trivial features require `/blueprint` first
- **Approve AI components without fallbacks** — what does the user see when the LLM fails?
- **Approve AI components without a cost estimate** — tokens × volume before any commit
- **Merge CRITICAL or HIGH security findings** — they block, period
- **Ship with unresolved CRITICAL issues** — NO-GO until fixed

These aren't settings. They're how she works.

---

## Checkpoint flow

Every mode has a moment where Athena stops and waits for you:

| Mode | What she waits for |
|------|--------------------|
| `/challenge` | GO / RETHINK / KILL |
| `/blueprint` | Section-by-section approval |
| `/forge` | Task breakdown approval before touching files |
| `/guard` | CRITICAL/HIGH findings confirmed fixed before merge |
| `/launch` | Your GO before any deploy commands run |
| `/hunt` | Root cause confirmed before fix is applied |

She will not skip these. An agent that builds without alignment builds the wrong thing.

---

## Tips

**Give her your ATHENA.md.** The more context she has about your stack and AI components, the more specific her suggestions will be. Generic project = generic output.

**Follow the mode chain.** Modes hand off artifacts to each other. `/blueprint` feeds `/forge`. `/forge` feeds `/guard`. Skipping steps skips the checks those steps enforce.

**Override with context, not instructions.** If she blocks on a hard stop and you want to proceed anyway, say "I know the risk, ship it." She'll document the decision and move forward — but she won't silently skip the warning.

**Use subagents.** Athena delegates expensive operations (codebase scans, dependency research, API lookups) to subagents so the main context stays clean. You'll see her spin one up when she needs it.
