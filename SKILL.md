---
name: athena
description: >
  Spec-driven engineering intelligence. Use ATHENA for any software development task:
  building features, investigating bugs, reviewing code quality, modernizing legacy code,
  writing specifications, visual QA, or challenging product direction. Works on both
  greenfield and existing codebases. Activate with /athena followed by a mode name.
  Modes: challenge, spec, forge, investigate, guard, vision, evolve, patch, retro.
  Use this skill whenever the user mentions planning a feature, writing a spec,
  building something, reviewing code, debugging, refactoring, investigating a bug,
  or questioning whether something should be built. Even if they don't say "athena."
---

# ATHENA

## Beliefs

1. Specs before code
2. Evidence before conclusions
3. Behavior tests before implementation
4. Blast radius before committing
5. Patterns over incidents

---

## Context architecture

**Hot tier** (always load if present):
- Read `ATHENA.md` from the project root — project constitution, rules, stack, conventions
- Read `lessons.md` from the project root — accumulated learnings from past retros
- Read the active spec file if one is referenced in the user's message

**Warm tier** (load per-mode when invoked):
- Each mode file specifies which `references/` files it needs — load only those

**Cold tier** (on-demand via subagents):
- Codebase scanning, git history analysis, dependency mapping, file search
- Use subagents for these — never block the main context with large file dumps

---

## Modes

| Mode | Invoke when | File |
|------|-------------|------|
| **challenge** | "Should we build this?" / product direction / scope question | modes/challenge.md |
| **spec** | "Write a spec" / feature description / requirements | modes/spec.md |
| **forge** | "Build this" / implement / create feature | modes/forge.md |
| **investigate** | "There's a bug" / error / production issue / incident | modes/investigate.md |
| **guard** | "Review this code" / PR review / code quality | modes/guard.md |
| **vision** | "Check the UI" / visual test / does it look right | modes/vision.md |
| **evolve** | "Refactor" / modernize / migrate / upgrade | modes/evolve.md |
| **patch** | "Quick fix" / typo / config change / small update | modes/patch.md |
| **retro** | "What did we learn" / retrospective / health check | modes/retro.md |

---

## Auto-detection

When the user does not specify a mode, select automatically:

- User describes a bug, error, or incident → `/investigate`
- User asks "should we" or questions value/scope → `/challenge`
- User says "fix" and the change is clearly trivial → `/patch`
- User asks to review code or a PR → `/guard`
- User describes a feature to build → check if a spec exists. If yes → `/forge`. If no → `/spec`
- User asks to refactor or modernize → `/evolve`
- Ambiguous → ask the user which mode to use

---

## Invocation

When a mode is invoked:

1. Load the mode file from `modes/[mode].md`
2. Load the warm-tier references listed in that mode file
3. Follow the workflow defined in the mode file exactly
4. Produce the output artifacts defined in the mode file

---

## Usage

```
/athena challenge "Add real-time notifications"
/athena spec "User authentication with OAuth"
/athena forge specs/auth.md
/athena guard src/controllers/
/athena guard src/controllers/ --against specs/auth.md
/athena investigate "checkout fails for EU users"
/athena vision http://localhost:3000
/athena evolve src/legacy/
/athena patch "fix typo in error message"
/athena retro --last 7d
```
