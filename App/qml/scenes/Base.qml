import QtQuick 2.0

import Qak 1.0
import Qak.Tools 1.0
import Qak.QtQuick 2.0

import ".."

Item {
    id: scene

    anchors { fill: parent }

    paused: App.paused
    onPausedChanged: App.debug('Scene',sceneNumber,paused ? 'paused' : 'continued')

    readonly property string sceneNumber: game.currentScene

    default property alias content: canvas.data
    property alias canvas: canvas


    signal objectDragged(var object)
    signal objectDropped(var object)
    signal objectCombined(var object, var otherObject)
    signal objectClicked(var object)
    signal objectReturned(var object)
    signal objectTravelingToInventory(var object)
    signal objectAddedToInventory(var object)
    signal objectRemovedFromInventory(var object)

    Component.onDestruction: {
        core.sounds.clear('level'+sceneNumber)
    }

    Connections {
        target: game
        onObjectDropped: { App.debug('Object dropped',object.name); objectDropped(object)}
        onObjectClicked: { App.debug('Object clicked',object.name); objectClicked(object)}
        onObjectTravelingToInventory: { App.debug('Object traveling to inventory',object.name); objectTravelingToInventory(object) }
        onObjectDragged: { App.debug('Object dragged',object.name); objectDragged(object) }
        onObjectReturned: { App.debug('Object returned',object.name);  objectReturned(object) }
        onObjectAddedToInventory: { App.debug('Object added to inventory',object.name);  objectAddedToInventory(object) }
        onObjectRemovedFromInventory: { App.debug('Object removed from inventory',object.name);  objectRemovedFromInventory(object) }
    }

    Image {
        id: background

        fillMode: Image.PreserveAspectFit
        source: App.getAsset('scenes/'+sceneNumber+'.png')

    }

    Item {
        id: canvas
        anchors { fill: parent }


    }

    Image {
        id: foreground

        anchors { fill: parent }

        fillMode: Image.PreserveAspectFit
        source: App.getAsset('scenes/'+sceneNumber+'_fg_shadow.png')

        SequentialAnimation {
            running: true
            loops: Animation.Infinite

            paused: running && scene.paused

            NumberAnimation { target: foreground; property: "opacity"; from: 1; to: 0.9; duration: 600 }
            NumberAnimation { target: foreground; property: "opacity"; from: 0.9; to: 1; duration: 800 }
        }

    }

}