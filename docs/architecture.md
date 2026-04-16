# Architecture

## Overview

AI Tech Lead is a set of structured modes for AI coding agents. It is not a library or framework — no runtime, no dependencies. Just structured knowledge and workflows that guide agent behavior.

It serves three personas (founders, developers, technical founders) through 11 modes that adapt their language and depth based on who's using them.

---

## Persona Layer

Every mode checks `AI-TECH-LEAD.md` for the user's role and adapts:

| Role | Language | Modes they typically use |
|------|----------|------------------------|
| Founder (non-technical) | Plain language, business context, no jargon | start, strategist, designer, roadmap, review |
| Developer | File paths, line numbers, token counts | start, challenge, blueprint, forge, guard, hunt, launch |
| Tech founder / CTO | Both, depending on mode | All |

Dev-only modes (forge, guard, hunt) redirect non-technical users to hand off to a developer instead of proceeding.

---

## Three-Tier Context Architecture

AI Tech Lead uses a tiered context system to keep agents focused and context windows efficient.

### Hot Tier (always loaded)

Files the agent loads on every invocation:

| File | Purpose |
|------|---------|
| `AI-TECH-LEAD.md` | Project constitution — role, stack, rules, conventions |
| `lessons.md` | Accumulated project learnings (if present) |
| Active spec | The spec referenced in the current task (if any) |

These files live in the **project root** (not in the AI Tech Lead installation). They are project-specific.

### Warm Tier (loaded per-mode)

Reference documents loaded only when a specific mode is invoked. Each mode file declares which references it needs.

| Mode | References loaded |
|------|------------------|
| `/start` | None |
| `/strategist` | None |
| `/designer` | `templates/design.md` |
| `/roadmap` | None (reads STRATEGY.md and DESIGN.md from hot tier) |
| `/review` | None |
| `/challenge` | None |
| `/blueprint` | `templates/spec.md` |
| `/forge` | `references/clean-code.md`, `references/solid-principles.md`, `references/ai-patterns.md` |
| `/guard` | `references/solid-principles.md`, `references/code-smells.md`, `references/anti-patterns.md`, `references/security-owasp.md`, `references/engineering-checklist.md`, `references/ai-patterns.md`, `templates/scorecard.md` |
| `/hunt` | `templates/rca.md`, `references/ai-patterns.md` |
| `/launch` | `references/security-owasp.md`, `references/ai-patterns.md` |

This prevents context window bloat — `/start` doesn't need OWASP.

### Cold Tier (on-demand via subagents)

Heavy operations that should not block the main context:

- Codebase scanning (file search, dependency mapping)
- Git history analysis
- Competitive research (for /strategist)
- Large file reads across many files

Subagents perform these tasks and return summaries.

---

## File Structure

```
ai-tech-lead/
├── SKILL.md                          # Main entry — identity, routing, auto-detection
├── AI-TECH-LEAD.md.template          # Template for project constitution
├── README.md
├── INSTALL.md
├── LICENSE
├── setup.sh                          # Auto-installer (multi-platform)
│
├── modes/                            # One file per mode
│   ├── start.md                      # Onboarding — creates AI-TECH-LEAD.md
│   ├── strategist.md                 # Idea validation + tech feasibility
│   ├── designer.md                   # Product design + UX architecture
│   ├── roadmap.md                    # MVP prioritization + developer handoff
│   ├── review.md                     # Requirements/plans/proposals review
│   ├── challenge.md                  # Feature challenge (GO/RETHINK/KILL)
│   ├── blueprint.md                  # Spec writing with AI components
│   ├── forge.md                      # Implementation (tests first, AI first)
│   ├── guard.md                      # 5-pass code review
│   ├── hunt.md                       # Bug investigation + RCA
│   └── launch.md                     # Pre-launch checklist (GO/NO-GO)
│
├── references/                       # Knowledge base (warm tier)
│   ├── clean-code.md
│   ├── solid-principles.md
│   ├── code-smells.md
│   ├── anti-patterns.md
│   ├── security-owasp.md
│   ├── design-patterns.md
│   ├── ai-patterns.md
│   └── engineering-checklist.md
│
├── templates/                        # Output templates
│   ├── strategy.md
│   ├── design.md
│   ├── roadmap.md
│   ├── spec.md
│   ├── rca.md
│   ├── scorecard.md
│   └── eval-starter.md
│
├── docs/
│   ├── getting-started.md
│   ├── workflows.md
│   ├── architecture.md               # This file
│   └── customization.md
│
└── examples/
    └── AI-TECH-LEAD.example.md
```

---

## Mode Lifecycle

```
User invokes mode (or auto-detected from natural language)
       ↓
SKILL.md routes to modes/[mode].md
       ↓
Mode checks persona in AI-TECH-LEAD.md
  - Adapts language (plain vs technical)
  - Redirects if wrong persona (e.g., founder → /forge)
       ↓
Mode file loads:
  - Hot tier (AI-TECH-LEAD.md, lessons.md if present)
  - Warm tier references (as specified by mode)
       ↓
Mode workflow executes
  - Subagents handle cold tier tasks
  - Human checkpoints at key decision points
       ↓
Output artifacts produced
  - Files saved to project (STRATEGY.md, specs/, etc.)
  - Reports printed in conversation
  - "Generated with AI Tech Lead" footer on shared documents
```

---

## Design Principles

**Persona-aware.** Every mode adapts to the user. Same rigor, different language.

**Spec first.** Every non-trivial implementation is preceded by a specification. Vague requests produce contested code.

**Evidence before conclusions.** Recommendations are backed by specific data — file paths, dollar figures, competitor names — not impressions.

**Artifacts are the handoff.** STRATEGY.md, DESIGN.md, ROADMAP.md, specs/ — these documents bridge personas. A founder's strategy becomes a developer's blueprint.

**Hard stops are non-negotiable.** No spec = no build. No fallback = no approval. CRITICAL = blocks merge. These exist because speed without discipline is debt.

**Incremental by default.** Each mode produces one artifact, gets approval, then hands off. Every step is verified before the next begins.
