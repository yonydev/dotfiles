#!/bin/bash
# Bootstrap this machine from the dotfiles repo. Idempotent: safe to re-run.
# Usage: ./install.sh [--no-packages]
set -euo pipefail
cd "$(dirname "$0")"

# Config directories in this repo to symlink into $HOME (GNU stow "packages").
# These are OUR config files, named after the app they configure -- this list
# does not install any software; programs live in packages/pacman.txt.
CONFIG_DIRS=(bash chromium claude git hypr kitty lazydocker mise nvim omarchy starship tmux)
BACKUP_DIR="$HOME/.local/state/dotfiles-backup-$(date +%Y%m%d-%H%M%S)"

# --- 1. Preflight -------------------------------------------------------------
command -v stow >/dev/null || { echo "installing stow..."; sudo pacman -S --needed --noconfirm stow; }
git submodule update --init

# --- 2. Packages --------------------------------------------------------------
if [[ ${1:-} != --no-packages ]]; then
  grep -vE '^\s*#|^\s*$' packages/pacman.txt | sudo pacman -S --needed --noconfirm -
  if grep -qvE '^\s*#|^\s*$' packages/aur.txt 2>/dev/null; then
    command -v yay >/dev/null && grep -vE '^\s*#|^\s*$' packages/aur.txt | yay -S --needed --noconfirm - ||
      echo "WARN: aur.txt has entries but yay is missing -- skipped"
  fi
fi

# --- 3. Back up real files that stow would collide with, then stow ------------
for pkg in "${CONFIG_DIRS[@]}"; do
  ( cd "$pkg" && find . \( -type f -o -type l \) -printf '%P\n' ) | while read -r rel; do
    tgt="$HOME/$rel"
    # a symlink already pointing into this repo is ours; anything else moves aside
    if [[ -e $tgt || -L $tgt ]] && [[ "$(readlink -f "$tgt" 2>/dev/null)" != "$(readlink -f "$pkg/$rel")" ]]; then
      mkdir -p "$BACKUP_DIR/$(dirname "$rel")"
      mv "$tgt" "$BACKUP_DIR/$rel"
    fi
  done
  stow --restow "$pkg"
done
[[ -d $BACKUP_DIR ]] && echo "Displaced originals saved to: $BACKUP_DIR"

# --- 4. Post-link fixups -------------------------------------------------------
# nvim's theme.lua must point at omarchy's live theme (absolute link, per-machine $HOME)
ln -sfn "$HOME/.config/omarchy/current/theme/neovim.lua" nvim/.config/nvim/lua/plugins/theme.lua

# Re-apply the current theme so user templates (fzf, starship) render
if command -v omarchy-theme-set >/dev/null && [[ -f $HOME/.config/omarchy/current/theme.name ]]; then
  OMARCHY_THEME_SKIP_BACKGROUND=1 omarchy-theme-set "$(cat "$HOME/.config/omarchy/current/theme.name")"
fi

# --- 5. Manual steps -----------------------------------------------------------
echo
echo "Done. Remaining manual steps:"
echo "  - ~/.env-secrets is NOT in this repo; copy it over securely (it is optional)."
echo "  - Open a new terminal so the shell picks everything up."
