# Anti-Patterns Reference

Performance, stability, and structural anti-patterns to detect during guard review.

---

## N+1 Queries

**Description:** A loop that executes one database query per iteration instead of one query for the whole set.

**Detection signal:**
```python
# Bad — N+1: one query for orders, then one per order for user
for order in orders:
    user = db.query("SELECT * FROM users WHERE id = ?", order.user_id)
    print(user.name, order.total)

# Good — 2 queries regardless of N
user_ids = [o.user_id for o in orders]
users = db.query("SELECT * FROM users WHERE id IN (?)", user_ids)
```

**Severity:** CRITICAL
**Fix:** Use JOIN, IN clause, or ORM eager loading (`includes`, `preload`, `with`). Never query inside a loop.

---

## Unbounded Result Sets

**Description:** A query with no LIMIT that returns the full table as it grows.

**Detection signal:** `SELECT * FROM orders` with no WHERE or LIMIT clause. Works fine at 100 rows, causes memory exhaustion at 10M rows.

**Severity:** CRITICAL
**Fix:** Always set a LIMIT. Use cursor-based pagination for large datasets.

---

## Missing Pagination

**Description:** List endpoints return all records without pagination.

**Detection signal:** `/api/users` returns all users. `/api/orders` returns all orders. No `page`, `cursor`, `limit`, or `offset` parameters.

**Severity:** HIGH
**Fix:** Add pagination to every list endpoint. Default page size: 20-100. Max page size: enforced server-side.

---

## Race Conditions

**Description:** Shared mutable state accessed by concurrent operations without synchronization.

**Detection signal:**
```python
# Bad — check-then-act race condition
if order.status == 'pending':       # check
    order.status = 'processing'     # act — another thread may have changed status between check and act
    process(order)

# Good — atomic compare-and-swap
rows_updated = db.execute(
    "UPDATE orders SET status='processing' WHERE id=? AND status='pending'",
    order.id
)
if rows_updated == 0:
    raise ConcurrentModificationError()
```

**Severity:** CRITICAL
**Fix:** Use optimistic locking, database-level locks, or atomic operations. Never rely on in-memory checks for concurrent writes.

---

## Memory Leaks

**Description:** Resources that are allocated but never released, causing memory growth over time.

**Detection signal:**
- Static collections that grow indefinitely: `CACHE = {}` with no eviction
- Event listeners registered but never removed
- File handles, database connections, or streams opened but not closed
- `try/finally` or `using` blocks missing

**Severity:** HIGH
**Fix:** Use bounded caches (LRU with size/TTL limits). Close resources in `finally` blocks or use RAII/disposable patterns. Remove event listeners when no longer needed.

---

## Error Swallowing

**Description:** Exceptions caught and silently discarded, hiding failures.

**Detection signal:**
```python
# Bad
try:
    send_email(user)
except Exception:
    pass  # What happened? Nobody knows.

# Good
try:
    send_email(user)
except Exception as e:
    logger.error(f"Failed to send email to user {user.id}", exc_info=True)
    raise  # or handle explicitly
```

**Severity:** HIGH
**Fix:** Never use empty catch blocks. At minimum, log the error. For non-critical paths, log and alert; for critical paths, let the error propagate.

---

## Missing Timeouts on External Calls

**Description:** HTTP requests, database queries, or service calls without configured timeouts.

**Detection signal:**
```python
# Bad — hangs indefinitely if service is slow
response = requests.get("https://api.external.com/data")

# Good
response = requests.get("https://api.external.com/data", timeout=5)
```

**Severity:** HIGH
**Fix:** Set explicit timeouts on all external calls. Default: 5-30 seconds depending on operation. Fail fast and let callers retry.

---

## Missing Circuit Breakers

**Description:** A service that keeps hammering a failing downstream dependency, amplifying the outage.

**Detection signal:** No retry-with-backoff logic. No circuit breaker library. Every request attempts the failing dependency regardless of prior failures.

**Severity:** HIGH
**Fix:** Implement circuit breaker pattern (open after N failures, half-open to probe recovery). Use libraries: `resilience4j` (Java), `pybreaker` (Python), `opossum` (Node).

---

## Unbounded Loops

**Description:** A loop with no guaranteed exit condition, or no safety limit.

