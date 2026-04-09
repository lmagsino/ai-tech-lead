# ATHENA — Architecture

## Overview

ATHENA is a spec-driven engineering workflow for AI coding agents. It is structured as a set of files that a coding agent reads — not a library, not a framework. No runtime. No dependencies. Just structured knowledge and workflows that guide agent behavior.

---

## Three-Tier Context Architecture

ATHENA uses a tiered context system to keep agents focused and context windows efficient.

### Hot Tier (always loaded)

Files the agent loads on every invocation:

| File | Purpose |
|------|---------|
| `ATHENA.md` | Project constitution — stack, rules, conventions, verification commands |
| `lessons.md` | Accumulated learnings from past retros — project-specific institutional memory |
| Active spec | The spec referenced in the current task, if any |

These files live in the **project root** (not in the ATHENA installation). They are project-specific.

### Warm Tier (loaded per-mode)

Reference documents loaded only when a specific mode is invoked. Each mode file declares which references it needs.

| Mode | References loaded |
|------|------------------|
| `/scope` | None |
| `/spec` | `templates/spec.md` |
| `/build` | `references/clean-code.md`, `references/solid-principles.md` |
| `/debug` | `templates/rca.md` |
| `/review` | `references/solid-principles.md`, `references/code-smells.md`, `references/anti-patterns.md`, `references/security-owasp.md`, `references/engineering-checklist.md`, `templates/scorecard.md` |
| `/qa` | Active spec (for UI criteria) |
| `/refactor` | `references/clean-code.md`, `references/design-patterns.md` |
| `/fix` | None |
| `/retro` | `templates/retro-report.md` |

This prevents context window bloat — `/fix` doesn't need SOLID principles.

### Cold Tier (on-demand via subagents)

Heavy operations that should not block the main context:

- Codebase scanning (file search, dependency mapping)
- Git history analysis
- Large file reads across many files
- External documentation fetch

Subagents perform these tasks and return summaries. The main agent never dumps large file collections into its own context.

---

## File Structure

```
athena/
├── SKILL.md                          # Main entry point — routing table, auto-detection
├── ATHENA.md.template                # Template users copy to their project root
├── README.md                         # GitHub documentation
├── INSTALL.md                        # Platform-specific setup instructions
├── LICENSE                           # MIT license
├── setup.sh                          # Auto-installer
│
├── modes/                            # One file per mode (warm tier — loaded on invocation)
│   ├── challenge.md                  # Product/design/engineering challenge
│   ├── spec.md                       # Specification writing
│   ├── forge.md                      # Implementation with clean code gate
│   ├── investigate.md                # Bug investigation and RCA
│   ├── guard.md                      # Code review (5-pass scorecard)
│   ├── vision.md                     # Visual QA with browser
│   ├── evolve.md                     # Incremental modernization
│   ├── patch.md                      # Trivial fixes
│   └── retro.md                      # Engineering retrospective
│
├── references/                       # Knowledge base (warm tier — loaded per-mode)
│   ├── clean-code.md                 # Clean Code principles
│   ├── solid-principles.md           # SOLID with examples
│   ├── code-smells.md                # 23 smells with detection signals
│   ├── anti-patterns.md              # Performance and stability anti-patterns
│   ├── security-owasp.md             # OWASP top 10 + additional checks
│   ├── design-patterns.md            # Practical pattern guide
│   └── engineering-checklist.md      # Comprehensive review checklist
│
├── templates/                        # Output templates (used by modes)
│   ├── spec.md                       # Specification document
│   ├── rca.md                        # Root Cause Analysis
│   ├── scorecard.md                  # Guard review scorecard
│   ├── visual-report.md              # Vision QA report
│   └── retro-report.md              # Retrospective report
│
└── docs/                             # Documentation
    ├── architecture.md               # This file
    ├── workflows.md                  # Greenfield and brownfield workflows
    └── customization.md              # How to tune ATHENA for your project
```

---

## Mode Lifecycle

```
User invokes mode
       ↓
SKILL.md routes to modes/[mode].md
       ↓
Mode file loads:
  - Hot tier (ATHENA.md, lessons.md if present)
  - Warm tier references (as specified by mode)
       ↓
Mode workflow executes
  - Subagents handle cold tier tasks
  - Human checkpoints at key decision points
       ↓
Output artifacts produced
  - Files saved to project
  - Reports printed in conversation
```

---

## Design Principles

**Spec first.** Every non-trivial implementation is preceded by a specification. Vague requests produce contested code.

**Evidence before conclusions.** Diagnoses and recommendations are backed by specific file paths and line numbers, not impressions.

**Blast radius awareness.** Before any change, the affected scope is mapped. Surprises are caught at planning time, not production time.

**Incremental by default.** /refactor never rewrites; it migrates. /build builds one task at a time. Every step is verified before the next begins.

**Patterns over incidents.** /retro surfaces systemic causes. /debug produces RCA documents. Individual bugs become institutional learning.
