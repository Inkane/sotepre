import QtQuick 2.0

Rectangle {
    id: infoblock
    property string title
    property real fontSize: height * 0.05
    property variant text: [[""]]
    property int index: 0
    smooth: true
    radius: 10
    height: parent.height / 3
    width: parent.width / 3
    gradient: Gradient {
	GradientStop { position: 0.16; color: "black" }
	GradientStop { position: 0.17; color: "white" }
    }
    Item {
	anchors.fill: parent
	focus: true
	
	MouseArea {
	    anchors.fill: parent
	    acceptedButtons: Qt.LeftButton | Qt.RightButton
	    cursorShape: Qt.PointingHandCursor
	    onClicked: {
		if (mouse.button == Qt.LeftButton) {
		    if (infoblock.index < text.length - 1) {
			infoblock.index++;
		    }
		} else {
		    if (infoblock.index > 0) {
			infoblock.index--;
		    }
		}
	    }
	}
    }
    
    Rectangle {
	id: title
	color: "black"
	height: infoblock.fontSize * 4
	anchors.margins: height
	anchors.horizontalCenter: parent.horizontalCenter
	
	Text {
	    text: infoblock.title
	    font.pixelSize: title.height / 2
	    color: p.titleColor
	    anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
	    anchors.topMargin: title.fontSize
	    anchors.bottomMargin: title.fontSize
	    horizontalAlignment: Text.Center
	}
    }
	
    Rectangle {
	anchors.top: title.bottom
	anchors.left: infoblock.left
	width: infoblock.width
	anchors.leftMargin: width *0.1
	Grid {
	    columns: 2
	    Repeater {
		model: infoblock.text[infoblock.index].length
		
		Rectangle {
		    height: infoblock.fontSize * 3
		    width:infoblock.width * 0.4
		    Text {
			text: infoblock.text[infoblock.index][index]
			font.pixelSize: infoblock.fontSize * 1.5
		    }
		}
	    }
	}
    }
}
