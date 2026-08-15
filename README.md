# dotfiles

Personal configuration delta on top of [Omarchy](https://omarchy.org). Omarchy
is the base image: it installs and migrates the desktop stack (hyprland,
waybar, starship, fzf, nvim, ...). This repo carries only what's *mine* —
customized configs and additionally installed programs.

## New machine

```sh
# after a fresh Omarchy install:
git clone --recurse-submodules <this-repo> ~/dotfiles
cd ~/dotfiles && ./install.sh
# then copy ~/.env-secrets over securely (optional, not in git)
```

## Layout

| Path | What |
|---|---|
| `packages/pacman.txt` | Programs I add on top of Omarchy (repo/omarchy-repo) |
| `packages/aur.txt` | AUR additions (built with yay) |
| `<app>/` | One stow package per app: config files symlinked into `$HOME` |
| `install.sh` | Idempotent bootstrap: packages → backup collisions → stow → re-render theme |

Stow runs with `--no-folding`: directories stay real, every managed file is an
individual symlink into this repo. New files created by apps land next to the
symlinks as normal files and never leak into the repo.

## Highlights

- `omarchy/.config/omarchy/themed/*.tpl` — user templates rendered by omarchy
  on every theme switch: fzf colors (`FZF_DEFAULT_OPTS_FILE`) and the starship
  rainbow prompt (`STARSHIP_CONFIG`) follow the active theme live.
- `~/.config/nvim/lua/plugins/theme.lua` is omarchy's live-theme symlink and
  is deliberately NOT in this repo (`nvim/.stow-local-ignore`); `install.sh`
  creates it on fresh machines. Don't add it as a regular file.
- `bash/.bash-plugins/fzf-tab-completion` is a git submodule pinned upstream.

## Day 2

```sh
make capture   # packages on this machine the manifest doesn't know about
make doctor    # broken symlinks + drift Omarchy migrations wrote through links
make stow      # relink configs after adding files to the repo
```

After `omarchy update`, run `make doctor`: migrations that `cp` into
`~/.config` write *through* the symlinks, so legitimate changes show up as
git diffs to review and commit.

## Never in this repo

`~/.env-secrets`, `~/.config/gh/` (OAuth token), `~/.config/omarchy/current/`
(generated), anything identical to Omarchy stock configs.
