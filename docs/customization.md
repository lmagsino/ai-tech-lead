# Customization

How to tune AI Tech Lead for your project and team.

---

## The Project Constitution (AI-TECH-LEAD.md)

The most important customization. AI Tech Lead loads this file on every invocation.

The fastest way to create it:

```
/start
```

She'll ask what you're building and who you are, then generate the file automatically.

Or copy the template manually:

```bash
cp /path/to/ai-tech-lead/AI-TECH-LEAD.md.template ./AI-TECH-LEAD.md
```

### What goes in AI-TECH-LEAD.md

**For founders:**

```markdown
## About you
Role: founder
Technical level: non-technical

## Project
Name: DentAI
Description: AI scheduling tool for independent dental practices
Stage: idea
```

That's enough. She'll adapt her language and recommend the right modes.

**For developers:**

```markdown
## About you
Role: developer
Technical level: technical

## Project
Name: DentAI
Description: AI scheduling tool for independent dental practices
Stage: building

## Stack
Language: TypeScript (Node 20)
Framework: Next.js 14
Database: PostgreSQL via Supabase
Testing: Vitest

## Rules
1. All AI prompts in src/ai/prompts/ — never inlined
2. No direct database queries in API routes — use repository layer
```

The more context you give, the more specific her suggestions will be. But you can start minimal and add over time.

---

## lessons.md

AI Tech Lead reads `lessons.md` from your project root on every invocation. This file captures project-specific knowledge that's hard to derive from code alone.

You can create and edit it manually:

```markdown
# Lessons

## Auth
- The JWT middleware checks expiry but not token revocation — check the cache separately
- Changing session TTL requires updating both JWT expiry and Redis TTL

## Payments
- Stripe webhook handler is idempotent — duplicate events are safe
- Never mock Stripe in integration tests — use their test mode

## Database
- The users table has a full-text search index on email — avoid LIKE queries
- Migrations on the orders table take 10+ minutes in prod — plan maintenance windows
```

---

## Customizing Guard Severity

If your project has different severity standards, document them in AI-TECH-LEAD.md under Rules:

```
## Rules
6. GUARD: treat missing pagination as CRITICAL (not HIGH) — our datasets are large
7. GUARD: console.log in production code is HIGH (not MEDIUM) — strict log hygiene
```

---

## Customizing Templates

Templates in `templates/` control the structure of output documents. Edit them to fit your team:

| Template | Used by | Common customizations |
|----------|---------|----------------------|
| `templates/strategy.md` | `/strategy` | Add industry-specific sections |
| `templates/design.md` | `/design` | Add accessibility requirements |
| `templates/roadmap.md` | `/roadmap` | Add timeline columns for sprints |
| `templates/spec.md` | `/blueprint` | Add QA notes, analytics events, rollout plan |
| `templates/rca.md` | `/hunt` | Add incident severity classification |
| `templates/scorecard.md` | `/guard` | Add custom review passes |

---

## Adding Custom References

Add your own reference documents and instruct modes to load them via AI-TECH-LEAD.md:

```
## Rules
8. When running /guard, also load references/our-api-conventions.md
```

Example custom references:
- `references/our-api-conventions.md` — your API design standards
- `references/our-data-model.md` — domain model documentation
- `references/our-testing-standards.md` — how your team writes tests

---

## Disabling Modes

If certain modes don't fit your workflow:

```
## Rules
9. Do not use /roadmap — we track priorities in Linear
10. Do not use /challenge for tickets already approved by product
```

---

## Platform Notes

### Claude Code

AI Tech Lead works as a Claude Code skill. The `SKILL.md` frontmatter triggers auto-detection — she'll pick the right mode based on what you say, even without a slash command.

To require explicit invocation only:
```
## Rules
11. Only invoke AI Tech Lead modes when explicitly asked with a slash command
```

### Codex / Cursor / Gemini CLI

On these platforms, AI Tech Lead works as a reference directory. Point your agent at AI-TECH-LEAD.md in your project root.

See [INSTALL.md](../INSTALL.md) for platform-specific setup.

---

## Minimal Setup

If you just want AI Tech Lead running without full customization:

```
/strategy "your idea here"
```

That's it. No setup step needed — just tell her what you're working on. She adapts based on context. You can optionally run `/start` later to create a detailed project file.
