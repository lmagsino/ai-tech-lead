---
name: athena
description: >
  Spec-driven engineering intelligence. Use ATHENA for any software development task:
  building features, investigating bugs, reviewing code quality, modernizing legacy code,
  writing specifications, visual QA, or challenging product direction. Works on both
  greenfield and existing codebases. Activate with /athena followed by a mode name.
  Modes: scope, spec, build, debug, review, qa, refactor, fix, retro, map, adr.
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
| **scope** | "Should we build this?" / product direction / feasibility | modes/scope.md |
| **spec** | "Write a spec" / feature description / requirements | modes/spec.md |
| **build** | "Build this" / implement / create feature | modes/build.md |
| **debug** | "There's a bug" / error / production issue / incident | modes/debug.md |
| **review** | "Review this code" / PR review / code quality | modes/review.md |
| **qa** | "Check the UI" / visual test / does it look right | modes/qa.md |
| **refactor** | "Refactor" / modernize / migrate / upgrade | modes/refactor.md |
| **fix** | "Quick fix" / typo / config change / small update | modes/fix.md |
| **retro** | "What did we learn" / retrospective / health check | modes/retro.md |
| **map** | "Explain this codebase" / new contributor / where to start | modes/map.md |
| **adr** | "Document this decision" / why we chose X / ADR | modes/adr.md |

---

## Auto-detection

When the user does not specify a mode, select automatically:

- User describes a bug, error, or incident → `/debug`
- User asks "should we" or questions value/scope → `/scope`
- User says "fix" and the change is clearly trivial → `/fix`
- User asks to review code or a PR → `/review`
- User describes a feature to build → check if a spec exists. If yes → `/build`. If no → `/spec`
- User asks to refactor or modernize → `/refactor`
- User is new to the codebase or asks how it works → `/map`
- User wants to document a technical decision → `/adr`
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
/athena scope "Add real-time notifications"
/athena spec "User authentication with OAuth"
/athena build specs/auth.md
/athena review src/controllers/
/athena review src/controllers/ --against specs/auth.md
/athena debug "checkout fails for EU users"
/athena qa http://localhost:3000
/athena refactor src/legacy/
/athena fix "fix typo in error message"
/athena retro --last 7d
/athena map
/athena map src/payments/
/athena adr "chose PostgreSQL over MongoDB"
```
