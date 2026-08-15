# Config dirs in this repo to symlink (stow terminology: "packages").
# NOT software -- programs to install live in packages/pacman.txt.
CONFIG_DIRS := bash chromium claude git hypr kitty lazydocker mise nvim omarchy starship tmux
OMARCHY_LISTS := $(HOME)/.local/share/omarchy/install/omarchy-base.packages \
                 $(HOME)/.local/share/omarchy/install/omarchy-other.packages

install: ## full bootstrap: packages + stow + post-link
	./install.sh

stow: ## (re)link all config packages, no package installs
	./install.sh --no-packages

unstow: ## remove all symlinks (configs revert to nothing -- restore from backup!)
	stow -D $(CONFIG_DIRS)

capture: ## show packages installed on this machine that the manifest doesn't know about
	@comm -23 <(pacman -Qqe | sort) \
	          <(cat $(OMARCHY_LISTS) 2>/dev/null | grep -v '^#' | tr -s ' \t' '\n' | sort -u) \
	  | grep -vxF -f <(grep -vE '^\s*#|^\s*$$' packages/pacman.txt packages/aur.txt | cut -d: -f2) \
	  || echo "manifest is up to date"

doctor: ## find broken symlinks in $$HOME and uncommitted drift in the repo
	@echo "--- broken symlinks pointing into this repo:"
	@find $(HOME) -maxdepth 4 -xtype l -lname '*dotfiles*' 2>/dev/null || true
	@echo "--- repo drift (omarchy migrations write through symlinks; review these):"
	@git status --short

help:
	@grep -E '^[a-z]+:.*##' $(MAKEFILE_LIST) | sed 's/:.*## /\t/'

.PHONY: install stow unstow capture doctor help
.SHELLFLAGS := -ec
SHELL := /bin/bash
