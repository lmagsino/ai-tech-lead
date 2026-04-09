# RCA: [Brief Description]

> Date: [date]
> Severity: P1 | P2 | P3 | P4
> Duration: [how long the incident lasted]
> Author: [who wrote this RCA]
> Bug type: CODE | AI | INFRASTRUCTURE

---

## Summary

[1-2 sentences: what broke, what the impact was, what fixed it. Must be readable by a non-engineer.]

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

---

## Root cause

[Clear explanation of WHY this happened — not symptoms, but the underlying cause. A non-engineer should be able to read this and understand it.]

---

## AI-specific context

> Complete this section for AI bugs (type: AI). Delete if type is CODE or INFRASTRUCTURE.

- **Failure characterization:** HALLUCINATION | PROMPT DRIFT | SCHEMA MISMATCH | CONTEXT OVERFLOW | RATE LIMIT | MODEL CHANGE | OTHER
- **Model version at time of incident:** [e.g. claude-sonnet-4-6]
- **Prompt snapshot:** [paste the exact system prompt that was active during the incident, or link to the git commit]
- **Example bad input:** [the input that triggered the failure]
- **Example bad output:** [what the model returned]
- **Expected output:** [what it should have returned]
- **Was this consistent or intermittent?** [consistent / intermittent — if intermittent, at what rate?]

---

## Contributing factors

[What conditions allowed this to happen? e.g. missing tests, no alerts, unclear ownership, no eval coverage]

- [Factor 1]
- [Factor 2]

---

## Fix

[What was changed to resolve the issue.]

- **PR / Commit:** [link]
- **Regression test:** [description of the test added to prevent recurrence]
- **Eval test case added:** [yes/no — for AI bugs, always yes. Describe the case.]

---

## Prevention

[What we will do to prevent this class of issue in the future. Be specific — not "be more careful".]

| Action | Owner | Due |
|--------|-------|-----|
| [specific action] | [who] | [date] |

---

## Monitoring

[What alerts, checks, or dashboards should be added or updated as a result of this incident?]
