# AI Tech Lead

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Built for Claude Code](https://img.shields.io/badge/Built%20for-Claude%20Code-blueviolet)](https://claude.ai/code)
[![Modes](https://img.shields.io/badge/Modes-11-green)]()

**Your AI technical co-founder.**

Founders get a CTO who never sleeps. Developers get a senior tech lead who actually pushes back. Built on [Claude Code](https://claude.ai/code).

> **Why not just use Claude?** AI Tech Lead is a structured workflow with opinions, hard stops, and artifact chains — not a general-purpose chatbot. It enforces specs before code, blocks merges on CRITICAL findings, and says KILL when your idea shouldn't be built.

```
You: /strategy "AI scheduling tool for dentists"

AI Tech Lead: The scheduling space has incumbents — Dentrix, Curve, Open Dental.
             Why would a dentist switch? What does AI unlock that their current tool can't?
```

<p align="center">
  <img src="assets/workflow.svg" alt="AI Tech Lead — Workflow Overview" width="100%">
</p>

---

## Quick start

```bash
git clone https://github.com/lmagsino/ai-tech-lead.git
cd ai-tech-lead
./setup.sh
```

Then:

```
/strategy "your idea here"
```

No setup needed. Just describe what you're working on. Works with **Claude Code**, **Cursor**, **Codex**, **Gemini CLI**, and **OpenCode**. See [INSTALL.md](INSTALL.md) for details.

---

## Modes

**For everyone**

| Mode | What it does | Output |
|------|-------------|--------|
| `/strategy` | Validates idea — market, competition, tech feasibility | `STRATEGY.md` — GO or STOP |
| `/design` | Plans the product — user journeys, AI interactions, screens | `DESIGN.md` |
| `/review` | Reviews a requirement, plan, or proposal | READY, NEEDS WORK, or RETHINK |
| `/roadmap` | Prioritizes what to build — MVP scope, build vs buy | `ROADMAP.md` with developer brief |

**For developers**

| Mode | What it does | Output |
|------|-------------|--------|
| `/challenge` | Challenges whether to build — asks for the AI-native version | GO, RETHINK, or KILL |
| `/blueprint` | Writes the spec — AI components, acceptance criteria, costs | `specs/[feature].md` |
| `/forge` | Builds from spec — AI infra first, tests first | Committed code |
| `/guard` | 5-pass code review — security, structure, AI components | Scorecard (CRITICAL blocks merge) |
| `/hunt` | Hunts bugs to root cause — classifies, traces, fixes | Fix + regression test |
| `/launch` | Pre-launch checklist | GO or NO-GO |

---

## How it works

**Adapts to you.** Founders get plain language. Developers get file paths and dollar figures. Detected from context — no setup step.

**Opinionated.** One recommendation, not five options. KILL when something shouldn't be built.

**Hard stops.** No spec = no build. CRITICAL = merge blocked. No AI fallback = won't approve. Non-negotiable.

**Artifact chain.** `/strategy` → STRATEGY.md → `/design` → DESIGN.md → `/blueprint` → specs/ → `/forge` → code → `/guard` → scorecard → `/launch` → GO or NO-GO.

**Founder handoff.** `/strategy` + `/design` + `/roadmap` = everything a developer needs. No meetings.

---

## Docs

- [Getting started](docs/getting-started.md) — first session walkthrough
- [Workflows](docs/workflows.md) — founder and developer flows
- [Architecture](docs/architecture.md) — how it's structured
- [Customization](docs/customization.md) — tune for your project

---

## Contributing

Issues and PRs welcome — bug reports, new mode ideas, improvements.

## License

MIT
