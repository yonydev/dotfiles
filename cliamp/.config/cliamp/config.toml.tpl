# Source of truth: config.toml.tpl (in the dotfiles repo).
# config.toml is GENERATED from it by envsubst (wired in ~/.bashrc), which
# substitutes secrets (CLIAMP_SPOTIFY_CLIENT_ID) from ~/.env-secrets -- so the
# client_id never lands in the repo. Edit the .tpl; the generated config is
# refreshed on the next shell start.
theme = ""

[spotify]
client_id = "${CLIAMP_SPOTIFY_CLIENT_ID}"
bitrate = 320
