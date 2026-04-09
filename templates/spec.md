# Spec: [Feature Name]

> Status: DRAFT | REVIEW | APPROVED
> Author: [name]
> Date: [date]
> Scope output: [link to scopes/feature.md if this came from /scope]

---

## Problem statement

[What problem does this solve? Who has this problem? Why does it matter now?]

---

## User story

As a [who], I want to [what], so that [why].

---

## Acceptance criteria

- [ ] [Specific, testable criterion 1]
- [ ] [Specific, testable criterion 2]
- [ ] [...]

> Each criterion must be testable. "Should be fast" is not a criterion. "P95 response time < 500ms including AI call" is.

---

## AI components

> Complete this section for every LLM call, embedding operation, or agent in the feature.
> If this feature has no AI components, write "None" and delete the sub-sections.

### [Component name — e.g. "Reply suggestions"]

- **Type:** LLM call | Embedding | Agent | RAG pipeline
- **Model:** [e.g. claude-haiku-4-5 — chosen for low latency and high call volume]
- **Input:** [What goes in — data shape, max size, any PII concerns]
- **Output:** [What comes out — schema, example]
- **Prompt location:** `src/ai/prompts/[name].ts`
- **Output schema:** `src/ai/schemas/[name].ts`
- **Fallback:** [What the user sees if this AI call fails or times out]
- **Timeout:** [e.g. 5s — after which fallback kicks in]
- **Eval criteria:** [How do we know the output is good? e.g. "acceptance rate > 40%"]
- **Cost estimate:** [~N tokens/call × expected volume = $X/day]

---

## Technical constraints

[Stack requirements, performance budgets, compatibility needs, third-party limits]

---

## Integration points

[What existing systems, services, or modules does this touch?]

---

## Data model changes

[New tables, columns, relationships, migrations — if applicable. "None" if not applicable.]

---

## API changes

[New endpoints, modified request/response shapes, removed endpoints — if applicable.]

---

## UI behavior

[What the user sees at each step.]

**Initial state:** [What the user sees before any action]
**Loading state:** [What the user sees during async operations — especially AI calls]
**Success state:** [What the user sees on success]
**Error state:** [What the user sees on failure]
**AI unavailable state:** [What the user sees when AI is down or slow — must not be a blank screen or raw error]
**Empty state:** [What the user sees with no data]

---

## Edge cases

[Unusual inputs, boundary conditions, error scenarios.]

Include AI-specific edge cases:
- What happens if the AI returns an empty or malformed response?
- What happens if the AI call times out?
- What happens if the model returns content that fails schema validation?

---

## Out of scope

[Explicitly list what we are NOT building in this iteration.]

- [Not building X]
- [Not building Y]

---

## Open questions

[Anything unresolved that needs a decision before implementation can start.]

| Question | Owner | Due |
|----------|-------|-----|
| [question] | [who] | [date] |
