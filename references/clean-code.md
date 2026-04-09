# Clean Code Reference

Source: "Clean Code" by Robert C. Martin + modern adaptations.

---

## Naming

**Intention-revealing names**
Names should answer why something exists, what it does, and how it's used. If a name requires a comment, rename it.

```
// Bad
int d; // elapsed time in days

// Good
int elapsedTimeInDays;
```

**Avoid abbreviations**
Don't shorten names unless the abbreviation is universal (e.g., `id`, `url`, `html`).

```
// Bad
usrMgr.calcUsr(u)

// Good
userManager.calculateActiveUsers(user)
```

**Avoid encodings**
Don't prefix types or roles into names (Hungarian notation is dead).

```
// Bad
strName, bIsValid, iCount

// Good
name, isValid, count
```

**Class names are nouns**
Classes represent things: `Account`, `UserRepository`, `PaymentProcessor`.
Avoid vague names: `Manager`, `Processor`, `Helper`, `Data`, `Info`.

**Function names are verbs**
Functions do things: `getUser`, `calculateTotal`, `isValid`, `sendEmail`.
Accessors: `getX`. Mutators: `setX`. Predicates: `isX`, `hasX`, `canX`.

**One word per concept**
Pick one word and stick to it. Don't use `fetch`, `get`, and `retrieve` interchangeably across the same codebase.

**Use domain names**
Use problem-domain and solution-domain terms. If you're writing a `JobQueue`, name it `JobQueue` — not `TaskManager`.

---

## Functions

**Small**
Functions should do one thing. Prefer under 20 lines. Hard limit: 40 lines. If you can't read it without scrolling, it's too long.

**Do one thing**
A function that fetches, validates, transforms, and persists is four functions. Extract each responsibility.

**One level of abstraction**
All statements in a function should be at the same level of abstraction. Don't mix high-level orchestration with low-level string manipulation.

```
// Bad — mixes levels
function processOrder(order) {
  if (!order.items || order.items.length === 0) return;
  const total = order.items.reduce((sum, item) => sum + item.price * item.qty, 0);
  db.query(`INSERT INTO orders (total) VALUES (${total})`);
}

// Good — consistent abstraction level
function processOrder(order) {
  if (!isValidOrder(order)) return;
  const total = calculateOrderTotal(order);
  saveOrder(order, total);
}
```

**Max 3 parameters**
More than 3 parameters is a sign the function does too much or needs a parameter object.

```
// Bad
createUser(firstName, lastName, email, password, role, isActive)

// Good
createUser({ firstName, lastName, email, password, role, isActive })
```

**No flag arguments**
Passing a boolean to a function is a sign the function does two things. Split it.

```
// Bad
render(page, true)  // what does true mean?

// Good
renderFullPage(page)
renderPartialPage(page)
```

**No side effects**
A function named `checkPassword` should not start a session. Side effects cause unexpected coupling.

**Prefer no output arguments**
Instead of modifying a parameter, return a new value.

```
// Bad
appendFooter(report)  // mutates report

// Good
return addFooter(report)  // returns new report
```

---

## Comments

**Don't comment bad code — rewrite it.**

**Good comments:**
- Legal (copyright, license)
- Informative (explaining a non-obvious return value)
- Intent (explaining why, not what)
- Clarification (translating obscure library behavior)
- Warning (consequences of use)
- TODO (tracked, not permanent)

**Bad comments:**
- Redundant — `i++; // increment i`
- Misleading — describes behavior that no longer matches code
- Journal — version history belongs in git, not code
- Noise — `// default constructor`
- Closing brace markers — `} // end if`
- Attributed — `// added by Leo`
- Commented-out code — delete it; git has it

---

## Error Handling

**Use exceptions, not return codes**
Return codes require callers to check them. Unchecked return codes cause silent failures.

**Provide context with exceptions**
Include what failed and why. Stack traces alone are not enough.

```
// Bad
throw new Error("failed");

// Good
throw new Error(`Failed to load user ${userId}: ${reason}`);
```

**Don't return null**
Returning null forces null checks everywhere. Return empty collections, throw, or use Option/Result types.

**Don't pass null**
If a function receives null and doesn't handle it, the error happens far from the cause.

**Never use empty catch blocks**
An empty catch block silently swallows errors. At minimum, log.

```
// Bad
try {
  loadUser(id);
} catch (e) {}

// Good
try {
  loadUser(id);
} catch (e) {
  logger.error(`Failed to load user ${id}`, e);
  throw e;
}
```

---

## DRY (Don't Repeat Yourself)

Every piece of knowledge must have a single, unambiguous representation in a system.

Duplication is not just copy-paste. It includes:
- Parallel class hierarchies that mirror each other
- Switch/case or if/else chains that must be updated together
- Validation logic scattered across multiple layers

When you find duplication: extract it, name it, own it.

---

## YAGNI (You Aren't Gonna Need It)

Don't build for hypothetical future requirements.

Symptoms:
- Abstract factories for a single concrete implementation
- Configuration flags that have only one valid value
- Extension points for features not yet planned
- Interfaces with a single implementer
- "Flexible" data models that store everything as key-value pairs

The cost: complexity today, for value that may never arrive.

---

## Boy Scout Rule

Leave the code cleaner than you found it.

Every time you touch a file:
- Fix one bad name
- Extract one function
- Remove one dead comment

Small, continuous improvement beats periodic rewrites.
