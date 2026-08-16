# TODO

## Multi-machine support (Raspberry Pi home lab, macOS work machine)

Design decided, not yet built. One branch for all machines: host profiles
select WHICH stow packages apply; guards/fragments handle platform behavior.
No branch-per-machine.

Build order:

1. **Guard or fragment `.bashrc`** — the omarchy `source` lines (rc, plugins)
   run unconditionally and would error on non-omarchy machines. Either wrap in
   `[ -d ~/.local/share/omarchy ] && ...` or split into self-guarding
   `~/.bashrc.d/*.sh` fragments. (Also benefits this machine.)
2. **`hosts/` profiles** — plain text per machine class listing its stow
   packages (`hosts/omarchy` = all; `hosts/pi` / `hosts/work-mac` = terminal
   stack only: bash git tmux nvim starship mise claude). `install.sh` +
   Makefile read `CONFIG_DIRS` from the profile (hostname match or
   `HOST_PROFILE` env var).
3. **`packages/Brewfile` + Darwin branch in `install.sh`** — brew bundle for
   the work mac. CLI formulae only (casks often blocked by MDM/JumpCloud; GUI
   apps are IT-provided there). No sudo needed anywhere: brew + stow + $HOME.
   Decide shell story first: `brew install bash` (keep one config) vs zsh
   (share only starship/fzf/git/nvim).
4. **`packages/apt.txt` + Debian branch** — for the Pi, when actually needed.
   `capture` equivalent: `apt-mark showmanual`. Note: RaspiOS neovim is old;
   may need tarball/appimage.
5. **launchd LaunchAgent for the manifest notification on macOS** — only if
   the missing notifications hurt; `brew bundle check` may be enough.

Already portable by design (no work needed): starship falls back to the
committed config when omarchy's rendered one is absent; fzf falls back to the
built-in Dracula palette; `wt`/`.env-secrets`/STARSHIP_CONFIG lines in
`.bashrc` are guarded; per-machine values (e.g. REMOTE_SSH_HOST) live in each
machine's own `~/.env-secrets`.
