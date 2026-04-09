# Design Patterns Reference

Not a GoF catalog. A practical guide: when you see a problem, here's the pattern that solves it.

---

## Strategy

**Problem:** A function with a large if/else or switch that selects different algorithms or behaviors based on a type.

**When to use:**
- Multiple algorithms for the same operation (sorting, pricing, validation)
- Behavior that varies by context and needs to be swappable at runtime
- The same if/else chain appears in multiple places

**When NOT to use:**
- Only two behaviors — a simple boolean flag or subclass is simpler
- The "strategies" share most of their logic — extract the shared part instead

**Example:**
```python
# Before: switch-heavy
def calculate_discount(order, customer_type):
    if customer_type == 'vip':
        return order.total * 0.2
    elif customer_type == 'member':
        return order.total * 0.1
    else:
        return 0

# After: Strategy
class DiscountStrategy:
    def calculate(self, order: Order) -> float: ...

class VipDiscount(DiscountStrategy):
    def calculate(self, order): return order.total * 0.2

class MemberDiscount(DiscountStrategy):
    def calculate(self, order): return order.total * 0.1

class NoDiscount(DiscountStrategy):
    def calculate(self, order): return 0.0
```

---

## Observer

**Problem:** When something happens, multiple other parts of the system need to react — but the source shouldn't know about the consumers.

**When to use:**
- Event-driven behavior: user signed up → send email + create profile + log analytics
- Decoupling producers from consumers
- The number of consumers may change over time

**When NOT to use:**
- Only one consumer — a direct call is simpler
- Order of execution matters and observers must run in sequence — use a pipeline instead
- Debug complexity is a concern — observer chains are hard to trace

**Example:**
```typescript
class EventBus {
  private listeners: Map<string, Function[]> = new Map();

  on(event: string, fn: Function) {
    this.listeners.get(event)?.push(fn) ?? this.listeners.set(event, [fn]);
  }

  emit(event: string, payload: any) {
    this.listeners.get(event)?.forEach(fn => fn(payload));
  }
}

// Producers don't know about consumers
eventBus.emit('user.created', { userId: 123 });

// Consumers register independently
eventBus.on('user.created', sendWelcomeEmail);
eventBus.on('user.created', createUserProfile);
eventBus.on('user.created', logToAnalytics);
```

---

## Factory

**Problem:** Object creation logic is complex, conditional, or needs to be abstracted from the caller.

**When to use:**
- Creating objects requires conditional logic based on type
- The exact class to instantiate may not be known until runtime
- You want to centralize construction logic and keep callers simple

**When NOT to use:**
- Construction is trivial — just use `new`
- Only one type is ever created — factory adds no value
- The factory becomes a switch statement antipattern (see Strategy instead)

**Example:**
```typescript
// Without factory: construction logic scattered across callers
const notifier = type === 'email'
  ? new EmailNotifier(smtpConfig)
  : new SmsNotifier(twilioConfig);

// With factory: centralized, testable construction
class NotifierFactory {
  create(type: 'email' | 'sms'): Notifier {
    switch (type) {
      case 'email': return new EmailNotifier(this.smtpConfig);
      case 'sms':   return new SmsNotifier(this.twilioConfig);
    }
  }
}
```

---

## Adapter

**Problem:** You need to use an external library or service but its interface doesn't match what your code expects.

**When to use:**
- Integrating a third-party service or library
- Wrapping a legacy API to make it fit a new interface
- Protecting your domain code from vendor-specific details

**When NOT to use:**
- The external interface already matches your needs — don't add a pass-through layer
- You're wrapping for wrapping's sake — only adapt when there's a meaningful mismatch

**Example:**
```python
# External payment library has its own API
class StripeClient:
    def charge_card(self, amount_cents, card_token, currency): ...

# Your domain expects this interface
class PaymentGateway:
    def charge(self, amount: Money, card: Card) -> PaymentResult: ...

# Adapter bridges the gap
class StripeAdapter(PaymentGateway):
    def __init__(self, stripe: StripeClient):
        self.stripe = stripe

    def charge(self, amount: Money, card: Card) -> PaymentResult:
        result = self.stripe.charge_card(
            amount_cents=amount.in_cents(),
            card_token=card.token,
            currency=amount.currency
        )
        return PaymentResult.from_stripe(result)
```

---

## Repository

**Problem:** Business logic is tightly coupled to the database or ORM, making it hard to test and hard to change persistence technology.

**When to use:**
- You want to test domain logic without a database
- You might change the persistence layer in the future
- Complex queries should be named and centralized

**When NOT to use:**
- Simple CRUD apps where the domain IS the data model — a repository adds ceremony without value
- Very early-stage projects — add it when the need is real

**Example:**
```python
# Without repository: ORM code in business logic
class OrderService:
    def get_unpaid_orders(self, user_id):
        return db.session.query(Order).filter(
            Order.user_id == user_id,
            Order.status == 'unpaid'
        ).all()

# With repository: domain logic decoupled from ORM
class OrderRepository:
    def find_unpaid_for_user(self, user_id: int) -> list[Order]: ...

class OrderService:
    def __init__(self, orders: OrderRepository):
        self.orders = orders

    def get_unpaid_orders(self, user_id):
        return self.orders.find_unpaid_for_user(user_id)
```

---

## Builder

**Problem:** Constructing a complex object requires many optional parameters, conditional configuration, or a multi-step setup process.

**When to use:**
- Objects with 5+ optional construction parameters
- Objects where construction order matters
- Creating different "flavors" of the same object

**When NOT to use:**
- Simple objects — just use keyword arguments or a factory
- Immutable value objects that can use named constructors

**Example:**
```typescript
// Without builder: 8-arg constructor
const email = new Email(to, from, subject, body, cc, bcc, isHtml, replyTo);

// With builder: readable, safe, flexible
const email = new EmailBuilder()
  .to(recipient)
  .from(sender)
  .subject('Your order shipped')
  .htmlBody(template.render(order))
  .replyTo(support)
  .build();
```

---

## Decorator

**Problem:** You need to add behavior to an object without modifying it — wrapping to extend functionality.

**When to use:**
- Cross-cutting concerns: logging, caching, retry, rate-limiting, auth
- Adding behavior to objects you don't control (third-party)
- Multiple independent features that can be combined

**When NOT to use:**
- Inheritance would be clearer (when the extension is a fundamental IS-A relationship)
- There's only one decorator — just subclass or extend directly
- The decorator chain becomes hard to debug

**Example:**
```python
class UserRepository:
    def find(self, id: int) -> User: ...

class CachedUserRepository(UserRepository):
    def __init__(self, inner: UserRepository, cache: Cache):
        self.inner = inner
        self.cache = cache

    def find(self, id: int) -> User:
        cached = self.cache.get(f'user:{id}')
        if cached:
            return cached
        user = self.inner.find(id)
        self.cache.set(f'user:{id}', user, ttl=300)
        return user

class LoggedUserRepository(UserRepository):
    def __init__(self, inner: UserRepository, logger: Logger):
        self.inner = inner
        self.logger = logger

    def find(self, id: int) -> User:
        self.logger.info(f'Looking up user {id}')
        return self.inner.find(id)

# Compose decorators
repo = LoggedUserRepository(
    CachedUserRepository(PostgresUserRepository(db), cache),
    logger
)
```
