import QtQuick
import QtQuick.Layouts
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

  // Classic arcade palette: Pac-Man yellow, ghosts cycle through
  // Blinky (red), Pinky (pink), Inky (cyan), Clyde (orange).
  property color pacmanColor: "#FFEE00"
  property var ghostColors: ["#FF0000", "#FFB8FF", "#00FFFF", "#FFB852"]
  property color dotColor: Color.muted

  function ghostColorFor(id) {
    return ghostColors[(id - 1) % ghostColors.length]
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

  implicitWidth: grid.implicitWidth + trailingGap
  implicitHeight: grid.implicitHeight

  GridLayout {
    id: grid
    anchors.fill: parent
    anchors.rightMargin: root.trailingGap
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
        foreground: focused ? root.pacmanColor : (occupied ? root.ghostColorFor(modelData) : root.dotColor)
        fontSize: occupied || focused ? Style.font.body : Style.font.body * 0.6
        opacity: occupied || focused ? 1 : 0.6
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
