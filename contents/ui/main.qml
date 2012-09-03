import QtQuick 1.1
import org.kde.plasma.components 0.1 as Plasma
import org.kde.plasma.graphicswidgets 0.1 as PlasmaWidgets
import org.kde.plasma.core 0.1 as PlasmaCore

Item {
    id: main
    width: 350
    height: 16
    
    property int minimumWidth: 350
    property int minimumHeight: 16
    
	property string activeSource
	property bool keepCurrentSource: false
	property variant activeData    
    
    //property Component compactRepresentation: applicationControl
    
    PlasmaCore.DataSource {
		id: dataSource
		dataEngine: 'tasks'
		interval: 0
		onSourceAdded: {
			connectSource(source)
		}
		Component.onCompleted: {
			connectedSources = sources
		}
		onDataChanged: {
			if(!keepCurrentSource) {
				for(source in data) {
					if(data[source].active) {
						activeData = data[source];
						activeSource = source;
						
						return;
					} else {
						activeData = null;
					}
				}
			} else {
				keepCurrentSource = false;
			}
		}
	}
    
	Item {
		id: appControl
		anchors.fill: parent
		
		ConfigIcon {
			id: closeButton
			size: parent.height
			svgElementId: 'close'
			
			visible: (typeof activeData=="object" && typeof activeData.maximized=="boolean" && activeData.maximized || false)
			
			onClicked: {
				var service=dataSource.serviceForSource(activeSource),
					operation = service.operationDescription("close"),
					job = service.startOperationCall(operation);
			}
			
		}

		ConfigIcon {
			id: unmaximizeButton
			size: parent.height
			svgElementId: (typeof activeData=="object" && typeof activeData.maximized=="boolean" && activeData.maximized) ? 'unmaximize' : 'maximize'
			
			visible: (typeof activeData=="object" && typeof activeData.maximized=="boolean" || false)
			
			anchors {
				left: closeButton.right
				leftMargin: 5
				verticalCenter: parent.verticalCenter
			}
			
			onClicked: {
				var service = dataSource.serviceForSource(activeSource),
					operation = service.operationDescription("toggleMaximized"),
					job = service.startOperationCall(operation);
			}

		}
		
		Plasma.Label {
			id: appName
			text: activeData ? activeData.name : ''
			elide: Text.ElideLeft
			width: 270
			anchors {
				left: unmaximizeButton.right
				verticalCenter: parent.verticalCenter
				leftMargin: 5
			}
		}
		
		PlasmaCore.ToolTip {
			id: tooltip
			target: appControl
			mainText: activeData ? activeData.name : ''
			image: activeData ? activeData.className : ''
		}
		
		MouseArea {
			visible: activeData ? true : false
			anchors.fill: appName
			
			onDoubleClicked: {
				unmaximizeButton.clicked(mouse);
			}
		}
	
	}
	
	Component.onCompleted: {
		plasmoid.popupIcon = "window-duplicate";
	}
    
}