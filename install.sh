#!/usr/bin/env bash
# Installer for super-loop and super-loop-advanced CLI and skills

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BIN_TARGET="${HOME}/.local/bin"

echo "==> Installing super-loop and super-loop-advanced..."

# 1. Install CLI scripts
mkdir -p "$BIN_TARGET"
cp -f "${SCRIPT_DIR}/bin/super-loop" "$BIN_TARGET/super-loop"
cp -f "${SCRIPT_DIR}/bin/super-loop-advanced" "$BIN_TARGET/super-loop-advanced"
chmod +x "$BIN_TARGET/super-loop" "$BIN_TARGET/super-loop-advanced"
echo "✓ Installed CLI scripts in ${BIN_TARGET}"

# Check PATH
if [[ ":$PATH:" != *":$BIN_TARGET:"* ]]; then
  echo "Notice: ${BIN_TARGET} is not in your PATH. Add it to your shell config (~/.bashrc or ~/.zshrc):"
  echo "  export PATH=\"\$HOME/.local/bin:\$PATH\""
fi

# 2. Install agent skills
SKILLS_TARGETS=(
  "${HOME}/.gemini/config/skills"
  "${HOME}/.antigravity-rc/.gemini/config/skills"
)

INSTALLED_SKILL=false
for target in "${SKILLS_TARGETS[@]}"; do
  if [ -d "$target" ] || [ -d "$(dirname "$target")" ]; then
    mkdir -p "$target/super-loop" "$target/super-loop-advanced"
    cp -f "${SCRIPT_DIR}/skills/super-loop/SKILL.md" "$target/super-loop/"
    cp -f "${SCRIPT_DIR}/skills/super-loop-advanced/SKILL.md" "$target/super-loop-advanced/"
    echo "✓ Installed agent skills in ${target}"
    INSTALLED_SKILL=true
  fi
done

if [ "$INSTALLED_SKILL" = false ]; then
  # Fallback: create default skills directory
  DEFAULT_TARGET="${HOME}/.gemini/config/skills"
  mkdir -p "$DEFAULT_TARGET/super-loop" "$DEFAULT_TARGET/super-loop-advanced"
  cp -f "${SCRIPT_DIR}/skills/super-loop/SKILL.md" "$DEFAULT_TARGET/super-loop/"
  cp -f "${SCRIPT_DIR}/skills/super-loop-advanced/SKILL.md" "$DEFAULT_TARGET/super-loop-advanced/"
  echo "✓ Installed agent skills in ${DEFAULT_TARGET}"
fi

echo ""
echo "Installation complete!"
echo "Run 'super-loop --help' or 'super-loop-advanced --help' to get started."
