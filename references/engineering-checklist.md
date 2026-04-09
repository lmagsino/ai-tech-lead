# Engineering Checklist Reference

Organized checklist for `/guard` to use when reviewing code. Each category lists specific things to check with the signal to look for.

---

## Correctness

**Off-by-one errors**
- [ ] Array/loop bounds: `< length` vs `<= length`, `start` vs `start+1`
- [ ] Inclusive vs exclusive range endpoints
- [ ] Pagination: `offset = (page - 1) * size` vs `offset = page * size`
- [ ] Date ranges: does "between Jan 1 and Jan 31" include Jan 31?

**Null/None handling**
- [ ] Every value that can be null is handled before use
- [ ] Null not returned from functions where callers won't check
- [ ] Optional chaining used where appropriate
- [ ] Null object pattern used instead of null returns where applicable

**Boundary conditions**
- [ ] Empty collection handled (not just the happy path with items)
- [ ] Single-element collection handled
- [ ] Zero value handled (division, percentage, rate calculations)
- [ ] Maximum value handled (integer overflow, string length limits)
- [ ] Negative values handled for counts and lengths

**Operator precedence**
- [ ] Boolean conditions parenthesized when mixing `&&` and `||`
- [ ] Arithmetic parenthesized when mixing `+/-` with `*//`
- [ ] Bitwise operators parenthesized (often lower precedence than expected)

**Type coercion**
- [ ] Strict equality used (`===` vs `==` in JavaScript)
- [ ] String-to-number conversion explicit, not implicit
- [ ] Date comparison: dates compared as dates, not strings

---

## Concurrency

**Race conditions**
- [ ] Check-then-act patterns are atomic (read-modify-write on shared state)
- [ ] Counters/accumulators use atomic operations or locks
- [ ] Database row updates use optimistic locking or `WHERE` conditions to prevent lost updates
- [ ] Idempotency: can this operation be called twice without harm?

**Deadlocks**
- [ ] Multiple locks always acquired in the same order
- [ ] Lock held for minimum necessary duration
- [ ] No blocking I/O performed while holding a lock
- [ ] Database transactions keep lock scope minimal

**Visibility**
- [ ] Shared variables marked `volatile` / `atomic` / `synchronized` where needed
- [ ] No assumption that reads are immediately visible across threads

**Async correctness**
- [ ] All async functions properly awaited
- [ ] Error handling covers async failures (unhandled promise rejection)
- [ ] Async operations in loops use `Promise.all` where appropriate, not sequential await
- [ ] No race condition between parallel async operations

---

## Performance

**Database**
- [ ] No N+1 queries (loop with query per iteration)
- [ ] All queries have a LIMIT or bounded by design
- [ ] List endpoints paginated
- [ ] Indexes exist for WHERE, JOIN ON, and ORDER BY columns
- [ ] Queries on large tables have an execution plan review
- [ ] No `SELECT *` on tables with many columns
- [ ] Transactions kept short to minimize lock contention

**Computation**
- [ ] O(n²) or worse algorithms on inputs that can be large
- [ ] Expensive calculations cached where inputs are stable
- [ ] String concatenation in loops uses a builder/join, not `+=`
- [ ] Large collections not serialized into memory when streaming is possible

**Network**
- [ ] HTTP calls not made inside loops (batch where possible)
- [ ] Responses compressed for large payloads
- [ ] Connection reuse (keep-alive, connection pooling)
- [ ] Unnecessary data not included in responses (fat responses)

**Memory**
- [ ] Large files not read entirely into memory when streaming is possible
- [ ] Static/class-level collections bounded (LRU, TTL, max size)
- [ ] Objects not retained longer than needed (leak-prone patterns)

---

## Reliability

**Error handling**
- [ ] All error paths handled (no silent swallowing)
- [ ] Error messages include context (what failed, with what input)
- [ ] Expected errors (validation, not found) differentiated from unexpected errors
- [ ] Callers informed of failure in a recoverable way

**Timeout handling**
- [ ] All external HTTP calls have explicit timeouts configured
- [ ] Database queries have statement timeouts where applicable
- [ ] Long-running background jobs have a maximum runtime guard

**Retry logic**
- [ ] Retries on transient failures (network, rate limit)
- [ ] Exponential backoff with jitter (not fixed interval)
- [ ] Maximum retry count set
- [ ] Non-retryable errors (4xx, validation) not retried

**Circuit breakers**
- [ ] Downstream services have circuit breaker protection
- [ ] Circuit breaker state monitored and alerted on
- [ ] Fallback behavior defined when circuit is open

**Idempotency**
- [ ] Payment and financial operations are idempotent (safe to retry)
- [ ] State-changing operations handle duplicate requests gracefully
- [ ] Webhook handlers are idempotent

---

## Observability

**Logging**
- [ ] Important state transitions logged (order placed, payment processed)
- [ ] Errors logged with context (not just "error occurred")
- [ ] Log levels used correctly (DEBUG < INFO < WARN < ERROR)
- [ ] No sensitive data in logs (passwords, tokens, card numbers, PII)
- [ ] Correlation ID / request ID included in logs for tracing

**Metrics**
- [ ] Critical operations emit duration metrics
- [ ] Error rates tracked per operation
- [ ] Business metrics tracked (orders per minute, sign-ups)

**Tracing**
- [ ] Distributed trace context propagated across service boundaries
- [ ] Slow operations identifiable from trace spans

**Error reporting**
- [ ] Unexpected errors reported to error tracker (Sentry, Bugsnag)
- [ ] Error grouping configured so similar errors cluster
- [ ] Alerts configured for error rate spikes

---

## Maintainability

**Naming**
- [ ] Variables, functions, and classes have intention-revealing names
- [ ] No abbreviations (except universally known: `id`, `url`, `config`)
- [ ] Boolean variables/functions use `is`, `has`, `can` prefix
- [ ] Collections named as plurals (`users`, not `user`)

**Function size and focus**
- [ ] Functions under 40 lines (prefer under 20)
- [ ] Each function does one thing at one level of abstraction
- [ ] No flag arguments (boolean that changes function behavior)

**Coupling and cohesion**
- [ ] Classes don't access internals of other classes (Law of Demeter)
- [ ] Dependencies flow in one direction (no circular dependencies)
- [ ] Modules depend on abstractions, not concrete implementations

**Documentation**
- [ ] Public APIs documented (parameters, return values, exceptions)
- [ ] Non-obvious behavior explained in comments (the "why", not the "what")
- [ ] TODO comments tracked and attributed (not permanent)
- [ ] README or module-level comment explains purpose and usage

**Testability**
- [ ] Business logic is testable without starting a server
- [ ] External dependencies injected (not instantiated inside)
- [ ] Tests cover the acceptance criteria from the spec
- [ ] Edge cases tested (empty, null, boundary values)
- [ ] Tests named to describe behavior: `test_checkout_fails_when_cart_is_empty`
