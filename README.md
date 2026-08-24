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
# and keep it owner-only readable:
chmod 600 ~/.env-secrets
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
- `omarchy/.config/omarchy/shell.json` + `plugins/yonatan.workspaces/` — the
  Quickshell bar. Omarchy quatrro's bar is assembled from plugin widgets:
  `shell.json` lays out the bar zones by plugin id (plus clock format and idle
  timings), and `plugins/<id>/` holds user widgets (`manifest.json` + QML).
  `yonatan.workspaces` is a clone of the stock workspaces widget (made with
  `omarchy plugin clone omarchy.workspaces`) rendering Pac-Man on the focused
  workspace, ghosts on occupied, pellets on empty, colored from the active
  theme. Edit the QML, then `omarchy restart shell` (no hot reload). Caveat:
  `omarchy plugin enable/disable` and the settings UI rewrite `shell.json`
  via tmp+mv, which replaces the symlink with a real file — `make doctor`
  catches it; merge the live file back into the repo and restow.
- `~/.config/nvim/lua/plugins/theme.lua` is omarchy's live-theme symlink and
  is deliberately NOT in this repo (`nvim/.stow-local-ignore`); `install.sh`
  creates it on fresh machines. Don't add it as a regular file.
- `bash/.bash-plugins/fzf-tab-completion` is a git submodule pinned upstream.

## Daily usage: which make command, when

| Just happened | Run |
|---|---|
| Fresh machine | `make install` |
| Edited a config file (any editor, any time) | nothing — edits flow through the symlink; commit when happy |
| Added or deleted a file inside the repo | `make stow` |
| Installed/removed a program | `make capture` → add it to the manifest → commit |
| Got the "manifest is stale" notification | same as above |
| Ran `omarchy update` | `make doctor` → review diffs → commit |
| Something's weird | `make doctor` first |

Mental model: **`install`/`stow` push the repo out to the system;
`capture`/`doctor` pull reality back into the repo.** Git sits in the middle
as the checkpoint where changes get approved.

### `make install` — set up this machine

Full bootstrap: packages → backup collisions → stow → enable the
manifest-check timer → re-render theme. Run once per machine after cloning;
idempotent, so re-running is always safe.

### `make stow` — the repo's file *structure* changed

Symlinks are per-file. Editing a linked file needs nothing, but a **new** file
in the repo has no link yet (apps can't see it) and a **deleted** one leaves a
dead link behind (apps trip over it). Both are fixed by restowing.
*Example: adding a first `waybar/` package, or deleting an nvim plugin spec.*

### `make capture` — did I forget to write down a program?

Compares installed packages against Omarchy's own lists, the manifests, and
`packages/ignore.txt`; prints anything unrecorded and which manifest file it
belongs in (AUR-built packages are detected via `pacman -Qqm`). A daily
systemd user timer (`dotfiles-manifest-check.timer`) runs this check and
sends a desktop notification when something is missing.
*Example: `yay -S lazysql`, forget about it; next morning a notification says
"add to packages/pacman.txt: lazysql".*

### `make doctor` — is everything still healthy?

Two checks: broken symlinks pointing into the repo (a linked file was deleted
or replaced), and uncommitted drift inside the repo. Drift is normal, not an
error — Omarchy migrations and menus `cp`/write *through* the symlinks, so
their changes land in the repo as reviewable git diffs. Run it after every
`omarchy update` and as the first diagnostic when something feels off.
*Example: it surfaced a display-scale change the Omarchy menu wrote into
`hypr/monitors.conf`.*

### `make unstow` — take everything down

Removes every symlink; configs effectively vanish until restored. Escape
hatch only (leaving the system, or a clean re-link via unstow + stow).

## Never in this repo

`~/.env-secrets`, `~/.config/gh/` and `~/.config/github-copilot/` (auth
tokens), `~/.local/state/omarchy/current/` (generated), anything identical to
Omarchy stock configs.
