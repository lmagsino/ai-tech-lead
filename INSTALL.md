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

### Option 1: Plugin marketplace (recommended)

Search for "ATHENA" in the Claude Code skill marketplace and install directly.

### Option 2: Manual install

**Global** (available in all projects):
```bash
mkdir -p ~/.claude/skills
git clone https://github.com/[your-org]/athena.git ~/.claude/skills/athena
```

**Local** (this project only):
```bash
mkdir -p .claude/skills
git clone https://github.com/[your-org]/athena.git .claude/skills/athena
```

### Verify installation

Open Claude Code in any project and run:
```
/athena patch "test installation"
```

You should see ATHENA respond with the patch workflow.

### Setup project constitution

```bash
cp ~/.claude/skills/athena/ATHENA.md.template ./ATHENA.md
# Edit ATHENA.md with your project's stack, rules, and conventions
```

### Initialize lessons

```
/athena retro --last 30d
```

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
"Run /spec for: [feature]"
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
/athena guard src/
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
/athena challenge "Should we build X?"
/athena spec "Feature description"
/athena guard src/
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
- [ ] Test basic invocation: `/athena patch "test"`
- [ ] Review `docs/workflows.md` for standard workflows
- [ ] Review `docs/customization.md` to tune ATHENA for your team
