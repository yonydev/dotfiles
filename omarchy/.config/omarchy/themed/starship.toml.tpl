# ==============================================================================
# Starship rainbow-bar prompt (catppuccin-powerline preset, via
# https://github.com/lixiang117423/starship_config)
# ==============================================================================
# Colors follow the active Omarchy theme: this template is rendered by
# omarchy-theme-set-templates into ~/.config/omarchy/current/theme/starship.toml
# on every `omarchy theme set`. STARSHIP_CONFIG (set in ~/.bashrc) points at
# the rendered file; starship re-reads it on every prompt, so theme switches
# recolor NEW prompts live in all open terminals.
#
# Edit THIS template (not the rendered file), then re-apply the theme to see
# changes: OMARCHY_THEME_SKIP_BACKGROUND=1 omarchy theme set <theme>

"$schema" = 'https://starship.rs/config-schema.json'

command_timeout = 200

format = """
[╭](fg:frame_dim)\
[](red)\
$os\
$username\
[](bg:peach fg:red)\
$directory\
[](bg:yellow fg:peach)\
$git_branch\
$git_status\
[](fg:yellow bg:green)\
$c\
$rust\
$golang\
$nodejs\
$bun\
$php\
$java\
$kotlin\
$haskell\
$python\
[](fg:green bg:sapphire)\
$conda\
[](fg:sapphire bg:lavender)\
$time\
[ ](fg:lavender)\
$cmd_duration\
$line_break\
$character"""

palette = 'omarchy'

# ==============================================================================
# 操作系统图标 + 用户名（红色色块，彩虹条最左侧）
# ==============================================================================
# OS 图标自动识别系统类型，username 显示当前用户
# style_root: root 用户时的样式（建议改成醒目颜色以区分）
[os]
disabled = false
style = "bg:red fg:crust"

[os.symbols]
Windows = ""
Ubuntu = "󰕈"
SUSE = ""
Raspbian = "󰐿"
Mint = "󰣭"
Macos = "󰀵"
Manjaro = ""
Linux = "󰌽"
Gentoo = "󰣨"
Fedora = "󰣛"
Alpine = ""
Amazon = ""
Android = ""
Arch = " "
Artix = " "
CentOS = ""
Debian = "󰣚"
Redhat = "󱄛"
RedHatEnterprise = "󱄛"

[username]
show_always = true
style_user = "bg:red fg:crust"
style_root = "bg:red fg:crust"
format = '[ $user]($style)'

# ==============================================================================
# 目录（橙色色块）
# ==============================================================================
# truncation_length: 最多显示 3 层目录
# truncation_symbol: 截断时显示 …/ 提示路径被省略
# substitutions: 常用目录替换为图标
[directory]
style = "bg:peach fg:crust"
format = "[ $path ]($style)"
truncation_length = 6
truncation_symbol = "…/"

[directory.substitutions]
"Documents" = "󰈙 "
"Downloads" = " "
"Music" = "󰝚 "
"Pictures" = " "
"Developer" = "󰲋 "

# ==============================================================================
# Git 分支 + 状态（黄色色块）
# ==============================================================================
# 不在 git 仓库时自动隐藏
[git_branch]
symbol = ""
style = "bg:yellow"
format = '[[ $symbol $branch ](fg:crust bg:yellow)]($style)'

[git_status]
style = "bg:yellow"
format = '[[($all_status$ahead_behind )](fg:crust bg:yellow)]($style)'

# ==============================================================================
# 语言版本（绿色色块）
# ==============================================================================
# 仅在检测到对应项目时才显示（如 package.json → nodejs，go.mod → golang）
[nodejs]
symbol = ""
style = "bg:green"
format = '[[ $symbol( $version) ](fg:crust bg:green)]($style)'

[bun]
symbol = ""
style = "bg:green"
format = '[[ $symbol( $version) ](fg:crust bg:green)]($style)'

[c]
symbol = " "
style = "bg:green"
format = '[[ $symbol( $version) ](fg:crust bg:green)]($style)'

[rust]
symbol = ""
style = "bg:green"
format = '[[ $symbol( $version) ](fg:crust bg:green)]($style)'

[golang]
symbol = ""
style = "bg:green"
format = '[[ $symbol( $version) ](fg:crust bg:green)]($style)'

[php]
symbol = ""
style = "bg:green"
format = '[[ $symbol( $version) ](fg:crust bg:green)]($style)'

[java]
symbol = " "
style = "bg:green"
format = '[[ $symbol( $version) ](fg:crust bg:green)]($style)'

[kotlin]
symbol = ""
style = "bg:green"
format = '[[ $symbol( $version) ](fg:crust bg:green)]($style)'

[haskell]
symbol = ""
style = "bg:green"
format = '[[ $symbol( $version) ](fg:crust bg:green)]($style)'

[python]
symbol = ""
style = "bg:green"
format = '[[ $symbol( $version)(\(#$virtualenv\)) ](fg:crust bg:green)]($style)'

# ==============================================================================
# Docker 上下文（蓝宝石色块）
# ==============================================================================
# 仅在 Docker 上下文非默认时显示
[docker_context]
symbol = ""
style = "bg:sapphire"
format = '[[ $symbol( $context) ](fg:crust bg:sapphire)]($style)'

# ==============================================================================
# Conda 环境（蓝宝石色块）
# ==============================================================================
[conda]
symbol = "  "
style = "fg:crust bg:sapphire"
format = '[$symbol$environment ]($style)'
ignore_base = false

# ==============================================================================
# 时间（薰衣草紫色块，彩虹条最右侧）
# ==============================================================================
[time]
disabled = false
time_format = "%R"
style = "bg:lavender"
format = '[[  $time ](fg:crust bg:lavender)]($style)'

# ==============================================================================
# 换行（彩虹条和输入符号分两行显示）
# ==============================================================================
# disabled = false: 彩虹条一行，输入在下一行，更宽敞
# disabled = true: 单行显示（官方默认）
[line_break]
disabled = false

# ==============================================================================
# 输入符号（彩虹条下方）
# ==============================================================================
# 命令成功绿色 ❯，失败红色 ❯
# 支持 vim 模式：普通模式 ❮，替换模式紫色，可视模式黄色
[character]
disabled = false
format = """
[│](fg:frame_dim)
[╰─$symbol](fg:frame_bright) """
success_symbol = '[](bold fg:green)'
error_symbol = '[](bold fg:red)'
vimcmd_symbol = '[❮](bold fg:green)'
vimcmd_replace_one_symbol = '[❮](bold fg:lavender)'
vimcmd_replace_symbol = '[❮](bold fg:lavender)'
vimcmd_visual_symbol = '[❮](bold fg:yellow)'

# ==============================================================================
# 命令耗时（显示在彩虹条末尾）
# ==============================================================================
# min_time_to_notify: 命令超过 45 秒时发送系统通知
[cmd_duration]
show_milliseconds = true
format = " in $duration "
style = "bg:lavender"
disabled = false
show_notifications = true
min_time_to_notify = 45000

# ==============================================================================
# Palette: rainbow segment names mapped to the active Omarchy theme
# (red -> peach -> yellow -> green -> sapphire -> lavender gradient;
#  crust = text on colored blocks = theme background for max contrast)
# ==============================================================================
[palettes.omarchy]
red = "{{ color1 }}"
peach = "{{ color11 }}"
yellow = "{{ color3 }}"
green = "{{ color2 }}"
sapphire = "{{ color6 }}"
lavender = "{{ color5 }}"
crust = "{{ background }}"
frame_dim = "{{ color8 }}"
frame_bright = "{{ foreground }}"
