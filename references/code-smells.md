# Code Smells Reference

23 smells to detect during guard review. Each smell is a signal that a refactor is warranted — not always a bug, but always a liability.

---

## 1. Long Method
**Description:** A method that does too much, making it hard to understand and test.
**Detection signal:** Method exceeds 40 lines; requires mental parsing to understand what it does.
**Severity:** HIGH
**Fix:** Extract smaller, named functions. Each should do one thing at one level of abstraction.

---

## 2. Large Class (God Class / Blob)
**Description:** A class that knows too much or does too much.
**Detection signal:** More than ~200 lines, more than ~10 public methods, or methods that don't share instance variables.
**Severity:** HIGH
**Fix:** Identify distinct responsibilities. Extract into focused, well-named classes.

---

## 3. Long Parameter List
**Description:** A function with more than 3-4 parameters.
**Detection signal:** `function(a, b, c, d, e)` — callers must look up meaning of each argument.
**Severity:** MEDIUM
**Fix:** Group related parameters into a parameter object. If parameters are from different concerns, the function does too much.

---

## 4. Divergent Change
**Description:** One class that changes for many different reasons.
**Detection signal:** Git log shows one file touched for database changes, UI changes, and validation changes.
**Severity:** HIGH
**Fix:** Split the class along its axes of change. Each resulting class changes for only one reason.

---

## 5. Shotgun Surgery
**Description:** A single change requires modifying many small classes.
**Detection signal:** Adding a field or changing behavior requires edits to 5+ files.
**Severity:** HIGH
**Fix:** Consolidate related behavior into fewer classes. The change should have a natural home.

---

## 6. Feature Envy
**Description:** A method that is more interested in data from another class than its own.
**Detection signal:** Method calls multiple getters on another object; uses that object's data more than its host class's data.
**Severity:** MEDIUM
**Fix:** Move the method to the class whose data it uses.

---

## 7. Data Clumps
**Description:** Groups of data items that always appear together but aren't formalized as an object.
**Detection signal:** `firstName, lastName, email` passed together to multiple functions, but never wrapped in a `User` type.
**Severity:** MEDIUM
**Fix:** Extract into a value object or data class.

---

## 8. Primitive Obsession
**Description:** Using primitive types (string, int) to represent domain concepts.
**Detection signal:** `string` used for email, phone number, currency, status codes. Business rules on primitives scattered everywhere.
**Severity:** MEDIUM
**Fix:** Create value objects: `Email`, `PhoneNumber`, `Money`, `OrderStatus`.

---

## 9. Switch Statements (Type Code)
**Description:** Switch or if-else chains on a type field that repeat across the codebase.
**Detection signal:** Same `switch(type)` pattern in multiple places; adding a new type requires touching all of them.
**Severity:** HIGH
**Fix:** Replace with polymorphism. Create subclasses or strategy objects.

---

## 10. Parallel Inheritance Hierarchies
**Description:** Two class hierarchies that must change in tandem — adding a subclass in one requires adding a subclass in the other.
**Detection signal:** "Whenever I create a `FooX`, I also need a `BarX`."
**Severity:** MEDIUM
**Fix:** Merge the hierarchies or use composition to break the parallel dependency.

---

## 11. Lazy Class
**Description:** A class that doesn't justify its existence — it does so little that it adds complexity without value.
**Detection signal:** Class with one method, or a class that simply delegates all calls to another.
**Severity:** LOW
**Fix:** Inline its behavior into the caller or merge into another class.

---

## 12. Speculative Generality (YAGNI violation)
**Description:** Code added to support future requirements that don't exist yet.
**Detection signal:** Interfaces with one implementer, hooks that are never called, configuration for features not built.
**Severity:** LOW
**Fix:** Delete it. If the need arises, add it then with real context.

---

## 13. Temporary Field
**Description:** An instance variable that is only set and used under certain conditions.
**Detection signal:** A field that is `null` in some states, or only initialized in one code path.
**Severity:** MEDIUM
**Fix:** Extract the object and its behavior into a separate class or use a local variable.

---

## 14. Message Chains
**Description:** A sequence of method calls chained together, tightly coupling the caller to the internal structure of several objects.
**Detection signal:** `user.getAccount().getProfile().getAddress().getCity()`
**Severity:** MEDIUM
**Fix:** Apply the Law of Demeter — talk to immediate neighbors only. Add delegation methods or restructure.

---

## 15. Middle Man
**Description:** A class whose primary job is to delegate to another class.
**Detection signal:** Half or more of a class's methods just forward to another object.
**Severity:** LOW
**Fix:** Remove the middle man. Callers should interact directly with the delegated class, or inline the delegation.

---

## 16. Inappropriate Intimacy
**Description:** Two classes that know too much about each other's internals.
**Detection signal:** Class A accesses private fields of Class B; bidirectional dependencies between classes.
**Severity:** HIGH
**Fix:** Reduce coupling. Move shared behavior to a common class or introduce an abstraction.

---

## 17. Alternative Classes with Different Interfaces
**Description:** Two classes that do the same thing but have different method signatures.
**Detection signal:** `EmailSender.send()` and `NotificationService.dispatch()` — same concept, incompatible interfaces.
**Severity:** MEDIUM
**Fix:** Unify behind a common interface. Rename and align the API.

---

## 18. Incomplete Library Class
**Description:** A library class that doesn't quite do what you need, leading to repeated workaround code.
**Detection signal:** Helper methods wrapping the same library call scattered throughout the codebase.
**Severity:** LOW
**Fix:** Extract the workaround into a single adapter or extension class.

---

## 19. Data Class
**Description:** A class with only data (getters/setters) and no behavior.
**Detection signal:** POJO/DTO with no methods other than accessors. Business logic that operates on it lives elsewhere.
**Severity:** LOW
**Fix:** Move the relevant behavior into the class. Objects should own their logic, not just their data.

---

## 20. Refused Bequest
**Description:** A subclass that inherits from a parent but doesn't use most of what it inherits.
**Detection signal:** Subclass overrides inherited methods to throw `NotSupported` or does nothing. Liskov Substitution violated.
**Severity:** HIGH
**Fix:** Reconsider the inheritance. Prefer composition; use interfaces rather than class inheritance.

---

## 21. Comments (as smell)
**Description:** Comments that explain what the code does — a sign the code is not self-explanatory.
**Detection signal:** Block comments above methods, inline comments on every other line, commented-out code.
**Severity:** LOW
**Fix:** Rename to make intent clear. Extract to a named function. Delete commented-out code.

---

## 22. Duplicated Code
**Description:** The same or structurally similar code appears in more than one place.
**Detection signal:** Copy-paste patterns; identical logic in multiple methods/classes with slight variations.
**Severity:** HIGH
**Fix:** Extract a shared function or class. Apply the Rule of Three: refactor on the third duplicate.

---

## 23. Dead Code
**Description:** Code that is never executed — unreachable branches, unused functions, stale imports.
**Detection signal:** Functions with no callers; variables assigned but never read; imports never used; `if false` branches.
**Severity:** MEDIUM
**Fix:** Delete it. Git has it if you ever need it back.
