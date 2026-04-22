# AI Tech Lead

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Built for Claude Code](https://img.shields.io/badge/Built%20for-Claude%20Code-blueviolet)](https://claude.ai/code)
[![Modes](https://img.shields.io/badge/Modes-11-green)]()

**Your AI technical co-founder.**

Founders get a CTO who never sleeps. Developers get a senior tech lead who challenges, reviews, and ships with you. Built on [Claude Code](https://claude.ai/code) — works in your terminal, desktop app, or browser.

> **Why not just use Claude?** Claude is a general-purpose assistant. AI Tech Lead is a structured workflow — she enforces specs before code, blocks merges on security findings, produces artifacts that chain together, and says KILL when your idea shouldn't be built. She has opinions, hard stops, and a process. That's the difference between a chatbot and a co-founder.

```
You: /strategy "AI scheduling tool for dentists"

AI Tech Lead: The scheduling space has incumbents — Dentrix, Curve, Open Dental.
             Why would a dentist switch? What does AI unlock that their current tool can't?
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

You wear both hats. So does she — founder modes for product thinking, developer modes for building. She adapts based on context.

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

Works with **Claude Code**, **Cursor**, **Codex**, **Gemini CLI**, and **OpenCode**. See [INSTALL.md](INSTALL.md) for platform-specific details.

---

## What it looks like

### A founder validates an idea

```
You: /strategy "AI-powered inventory management for restaurants"

AI Tech Lead: Competitive scan: MarketMan, BlueCart, Restaurant365, Toast inventory.
             Established players but none are AI-native.

             The gap: existing tools require manual data entry. An AI-native tool
             could infer inventory from POS data and auto-generate purchase orders.
             That's structural, not cosmetic.

             Technical feasibility: straightforward. The hard part is POS integration —
             start with one (Square or Toast) and expand.

             Business model concern: independent restaurant owners are price-sensitive
             and churn is high. What's your CAC/LTV math?

             GO — proceed to /design with STRATEGY.md.
```

### A developer challenges a feature

```
You: /challenge "Add a search bar to find users"

AI Tech Lead: Before we build a search bar — have you considered semantic search?

             Embeddings + pgvector lets users find "that designer who worked on
             our mobile app" instead of requiring exact name recall.
             Same effort to build, dramatically better UX.

             If the answer is "just names and emails" — a LIKE filter ships
             in 2 hours. Which problem are we solving?
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

**She adapts to you.** She figures out who you are from what you say — founders get plain language, developers get file paths and dollar figures. No setup step required.

**She's opinionated.** She doesn't list five options and ask you to choose. She has a recommendation and she states it. She says KILL when something shouldn't be built.

**She enforces hard stops.** No spec = no build. CRITICAL finding = merge blocked. No fallback on AI = won't approve. No regression test = bug stays open. These are non-negotiable.

**She chains artifacts.** Each mode produces something the next mode reads: `/strategy` → `STRATEGY.md` → `/design` → `DESIGN.md` → `/blueprint` → `specs/` → `/forge` → code → `/guard` → scorecard → `/launch` → GO or NO-GO.

**Founders can hand off to developers.** Complete `/strategy` + `/design` + `/roadmap` and you have everything a developer needs — no meetings required.

---

## Docs

- [Getting started](docs/getting-started.md) — your first session, step by step
- [Workflows](docs/workflows.md) — common workflows for founders and developers
- [Architecture](docs/architecture.md) — how AI Tech Lead is structured
- [Customization](docs/customization.md) — tune it for your project and team

---

## Contributing

Open an issue or PR. Bug reports, new mode ideas, and improvements to existing modes are all welcome.

---

## License

MIT
