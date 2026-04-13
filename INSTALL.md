# AI TECH LEAD — Installation

Platform-specific setup for Claude Code, Codex, Cursor, Gemini CLI, and OpenCode.

---

## Quick install (all platforms)

```bash
git clone https://github.com/[your-org]/ai-tech-lead.git
cd ai-tech-lead
./setup.sh
```

`setup.sh` detects your platform and installs automatically.

---

## Claude Code

### Install

```bash
git clone https://github.com/[your-org]/ai-tech-lead.git
cd ai-tech-lead
./setup.sh
```

`setup.sh` installs the core and creates individual skill commands so each mode is callable directly:

```
/challenge "Should we build this?"
/blueprint "User authentication with OAuth"
/forge specs/auth.md
/guard src/controllers/
/hunt "checkout fails for EU users"
/guard http://localhost:3000
/forge src/legacy/
/forge "fix typo in error message"
/hunt --last 7d

 "chose PostgreSQL over MongoDB"
```

Or use the unified entry point: `/ai-tech-lead [mode] [args]`

### How it works

The installer creates two things in `~/.claude/skills/`:

```
~/.claude/skills/
├── ai-tech-lead/          ← core: modes/, references/, templates/
├── challenge/           ← thin wrapper → loads ai-tech-lead/modes/challenge.md
├── blueprint/
├── forge/
├── hunt/
├── guard/
├── 
├── 
├── 
├── 
├── 
└── 
```

Each wrapper loads your project's `AI-TECH-LEAD.md` and `lessons.md` first, then hands off to the full mode workflow.

### Setup project constitution

```bash
cp ~/.claude/skills/ai-tech-lead/AI-TECH-LEAD.md.template ./AI-TECH-LEAD.md
# Edit: stack, architecture, rules, test commands
```

### Initialize lessons

```
/hunt --last 30d
```

### Uninstall

```bash
cd ~/.claude/skills/ai-tech-lead && ./setup.sh --uninstall
```

Removes all AI TECH LEAD skill wrappers and the core. Non-AI TECH LEAD skills are untouched.

---

## Codex

Codex uses a `.codex/` directory or a `AGENTS.md` file for agent context.

### Setup

```bash
git clone https://github.com/[your-org]/ai-tech-lead.git /path/to/ai-tech-lead

# Copy AI TECH LEAD files to your project
mkdir -p .codex/ai-tech-lead
cp -r /path/to/ai-tech-lead/* .codex/ai-tech-lead/

# Copy the project constitution template
cp /path/to/ai-tech-lead/AI-TECH-LEAD.md.template ./AI-TECH-LEAD.md
```

### Agent configuration

Add to your `AGENTS.md` or Codex configuration:
```markdown
## Context
Load the following files for context:
- AI-TECH-LEAD.md (project constitution)
- lessons.md (if present)
- .codex/ai-tech-lead/SKILL.md (AI TECH LEAD routing)

## Reference directories
- .codex/ai-tech-lead/modes/
- .codex/ai-tech-lead/references/
- .codex/ai-tech-lead/templates/
```

### Usage

Invoke modes naturally:
```
"Use AI TECH LEAD to challenge this feature: [description]"
"Run /blueprint for: [feature]"
"Guard review: src/controllers/"
```

---

## Cursor

Cursor reads rules from `.cursor/rules/` in the project directory.

### Setup

```bash
git clone https://github.com/[your-org]/ai-tech-lead.git /path/to/ai-tech-lead

mkdir -p .cursor/rules
cp /path/to/ai-tech-lead/SKILL.md .cursor/rules/ai-tech-lead.md
cp -r /path/to/ai-tech-lead/modes .cursor/rules/ai-tech-lead-modes
cp -r /path/to/ai-tech-lead/references .cursor/rules/ai-tech-lead-references
cp /path/to/ai-tech-lead/AI-TECH-LEAD.md.template ./AI-TECH-LEAD.md
```

### Usage in Cursor

AI TECH LEAD rules are automatically loaded by Cursor. Use natural language:
```
Challenge this feature: [description]
Write a spec for: [feature]
Review this code for quality issues
Investigate this bug: [description]
```

Or explicit mode invocation:
```
/guard src/
/blueprint "user authentication"
```

---

## Gemini CLI

Gemini CLI supports context files via `GEMINI.md` or project-specific context configuration.

### Setup

```bash
git clone https://github.com/[your-org]/ai-tech-lead.git /path/to/ai-tech-lead

# Copy to project
cp -r /path/to/ai-tech-lead /path/to/your-project/.ai-tech-lead
cp /path/to/ai-tech-lead/AI-TECH-LEAD.md.template ./AI-TECH-LEAD.md
```

### Configuration

Add to your project's Gemini configuration or `GEMINI.md`:
```markdown
## AI TECH LEAD Workflow System
Context: ./AI-TECH-LEAD.md
Context: ./lessons.md
Reference: ./.ai-tech-lead/SKILL.md
Reference: ./.ai-tech-lead/modes/
Reference: ./.ai-tech-lead/references/
```

### Usage

```
/challenge "Should we build X?"
/blueprint "Feature description"
/guard src/
```

---

## OpenCode

OpenCode supports skills directories similar to Claude Code.

### Setup

```bash
git clone https://github.com/[your-org]/ai-tech-lead.git ~/.opencode/skills/ai-tech-lead
cp ~/.opencode/skills/ai-tech-lead/AI-TECH-LEAD.md.template ./AI-TECH-LEAD.md
```

### Usage

```
/ai-tech-lead [mode] [args]
```

---

## Post-install checklist

After installing on any platform:

- [ ] `AI-TECH-LEAD.md` created in project root and filled in with stack + rules
- [ ] `lessons.md` initialized (run `/ai-tech-lead retro --last 30d`)
- [ ] Test basic invocation: `/forge "test"`
- [ ] Review `docs/workflows.md` for standard workflows
- [ ] Review `docs/customization.md` to tune AI TECH LEAD for your team
