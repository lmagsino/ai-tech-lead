# AI TECH LEAD — Project Constitution
# Example: AI-powered customer support platform

> This is a filled example showing what a complete AI-TECH-LEAD.md looks like.
> Copy AI-TECH-LEAD.md.template to your project root and fill it in for your own project.

---

## Project

**Name:** Helpdesk AI
**Description:** AI-native customer support platform that resolves tickets automatically and escalates to humans when needed.
**Stage:** MVP

---

## Stack

- **Language:** TypeScript (strict mode)
- **Frontend:** Next.js 14 (App Router), Tailwind CSS, shadcn/ui
- **Backend:** Next.js API routes + tRPC
- **Database:** PostgreSQL via Supabase (pgvector enabled for semantic search)
- **Auth:** Clerk (organizations + roles: admin, agent, viewer)
- **Infrastructure:** Vercel (frontend + API), Supabase (DB + storage), Resend (email)
- **Package manager:** pnpm

---

## AI components

- **LLM:** Anthropic Claude via `@anthropic-ai/sdk` — `claude-sonnet-4-6` for resolution, `claude-haiku-4-5` for classification
- **Embeddings:** `text-embedding-3-small` (OpenAI) — used to embed support tickets and knowledge base articles
- **Vector store:** pgvector on Supabase — `ticket_embeddings` and `kb_embeddings` tables
- **Prompt location:** `src/ai/prompts/` — `classify.ts`, `resolve.ts`, `summarize.ts`, `suggest-reply.ts`
- **Output schemas:** `src/ai/schemas/` — `ClassificationSchema`, `ResolutionSchema`, `SuggestionSchema`
- **AI client:** `src/ai/client.ts` — singleton Anthropic client, 30s timeout, 3 retries with exponential backoff
- **Evals:** `src/ai/evals/` — `classify.eval.ts`, `resolve.eval.ts`
- **RAG pipeline:** `src/ai/rag/` — chunk, embed, retrieve, re-rank before passing to resolution prompt

---

## Architecture

- Next.js monorepo — frontend and API in one repo under `src/`
- AI pipeline: ticket arrives → classify → retrieve KB context → attempt resolution → confidence check → auto-resolve or escalate
- All AI calls go through `src/ai/client.ts` — never call Anthropic directly in route handlers
- Supabase Realtime for live ticket updates to agent dashboard
- Webhook receiver for email-to-ticket (Resend inbound)

---

## Rules

1. All prompts in `src/ai/prompts/` — never inline prompt strings in route handlers or components
2. All AI outputs validated against Zod schema before use — `ClassificationSchema.parse(result)` not `result as Classification`
3. Every AI endpoint has: 30s timeout, 20 req/min rate limit per user, fallback to manual queue
4. Strip PII from ticket content before sending to classification prompt (names, emails, phone numbers)
5. TypeScript strict — no `any`, no `as unknown as`
6. Agent dashboard is server-rendered — client components only for real-time updates
7. Confidence threshold: auto-resolve only if resolution confidence > 0.85, else escalate

---

## How to verify

```bash
pnpm test              # vitest
pnpm lint              # eslint
pnpm typecheck         # tsc --noEmit
pnpm dev               # next dev (port 3000)
pnpm db:migrate        # supabase db push
```

---

## Conventions

- **Branch naming:** `feature/`, `fix/`, `chore/`
- **Commit format:** Conventional Commits — `feat:`, `fix:`, `chore:`
- **Spec location:** `specs/` — one file per feature, approved before forge
- **Scope location:** `scopes/` — challenge outputs, one per feature evaluated
- **RCA location:** `docs/rca/` — one file per incident, date-prefixed
