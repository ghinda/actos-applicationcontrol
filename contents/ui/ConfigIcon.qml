import QtQuick 1.1
import org.kde.plasma.core 0.1

Item {
	id: configButton
	
	property string size : parent.height
	property string svgElementId : 'close'
	signal clicked
	
	width: size
	height: size
	
	SvgItem {
		id: configIcon
		svg: Svg {
			imagePath: 'widgets/configuration-icons'
			usingRenderingCache: true
		}
		elementId: svgElementId
		
		width: parent.height
		height: parent.height
		
		anchors {
			verticalCenter: parent.verticalCenter
			horizontalCenter: parent.horizontalCenter
		}
	}
	
	anchors {
		left: parent.left
		leftMargin: 5
		verticalCenter: parent.verticalCenter
	}
	
	MouseArea {
		anchors.fill: parent
		onPressed: {
			configIcon.width = configIcon.height = configIcon.height * 0.9; // 90%
		}
		
		onReleased: {
			configIcon.width = configIcon.height = size;
		}
		
		onClicked: configButton.clicked()
	}
	
}