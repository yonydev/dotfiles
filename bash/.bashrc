# If not running interactively, don't do anything (leave this at the top of this file)
[[ $- != *i* ]] && return

# All the default Omarchy aliases and functions
# (don't mess with these directly, just overwrite them here!)
source ~/.local/share/omarchy/default/bash/rc

# Add your own exports, aliases, and functions here.
#
# Make an alias for invoking commands you use constantly
# alias p='python'

[ -f ~/.env-secrets ] && source ~/.env-secrets

# fzf-plugin for git
source ~/.bash-plugins/fzf-git.sh

# git-plugin-bash aliases
source ~/.bash-plugins/git-plugin-bash.sh

# fzf-preview plugin
source ~/.bash-plugins/fzf-preview.sh

# fzf-tab-completion
source ~/.bash-plugins/fzf-tab-completion/bash/fzf-bash-completion.sh
bind -x '"\t": fzf_bash_completion'

# . "$HOME/.local/share/../bin/env"

# Starship prompt follows the active Omarchy theme (rendered from
# ~/.config/omarchy/themed/starship.toml.tpl). Falls back to
# ~/.config/starship.toml if the theme hasn't rendered one.
[ -f ~/.config/omarchy/current/theme/starship.toml ] && export STARSHIP_CONFIG="$HOME/.config/omarchy/current/theme/starship.toml"

if command -v wt >/dev/null 2>&1; then eval "$(command wt config shell init bash)"; fi
export PATH="$HOME/.local/share/go/bin:$PATH"
