# AI Tech Lead

A set of Claude Code modes I use to build AI-native products from scratch. Each mode is a specialist — one challenges whether something is worth building, one specs it, one builds it, one reviews it, one hunts bugs, one ships it.

Built for how I actually work: fast, greenfield, AI-first.

```
  PRODUCT THINKING                 ENGINEERING EXECUTION
  ─────────────────                ──────────────────────────────────────
  /strategist                      /challenge → /blueprint → /forge
  "Is this worth building?"        "Should we?" → "What exactly?" → "Build it"
       │
       ▼
  /designer                        /guard        /hunt        /launch
  "How should it work?"            "Is it solid?" "What broke?" "Ship it"

  Full workflow:
  /strategist → /designer → /challenge → /blueprint → /forge → /guard → /launch
```

---

## How I use it

Every new product or feature goes through the same sequence. The modes enforce it so I don't skip steps when I'm moving fast.

**New product idea**
```
/strategist "AI inventory tool for restaurants"
/designer
```

**New feature**
```
/challenge "Add real-time AI recommendations"
/blueprint scopes/recommendations.md
/forge specs/recommendations.md
/guard src/
/launch
```

**Something broke**
```
/hunt "AI responses are hallucinating product names"
```

---

## Install

```bash
git clone https://github.com/lmagsino/ai-tech-lead.git
cd ai-tech-lead
./setup.sh
```

Then copy the project constitution into your repo:
```bash
cp /path/to/ai-tech-lead/AI-TECH-LEAD.md.template ./AI-TECH-LEAD.md
# Fill in: stack, AI components, architecture decisions
```

---

## Modes

**Product thinking**

| Mode | Role | Produces |
|------|------|----------|
| `/strategist` | YC partner — challenges market, monetization, distribution | `STRATEGY.md` |
| `/designer` | UX architect — user journeys, AI interactions, screen specs | `DESIGN.md` |

**Engineering execution**

| Mode | Role | Produces |
|------|------|----------|
| `/challenge` | Challenges whether to build, AI-native alternatives | `scopes/[feature].md` |
| `/blueprint` | Specs the feature — AI components, fallbacks, cost estimate | `specs/[feature].md` |
| `/forge` | Builds from spec — AI infrastructure first, tests first | committed code |
| `/guard` | 5-pass review — structure, smells, security, clean code, AI | severity scorecard |
| `/hunt` | Hunts bugs — classifies, hypothesizes, traces, fixes | fix + RCA doc |
| `/launch` | Pre-launch checklist — functionality, AI, security, infra | GO / NO-GO |

---

## Hard stops

These block regardless of what I say. They exist because I've learned to trust them over my own impatience.

| Condition | Mode | Block |
|-----------|------|-------|
| No spec for a non-trivial feature | `/forge` | Won't build |
| AI component without fallback | `/blueprint` | Won't approve spec |
| AI component without cost estimate | `/blueprint` | Won't approve spec |
| CRITICAL or HIGH security finding | `/guard` | Blocks merge |
| Bug closed without regression test | `/hunt` | Won't close |
| CRITICAL finding before launch | `/launch` | NO-GO |

---

## AI-first defaults

Every mode defaults to AI-native patterns:

- **Anthropic SDK** — structured outputs, prompt caching, tool use
- **pgvector** — embeddings + vector search before building custom retrieval
- **Evals** — AI behavior tested like code behavior
- **Cost awareness** — token budgets in every design
- **Failure modes** — fallbacks and graceful degradation from the start

---

## Reference library

Loaded per-mode — only what each mode needs:

- `references/clean-code.md`
- `references/solid-principles.md`
- `references/code-smells.md`
- `references/anti-patterns.md`
- `references/security-owasp.md`
- `references/engineering-checklist.md`
- `references/design-patterns.md`
- `references/ai-patterns.md`

---

## Docs

- [Getting started](docs/getting-started.md)
- [Workflows](docs/workflows.md)
- [Architecture](docs/architecture.md)
- [Customization](docs/customization.md)
- [Install options](INSTALL.md)

---

## License

MIT
