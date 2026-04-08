# Guard Review: [Target]

> Date: [date]
> Target: [path / branch / PR]
> Spec: [spec file, if provided — "none" if not]
> Overall health: [score]/100

---

## Summary

| Pass | Findings | Critical | High | Medium | Low | Info |
|------|----------|----------|------|--------|-----|------|
| 1 — Structural integrity | [n] | [n] | [n] | [n] | [n] | [n] |
| 2 — Code smells & anti-patterns | [n] | [n] | [n] | [n] | [n] | [n] |
| 3 — Security | [n] | [n] | [n] | [n] | [n] | [n] |
| 4 — Clean code | [n] | [n] | [n] | [n] | [n] | [n] |
| 5 — Spec conformance | [n] | [n] | [n] | [n] | [n] | [n] |
| **Total** | **[n]** | **[n]** | **[n]** | **[n]** | **[n]** | **[n]** |

---

## Health score

| Category | Score | Weight | Weighted |
|----------|-------|--------|---------|
| Structural integrity | [0-20] | 20% | [n] |
| Code smells & anti-patterns | [0-20] | 20% | [n] |
| Security | [0-20] | 25% | [n] |
| Clean code | [0-20] | 20% | [n] |
| Spec conformance | [0-20] | 15% | [n] |
| **Overall** | | | **[score]/100** |

---

## Findings

> Ordered by severity: CRITICAL → HIGH → MEDIUM → LOW → INFO

---

### CRITICAL — [Title]

- **File:** `[path:line]`
- **Issue:** [What is wrong and why it is dangerous]
- **Fix:** [Exact, actionable recommendation]

---

### HIGH — [Title]

- **File:** `[path:line]`
- **Issue:** [What is wrong]
- **Fix:** [Exact, actionable recommendation]

---

### MEDIUM — [Title]

- **File:** `[path:line]`
- **Issue:** [What is wrong]
- **Fix:** [Exact, actionable recommendation]

---

### LOW — [Title]

- **File:** `[path:line]`
- **Issue:** [What is wrong]
- **Fix:** [Exact, actionable recommendation]

---

### INFO — [Title]

- **File:** `[path:line]`
- **Note:** [Observation — not a violation, but worth knowing]

---

## Spec conformance

> Only present if a spec was provided with --against flag.

| Acceptance criterion | Implemented | Tested | Notes |
|----------------------|-------------|--------|-------|
| [criterion from spec] | PASS / FAIL | PASS / FAIL | [details] |
