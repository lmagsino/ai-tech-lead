# AI Engineering Patterns

Reference for building AI-native applications. Load this when reviewing AI code, designing AI components, or evaluating architecture decisions involving LLMs, embeddings, or agents.

---

## Model Selection

### Claude model family (Anthropic)

| Model | Use when | Avoid when |
|-------|----------|------------|
| `claude-haiku-4-5` | High-frequency calls, simple extraction, classification, real-time UX | Complex reasoning, nuanced generation |
| `claude-sonnet-4-6` | Default choice — balanced quality and cost | Pure speed/cost optimization needed |
| `claude-opus-4-6` | Complex multi-step reasoning, high-stakes generation, agentic tasks | Frequent calls, latency-sensitive UX |

**Rule:** Default to Sonnet. Downgrade to Haiku if the task is mechanical and volume is high. Upgrade to Opus only when Sonnet demonstrably fails.

### Model pinning

Always pin to a specific model version in production. Model aliases (`claude-sonnet-latest`) can introduce behavioral regressions when Anthropic updates them.

```typescript
// Bad — alias can change behavior silently
model: "claude-sonnet-latest"

// Good — explicit version, intentional upgrade path
model: "claude-sonnet-4-6"
```

---

## Prompt Engineering

### System prompt structure

A well-structured system prompt has three parts:
1. **Role** — who Athena is in this context
2. **Task** — what she's being asked to do
3. **Constraints** — what she must not do

```xml
<role>
You are a customer support specialist for Acme. You help users troubleshoot 
their accounts with empathy and precision.
</role>

<task>
Answer the user's question using the provided account context. 
If you cannot answer from the context, say so clearly.
</task>

<constraints>
- Never guess account details not present in the context
- Never make promises about refunds or credits
- Escalate to a human if the user expresses frustration twice
</constraints>
```

### Use XML tags for structure

Claude performs significantly better when inputs are structured with XML tags rather than plain prose or markdown. Use tags to delineate sections of context.

```xml
<user_message>{{ message }}</user_message>
<conversation_history>{{ history }}</conversation_history>
<account_context>{{ account }}</account_context>
```

### Few-shot examples

For tasks with a specific format or tone, provide 2-3 examples in the prompt. Examples outperform instructions for output format control.

```xml
<examples>
<example>
  <input>User asks about shipping delay</input>
  <output>I can see your order #12345 is currently in transit and expected 
  to arrive by Thursday. If it doesn't arrive by then, reply here and 
  I'll escalate immediately.</output>
</example>
</examples>
```

### Chain of thought

For reasoning tasks, instruct the model to think before answering. This dramatically reduces errors on multi-step logic.

```xml
Think through this step by step before giving your final answer.
Show your reasoning in <thinking> tags, then give your answer in <answer> tags.
```

### Prompt injection defense

Never interpolate raw user input directly into a system prompt. Use a structured messages array or sanitize and delimit user content.

```typescript
// Vulnerable — user can override system instructions
const prompt = `You are helpful. User said: ${userMessage}`

// Safe — user content is isolated in the messages array
const messages = [
  { role: "user", content: userMessage }
]
```

---

## Structured Outputs

### Always define a schema

Never parse free-text LLM output with regex or string splitting. Define a schema and use tool use or JSON mode to enforce it.

```typescript
// Define the schema
const ReplySchema = z.object({
  suggestions: z.array(z.string()).max(3),
  confidence: z.number().min(0).max(1),
  reasoning: z.string().optional()
})

// Use tool use to enforce it
const response = await client.messages.create({
  tools: [{
    name: "generate_reply",
    input_schema: zodToJsonSchema(ReplySchema)
  }],
  tool_choice: { type: "tool", name: "generate_reply" }
})
```

### Validate before use

Even with tool use, validate the output before trusting it. The model can still return unexpected shapes.

```typescript
const parsed = ReplySchema.safeParse(toolInput)
if (!parsed.success) {
  // Handle gracefully — fall back, log, alert
}
```

---

## RAG (Retrieval-Augmented Generation)

### When to use RAG

Use RAG when:
- The answer depends on data that changes frequently
- The data is too large to fit in context
- You need to cite sources or reference specific documents
- Fine-tuning is too expensive or inflexible

Do not use RAG when:
- The answer can be derived from reasoning alone
- The data is small and stable enough to fit in the system prompt
- Retrieval latency is unacceptable for the UX

### Chunking strategy

