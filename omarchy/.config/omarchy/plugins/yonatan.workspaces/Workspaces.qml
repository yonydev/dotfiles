import QtQuick
import QtQuick.Layouts
import Quickshell.Io
import Quickshell.Hyprland
import qs.Commons
import qs.Ui

BarWidget {
  id: root
  moduleName: "yonatan.workspaces"

  // Pac-Man workspace indicators:
  //   focused   -> Pac-Man
  //   occupied  -> ghost
  //   empty     -> pac-dot
  readonly property string pacmanIcon: "󰮯" // nf-md-pac_man
  readonly property string ghostIcon: "󰊠"  // nf-md-ghost
  readonly property string dotIcon: "●"          // pellet

  // Characters keep their arcade identity but take their actual color from
  // the current theme's colors.toml palette (like starship does with ANSI
  // names), so they dim/brighten with every theme change.
  property var themePalette: ({})

  function paletteColor(names, fallback) {
    for (var i = 0; i < names.length; i++) {
      var value = themePalette[names[i]]
      if (value) return value
    }
    return fallback
  }

  // Each lookup tries named keys first, then the ANSI colorN keys some
  // themes (e.g. Dracula) use instead: 1=red 2=green 3=yellow 4=blue
  // 5=magenta 6=cyan, 9-14 = bright variants.
  readonly property color pacmanColor: paletteColor(["bright_yellow", "yellow", "color11", "color3"], Color.bar.active)
  readonly property var ghostColors: [
    paletteColor(["red", "color1", "bright_red", "color9"], Color.urgent),              // Blinky
    paletteColor(["magenta", "color5", "bright_magenta", "color13"], Color.accent),     // Pinky
    paletteColor(["cyan", "color6", "bright_cyan", "color14"], Color.accent),           // Inky
    paletteColor(["orange", "bright_yellow", "yellow", "color3"], Color.foreground),    // Clyde
    paletteColor(["bright_magenta", "color13", "magenta", "color5"], Color.accent),     // Sue
    paletteColor(["green", "color2", "bright_green", "color10"], Color.accent),         // Funky
    Color.muted,                                                                        // Spunky
    paletteColor(["blue", "color4", "bright_blue", "color12"], Color.accent)            // frightened
  ]
  readonly property color dotColor: Color.muted

  function ghostColorFor(id) {
    return ghostColors[(id - 1) % ghostColors.length]
  }

  // Arcade "frightened mode": when Pac-Man (the focus marker) leaves a
  // workspace, the ghost left behind blinks blue<->white for a moment,
  // like after a power pellet. Trigger: focus change; only ghosts
  // (occupied workspaces) flash.
  readonly property color frightBlue: paletteColor(["blue", "color4", "bright_blue", "color12"], "#2121de")
  readonly property color frightWhite: paletteColor(["bright_foreground", "color15"], "#f8f8f2")
  property int lastFocusedId: Hyprland.focusedWorkspace !== null ? Hyprland.focusedWorkspace.id : -1
  property int frightenedId: -1
  property bool frightPhase: false

  Connections {
    target: Hyprland
    function onFocusedWorkspaceChanged() {
      var now = Hyprland.focusedWorkspace !== null ? Hyprland.focusedWorkspace.id : -1
      if (root.lastFocusedId > 0 && now !== root.lastFocusedId) {
        root.frightenedId = root.lastFocusedId
        frightTimer.restart()
      }
      root.lastFocusedId = now
    }
  }

  Timer {
    id: frightTimer
    interval: 2500
    onTriggered: root.frightenedId = -1
  }

  // The blink itself: only ticks while a ghost is frightened, idle otherwise.
  Timer {
    interval: 250
    repeat: true
    running: root.frightenedId > 0
    onTriggered: root.frightPhase = !root.frightPhase
  }

  function loadPalette(raw) {
    var lines = String(raw || "").split("\n")
    var parsed = {}
    for (var i = 0; i < lines.length; i++) {
      var match = lines[i].match(/^\s*([A-Za-z0-9_-]+)\s*=\s*["']?(#[0-9A-Fa-f]{6})/)
      if (match) parsed[match[1]] = match[2]
    }
    themePalette = parsed
  }

  property FileView paletteFile: FileView {
    path: Color.currentThemePath + "/colors.toml"
    watchChanges: true
    printErrors: false
    onLoaded: root.loadPalette(text())
    onFileChanged: reload()
  }

  // Theme switches don't touch the colors.toml path (only what it resolves
  // to), so re-read it when the shell pushes new foundational colors.
  property Connections themeWatch: Connections {
    target: Color
    function onForegroundChanged() { root.paletteFile.reload() }
    function onBackgroundChanged() { root.paletteFile.reload() }
    function onAccentChanged() { root.paletteFile.reload() }
  }

  function workspaceById(id) {
    var values = Hyprland.workspaces.values
    for (var i = 0; i < values.length; i++) {
      if (values[i].id === id) return values[i]
    }

    return null
  }

  function workspaceIds() {
    var ids = [1, 2, 3, 4, 5]
    var values = Hyprland.workspaces.values

    for (var i = 0; i < values.length; i++) {
      var id = values[i].id
      if (id > 0 && id <= 10 && ids.indexOf(id) === -1) ids.push(id)
    }

    ids.sort(function(left, right) { return left - right })
    return ids
  }

  function focusWorkspace(id) {
    if (!root.bar) return
    root.bar.run("hyprctl dispatch " + Util.shellQuote("hl.dsp.focus({ workspace = \"" + id + "\" })"))
  }

  readonly property real trailingGap: root.vertical ? 0 : Style.spaceReal(1.5)

  // Pill wrapper: padding along the bar axis, inset across it so the capsule
  // sits slimmer than the bar itself.
  readonly property real pillPad: Style.space(3)
  readonly property real pillInset: 3

  implicitWidth: grid.implicitWidth + trailingGap + (root.vertical ? 0 : pillPad * 2)
  implicitHeight: grid.implicitHeight + (root.vertical ? pillPad * 2 : 0)

  // Theme-aware pill: Color.* properties re-resolve on every theme switch,
  // so the wash and outline follow the active palette automatically.
  Rectangle {
    anchors.fill: parent
    anchors.rightMargin: (root.vertical ? root.pillInset : root.trailingGap)
    anchors.leftMargin: root.vertical ? root.pillInset : 0
    anchors.topMargin: root.vertical ? 0 : root.pillInset
    anchors.bottomMargin: root.vertical ? 0 : root.pillInset
    radius: Math.min(width, height) / 2
    color: Util.alpha(Color.foreground, 0.08)
    border.width: 1
    border.color: Util.alpha(Color.accent, 0.35)
  }

  GridLayout {
    id: grid
    anchors.fill: parent
    anchors.rightMargin: root.trailingGap + (root.vertical ? 0 : root.pillPad)
    anchors.leftMargin: root.vertical ? 0 : root.pillPad
    anchors.topMargin: root.vertical ? root.pillPad : 0
    anchors.bottomMargin: root.vertical ? root.pillPad : 0
    columns: root.vertical ? 1 : root.workspaceIds().length
    columnSpacing: root.vertical ? 0 : Style.space(1)
    rowSpacing: root.vertical ? Style.space(2) : 0

    Repeater {
      model: root.workspaceIds()

      WidgetButton {
        required property int modelData

        readonly property var workspace: root.workspaceById(modelData)
        readonly property bool occupied: workspace !== null && workspace.toplevels.values.length > 0
        readonly property bool focused: Hyprland.focusedWorkspace !== null && Hyprland.focusedWorkspace.id === modelData

        bar: root.bar
        text: focused ? root.pacmanIcon : (occupied ? root.ghostIcon : root.dotIcon)
        readonly property bool frightened: occupied && modelData === root.frightenedId

        foreground: focused ? root.pacmanColor
                  : frightened ? (root.frightPhase ? root.frightWhite : root.frightBlue)
                  : (occupied ? root.ghostColorFor(modelData) : root.dotColor)
        fontSize: occupied || focused ? Style.font.body : Style.font.body * 0.8
        opacity: occupied || focused ? 1 : 0.85
        tooltipText: "Workspace " + (modelData === 10 ? "0" : String(modelData))
        horizontalMargin: 6
        verticalPadding: 6
        fixedWidth: root.vertical ? root.barSize : Style.space(20)
        fixedHeight: root.barSize
        onPressed: function() { root.focusWorkspace(modelData) }
      }
    }
  }
}
