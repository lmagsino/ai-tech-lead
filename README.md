# AI Tech Lead

**Your AI technical co-founder.**

Founders get a CTO who never sleeps. Developers get a senior tech lead who challenges, reviews, and ships with you. Built on [Claude Code](https://claude.ai/code) — works in your terminal, desktop app, or browser.

```
You: I want to build an AI scheduling tool for dentists.

AI Tech Lead: Who is the target user — solo practices, multi-location clinics, or both?
             What does scheduling look like for them today?

             Before we go further: the scheduling space has incumbents (Dentrix, Curve,
             Open Dental). Why would a dentist switch? What does AI unlock here that
             their current tool can't do?
```

She's not here to agree with you. She's here to make sure you build the right thing, the right way.

<p align="center">
  <img src="assets/workflow.svg" alt="AI Tech Lead — Workflow Overview" width="100%">
</p>

---

## Who is this for?

### Founders

You have an idea but no technical co-founder. AI Tech Lead fills that gap.

Tell her your idea. She'll challenge it, research competitors, assess technical feasibility, help you design the product, prioritize what to build first, and produce documents you can hand directly to a developer.

```
/strategy "AI tool for X"           — validate the idea: market, tech, business model
/design                             — plan the product experience
/roadmap                            — prioritize: what to build first, what to skip
/review                             — review a requirement, plan, or approach
```

### Developers

You want a senior tech lead who actually pushes back instead of saying "sounds good."

She challenges requirements before you waste time building, writes specs with testable acceptance criteria, builds AI-first, reviews code across five passes, hunts bugs to root cause, and blocks your launch if there's a CRITICAL finding.

```
/challenge "Add real-time AI recommendations"   — should we build this?
/blueprint scopes/recommendations.md            — write the spec
/forge specs/recommendations.md                 — build it
/guard src/                                     — 5-pass code review
/hunt "AI responses are hallucinating names"     — find and fix the bug
/launch                                         — pre-launch checklist: GO or NO-GO
```

### Technical Founders & CTOs

You wear both hats. So does she.

Use the founder modes when you're thinking about product and market. Use the developer modes when you're writing code. She adapts based on context.

---

## Quick start

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

## What it looks like

### A founder validates an idea

```
You: /strategy "AI-powered inventory management for restaurants"

AI Tech Lead: Who is the target user — independent restaurants, chains, or both?
             What does inventory management look like for them today?

             [After your answer]

             Competitive scan running...
             Direct: MarketMan, BlueCart, Restaurant365, Toast inventory
             Adjacent: Craftybase, Square for Restaurants

             There are established players but none are AI-native. The gap:
             existing tools require manual data entry. An AI-native tool could
             infer inventory from POS data, flag anomalies, and auto-generate
             purchase orders. That's structural, not cosmetic.

             Technical feasibility: straightforward. Standard web app + AI
             classification. The hard part is POS integration — every system
             has a different API. Start with one (Square or Toast) and expand.

             Business model challenge: independent restaurant owners are
             price-sensitive and churn is high. What's your CAC/LTV math?

             ...

             GO — proceed to /design with STRATEGY.md.
```

### A developer challenges a feature

```
You: /challenge "Add a search bar to find users"

AI Tech Lead: Before we build a search bar — have you considered semantic search?

             A vector-based search (embeddings + pgvector) would let users find
             "that designer who worked on our mobile app" instead of requiring
             exact name recall. Same effort to build, dramatically better UX.

             If the answer is "just names and emails" — a simple DB query with
             a LIKE filter ships in 2 hours and is right-sized.

             Which problem are we solving?
```

### A code review catches a real problem

```
You: /guard src/

AI Tech Lead: CRITICAL — src/ai/prompts/chat.ts:34: user message concatenated
             directly into system prompt without sanitization.
             Prompt injection risk. Fix before merge.

             HIGH — src/ai/client.ts:12: no timeout on API calls.
             A hanging Claude call blocks the request indefinitely.
             Fix: add AbortController with 30s timeout.

             Scorecard:
             Structural integrity  PASS
             Code smells           PASS
             Security              FAIL (1 CRITICAL — blocks merge)
             Clean code            PASS
             AI components         FAIL (1 HIGH)

             Fix these 2 issues before merge.
```

---

## All modes

### For everyone

| Mode | What it does | What you get |
|------|-------------|--------------|
| `/strategy` | Validates your idea — market, competition, tech feasibility, business model | `STRATEGY.md` with GO or STOP |
| `/design` | Plans the product experience — user journeys, AI interactions, screen specs | `DESIGN.md` |
| `/review` | Reviews a requirement, plan, or approach — finds gaps and challenges assumptions | Assessment: READY, NEEDS WORK, or RETHINK |

### For founders

| Mode | What it does | What you get |
|------|-------------|--------------|
| `/roadmap` | Prioritizes what to build — MVP scoping, sequencing, build vs buy | `ROADMAP.md` with phases and developer brief |

### For developers

| Mode | What it does | What you get |
|------|-------------|--------------|
| `/challenge` | Challenges whether to build something — always asks if there's an AI-native alternative | GO, RETHINK, or KILL with reasoning |
| `/blueprint` | Writes the spec — AI components, acceptance criteria, edge cases, cost estimates | `specs/[feature].md` |
| `/forge` | Builds from spec — AI infrastructure first, tests first, clean code gate | Committed code with passing tests |
| `/guard` | 5-pass code review — structure, smells, security, clean code, AI components | Severity scorecard (CRITICAL/HIGH block merge) |
| `/hunt` | Hunts bugs to root cause — classifies, traces, fixes, regression tests | Fix + `docs/rca/[date]-[description].md` |
| `/launch` | Pre-launch checklist — functionality, AI systems, security, infrastructure | GO or NO-GO |

---

## How she works

### She adapts to you

She figures out who you are from what you say and how you say it. No setup step required.

- **Founders** get plain language, business context, and no jargon
- **Developers** get file paths, line numbers, token counts, and dollar figures
- **Technical founders** get both, depending on which mode they're in

### She's opinionated

She doesn't list five options and ask you to choose. She has a recommendation and she states it. She pushes back when your idea has a hole. She says KILL when something shouldn't be built.

### She enforces discipline

These are hard stops. She will not proceed past them, even if you ask nicely.

| Rule | Mode | What happens |
|------|------|-------------|
| No spec for a non-trivial feature | `/forge` | Won't build. "Run `/blueprint` first." |
| AI component without a fallback | `/blueprint` | Won't approve. "What does the user see when this fails?" |
| AI component without cost estimate | `/blueprint` | Won't approve. "Estimate tokens x volume first." |
| CRITICAL or HIGH security finding | `/guard` | Blocks merge. Lists exactly what to fix. |
| Bug fix without regression test | `/hunt` | Won't close. "Regression test required." |
| Unresolved CRITICAL before launch | `/launch` | NO-GO. Period. |

If you know the risk and want to proceed anyway, say so. She'll document the decision and move on — but she won't silently skip the warning.

### She hands off between modes

Each mode produces an artifact that the next mode reads:

```
/strategy  → STRATEGY.md
/design    → DESIGN.md     (reads STRATEGY.md)
/challenge → scopes/       (reads STRATEGY.md)
/blueprint → specs/        (reads scopes/)
/forge     → code          (reads specs/)
/guard     → scorecard     (reads code)
/launch    → GO / NO-GO    (reads everything)
```

You can skip steps when it makes sense. But the chain exists because each step catches things the next step can't.

### Founder-to-developer handoff

If you're a founder and you've completed `/strategy` + `/design` + `/roadmap`, you have everything a developer needs. Hand them:

- `STRATEGY.md` — what you're building and why
- `DESIGN.md` — how the product should work
- `ROADMAP.md` — what to build first

Have them install AI Tech Lead and run `/blueprint` to start speccing. They'll have the full context of your product decisions without a single meeting.

---

## Install

```bash
git clone https://github.com/lmagsino/ai-tech-lead.git
cd ai-tech-lead
./setup.sh
```

Works with **Claude Code**, **Cursor**, **Codex**, **Gemini CLI**, and **OpenCode**. The setup script detects your platform automatically.

See [INSTALL.md](INSTALL.md) for platform-specific details and manual setup.

---

## Reference library

Each mode loads only the references it needs:

- `references/clean-code.md` — naming, function size, readability
- `references/solid-principles.md` — structural integrity
- `references/code-smells.md` — what bad code looks like
- `references/anti-patterns.md` — common mistakes
- `references/security-owasp.md` — OWASP Top 10 + AI security
- `references/design-patterns.md` — proven solutions
- `references/ai-patterns.md` — AI-native implementation patterns
- `references/engineering-checklist.md` — pre-merge checklist

---

## Docs

- [Getting started](docs/getting-started.md) — your first session, step by step
- [Workflows](docs/workflows.md) — common workflows for founders and developers
- [Architecture](docs/architecture.md) — how AI Tech Lead is structured
- [Customization](docs/customization.md) — tune it for your project and team

---

## License

MIT
