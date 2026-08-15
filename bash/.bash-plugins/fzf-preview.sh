#!/bin/bash

# ==============================================================================
# FZF Preview Configuration
# ==============================================================================
#
# This file configures preview windows for fzf (fuzzy finder) commands.
# It enhances fzf with rich previews using modern tools like 'eza' and 'bat'.
#
# Requirements:
#   - fzf: Fuzzy finder for command-line (https://github.com/junegunn/fzf)
#   - eza: Modern replacement for ls (https://github.com/eza-community/eza)
#   - bat: Cat clone with syntax highlighting (https://github.com/sharkdp/bat)
#
# Usage:
#   Source this file in your .bashrc or .bash_profile:
#     source ~/.bash-plugins/fzf-preview.sh
#
# ==============================================================================

# ------------------------------------------------------------------------------
# Preview Command for Files and Directories
# ------------------------------------------------------------------------------
# This variable defines how files and directories are previewed in fzf.
# - For directories: Shows tree structure using eza (limited to 200 lines)
# - For files: Shows syntax-highlighted content using bat (limited to 500 lines)
#
# The {} placeholder is replaced by fzf with the selected item.
show_file_or_dir_preview="if [ -d {} ]; then eza --tree --color=always {} | head -200; else bat -n --color=always --line-range :500 {}; fi"

# ------------------------------------------------------------------------------
# FZF Key Binding Options
# ------------------------------------------------------------------------------

# Ctrl+T: File/directory finder from current directory
# Shows preview of selected files or directory structures
export FZF_CTRL_T_OPTS="--preview '$show_file_or_dir_preview'"

# Alt+C: Directory navigation
# Shows tree preview of directories before changing to them
export FZF_ALT_C_OPTS="--preview 'eza --tree --color=always {} | head -200'"

# Default FZF Options: Custom key bindings for preview navigation
# - Alt+J: Scroll preview window down (vim-style navigation)
# - Alt+K: Scroll preview window up (vim-style navigation)
# - Tab / Shift+Tab: Move down/up through the candidate list (wraps around
#   thanks to --cycle). Note: this replaces Tab's default multi-select
#   toggle in `fzf -m`; use Ctrl+Space there instead.
export FZF_DEFAULT_OPTS="--cycle --bind 'alt-j:preview-down,alt-k:preview-up,tab:down,btab:up,ctrl-space:toggle+down'"

# Color Scheme: Follows the active Omarchy theme, live.
# ~/.config/omarchy/current/theme/fzf-colors is rendered from the theme's
# palette by the user template ~/.config/omarchy/themed/fzf-colors.tpl on
# every `omarchy theme set`. fzf re-reads FZF_DEFAULT_OPTS_FILE on every
# invocation, so theme switches recolor fzf in already-open terminals
# without re-sourcing .bashrc.
# Falls back to Dracula (via FZF_DEFAULT_OPTS) if no theme file exists.
# Color mappings:
#   fg/fg+:      Foreground text color (normal/selected)
#   bg/bg+:      Background color (normal/selected)
#   hl/hl+:      Highlight color for matching text
#   info:        Info line color
#   prompt:      Input prompt color
#   pointer:     Selection pointer color
#   marker:      Multi-select marker color
#   spinner:     Loading spinner color
#   header:      Header text color
if [ -f "$HOME/.config/omarchy/current/theme/fzf-colors" ]; then
  export FZF_DEFAULT_OPTS_FILE="$HOME/.config/omarchy/current/theme/fzf-colors"
else
  export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS \
--color=fg:#f8f8f2,bg:#282a36,hl:#bd93f9 \
--color=fg+:#f8f8f2,bg+:#44475a,hl+:#bd93f9 \
--color=info:#ffb86c,prompt:#50fa7b,pointer:#ff79c6 \
--color=marker:#ff79c6,spinner:#ffb86c,header:#6272a4"
fi

# ------------------------------------------------------------------------------
# Command-Specific Preview Function
# ------------------------------------------------------------------------------
# _fzf_comprun: Customizes fzf behavior based on the command being completed
#
# This function is called by fzf's completion system to provide context-aware
# previews for different commands. It intercepts tab completion and adds
# appropriate preview options based on what you're trying to complete.
#
# Arguments:
#   $1 - The command name (cd, ssh, export, etc.)
#   $@ - Additional arguments passed to fzf
#
# Supported Commands:
#   - cd: Shows directory tree structure
#   - export/unset: Shows variable value evaluation
#   - ssh: Shows DNS information via dig
#   - *: Default file/directory preview for all other commands
#
_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf --preview 'eza --tree --color=always {} | head -200' "$@" ;;
    export|unset) fzf --preview "eval 'echo ${}'"         "$@" ;;
    ssh)          fzf --preview 'dig {}'                   "$@" ;;
    *)            fzf --preview "$show_file_or_dir_preview" "$@" ;;
  esac
}
