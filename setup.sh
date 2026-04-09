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

# Create individual skill wrapper for each mode
# Each wrapper lets you call /scope, /build, /review etc. directly
create_mode_wrappers() {
  local skills_dir="$1"
  local core_dir="$2"

  declare -A DESCRIPTIONS=(
    ["scope"]="Evaluate whether something should be built — product, design, and engineering challenge before any code is written. Use when asked should we build this, product direction, feasibility, or before writing a spec."
    ["spec"]="Write a complete, testable specification before implementation begins. Use when asked to write a spec, define requirements, or document a feature before building it."
    ["build"]="Implement exactly what the spec defines — test first, clean code gate before each commit. Use when asked to build, implement, or create a feature from a spec."
    ["debug"]="Diagnose bugs and incidents — trace to root cause, scoped fix, regression test, RCA document. Use when there is a bug, error, production issue, or incident."
    ["review"]="Formal 5-pass code review covering structural integrity, code smells, anti-patterns, security, and spec conformance. Use when asked to review code or a PR."
    ["qa"]="Visual QA — multi-viewport screenshots, console error scan, accessibility check, spec UI criteria verification. Use when asked to check the UI, test visually, or QA a page."
    ["refactor"]="Incremental modernization with behavior tests first — one pattern at a time, never rewrites. Use when asked to refactor, modernize, or migrate legacy code."
    ["fix"]="Fast, minimal fix for trivial changes under 3 files — typos, config updates, small corrections. No ceremony. Use when asked for a quick fix or small update."
    ["retro"]="Engineering retrospective — analyze git history, detect patterns, update lessons.md, produce tech debt roadmap. Use when asked what did we learn or to run a retro."
    ["map"]="Explore an unfamiliar codebase and produce a structured mental model — entry points, module map, data flow, hotspots, where to start. Use when new to a codebase or asked how it works."
    ["adr"]="Write an Architecture Decision Record — context, options considered, decision, consequences. Use when asked to document a technical decision or write an ADR."
  )

  echo "  Creating skill commands:"
  for mode in scope spec build debug review qa refactor fix retro map adr; do
    local wrapper_dir="$skills_dir/$mode"

    # Warn if a skill with this name already exists (not from athena)
    if [[ -d "$wrapper_dir" ]] && ! grep -q "ATHENA" "$wrapper_dir/SKILL.md" 2>/dev/null; then
      echo "    ⚠ /$mode — skipped (a non-ATHENA skill already exists here)"
      continue
    fi

    mkdir -p "$wrapper_dir"
    cat > "$wrapper_dir/SKILL.md" <<EOF
---
name: $mode
description: >
  ${DESCRIPTIONS[$mode]}
---

You are running ATHENA in /$mode mode.

**Load context in this order before starting:**
1. If \`ATHENA.md\` exists in the project root — read it (project stack, rules, conventions)
2. If \`lessons.md\` exists in the project root — read it (accumulated project learnings)
3. Read and follow the mode file exactly: $core_dir/modes/$mode.md

The mode file defines the persona, workflow, output artifacts, and constraints for this skill.
Do not skip any step in the workflow. Produce the output artifacts defined in the mode file.
EOF
    echo "    ✓ /$mode"
  done
}

install_claude_code() {
  local global_skills="$HOME/.claude/skills"
  local local_skills="$PWD/.claude/skills"

  echo "  Where do you want to install ATHENA?"
  echo "  [1] Global  — available in all projects (~/.claude/skills/)"
  echo "  [2] Local   — this project only (.claude/skills/)"
  echo ""
  read -rp "  Choice [1/2]: " choice

  if [[ "$choice" == "2" ]]; then
    SKILLS_DIR="$local_skills"
  else
    SKILLS_DIR="$global_skills"
  fi

  # Install core files
  local CORE="$SKILLS_DIR/athena"
  mkdir -p "$CORE"
  cp -r "$ATHENA_DIR"/. "$CORE/"
  echo ""
  echo "  ✓ Core installed: $CORE"
  echo ""

  # Create per-mode skill wrappers
  create_mode_wrappers "$SKILLS_DIR" "$CORE"

  echo ""
  echo "  ✓ Done. Call skills directly in Claude Code:"
  echo ""
  echo "    /scope \"Should we build X?\""
  echo "    /spec \"User authentication with OAuth\""
  echo "    /build specs/auth.md"
  echo "    /review src/controllers/"
  echo "    /debug \"checkout fails for EU users\""
  echo "    /qa http://localhost:3000"
  echo "    /refactor src/legacy/"
  echo "    /fix \"fix typo in error message\""
  echo "    /retro --last 7d"
  echo "    /map"
  echo "    /adr \"chose PostgreSQL over MongoDB\""
  echo ""
  echo "  Or with the unified entry point: /athena [mode] [args]"
  echo ""
}

uninstall_claude_code() {
  local skills_dir="${1:-$HOME/.claude/skills}"
  echo "  Removing ATHENA skills from $skills_dir..."
  rm -rf "$skills_dir/athena"
  for mode in scope spec build debug review qa refactor fix retro map adr; do
    if [[ -f "$skills_dir/$mode/SKILL.md" ]] && grep -q "ATHENA" "$skills_dir/$mode/SKILL.md" 2>/dev/null; then
      rm -rf "$skills_dir/$mode"
      echo "    ✓ removed /$mode"
    fi
  done
  echo "  ✓ ATHENA uninstalled."
}

install_cursor() {
  local rules_dir="$PWD/.cursor/rules"
  mkdir -p "$rules_dir"

  cp "$ATHENA_DIR/SKILL.md" "$rules_dir/athena.md"
  cp -r "$ATHENA_DIR/modes" "$rules_dir/athena-modes"
  cp -r "$ATHENA_DIR/references" "$rules_dir/athena-references"

  echo "  ✓ ATHENA installed to: $rules_dir"
  echo ""
  echo "  Use natural language in Cursor:"
  echo "    \"Should we build X?\"  →  scope mode"
  echo "    \"Write a spec for X\"  →  spec mode"
  echo "    \"Review this code\"    →  review mode"
  echo ""
}

install_generic() {
  local platform="$1"
  local target="$PWD/.athena"

  mkdir -p "$target"
  cp -r "$ATHENA_DIR"/. "$target/"

  echo "  ✓ ATHENA copied to: $target"
  echo ""
  echo "  Manual setup for $platform:"
  echo "  Point your agent at ATHENA.md in your project root and"
  echo "  add the following to your agent's context path: $target"
  echo ""
  echo "  See INSTALL.md for $platform-specific instructions."
  echo ""
}

# Handle uninstall flag
if [[ "${1:-}" == "--uninstall" ]]; then
  uninstall_claude_code "${2:-$HOME/.claude/skills}"
  exit 0
fi

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
  echo "  (Your stack, rules, and conventions — loaded on every invocation)"
  read -rp "  Create ATHENA.md? [y/n]: " create_athena

  if [[ "$create_athena" == "y" || "$create_athena" == "Y" ]]; then
    cp "$ATHENA_DIR/ATHENA.md.template" "$PWD/ATHENA.md"
    echo ""
    echo "  ✓ Created ATHENA.md — edit it to add your project's stack and rules."
    echo ""
  fi
fi

# Offer to initialize lessons.md
if command -v claude &>/dev/null && [[ ! -f "$PWD/lessons.md" ]] && [[ -d "$PWD/.git" ]]; then
  echo "  Would you like to initialize lessons.md from your git history?"
  read -rp "  Run /retro --last 30d? [y/n]: " run_retro

  if [[ "$run_retro" == "y" || "$run_retro" == "Y" ]]; then
    echo ""
    echo "  Run this in Claude Code: /retro --last 30d"
    echo ""
  fi
fi

echo "  ─────────────────────────────────────────"
echo "  ATHENA setup complete."
echo ""
echo "  Docs:          docs/workflows.md"
echo "  Customization: docs/customization.md"
echo "  Uninstall:     ./setup.sh --uninstall"
echo ""
