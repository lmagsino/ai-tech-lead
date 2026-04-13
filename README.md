# AI TECH LEAD

**The co-founder who codes.**

AI TECH LEAD is an AI agent skill set that covers the full startup journey — from raw idea to shipped product. She challenges your strategy, designs AI-native experiences, builds production code, and guards the quality gate. Built for CTOs and founders shipping AI-native products from zero.

Works with Claude Code (global or per-project install).

```
 ┌─────────────────────────────────────────────────────────────────┐
 │                         AI TECH LEAD                                  │
 │              The co-founder who codes.                          │
 └─────────────────────────────────────────────────────────────────┘

  PRODUCT THINKING                 ENGINEERING EXECUTION
  ─────────────────                ────────────────────────────────────────
  /strategist                      /challenge → /blueprint → /forge
  "Is this worth building?"        "Should we?" → "What exactly?" → "Build it"
       │
       ▼
  /designer                        /guard        /hunt        /launch
  "How should it work?"            "Is it solid?" "What broke?" "Ship it"
       │
       ▼
  STRATEGY.md + DESIGN.md
  feed into engineering →

  Full workflow:
  /strategist → /designer → /challenge → /blueprint → /forge → /guard → /launch
```

---

## What makes AI Tech Lead, AI Tech Lead

The goddess AI Tech Lead isn't just skilled — she's the combination of two things most engineers split apart: **wisdom** and **craft**.

She thinks before she acts. She challenges before she builds. She's loyal to the mission, not the task.

**She thinks, she doesn't just do.**
Before writing a line of code she asks: *should this exist? is this the right shape? what breaks if we're wrong?* Most AI agents jump to execution. AI Tech Lead pauses.

**She has conviction.**
She won't just validate your idea. She'll tell you it's wrong if it's wrong — then build it brilliantly if you still want it. A senior engineer who only agrees is useless to a CTO.

**She's AI-first.**
Every suggestion defaults to AI-native. When she scopes a feature, she asks how AI can power it. When she builds, she reaches for LLMs, embeddings, and agents as naturally as most engineers reach for a database. She knows the Claude API, RAG patterns, agent architectures, and the failure modes of AI systems.

**She sees the whole.**
Not just the feature — the system it lives in, the users it serves, the tech debt it creates, the future it opens or closes. Full stack isn't just front + back. It's the whole product.

**She's loyal to outcomes, not process.**
She uses structure when it helps. She drops it when it doesn't. The goal is shipping something excellent — not completing a checklist.

Each mode is AI Tech Lead thinking in a different dimension of her craft:

**Product thinking**

| Mode | AI Tech Lead is | Use when |
|------|-----------|----------|
| `/strategist` | The YC partner | "I have an idea" / "Is this worth building?" |
| `/designer` | The UX architect | "How should this work?" / "Design the experience" |

**Engineering execution**

| Mode | AI Tech Lead is | Use when |
|------|-----------|----------|
| `/challenge` | The feature challenger | "Should we build this feature?" |
| `/blueprint` | The spec architect | "Define what we're building" |
| `/forge` | The craftsperson | "Build it" |
| `/guard` | The quality gate | "Is this solid?" |
| `/hunt` | The detective | "Something broke" |
| `/launch` | The closer | "We're ready to launch" |

---

## Install

```bash
git clone https://github.com/lmagsino/ai-tech-lead.git
cd ai-tech-lead
./setup.sh
```

`setup.sh` installs each mode as a direct slash command in Claude Code. See [INSTALL.md](INSTALL.md) for manual setup or [docs/getting-started.md](docs/getting-started.md) for a full walkthrough.

---

## Quick start

**1. Create your project constitution**
```bash
cp /path/to/ai-tech-lead/AI-TECH-LEAD.md.template ./AI-TECH-LEAD.md
# Edit: stack, AI components, architecture, rules
```

**2. Use it**
```
# New product
/strategist "AI inventory tool for restaurants"
/designer

# New feature
/challenge "Add real-time AI recommendations"
/blueprint "Conversational onboarding with LLM"
/forge specs/onboarding.md
/guard src/
/hunt "AI responses are hallucinating product names"
/launch
```

---

## How it works

AI TECH LEAD uses a **three-tier context architecture**:

- **Hot tier** — `AI-TECH-LEAD.md` (your project constitution) is loaded on every invocation
- **Warm tier** — Each mode loads only the references it needs (clean code, security, AI patterns, etc.)
- **Cold tier** — Subagents handle codebase scanning, dependency mapping, and research on demand

This keeps context lean. `/debug` doesn't load SOLID principles. `/review` doesn't scan your entire codebase upfront.

---

## AI-first defaults

AI TECH LEAD treats AI as infrastructure, not a feature. Her defaults:

- **LLM integration** — Claude API with structured outputs, prompt caching, and tool use
- **Agent patterns** — multi-step reasoning, tool orchestration, subagent delegation
- **RAG** — embeddings + vector search before building custom retrieval
- **Evals** — AI behavior should be tested like code behavior
- **Cost awareness** — token budgets and caching strategies considered in every design
- **Failure modes** — hallucination handling, fallbacks, and graceful degradation built in from the start

---

## Reference library

AI TECH LEAD ships with reference documents loaded per-mode:

- `references/clean-code.md` — Naming, functions, error handling, DRY, YAGNI
- `references/solid-principles.md` — SOLID with violation examples and corrected code
- `references/code-smells.md` — 23 smells with detection signals and severity ratings
- `references/anti-patterns.md` — N+1, race conditions, memory leaks, missing timeouts
- `references/security-owasp.md` — OWASP Top 10 with code patterns and fixes
- `references/engineering-checklist.md` — Correctness, performance, reliability, observability
- `references/design-patterns.md` — Strategy, Observer, Factory, Repository, Builder, and more

---

## Guard: 5-pass code review

`/review` runs five passes and produces a severity-ranked scorecard:

1. **Structural integrity** — SOLID principles
2. **Code smells & anti-patterns** — 23 smells + N+1, race conditions, etc.
3. **Security** — OWASP Top 10, hardcoded secrets, missing auth, prompt injection
4. **Clean code** — Naming, function size, DRY, YAGNI, error handling
5. **Spec conformance** — (if `--against spec.md`) — acceptance criteria pass/fail

Every finding includes: severity, `file:line`, description, and a concrete fix.

---

## Customization

Edit `AI-TECH-LEAD.md` in your project root:
- Define your stack and AI components
- Set project-specific rules
- Document your architecture decisions

See [docs/customization.md](docs/customization.md) for the full guide.

---

## Architecture

See [docs/getting-started.md](docs/getting-started.md) for a step-by-step walkthrough.
See [docs/architecture.md](docs/architecture.md) for the full design.
See [docs/workflows.md](docs/workflows.md) for greenfield startup workflows.

---

## License

MIT — do whatever you want with it.
