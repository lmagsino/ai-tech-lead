# ATHENA

**Spec-driven engineering intelligence for AI coding agents.**

ATHENA is a set of nine intelligent modes (slash commands) that guide AI coding agents through the full software development lifecycle — from challenging product direction to writing specs, implementing features, reviewing code, investigating bugs, and running retrospectives.

Works with Claude Code, Codex, Cursor, Gemini CLI, and OpenCode.

---

## What it does

| Mode | Invoke when | What it produces |
|------|------------|-----------------|
| `/challenge` | "Should we build this?" | GO / RETHINK / KILL recommendation with reasoning |
| `/spec` | "Write a spec" | Approved specification saved to `specs/[name].md` |
| `/forge` | "Build this" | Implementation with tests, clean code gate |
| `/investigate` | "There's a bug" | Root cause analysis, scoped fix, RCA document |
| `/guard` | "Review this code" | 5-pass scorecard with severity-ranked findings |
| `/vision` | "Check the UI" | Multi-viewport screenshots, a11y check, flow walkthrough |
| `/evolve` | "Refactor this" | Behavior-tested incremental migration |
| `/patch` | "Quick fix" | Scoped fix, committed, done |
| `/retro` | "What did we learn?" | Lessons updated, tech debt roadmap |

---

## Five beliefs

1. **Specs before code** — Vague requests produce contested implementations.
2. **Evidence before conclusions** — Root causes, not symptoms.
3. **Behavior tests before implementation** — Tests as documentation.
4. **Blast radius before committing** — Map the impact before touching anything.
5. **Patterns over incidents** — Retrospectives surface structural causes.

---

## Install

```bash
git clone https://github.com/[your-org]/athena.git
cd athena
./setup.sh
```

`setup.sh` detects your platform and installs automatically. See [INSTALL.md](INSTALL.md) for manual setup.

---

## Quick start

**1. Create your project constitution**
```bash
cp /path/to/athena/ATHENA.md.template ./ATHENA.md
# Edit: stack, architecture, rules, test commands
```

**2. Initialize project knowledge**
```
/athena retro --last 30d
```

**3. Use it**
```
/athena challenge "Add real-time notifications"
/athena spec "User authentication with OAuth"
/athena forge specs/auth.md
/athena guard src/controllers/
/athena investigate "checkout fails for EU users"
/athena retro --last 7d
```

---

## How it works

ATHENA uses a **three-tier context architecture**:

- **Hot tier** — `ATHENA.md` (your project constitution) and `lessons.md` are loaded on every invocation
- **Warm tier** — Each mode loads only the reference documents it needs (clean code, SOLID, security, etc.)
- **Cold tier** — Subagents handle codebase scanning, git history, and dependency mapping on demand

This keeps agent context efficient. `/patch` doesn't need SOLID principles. `/guard` doesn't need to scan your entire codebase.

---

## Reference library

ATHENA ships with seven reference documents:

- `references/clean-code.md` — Clean Code principles (naming, functions, error handling, DRY, YAGNI)
- `references/solid-principles.md` — SOLID with violation examples and corrected code
- `references/code-smells.md` — 23 smells with detection signals and severity ratings
- `references/anti-patterns.md` — N+1, race conditions, memory leaks, missing timeouts, and more
- `references/security-owasp.md` — OWASP Top 10 (2021) with code patterns and fixes
- `references/engineering-checklist.md` — Correctness, concurrency, performance, reliability, observability, maintainability
- `references/design-patterns.md` — When to use Strategy, Observer, Factory, Adapter, Repository, Builder, Decorator

---

## Guard: 5-pass code review

`/guard` runs five passes and produces a severity-ranked scorecard:

1. **Structural integrity** — SOLID principles
2. **Code smells & anti-patterns** — 23 smells + N+1, race conditions, missing timeouts, etc.
3. **Security** — OWASP Top 10, hardcoded secrets, missing auth checks
4. **Clean code** — Naming, function size, DRY, YAGNI, error handling
5. **Spec conformance** — (if `--against spec.md`) — acceptance criteria pass/fail

Every finding includes: severity, `file:line`, description, and a concrete fix recommendation.

---

## Customization

Edit `ATHENA.md` in your project root to tune ATHENA:
- Add project-specific rules
- Set severity overrides for guard
- Document your stack and test commands
- Add lessons to `lessons.md` manually

See [docs/customization.md](docs/customization.md) for the full guide.

---

## Architecture

See [docs/architecture.md](docs/architecture.md) for the full design.
See [docs/workflows.md](docs/workflows.md) for standard greenfield and brownfield workflows.

---

## License

MIT — do whatever you want with it.
