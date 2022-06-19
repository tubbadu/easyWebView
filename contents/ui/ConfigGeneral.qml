import QtQuick 2.5
import QtQuick.Layouts 1.3
import QtQuick.Controls 2.12 as QQC2

import org.kde.kirigami 2.8 as Kirigami
import org.kde.plasma.core 2.0 as PlasmaCore

Kirigami.FormLayout {
    anchors.right: parent.right
    anchors.left: parent.left

    property alias cfg_useMinViewWidth: useMinViewWidth.checked
    property alias cfg_minViewWidth: minViewWidth.value
    property alias cfg_constantZoomFactor: constantZoomFactor.value
    property alias cfg_startingUrl: startingUrl.text

    QQC2.ButtonGroup { id: zoomGroup }

    RowLayout {
        Kirigami.FormData.label: i18nc("@title:group", "Content scaling:")

        QQC2.RadioButton {
            id: useConstantZoom
            text: i18nc("@option:radio", "Fixed scale:")

            QQC2.ButtonGroup.group: zoomGroup

            onClicked: {
                constantZoomFactor.forceActiveFocus();
            }
        }

        QQC2.SpinBox {
            id: constantZoomFactor
            editable: true
            enabled: useConstantZoom.checked

            validator: RegExpValidator {
                regExp: new RegExp("[0-9]?[0-9]{2}[ ]?%");
            }

            textFromValue: function(value) {
                return value+"%";
            }

            valueFromText: function(text) {
                return text.split(" ")[0].split("%")[0];
            }

            from: 25
            to: 500
        }
    }

    RowLayout {
        QQC2.RadioButton {
            id: useMinViewWidth
            text: i18nc("@option:radio", "Automatic scaling if width is below")

            QQC2.ButtonGroup.group: zoomGroup

            onClicked: {
                minViewWidth.forceActiveFocus();
            }
        }

        QQC2.SpinBox {
            id: minViewWidth
            editable: true
            enabled: useMinViewWidth.checked

            validator: RegExpValidator {
                regExp: new RegExp("[0-9]?[0-9]{3}[ ]?px");
            }

            textFromValue: function(value) {
                return value+"px";
            }

            valueFromText: function(text) {
                return text.split(" ")[0].split("px")[0];
            }

            from: 320
            to: 3840
        }
    }

    RowLayout{
        Kirigami.FormData.label: i18nc("@title:group", "Starting URL:")
        QQC2.TextField {
		    id: startingUrl
            //editable: true
            enabled: true
	    }
    }
}
