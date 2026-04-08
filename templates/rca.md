# RCA: [Brief Description]

> Date: [date]
> Severity: P1 | P2 | P3 | P4
> Duration: [how long the incident lasted]
> Author: [who wrote this RCA]

---

## Summary

[1-2 sentences: what broke, what the impact was, what fixed it.]

---

## Timeline

| Time | Event |
|------|-------|
| [time] | [what happened — be specific] |
| [time] | [first alert / user report] |
| [time] | [investigation started] |
| [time] | [root cause identified] |
| [time] | [fix deployed] |
| [time] | [incident resolved] |

---

## Impact

- **Users affected:** [count or scope — e.g. "all EU users", "~200 accounts"]
- **Duration:** [how long the issue was live]
- **Data loss:** [yes/no, and details if yes]
- **Revenue impact:** [if applicable]
- **SLA breach:** [yes/no]

---

## Root cause

[Clear explanation of WHY this happened — not symptoms, but the underlying cause. A non-engineer should be able to read this and understand it.]

---

## Contributing factors

[What conditions allowed this to happen? e.g. missing tests, no alerts, unclear ownership]

- [Factor 1]
- [Factor 2]

---

## Fix

[What was changed to resolve the issue.]

- **PR / Commit:** [link]
- **Regression test:** [description of the test added to prevent recurrence]

---

## Prevention

[What we will do to prevent this class of issue in the future. Be specific — not "be more careful".]

| Action | Owner | Due |
|--------|-------|-----|
| [specific action] | [who] | [date] |

---

## Monitoring

[What alerts, checks, or dashboards should be added or updated as a result of this incident?]