**Detection signal:**
```python
# Bad — infinite if condition never becomes false
while not job.is_complete():
    process_next_item(job)  # what if is_complete() never returns True?

# Good
MAX_ITERATIONS = 10_000
for _ in range(MAX_ITERATIONS):
    if job.is_complete():
        break
    process_next_item(job)
else:
    raise RuntimeError("Job did not complete after max iterations")
```

**Severity:** HIGH
**Fix:** Add a maximum iteration limit. Log if the limit is hit — it signals a bug in the termination condition.

---

## Connection Pool Exhaustion

**Description:** Database or HTTP connections acquired but not returned, causing the pool to run dry.

**Detection signal:** Connections opened in try blocks without matching close/release. Connections stored in instance variables. No `with` statement or connection manager.

**Severity:** CRITICAL
**Fix:** Always use context managers (`with`) or connection-returning finally blocks. Set pool size monitoring and alerting.

---

## Blocking I/O on Async Threads

**Description:** Synchronous blocking I/O inside an async event loop, freezing the entire loop.

**Detection signal:**
```python
# Bad — blocks the async event loop
async def handle_request(req):
    result = requests.get(url)  # synchronous! blocks everything

# Good
async def handle_request(req):
    result = await aiohttp_session.get(url)  # async-aware
```

**Severity:** HIGH
**Fix:** Use async-aware libraries for I/O in async code. If sync code is unavoidable, run it in a thread pool executor.

---

## Missing Rate Limiting on Public Endpoints

**Description:** APIs accessible without rate limits, vulnerable to abuse, DoS, and scraping.

**Detection signal:** No rate limit headers in responses (`X-RateLimit-*`). No throttling middleware. `/api/search`, `/api/login`, public endpoints with no request caps.

**Severity:** HIGH
**Fix:** Apply rate limiting at the API gateway or middleware level. Stricter limits on auth endpoints (brute-force protection). Return `429 Too Many Requests` with `Retry-After`.

---

## Cache Without TTL or Size Bounds

**Description:** A cache that grows indefinitely, eventually consuming all available memory.

**Detection signal:**
```python
# Bad — unbounded, no eviction
cache = {}
def get_user(id):
    if id not in cache:
        cache[id] = db.load_user(id)
    return cache[id]

# Good — LRU with TTL
from cachetools import TTLCache
cache = TTLCache(maxsize=1000, ttl=300)
```

**Severity:** HIGH
**Fix:** Use LRU caches with a size limit. Add TTL so stale data doesn't persist indefinitely. Monitor cache hit rate and size.

---

## Lava Flow

**Description:** Dead code that nobody dares remove because nobody knows what it does or if anything depends on it.

**Detection signal:** Large commented-out blocks. Functions prefixed with `old_` or `legacy_`. "DO NOT DELETE" comments with no explanation. Code that looks duplicate but slightly different.

**Severity:** MEDIUM
**Fix:** Investigate ownership (git blame). If unused, delete. If uncertain, add logging to confirm it's not called, then delete in a follow-up.

---

## Dead Code

**Description:** Code that is never reachable or executed.

**Detection signal:** Functions with no callers. Imports never used. Variables assigned but never read. Branches that can never be true given type constraints.

**Severity:** MEDIUM
**Fix:** Delete it. Static analysis tools (ESLint, PyFlakes, IntelliJ) will find most of it automatically.

---

## God Object / Blob

**Description:** A single class or module that knows about and controls too much of the system.

**Detection signal:** One class with 500+ lines, 20+ methods, imports from every other module. Changes to unrelated features all touch this class.

**Severity:** HIGH
**Fix:** Split along responsibility boundaries. No single class should be the hub of the dependency graph.

---

## Spaghetti Code

**Description:** Unstructured code with tangled control flow, deep nesting, and no clear boundaries.

**Detection signal:** Functions with 5+ levels of nesting. `goto`-style logic with many early returns at random levels. No clear separation of concerns within a module.

**Severity:** HIGH
**Fix:** Flatten by inverting conditions (guard clauses). Extract deeply nested code into named functions. Establish clear module boundaries.

---

## Golden Hammer

**Description:** Applying one familiar solution to every problem, regardless of fit.

**Detection signal:** Redis used for everything including durable storage. Microservices for a 3-person team. Event sourcing applied to a simple CRUD app. GraphQL for a mobile client that needs one endpoint.

**Severity:** MEDIUM
**Fix:** Evaluate the problem first. Choose the simplest tool that solves it. Over-engineering is a form of technical debt.
