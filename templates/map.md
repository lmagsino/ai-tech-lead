# Codebase Map: [Project Name]

> Generated: [date]
> Mapped by: ATHENA /map
> Scope: [full codebase | module name]

## Overview

[One paragraph: what this system does, who uses it, at what scale. Written for a new engineer.]

## Stack

| Layer | Technology |
|-------|-----------|
| Language | [e.g., TypeScript (Node 20)] |
| Framework | [e.g., Express, Next.js] |
| Database | [e.g., PostgreSQL + Redis] |
| Infrastructure | [e.g., AWS ECS, Vercel] |
| Testing | [e.g., Vitest + Supertest] |

## Structure

[Top-level directory layout with one-line descriptions]

```
[project]/
├── [dir]/     — [responsibility]
├── [dir]/     — [responsibility]
└── [dir]/     — [responsibility]
```

## Entry points

| Entry point | File | Handles |
|-------------|------|---------|
| [e.g., HTTP API] | [path] | [what it receives] |
| [e.g., Background worker] | [path] | [what it processes] |

## Module map

| Module | Path | Responsibility |
|--------|------|---------------|
| [name] | [path] | [one sentence] |
| [name] | [path] | [one sentence] |

## Key data flow

[Trace one representative request end-to-end]

```
[Entry] → [Step] → [Step] → [Step] → [Data layer] → [Response]
```

[Step-by-step description of what happens at each stage]

## Patterns

| Concern | Pattern | Where |
|---------|---------|-------|
| Error handling | [e.g., thrown exceptions, caught at controller] | [file] |
| Authentication | [e.g., JWT middleware] | [file] |
| Database access | [e.g., Repository pattern, Prisma] | [path] |
| Configuration | [e.g., env vars via dotenv] | [file] |
| Testing | [e.g., Vitest, tests colocated in __tests__/] | [path] |

## Hotspots

Files that change most frequently — highest complexity and coordination cost.

| File | Churn (90d) | Why it matters |
|------|-------------|---------------|
| [path] | [N commits] | [what this file does] |

## Where to start

| Task | Starting point |
|------|---------------|
| Add an API endpoint | [file/directory] |
| Add a database table | [migration file/pattern] |
| Add a background job | [file/directory] |
| Write a test | [example test file] |
| Fix a bug in [area] | [likely files] |