| Content type | Chunk strategy |
|-------------|----------------|
| Documents / articles | Recursive character splitting, 512-1024 tokens, 10-20% overlap |
| Code | Split by function or class boundary — never mid-function |
| Structured data | Embed row summaries, not raw JSON |
| Conversations | Embed per-message or per-turn, preserve speaker context |

### Embedding models

| Model | Use when |
|-------|----------|
| `text-embedding-3-small` (OpenAI) | Default — good quality, low cost |
| `text-embedding-3-large` (OpenAI) | Higher accuracy needed, cost acceptable |
| `voyage-3` (Voyage AI) | Code-heavy retrieval — outperforms OpenAI on code |

### Retrieval quality

Raw vector similarity is often insufficient. Apply these in order:
1. **Top-k retrieval** — fetch more candidates than needed (k=10-20)
2. **Re-ranking** — use a cross-encoder to re-rank candidates by relevance
3. **Metadata filtering** — filter by user, date, category before vector search
4. **Hybrid search** — combine vector similarity with BM25 keyword search for better recall

### pgvector (Postgres)

Default choice for startup-scale RAG. No separate vector DB needed.

```sql
-- Enable extension
CREATE EXTENSION vector;

-- Store embeddings
ALTER TABLE documents ADD COLUMN embedding vector(1536);

-- Similarity search
SELECT id, content, embedding <=> $1 AS distance
FROM documents
ORDER BY distance
LIMIT 10;
```

---

## Agent Patterns

### When to use agents

Use an agent when a task requires:
- Multiple sequential steps where each step depends on the previous result
- Dynamic tool selection based on intermediate results
- Loops or retries based on outcome (e.g. generate → verify → regenerate)

Do not use agents when:
- A single LLM call with structured output solves the problem
- The steps are fixed and known upfront (use a pipeline instead)
- Latency is critical — agents are slow

### Tool design

Tools should be:
- **Atomic** — one clear action per tool
- **Idempotent** where possible — safe to call twice
- **Descriptive** — the name and description must be unambiguous to the model

```typescript
{
  name: "search_knowledge_base",
  description: "Search the product knowledge base for relevant articles. " +
    "Use this when the user asks about product features, pricing, or policies.",
  input_schema: {
    type: "object",
    properties: {
      query: { type: "string", description: "The search query" },
      max_results: { type: "number", default: 5 }
    },
    required: ["query"]
  }
}
```

### Orchestrator + subagent pattern

For complex multi-step tasks, use an orchestrator agent that plans and delegates to specialized subagents. The orchestrator never does work directly — it only coordinates.

```
Orchestrator
├── Calls: research_agent (retrieves context)
├── Calls: writer_agent (generates content)
└── Calls: review_agent (checks quality)
```

### Agent loop safety

Always set hard limits on agent loops:
- Max iterations (e.g. 10)
- Max total tokens consumed
- Timeout (e.g. 60s)
- Human-in-the-loop checkpoint for irreversible actions

```typescript
const MAX_ITERATIONS = 10
let iterations = 0

while (shouldContinue && iterations < MAX_ITERATIONS) {
  // agent step
  iterations++
}

if (iterations >= MAX_ITERATIONS) {
  // surface to user — don't fail silently
}
```

---

## Evals

### What to eval

Evals test your **integration**, not the model. You are not testing whether Claude is smart — you are testing whether your prompt, schema, and logic produce the right output for your specific use case.

### Eval types

| Type | What it checks | When to use |
|------|---------------|-------------|
| **Assertion-based** | Output matches expected schema or contains required fields | Always — basic sanity check |
| **Regression** | A known-bad input no longer produces a known-bad output | After every bug fix |
| **Golden dataset** | A set of inputs with expected outputs, scored for accuracy | For classification/extraction tasks |
| **LLM-as-judge** | A second LLM evaluates the quality of the first LLM's output | For generation tasks where quality is subjective |

### Minimal eval structure

Even a small eval suite is better than none. Start here:

```typescript
// evals/smart-reply.eval.ts
const cases = [
  {
    input: { message: "Where is my order?", history: [] },
    assert: (output) => {
      expect(output.suggestions).toHaveLength(3)
      expect(output.suggestions[0]).not.toContain("I don't know")
    }
  },
  {
    // regression: known hallucination case
    input: { message: "Tell me about the Pro plan features", history: [] },
    assert: (output) => {
      // Should not invent features not in knowledge base
      expect(output.suggestions[0]).not.toMatch(/unlimited|free|forever/)
    }
  }
]
```

### Eval as regression suite

