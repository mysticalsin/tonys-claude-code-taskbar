#!/bin/bash
# Symlink dotfiles into their live locations. Idempotent & safe:
# backs up any existing real file before linking.
set -e
R="$(cd "$(dirname "$0")" && pwd)"

link() { # $1 = path relative to $HOME
  local rel="$1" src="$R/$1" dst="$HOME/$1"
  mkdir -p "$(dirname "$dst")"
  if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
    echo "ok   $dst"; return
  fi
  if [ -e "$dst" ] && [ ! -L "$dst" ]; then
    mv "$dst" "$dst.pre-dotfiles.bak"
    echo "bak  $dst -> $dst.pre-dotfiles.bak"
  fi
  ln -sf "$src" "$dst"
  echo "link $dst -> $src"
}

link ".claude/bin/cc-health.sh"
link ".claude/bin/cc-tokens"
link ".config/ccstatusline/settings.json"

chmod +x "$R/.claude/bin/cc-health.sh" "$R/.claude/bin/cc-tokens"

command -v ccstatusline >/dev/null 2>&1 \
  && echo "ccstatusline: $(ccstatusline --version 2>/dev/null || echo installed)" \
  || echo "WARN: ccstatusline not installed -> npm install -g ccstatusline@2.2.19"
echo "done."
