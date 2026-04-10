# ATHENA — Installation

Platform-specific setup for Claude Code, Codex, Cursor, Gemini CLI, and OpenCode.

---

## Quick install (all platforms)

```bash
git clone https://github.com/[your-org]/athena.git
cd athena
./setup.sh
```

`setup.sh` detects your platform and installs automatically.

---

## Claude Code

### Install

```bash
git clone https://github.com/[your-org]/athena.git
cd athena
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

Or use the unified entry point: `/athena [mode] [args]`

### How it works

The installer creates two things in `~/.claude/skills/`:

```
~/.claude/skills/
├── athena/          ← core: modes/, references/, templates/
├── challenge/           ← thin wrapper → loads athena/modes/challenge.md
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

Each wrapper loads your project's `ATHENA.md` and `lessons.md` first, then hands off to the full mode workflow.

### Setup project constitution

```bash
cp ~/.claude/skills/athena/ATHENA.md.template ./ATHENA.md
# Edit: stack, architecture, rules, test commands
```

### Initialize lessons

```
/hunt --last 30d
```

### Uninstall

```bash
cd ~/.claude/skills/athena && ./setup.sh --uninstall
```

Removes all ATHENA skill wrappers and the core. Non-ATHENA skills are untouched.

---

## Codex

Codex uses a `.codex/` directory or a `AGENTS.md` file for agent context.

### Setup

```bash
git clone https://github.com/[your-org]/athena.git /path/to/athena

# Copy ATHENA files to your project
mkdir -p .codex/athena
cp -r /path/to/athena/* .codex/athena/

# Copy the project constitution template
cp /path/to/athena/ATHENA.md.template ./ATHENA.md
```

### Agent configuration

Add to your `AGENTS.md` or Codex configuration:
```markdown
## Context
Load the following files for context:
- ATHENA.md (project constitution)
- lessons.md (if present)
- .codex/athena/SKILL.md (ATHENA routing)

## Reference directories
- .codex/athena/modes/
- .codex/athena/references/
- .codex/athena/templates/
```

### Usage

Invoke modes naturally:
```
"Use ATHENA to challenge this feature: [description]"
"Run /blueprint for: [feature]"
"Guard review: src/controllers/"
```

---

## Cursor

Cursor reads rules from `.cursor/rules/` in the project directory.

### Setup

```bash
git clone https://github.com/[your-org]/athena.git /path/to/athena

mkdir -p .cursor/rules
cp /path/to/athena/SKILL.md .cursor/rules/athena.md
cp -r /path/to/athena/modes .cursor/rules/athena-modes
cp -r /path/to/athena/references .cursor/rules/athena-references
cp /path/to/athena/ATHENA.md.template ./ATHENA.md
```

### Usage in Cursor

ATHENA rules are automatically loaded by Cursor. Use natural language:
```
Challenge this feature: [description]
Write a spec for: [feature]
Review this code for quality issues
Investigate this bug: [description]
```

Or explicit mode invocation:
```
/athena review src/
/athena spec "user authentication"
```

---

## Gemini CLI

Gemini CLI supports context files via `GEMINI.md` or project-specific context configuration.

### Setup

```bash
git clone https://github.com/[your-org]/athena.git /path/to/athena

# Copy to project
cp -r /path/to/athena /path/to/your-project/.athena
cp /path/to/athena/ATHENA.md.template ./ATHENA.md
```

### Configuration

Add to your project's Gemini configuration or `GEMINI.md`:
```markdown
## ATHENA Workflow System
Context: ./ATHENA.md
Context: ./lessons.md
Reference: ./.athena/SKILL.md
Reference: ./.athena/modes/
Reference: ./.athena/references/
```

### Usage

```
/athena scope "Should we build X?"
/athena spec "Feature description"
/athena review src/
```

---

## OpenCode

OpenCode supports skills directories similar to Claude Code.

### Setup

```bash
git clone https://github.com/[your-org]/athena.git ~/.opencode/skills/athena
cp ~/.opencode/skills/athena/ATHENA.md.template ./ATHENA.md
```

### Usage

```
/athena [mode] [args]
```

---

## Post-install checklist

After installing on any platform:

- [ ] `ATHENA.md` created in project root and filled in with stack + rules
- [ ] `lessons.md` initialized (run `/athena retro --last 30d`)
- [ ] Test basic invocation: `/athena fix "test"`
- [ ] Review `docs/workflows.md` for standard workflows
- [ ] Review `docs/customization.md` to tune ATHENA for your team
