# Getting Started

AI Tech Lead is your AI technical co-founder. She adapts to who you are — founder, developer, or both.

Pick your track below and follow along. The whole setup takes about 2 minutes.

---

## Install

```bash
git clone https://github.com/lmagsino/ai-tech-lead.git
cd ai-tech-lead
./setup.sh
```

Then open Claude Code and go:

```
/strategy "your idea here"
```

No setup needed. Just tell her what you're working on.

---

## Track 1: I'm a founder

You have an idea. You may or may not have a technical background. Here's how to go from idea to something a developer can build.

### Step 1 — Validate the idea

```
/strategy "AI scheduling tool for dentists"
```

She'll challenge your idea like a tough investor: Who's the user? What's the real pain? Who already built this? Is it technically feasible? How do you make money?

She produces `STRATEGY.md` with a GO or STOP decision.

### Step 2 — Design the product

```
/design
```

She reads your `STRATEGY.md` and designs the experience: user journeys, where AI replaces manual steps, screen-by-screen specs. She produces `DESIGN.md`.

### Step 3 — Prioritize what to build

```
/roadmap
```

She reads your strategy and design, then prioritizes: what's in the MVP, what to buy vs build, what to skip. She produces `ROADMAP.md` with a phased plan and a developer handoff brief.

### Step 4 — Hand off to a developer

Your `STRATEGY.md`, `DESIGN.md`, and `ROADMAP.md` are everything a developer needs. Hand them over and have the developer install AI Tech Lead. They'll run `/blueprint` and `/forge` to build what you've defined.

No meetings needed — the documents are the brief.

### What else you can do

```
/review "Here's the requirement from our developer..."
```

Review any plan, requirement, or proposal. She finds gaps, challenges assumptions, and tells you what's missing.

---

## Track 2: I'm a developer

You're building software and want a senior tech lead who actually pushes back.

### Evaluate a feature

```
/challenge "Add real-time AI recommendations"
```

Before you build anything, she challenges whether it's worth building and how. Is there an AI-native version? What's the simpler alternative? She gives you GO, RETHINK, or KILL.

### Write the spec

```
/blueprint scopes/recommendations.md
```

She probes for gaps, designs AI components (model, prompt, fallback, cost), defines testable acceptance criteria, and produces `specs/recommendations.md`. She reviews section-by-section with you before approving.

### Build it

```
/forge specs/recommendations.md
```

AI infrastructure first, then tests, then implementation — exactly what the spec says. She won't start without a spec for anything non-trivial.

### Review the code

```
/guard src/
```

Five-pass review: structure, smells, security (including prompt injection), clean code, AI components. CRITICAL and HIGH findings block merge.

### Fix a bug

```
/hunt "AI responses are hallucinating product names"
```

She classifies first (CODE / AI / INFRASTRUCTURE), traces to root cause, fixes with a regression test, and writes an RCA document. She won't close the bug without a test.

### Ship it

```
/launch
```

Pre-launch checklist: functionality, AI systems, security, infrastructure. GO or NO-GO.

### Quick fixes

For trivial changes — config updates, copy changes, typos:

```
/forge "Update the error message from 'Invalid credentials' to 'Email or password is incorrect'"
```

---

## Track 3: I'm a technical founder

You do both — product and code. Use all the modes.

**When you're thinking about product:**
```
/strategy → /design → /roadmap
```

**When you're building:**
```
/challenge → /blueprint → /forge → /guard → /launch
```

**When something breaks:**
```
/hunt "description of the problem"
```

The full journey looks like this:
```
/strategy → /design → /roadmap → /challenge → /blueprint → /forge → /guard → /launch
```

You can skip steps when it makes sense. But each step catches things the next one can't.

---

## What she won't do

These are hard stops. She will not proceed past them, even if you ask nicely.

- **Build without a spec** — non-trivial features require `/blueprint` first
- **Approve AI without fallbacks** — "what does the user see when the AI fails?"
- **Approve AI without cost estimate** — tokens x volume before any commit
- **Merge CRITICAL findings** — they block, period
- **Close bugs without tests** — regression test required
- **Ship with CRITICAL issues** — NO-GO until fixed

If you know the risk, say "I know the risk, ship it." She'll document the decision and proceed — but she won't silently skip the warning.

---

## Checkpoints

Every mode has a moment where she stops and waits for your input:

| Mode | What she waits for |
|------|--------------------|
| `/strategy` | Your answers to her challenges |
| `/design` | Confirmation of user journey and screen specs |
| `/challenge` | GO / RETHINK / KILL decision |
| `/blueprint` | Section-by-section spec approval |
| `/forge` | Task breakdown approval before touching files |
| `/guard` | CRITICAL/HIGH findings confirmed fixed |
| `/roadmap` | Feature inventory confirmation before prioritizing |
| `/launch` | Your GO before any deploy commands run |
| `/hunt` | Root cause confirmed before fix is applied |

She will not skip these. An agent that builds without alignment builds the wrong thing.

---

## Tips

**She learns as you go.** The more you use her, the more context she has about your project. You can optionally run `/start` to create a project file upfront, but it's not required.

**Follow the mode chain.** Modes hand off artifacts to each other. `/strategy` feeds `/design`. `/blueprint` feeds `/forge`. `/forge` feeds `/guard`. Skipping steps skips the checks those steps enforce.

**She says no.** That's the point. If she says KILL, RETHINK, or NO-GO — listen. She's catching something you might miss when you're moving fast.
