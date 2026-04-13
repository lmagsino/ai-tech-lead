# AI TECH LEAD — Customization Guide

How to tune AI TECH LEAD for your project.

---

## The Project Constitution (AI-TECH-LEAD.md)

The most important customization is creating `AI-TECH-LEAD.md` in your project root. This is the hot tier — AI TECH LEAD loads it on every invocation.

Copy `AI-TECH-LEAD.md.template` to your project root and fill it in:

```bash
cp /path/to/ai-tech-lead/AI-TECH-LEAD.md.template ./AI-TECH-LEAD.md
```

### What to put in AI-TECH-LEAD.md

**Stack** — What you're running on. AI TECH LEAD adjusts its suggestions based on your language, framework, and database.
```
## Stack
Language: TypeScript (Node 20)
Framework: Express.js
Database: PostgreSQL 15
ORM: Prisma
Testing: Vitest + Supertest
Infrastructure: AWS (ECS, RDS, S3)
```

**Architecture** — Where things live. Helps AI TECH LEAD scan the right places.
```
## Architecture
Monorepo. Services in services/, shared code in packages/.
API gateway in services/api/. Auth service in services/auth/.
Frontend in apps/web/ (Next.js).
```

**Rules** — Only the rules the agent gets wrong without being told. Don't list obvious things.
```
## Rules
1. Never import from services/ into packages/ — packages are shared, services are not
2. All new API endpoints require an OpenAPI annotation
3. Database migrations go in db/migrations/ and must be backward-compatible
4. No direct database queries in controllers — use repository layer
5. Feature flags are in config/features.ts — check before adding conditional logic
```

**How to verify** — Exact commands to run tests, lint, and type check.
```
## How to verify
Tests: npm test
Lint: npm run lint
Types: npm run typecheck
Dev server: npm run dev (port 3000)
DB migrations: npm run db:migrate
```

**Team conventions** — Branch naming, commit format, PR process.
```
## Team conventions
Branches: feature/[ticket-id]-[description]
Commits: conventional commits (feat, fix, refactor, chore)
PR: requires 1 approval + passing CI
```

---

## lessons.md

AI TECH LEAD accumulates project-specific knowledge in `lessons.md` at your project root. This file is updated by `/retro` and read on every invocation.

You can also edit it manually to pre-seed knowledge:

```markdown
# Lessons

## Auth
- The JWT middleware checks expiry but not token revocation — check the revocation cache separately
- Changing session TTL requires updating both the JWT expiry and the Redis TTL

## Payments
- The Stripe webhook handler is idempotent — duplicate events are safe, but test with ngrok locally
- Never mock Stripe in integration tests — use their test mode with real API calls

## Database
- The users table has a full-text search index on email — avoid LIKE queries, use to_tsquery
- Migrations on the orders table take 10+ minutes in prod due to table size — plan maintenance windows
```

---

## Customizing Guard Severity

If your project has different severity standards, document them in AI-TECH-LEAD.md under Rules:

```
## Rules
...
6. GUARD: treat missing pagination as CRITICAL (not HIGH) — our datasets are large
7. GUARD: console.log in production code is HIGH (not MEDIUM) — we have strict log hygiene
```

AI TECH LEAD will apply your project-specific severity adjustments during guard passes.

---

## Customizing Spec Templates

If `templates/spec.md` doesn't fit your team's workflow, edit it directly. Common customizations:

- Add a **QA notes** section for your QA team
- Add a **Analytics events** section for product tracking
- Add a **Rollout plan** section for gradual feature flags
- Remove sections that don't apply (e.g., remove API changes if your project is frontend-only)

The template is yours to own.

---

## Adding Project-Specific Reference Documents

You can add your own reference documents to the `references/` directory and instruct modes to load them via AI-TECH-LEAD.md:

```
## Rules
8. When running /review, also load references/our-api-conventions.md
```

Example custom references:
- `references/our-api-conventions.md` — your API design standards
- `references/our-data-model.md` — domain model documentation
- `references/our-testing-standards.md` — how your team writes tests

---

## Platform-Specific Notes

### Claude Code

AI TECH LEAD works as a Claude Code skill. The `SKILL.md` frontmatter description triggers AI TECH LEAD automatically on relevant queries — you don't always need to type `/ai-tech-lead`.

To suppress auto-triggering and only use explicit invocation:
```
## Rules
9. Only invoke AI TECH LEAD modes when explicitly asked with /ai-tech-lead
```

### Codex / Cursor / Gemini CLI

On these platforms, AI TECH LEAD works as a reference directory. Point your agent at AI-TECH-LEAD.md in your project root:

```
Context files: AI-TECH-LEAD.md, lessons.md
Reference dir: /path/to/ai-tech-lead/
```

See `INSTALL.md` for platform-specific setup.

---

## Disabling Modes

If certain modes don't fit your workflow, note that in AI-TECH-LEAD.md:

```
## Rules
10. Do not use /qa — we have a dedicated visual QA process
11. Do not use /scope for tickets that have already been approved by product
```

---

## Minimal Setup (If You're in a Hurry)

If you just want AI TECH LEAD running without full customization:

1. Copy `AI-TECH-LEAD.md.template` → `AI-TECH-LEAD.md` in your project root
2. Fill in Stack and How to verify (minimum viable config)
3. Run: `/ai-tech-lead retro --last 30d` to generate an initial `lessons.md`

The rest can be refined over time.
