# Visual QA Report: [Target]

> Date: [date]
> URL: [tested URL or local address]
> Spec: [spec file, if provided — "none" if not]

---

## Viewport results

| Viewport | Dimensions | Status | Issues found |
|----------|-----------|--------|-------------|
| Mobile | 375×812 | PASS / FAIL | [count] |
| Tablet | 768×1024 | PASS / FAIL | [count] |
| Desktop | 1440×900 | PASS / FAIL | [count] |

---

## Screenshots

| Viewport | File |
|----------|------|
| Mobile | `screenshots/mobile-[date].png` |
| Tablet | `screenshots/tablet-[date].png` |
| Desktop | `screenshots/desktop-[date].png` |

---

## Console errors

[List all console.error, console.warn, uncaught exceptions, and failed network requests. "None" if clean.]

| Type | Message | Source | Line |
|------|---------|--------|------|
| [error / warn / 4xx / 5xx] | [message] | [file] | [line] |

---

## Accessibility

| Check | Status | Details |
|-------|--------|---------|
| Color contrast (WCAG AA — 4.5:1 normal, 3:1 large) | PASS / FAIL | [details] |
| Focus indicators on interactive elements | PASS / FAIL | [details] |
| Alt text on images | PASS / FAIL | [details] |
| Semantic HTML (heading order, landmarks present) | PASS / FAIL | [details] |

---

## Spec UI criteria

> Only present if a spec was provided.

| Criterion | Status | Screenshot | Notes |
|-----------|--------|-----------|-------|
| [from spec] | PASS / FAIL | [file] | [details] |

---

## Interactive flow results

| Step | Action | Expected | Actual | Status |
|------|--------|----------|--------|--------|
| 1 | [action] | [expected] | [actual] | PASS / FAIL |

---

## Issues

> All failures consolidated, ordered by severity.

### [SEVERITY] — [Issue title]

- **Viewport(s):** [which viewports affected]
- **Description:** [what's wrong]
- **Screenshot:** `[file]`
- **Fix:** [how to address it]
