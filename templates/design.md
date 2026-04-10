# DESIGN: [Product Name]

> Status: DRAFT | APPROVED
> Date: [date]
> Strategy: [link to STRATEGY.md]

---

## Core user journey

[The primary flow in plain language — before touching screens. "The user has [problem]. They open the app wanting to [goal]. They [step 1] → [step 2] → [step 3]. The moment of value is when [outcome]."]

**Entry point:** [How does the user first land here? Direct open, notification, email link, invite?]

**Moment of value:** [The specific moment the user gets the thing they came for. Everything in the design should accelerate arriving here.]

---

## AI interaction map

> Where AI replaces or enhances manual interactions. Every AI-powered interaction must have a fallback state.

| Interaction | Without AI | With AI | Fallback if AI fails |
|-------------|-----------|---------|---------------------|
| [e.g., Onboarding] | [6-step form] | [Single conversation prompt → AI infers setup] | [Show form as fallback] |
| [e.g., Search] | [Keyword filter] | [Semantic intent search] | [Fall back to keyword] |

---

## Information architecture

**Navigation pattern:** [Tab bar / sidebar / single-flow / contextual / hub-and-spoke]
**Reasoning:** [Why this pattern for this product and user. Reference comparable products if useful.]

**Top-level sections:**
1. [Section name] — [one sentence purpose]
2. [Section name] — [one sentence purpose]
3. [Section name] — [one sentence purpose]

---

## Screen inventory

| Screen | Purpose | Entry | Primary action |
|--------|---------|-------|---------------|
| [Screen name] | [what it does] | [how you get here] | [main thing user does] |

---

## Screen-by-screen specs

---

### [Screen name]

**Purpose:** [What the user accomplishes on this screen]

**Layout:** [Structure — not visual design. e.g., "Header with title + action button. Scrollable list of cards. Empty state when no items."]

**Components:**
- [Component]: [what it is and what it does]
- [Component]: [what it is and what it does]

**States:**
- **Empty:** [What the user sees with no data — not a blank screen]
- **Loading:** [What the user sees while data loads or AI is processing]
- **Populated:** [Normal state with content]
- **Error:** [What the user sees on failure]

**Primary action:** [The main thing the user does here → what happens]

**AI interactions:** [Where AI output appears on this screen, loading state, confidence handling, fallback]

**Edge cases:**
- [What if X?]
- [What if Y?]

---

## Design decisions

| Decision | Choice | Reasoning |
|----------|--------|-----------|
| [Navigation pattern] | [What was chosen] | [Why — what did this optimize for?] |
| [AI interaction design] | [Approach taken] | [Why conversation vs. form, etc.] |
| [Major UX tradeoff] | [What was chosen] | [What was sacrificed and why it was worth it] |

---

## Out of scope

> Features and interactions explicitly excluded from this design. Prevents scope creep during engineering.

- [Not designing X — why]
- [Not designing Y — why]
