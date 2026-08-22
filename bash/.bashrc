# If not running interactively, don't do anything (leave this at the top of this file)
[[ $- != *i* ]] && return

# All the default Omarchy aliases and functions
# (don't mess with these directly, just overwrite them here!)
# /etc/omarchy.conf is written by omarchy-dev-link. When absent, force the
# package default instead of preserving a stale inherited dev-link value before
# we decide which rc file to source.
if [[ -f /etc/omarchy.conf ]]; then
  source /etc/omarchy.conf
  export OMARCHY_PATH="${OMARCHY_PATH:-/usr/share/omarchy}"
else
  export OMARCHY_PATH=/usr/share/omarchy
fi
source "$OMARCHY_PATH/default/bash/rc"

# Add your own exports, aliases, and functions here.
#
# Make an alias for invoking commands you use constantly
# alias p='python'

[ -f ~/.env-secrets ] && source ~/.env-secrets

# Render cliamp's config from its template whenever the template is newer,
# substituting secrets (CLIAMP_SPOTIFY_CLIENT_ID) from ~/.env-secrets.
# The generated config.toml is a real file, never committed to the repo.
if [ -f ~/.config/cliamp/config.toml.tpl ] && [ ~/.config/cliamp/config.toml.tpl -nt ~/.config/cliamp/config.toml ] && command -v envsubst >/dev/null; then
  envsubst < ~/.config/cliamp/config.toml.tpl > ~/.config/cliamp/config.toml
fi

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
[ -f ~/.local/state/omarchy/current/theme/starship.toml ] && export STARSHIP_CONFIG="$HOME/.local/state/omarchy/current/theme/starship.toml"

if command -v wt >/dev/null 2>&1; then eval "$(command wt config shell init bash)"; fi
# Keep go-installed tools in a version-independent dir so they survive
# mise Go upgrades (mise would otherwise set GOBIN to the versioned install dir)
export GOBIN="$HOME/.local/share/go/bin"
export PATH="$HOME/.local/share/go/bin:$PATH"
