# SOLID Principles Reference

---

## S — Single Responsibility Principle

**A class should have only one reason to change.**

One responsibility = one axis of change. A class that handles business logic AND persistence AND formatting will change whenever any of those concerns change.

**Violation:**
```python
class User:
    def calculate_salary(self): ...      # business logic
    def save_to_database(self): ...      # persistence
    def format_as_json(self): ...        # serialization
    def send_welcome_email(self): ...    # notifications
```

**Corrected:**
```python
class User:
    def calculate_salary(self): ...

class UserRepository:
    def save(self, user: User): ...

class UserSerializer:
    def to_json(self, user: User): ...

class UserNotifier:
    def send_welcome_email(self, user: User): ...
```

**Detection signals:**
- Class name contains "And", "Manager", "Processor", "Helper"
- Class has more than ~5-7 public methods
- Methods in the class don't share any instance variables
- You can't explain the class's purpose without using "and"

---

## O — Open/Closed Principle

**Software entities should be open for extension, closed for modification.**

New behavior should be addable without changing existing code. Typically achieved through polymorphism, not conditionals.

**Violation:**
```typescript
function getAreaCalculator(shape: Shape): number {
  if (shape.type === 'circle') {
    return Math.PI * shape.radius ** 2;
  } else if (shape.type === 'rectangle') {
    return shape.width * shape.height;
  }
  // Every new shape requires modifying this function
}
```

**Corrected:**
```typescript
interface Shape {
  area(): number;
}

class Circle implements Shape {
  area() { return Math.PI * this.radius ** 2; }
}

class Rectangle implements Shape {
  area() { return this.width * this.height; }
}

// Adding Triangle requires no change to existing code
function getTotalArea(shapes: Shape[]): number {
  return shapes.reduce((sum, s) => sum + s.area(), 0);
}
```

**Detection signals:**
- Adding a new type requires a new `if` or `case` branch in multiple places
- Feature flags used to conditionally alter core logic
- A switch statement on a type field that recurs in multiple methods

---

## L — Liskov Substitution Principle

**Subtypes must be substitutable for their base types without altering program correctness.**

A subclass should honor the contract of its parent. If you have to check "is this a subtype?" before using it, LSP is violated.

**Violation:**
```typescript
class Rectangle {
  setWidth(w: number) { this.width = w; }
  setHeight(h: number) { this.height = h; }
  area() { return this.width * this.height; }
}

class Square extends Rectangle {
  setWidth(w: number) {
    this.width = w;
    this.height = w;  // Square silently overrides Rectangle's contract
  }
}

// Caller breaks when a Square is passed
function resizeToDouble(rect: Rectangle) {
  rect.setWidth(rect.width * 2);
  // Expected: width doubled, height unchanged
  // With Square: BOTH change
}
```

**Corrected:**
```typescript
interface Shape {
  area(): number;
}

class Rectangle implements Shape { ... }
class Square implements Shape { ... }
// No inheritance — they share an interface, not an implementation
```

**Detection signals:**
- Subclass overrides a parent method to throw `NotImplementedError`
- Code checks `instanceof` before calling a method
- Subclass silently changes invariants the parent guaranteed
- Unit tests for the parent type fail when a subclass is substituted

---

## I — Interface Segregation Principle

**Clients should not be forced to depend on interfaces they do not use.**

Fat interfaces force implementers to stub out methods they don't need, and force callers to navigate irrelevant API surface.

**Violation:**
```typescript
interface Worker {
  work(): void;
  eat(): void;
  sleep(): void;
}

class Robot implements Worker {
  work() { ... }
  eat() { throw new Error("Robots don't eat"); }   // forced stub
  sleep() { throw new Error("Robots don't sleep"); } // forced stub
}
```

**Corrected:**
```typescript
interface Workable { work(): void; }
interface Eatable  { eat(): void; }
interface Sleepable { sleep(): void; }

class Human implements Workable, Eatable, Sleepable { ... }
class Robot implements Workable { ... }
```

**Detection signals:**
- Methods that throw `NotImplemented` or return empty/null
- Interface has more than ~5-7 methods
- Callers only use a small subset of the interface
- Interface name is vague: `IService`, `IHelper`, `IProcessor`

---

## D — Dependency Inversion Principle

**High-level modules should not depend on low-level modules. Both should depend on abstractions.**

Business logic should not know about databases, frameworks, or external services. Dependencies should flow inward toward the domain.

**Violation:**
```python
class OrderService:
    def __init__(self):
        self.db = PostgresDatabase()     # hard dependency on low-level module
        self.emailer = SendGridEmailer() # hard dependency on vendor

    def place_order(self, order):
        self.db.save(order)
        self.emailer.send_confirmation(order)
```

**Corrected:**
```python
class OrderService:
    def __init__(self, order_repo: OrderRepository, notifier: OrderNotifier):
        self.order_repo = order_repo  # depends on abstraction
        self.notifier = notifier      # depends on abstraction

    def place_order(self, order):
        self.order_repo.save(order)
        self.notifier.notify(order)

# In production: inject PostgresOrderRepository, SendGridNotifier
# In tests: inject InMemoryOrderRepository, FakeNotifier
```

**Detection signals:**
- `new ConcreteClass()` inside a business logic method
- Import of a database library, HTTP client, or vendor SDK inside a domain class
- Tests require real database/network to run
- Can't swap implementations without modifying the class
