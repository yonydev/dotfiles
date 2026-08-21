# tuicr local theme generated from the active Omarchy theme palette (colors.toml).
# Rendered by omarchy-theme-set-templates into ~/.local/state/omarchy/current/theme/tuicr.toml
# ~/.config/tuicr/themes/omarchy.toml symlinks there (created by install.sh),
# and ~/.config/tuicr/config.toml selects theme = "omarchy".
# tuicr reads its theme at startup, so colors apply on the next launch after
# a theme switch. syntax_theme is omitted on purpose: tuicr then picks its
# bundled dark/light syntax theme from the panel background automatically.
# Uses quatrro's semantic palette keys; the "mix a b amount" template
# function blends two palette colors (used for tinted diff backgrounds).

panel_bg = "{{ background }}"
bg_highlight = "{{ lighter_background }}"
fg_primary = "{{ foreground }}"
fg_secondary = "{{ dark_foreground }}"
fg_dim = "{{ muted }}"

diff_add = "{{ green }}"
diff_add_bg = "{{ mix background green 0.15 }}"
diff_del = "{{ red }}"
diff_del_bg = "{{ mix background red 0.15 }}"
diff_context = "{{ foreground }}"
diff_hunk_header = "{{ blue }}"
expanded_context_fg = "{{ muted }}"

syntax_add_bg = "{{ mix background green 0.15 }}"
syntax_del_bg = "{{ mix background red 0.15 }}"

file_added = "{{ green }}"
file_modified = "{{ bright_yellow }}"
file_deleted = "{{ red }}"
file_renamed = "{{ magenta }}"

reviewed = "{{ green }}"
pending = "{{ bright_yellow }}"

comment_note = "{{ blue }}"
comment_suggestion = "{{ cyan }}"
comment_issue = "{{ red }}"
comment_praise = "{{ bright_green }}"

border_focused = "{{ accent }}"
border_unfocused = "{{ selection }}"
status_bar_bg = "{{ dark_background }}"
cursor_color = "{{ cursor }}"
cursor_line_bg = "{{ mix background lighter_background 0.5 }}"
branch_name = "{{ magenta }}"
help_indicator = "{{ muted }}"

message_info_fg = "{{ background }}"
message_info_bg = "{{ blue }}"
message_warning_fg = "{{ background }}"
message_warning_bg = "{{ bright_yellow }}"
message_error_fg = "{{ background }}"
message_error_bg = "{{ red }}"
update_badge_fg = "{{ background }}"
update_badge_bg = "{{ bright_yellow }}"

mode_fg = "{{ background }}"
mode_bg = "{{ accent }}"