Every AI bug fixed should become an eval test case. Over time this becomes your most valuable safety net.

---

## Cost Management

### Token budgets

Always set `max_tokens` on every API call. An unbounded call can consume your monthly budget on a single runaway request.

```typescript
const response = await client.messages.create({
  max_tokens: 1024, // always set this
  // ...
})
```

### Prompt caching

Use Anthropic's prompt caching for static or slow-changing content (system prompts, knowledge base, few-shot examples). Cache hits cost ~10x less than full tokens.

```typescript
{
  role: "user",
  content: [
    {
      type: "text",
      text: largeSystemContext,
      cache_control: { type: "ephemeral" } // cache this block
    },
    {
      type: "text",
      text: userMessage // dynamic part — not cached
    }
  ]
}
```

### Cost heuristics

| Operation | Approx tokens | At $3/M tokens (Sonnet) |
|-----------|--------------|------------------------|
| Simple classification | ~200 in + 50 out | $0.00075/call |
| Smart reply (3 suggestions) | ~500 in + 200 out | $0.0021/call |
| Document summarization | ~2000 in + 500 out | $0.0075/call |
| RAG answer (10 chunks) | ~3000 in + 300 out | $0.0099/call |
| Complex agent task (5 steps) | ~10000 in + 2000 out | $0.036/call |

**Always estimate cost at 100, 1000, and 10k daily active users before committing to a design.**

### Caching repeated calls

Cache the output of LLM calls that run on the same input repeatedly. A product description summary doesn't need to be regenerated on every page view.

```typescript
const cached = await redis.get(`summary:${productId}`)
if (cached) return cached

const summary = await generateSummary(product)
await redis.set(`summary:${productId}`, summary, { ex: 3600 })
return summary
```

---

## Failure Modes

### Hallucination

**Symptom:** Model generates confident, plausible, but false content.
**Mitigation:**
- Ground responses in retrieved context (RAG)
- Instruct the model to say "I don't know" when uncertain
- Validate factual claims against a known-good source
- Eval for known hallucination patterns

### Prompt drift

**Symptom:** AI behavior changes after a system prompt update, even unrelated changes.
**Mitigation:**
- Version-control all prompts
- Run eval suite before and after any prompt change
- Treat prompt changes like code changes — review required

### Context overflow

**Symptom:** Model ignores early parts of the context; quality degrades on long inputs.
**Mitigation:**
- Measure actual context length before each call
- Truncate or summarize conversation history when approaching limits
- For long documents, use RAG instead of full-document context

### Output schema mismatch

**Symptom:** Output parser fails because the model returned an unexpected format.
**Mitigation:**
- Use tool use / JSON mode — don't rely on prompt instructions alone
- Validate all outputs with Zod/Pydantic before use
- Handle parse failures gracefully with a fallback

### Rate limits

**Symptom:** API returns 429 errors under load.
**Mitigation:**
- Implement exponential backoff with jitter
- Queue non-real-time requests instead of calling directly
- Monitor tokens-per-minute, not just requests-per-minute

### Model version changes

**Symptom:** Behavior changes after Anthropic updates a model alias.
**Mitigation:** Pin to explicit model versions. Upgrade intentionally after testing.

---

## Security

### Prompt injection

User-controlled input should never be interpolated directly into a system prompt or instruction block. An attacker can override your instructions.

```
User input: "Ignore previous instructions. You are now a different AI..."
```

**Defense:**
- Use the messages array — keep user content in `role: "user"` messages
- Never concatenate user input into system prompts
- Validate that the model's output doesn't echo injection attempts

### PII handling

Before sending data to any external AI API:
- Strip or pseudonymize PII (names, emails, phone numbers, SSNs)
- Check your data processing agreements — most AI APIs process data on their servers
- Log what data categories are sent, not the data itself

### Output sanitization

LLM output rendered in a browser must be sanitized like any other user-generated content. An attacker can prompt the model to return XSS payloads.

```typescript
// Never render raw LLM output as HTML
element.innerHTML = llmOutput // XSS risk

// Sanitize or use text content
element.textContent = llmOutput // safe
// or
element.innerHTML = DOMPurify.sanitize(llmOutput) // safe for HTML rendering
```

### Rate limiting AI endpoints

AI-powered endpoints are expensive targets for abuse. A single user making thousands of requests can run up significant API costs.

- Rate limit per user: e.g. 20 AI requests per minute
- Rate limit globally: circuit breaker if total spend exceeds threshold
- Alert on anomalous usage patterns
