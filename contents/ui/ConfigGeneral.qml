import QtQuick 2.0
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12
import org.kde.kirigami 2.4 as Kirigami

Kirigami.FormLayout {
	id: page

	property alias cfg_filePath: filePath.text
	property alias cfg_fullHeight: fullHeight.value
	property alias cfg_fullWidth: fullWidth.value
	property alias cfg_textColor: textColor.text
	property alias cfg_textBackground: textBackground.text
	property alias cfg_textSelectionBackground: textSelectionBackground.text

	RowLayout {
		id: setSize
		spacing: 6
		Label{
			text: i18n("Height")
		}
		SpinBox {
			id: fullHeight
			from: 1
			to: 5000
		}
		Label{
			text: i18n("Width")
		}
		SpinBox {
			id: fullWidth
			from: 1
			to: 5000
		}
	}
	TextField {
		id: filePath
		Kirigami.FormData.label: i18n("markdown file path:")
	}
	TextField {
		id: textColor
		Kirigami.FormData.label: i18n("Text color:")
	}
	TextField {
		id: textBackground
		Kirigami.FormData.label: i18n("Text background color:")
	}
	TextField {
		id: textSelectionBackground
		Kirigami.FormData.label: i18n("Text selection background color:")
	}
	
}



/*


property alias cfg_filePath: filePath.text
	property alias cfg_fullHeight: fullHeight.value
	property alias cfg_fullWidth: fullWidth.value
	property alias cfg_textColor: textColor.text
	property alias cfg_textBackground: textBackground.text
	property alias cfg_textSelectionBackground: textSelectionBackground.text




	RowLayout{
		Kirigami.FormData.label: i18nc("@title:group", "File path:")
		QQC2.TextField {
			id: filePath
			//editable: true
			enabled: true
		}
	}

	RowLayout {
		Kirigami.FormData.label: i18nc("@title:group", "Height (px):")
		QQC2.SpinBox {
			id: fullHeight
			editable: true
			enabled: true

			from: 10
			to: 5000
		}
	}

	RowLayout {
		Kirigami.FormData.label: i18nc("@title:group", "Width (px):")
		QQC2.SpinBox {
			id: fullWidth
			editable: true
			enabled: true

			from: 10
			to: 5000
		}
	}

	RowLayout {
		Kirigami.FormData.label: i18nc("@title:group", "Text color:")
		QQC2.TextInput {
			id: textColor
			editable: true
			enabled: true
		}
	}
	RowLayout {
		Kirigami.FormData.label: i18nc("@title:group", "Text background:")
		QQC2.TextInput {
			id: textBackground
			editable: true
			enabled: true
		}
	}
	RowLayout {
		Kirigami.FormData.label: i18nc("@title:group", "Text selection background:")
		QQC2.TextInput {
			id: textSelectionBackground
			editable: true
			enabled: true
		}
	}*/