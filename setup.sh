#!/usr/bin/env bash
set -euo pipefail

ATHENA_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo ""
echo "  ATHENA — Setup"
echo "  ─────────────────────────────────────────"
echo ""

# Detect which coding agent is installed
detect_platform() {
  if command -v claude &>/dev/null; then
    echo "claude-code"
  elif command -v codex &>/dev/null; then
    echo "codex"
  elif command -v cursor &>/dev/null; then
    echo "cursor"
  elif command -v gemini &>/dev/null; then
    echo "gemini"
  elif command -v opencode &>/dev/null; then
    echo "opencode"
  else
    echo "unknown"
  fi
}

PLATFORM=$(detect_platform)

echo "  Detected platform: $PLATFORM"
echo ""

install_claude_code() {
  # Claude Code looks for skills in ~/.claude/skills/ or the project's .claude/skills/
  local global_skills="$HOME/.claude/skills"
  local local_skills="$PWD/.claude/skills"

  echo "  Where do you want to install ATHENA?"
  echo "  [1] Global  — available in all projects (~/.claude/skills/athena/)"
  echo "  [2] Local   — this project only (.claude/skills/athena/)"
  echo ""
  read -rp "  Choice [1/2]: " choice

  if [[ "$choice" == "2" ]]; then
    TARGET="$local_skills/athena"
  else
    TARGET="$global_skills/athena"
  fi

  mkdir -p "$TARGET"

  # Copy all ATHENA files
  cp -r "$ATHENA_DIR"/* "$TARGET/"

  echo ""
  echo "  ✓ ATHENA installed to: $TARGET"
  echo ""
  echo "  Usage:"
  echo "    /athena scope \"Should we build X?\""
  echo "    /athena spec \"Feature description\""
  echo "    /athena review src/"
  echo "    /athena build specs/feature.md"
  echo "    /athena retro --last 7d"
  echo ""
}

install_cursor() {
  # Cursor uses .cursorrules or .cursor/rules/ directory
  local rules_dir="$PWD/.cursor/rules"
  mkdir -p "$rules_dir"

  # Copy SKILL.md as the primary rules file
  cp "$ATHENA_DIR/SKILL.md" "$rules_dir/athena.md"

  # Copy modes and references
  cp -r "$ATHENA_DIR/modes" "$rules_dir/athena-modes"
  cp -r "$ATHENA_DIR/references" "$rules_dir/athena-references"

  echo "  ✓ ATHENA installed to: $rules_dir"
  echo ""
  echo "  Cursor setup: ATHENA rules are now active in this project."
  echo "  Use natural language to invoke modes:"
  echo "    \"Challenge this feature: ...\""
  echo "    \"Write a spec for: ...\""
  echo "    \"Review this code\""
  echo ""
}

install_generic() {
  local platform="$1"
  local target="$PWD/.athena"

  mkdir -p "$target"
  cp -r "$ATHENA_DIR"/* "$target/"

  echo "  ✓ ATHENA copied to: $target"
  echo ""
  echo "  Manual setup for $platform:"
  echo "  Point your agent at ATHENA.md in your project root and"
  echo "  add the following to your agent's context path:"
  echo "    $target"
  echo ""
  echo "  See INSTALL.md for $platform-specific instructions."
  echo ""
}

# Run platform-specific installer
case "$PLATFORM" in
  claude-code)
    install_claude_code
    ;;
  cursor)
    install_cursor
    ;;
  codex|gemini|opencode|unknown)
    install_generic "$PLATFORM"
    ;;
esac

# Copy ATHENA.md.template to project root if not already present
if [[ ! -f "$PWD/ATHENA.md" ]]; then
  echo "  Would you like to create ATHENA.md in the current project?"
  echo "  (This is the project constitution — your stack, rules, and conventions)"
  read -rp "  Create ATHENA.md? [y/n]: " create_athena

  if [[ "$create_athena" == "y" || "$create_athena" == "Y" ]]; then
    cp "$ATHENA_DIR/ATHENA.md.template" "$PWD/ATHENA.md"
    echo ""
    echo "  ✓ Created ATHENA.md — edit it to add your project's stack and rules."
    echo ""
  fi
fi

# Offer to run retro to initialize lessons.md
if command -v claude &>/dev/null && [[ ! -f "$PWD/lessons.md" ]] && [[ -d "$PWD/.git" ]]; then
  echo "  Would you like to run /athena retro to initialize lessons.md?"
  echo "  (Analyzes your git history and creates an initial lessons file)"
  read -rp "  Run retro? [y/n]: " run_retro

  if [[ "$run_retro" == "y" || "$run_retro" == "Y" ]]; then
    echo ""
    echo "  Run this in Claude Code:"
    echo "    /athena retro --last 30d"
    echo ""
  fi
fi

echo "  ─────────────────────────────────────────"
echo "  ATHENA setup complete."
echo ""
echo "  Docs: docs/workflows.md"
echo "  Customization: docs/customization.md"
echo "  Modes: /scope /spec /build /debug /review /qa /refactor /fix /retro"
echo ""
