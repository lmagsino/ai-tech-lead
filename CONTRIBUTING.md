# Contributing to AI TECH LEAD

AI TECH LEAD is open source. Contributions are welcome — modes, references, templates, and fixes.

---

## What's worth contributing

- **Mode improvements** — better workflows, tighter personas, sharper examples
- **Reference additions** — new `references/` docs (AI patterns, security, architecture)
- **Bug fixes** — broken handoffs, incorrect file references, typos
- **New examples** — filled `AI-TECH-LEAD.md` examples for different stack configurations

**What's not worth contributing:**
- Brownfield or legacy-focused modes — AI TECH LEAD is greenfield-only by design
- Generic engineering content not specific to AI-native development
- Complexity for its own sake — if it makes the system harder to understand, it's wrong

---

## How modes work

Each mode is a markdown file in `modes/` with this structure:

```
---
name: ai-tech-lead-[mode]
description: [one-liner for Claude's skill picker]
---

# [Mode Name] — [AI Tech Lead's role]

## Persona        — how she sounds and behaves in this mode
## When to use    — trigger conditions
## Scope          — greenfield only
## Context to load — which references/ files to load
## Handoff        — receives, produces, next mode
## Workflow       — numbered steps, exact and complete
## Output artifacts — what gets saved and where
## Constraints    — what she never skips or violates
## Examples       — 2-3 concrete input/output examples
```

The persona section is the most important. It must be behavioral — what she does, how she opens, what she never skips — not just a job title description.

---

## Making a change

1. Fork the repo
2. Create a branch: `feature/[what-you're-changing]`
3. Make your change
4. Test it — install locally with `./setup.sh` and verify the mode works as described
5. Open a PR with a clear description of what changed and why

---

## PR expectations

- One change per PR — don't bundle unrelated changes
- Mode changes must include updated examples
- Reference doc changes must be grounded in real engineering practice — no vague advice
- All mode references must use the current mode names: `challenge`, `blueprint`, `forge`, `guard`, `hunt`, `launch`

---

## Installing locally for testing

```bash
git clone https://github.com/[owner]/ai-tech-lead.git
cd ai-tech-lead
./setup.sh
```

Then in Claude Code, verify your mode works:
```
/challenge "test prompt"
```

---

## Questions

Open an issue. Be specific about what you're trying to do.
