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
# Each wrapper lets you call /challenge, /forge, /guard etc. directly
create_mode_wrappers() {
  local skills_dir="$1"
  local core_dir="$2"

  declare -A DESCRIPTIONS=(
    ["strategist"]="Challenge whether a product is worth building — interrogates market, competition, monetization, and distribution before design or code. Use when starting a new product or asking is this worth doing. Produces STRATEGY.md."
    ["designer"]="Design the product experience — user journeys, AI-first interactions, screen-by-screen specs. Reads STRATEGY.md. Produces DESIGN.md ready for engineering. Use when planning UX or designing a new product."
    ["challenge"]="Challenge whether something should be built — interrogate product direction, feasibility, and approach before any code is written. Always asks if there is an AI-native version. Use when asked should we build this, product direction, or before writing a spec."
    ["blueprint"]="Design the blueprint — probe for gaps, design AI components, produce an approved spec. Includes AI component design by default — model selection, prompt design, evals, fallbacks, cost estimate. Use when asked to write a spec or define requirements."
    ["forge"]="Forge the implementation from the blueprint — AI infrastructure first, then tests, then code. Use when asked to build, implement, or create a feature from a spec."
    ["guard"]="Guard the quality gate — 5-pass review: structural integrity, code smells, security (including prompt injection), clean code, and AI component review. Use when asked to review code or a PR."
    ["hunt"]="Hunt bugs and AI failures to their root cause — classify first, trace the causal chain, regression test, RCA document. Handles both code bugs and AI bugs (hallucinations, prompt drift, output schema failures). Use when there is a bug, error, or AI quality issue."
    ["launch"]="Launch checklist for AI-native applications — functionality, AI systems, security, infrastructure. Produces GO / NO-GO recommendation. Use when ready to launch or deploy."
  )

  echo "  Creating skill commands:"
  for mode in strategist designer challenge blueprint forge guard hunt launch; do
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
  echo "    /strategist \"AI inventory tool for restaurants\""
  echo "    /designer"
  echo "    /challenge \"Should we add AI-powered recommendations?\""
  echo "    /blueprint \"Conversational onboarding with LLM\""
  echo "    /forge specs/onboarding.md"
  echo "    /guard src/"
  echo "    /hunt \"AI responses are hallucinating product names\""
  echo "    /launch"
  echo ""
  echo "  Or with the unified entry point: /athena [mode] [args]"
  echo ""
}

uninstall_claude_code() {
  local skills_dir="${1:-$HOME/.claude/skills}"
  echo "  Removing ATHENA skills from $skills_dir..."
  rm -rf "$skills_dir/athena"
  for mode in strategist designer challenge blueprint forge guard hunt launch; do
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
  echo "    \"Should we build X?\"  →  challenge mode"
  echo "    \"Write a spec for X\"  →  blueprint mode"
  echo "    \"Review this code\"    →  guard mode"
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

echo "  ─────────────────────────────────────────"
echo "  ATHENA setup complete."
echo ""
echo "  Docs:          docs/workflows.md"
echo "  Customization: docs/customization.md"
echo "  Uninstall:     ./setup.sh --uninstall"
echo ""
