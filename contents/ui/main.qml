/*
 *   SPDX-FileCopyrightText: 2014, 2016 Mikhail Ivchenko <ematirov@gmail.com>
 *   SPDX-FileCopyrightText: 2018 Kai Uwe Broulik <kde@privat.broulik.de>
 *   SPDX-FileCopyrightText: 2020 Sora Steenvoort <sora@dillbox.me>
 *
 *   SPDX-License-Identifier: GPL-2.0-or-later
 */

import QtQuick 2.7
import QtQuick.Controls 2.0
import QtWebEngine 1.5
import QtQuick.Layouts 1.1
import org.kde.plasma.components 2.0 as PlasmaComponents // for Menu+MenuItem
import org.kde.plasma.components 3.0 as PlasmaComponents3
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.extras 2.0 as PlasmaExtras
import org.kde.plasma.plasmoid 2.0

//to be removed
import QtAudioEngine 1.15

//import QtQuick.Controls 2.12 as QQC2


Item {
	id: root
	property string filePath: Plasmoid.configuration.filePath
	property string fullHeight: Plasmoid.configuration.fullHeight
	property string fullWidth: Plasmoid.configuration.fullWidth
	property string textColor: Plasmoid.configuration.textColor
	property string textBackground: Plasmoid.configuration.textBackground
	property string textSelectionBackground: Plasmoid.configuration.textSelectionBackground

	Component.onCompleted: {
		//onStartup();
		openMarkdown()
		plasmoid.addEventListener('ConfigChanged', configChanged);
	}
	/*focus: plasmoid.expanded
	onFocusChanged: {

		lView.currentItem.setText("diocan")
	}*/
	
	function configChanged(){ // dont know if useful or not
		root.filePath = plasmoid.readConfig("filePath");
		root.fullHeight = plasmoid.readConfig("fullHeight");
		root.fullWidth = plasmoid.readConfig("fullWidth");
		root.textColor = plasmoid.readConfig("textColor");
		root.textBackground = plasmoid.readConfig("textBackground");
		root.textSelectionBackground = plasmoid.readConfig("textSelectionBackground");
	}

	function openFile(fileUrl) {
		var request = new XMLHttpRequest();
		request.open("GET", fileUrl, false);
		request.send(null);
		return request.responseText;
	}

	function saveFile(fileUrl, text) {
		var request = new XMLHttpRequest();
		request.open("PUT", fileUrl, false);
		request.send(text);
		return request.status;
	}

	function exportMarkdown(){
		let doc = ""
		for(let i=0; i<lView.model.count; i++){
			doc = doc + lView.itemAtIndex(i).getText()+ "\n"
		}
		saveFile("/home/tubbadu/prova.md", doc)
	}

	function openMarkdown(){
		lModel.clear()
		let doc = openFile("/home/tubbadu/prova.md").split("\n")
		for (let i=0; i<doc.length; i++){
			lView.addBlock(-1, doc[i])
		}
	}
	
	Layout.preferredWidth: fullWidth
	Layout.preferredHeight: fullHeight
	Rectangle {
		anchors.fill: parent
		color: textBackground
		ColumnLayout{
			id: colLay
			spacing: 10
			anchors.fill: parent

			Button {
				id: butt
				visible: false
				text: "aa"
				anchors.right: parent.right
				onClicked: text = "lModel.get(i).text"//exportMarkdown() //lView.addBlock(0)
			}

			Text {
				id: hiddenMarkdownRender
				visible: false
				font.pixelSize: 18 // add in config TODO
				textFormat: TextEdit.MarkdownText
				text: "a"
			}

			ListModel{
				id: lModel
			}

			Component {
				id: block
				Rectangle {
					default property alias data: col.data
					implicitWidth: colLay.width 
					implicitHeight: col.implicitHeight
					color: (tEdit.focus ? textSelectionBackground : textBackground) // change colors
					property string formatted
					onFocusChanged: {
						tEdit.focus = true
					}

					function setAsCurrentItem(){
						lView.currentIndex = index
					}
					function setFocused(){
						tEdit.focus = true
					}
					function addText(txt){
						tEdit.text = tEdit.text + txt
					}
					function setCursorPosition(pos){
						tEdit.cursorPosition = pos
					}
					function getText(){
						return tEdit.text
					}
					function getLength(){
						return tEdit.length
					}
					function deleteCurrentItemAndMoveUp(){
						if (index > 0){
							lView.decrementCurrentIndex()
							let setIndex = lView.currentItem.getLength()
							lView.currentItem.addText(tEdit.text)
							lView.currentItem.setCursorPosition(setIndex)
							lModel.remove(index)
						} else {
							// is the first block, do nothing
						}
					}

					function deleteNextItemAndMoveUp(){ // TODO move cursor
						/* 
						* check if item is last
						* if last, do nothing
						* otherwise, delete next item and copy it's text to this
						*/

						if (index < lModel.count-1){
							let setIndex = tEdit.cursorPosition
							tEdit.text = tEdit.text + lView.itemAtIndex(index+1).getText()
							tEdit.cursorPosition = setIndex
							lModel.remove(index+1)
						} else {
							// is the last block, do nothing
						}
					}
					Column {
						id: col
						anchors.fill: parent
						spacing: 20
						
						TextEdit {
							id: tEdit
							property string ssetText: setText
							width: parent.width
							text: setText
							font.pixelSize: (hiddenMarkdownRender.height / tView.lineCount) * 0.75
							color: textColor
							wrapMode: TextEdit.Wrap

							onFocusChanged: {
								tView.visible = !focus
								visible = focus
								formatted = text
								if (focus) {
									hiddenMarkdownRender.text = formatted
									setAsCurrentItem()
								}
							}

							Component.onCompleted:{
								focus = true
							}
							onEditingFinished: {
								// perde fuoco
								exportMarkdown()
							}

							Keys.onReturnPressed: {
								if (lView.currentIndex + 1 < lView.model.count){
									lView.addBlock(lView.currentIndex + 1)
								} else {
									lView.addBlock(-1)
								}
							}

							Keys.onPressed: {
								let delKey = 16777219
								let cancKey = 16777223
								let tabKey = 16777217
								let shiftTabKey = 16777218
								let escKey = 16777216

								//butt.text = event.key
								if (event.key == delKey){
									if(cursorPosition == 0){
										event.accepted = true;
										deleteCurrentItemAndMoveUp()
									}
								} else if (event.key == cancKey){
									if(cursorPosition == length){
										event.accepted = true;
										deleteNextItemAndMoveUp()
									}
								} else if (event.key == tabKey){
									openMarkdown()
								} else if (event.key == shiftTabKey){

								} else if (event.key == escKey){
									focus = false
								}
							}

							Timer {
								interval: 100
								running: tEdit.focus && plasmoid.expanded
								repeat: true
								onTriggered: {
									formatted=tEdit.text
									hiddenMarkdownRender.text = formatted
									saveFile("/home/tubbadu/log.txt", Date().toString())
									lView.focus = true
								}
							}
						}

						Text {
							id: tView
							font.pixelSize: hiddenMarkdownRender.font.pixelSize
							textFormat: TextEdit.MarkdownText
							text: formatted
							width: parent.width
							wrapMode: TextEdit.Wrap
							color: textColor

							function clicked(){
								tEdit.focus = true
							}

							MouseArea {
								anchors.fill: parent
								onClicked: {
									tView.clicked()
								}
							}
						}
					}
				}
			}

			ListView{
				id: lView
				anchors.fill: parent
				model: lModel
				delegate: block
				snapMode: ListView.NoSnap
				focus:  true
				ScrollBar.vertical: ScrollBar {
					active: true
				}
				property int n: 0

				
				function addBlock(index, txt=""){
					let prop = {"setText": txt, "setMarkdown": "# markdown `prova` " + n, "setFocused": true}
					if(index == -1) {
						model.append(prop)
					}
					model.insert(index, prop)
					incrementCurrentIndex()
					let setIndex = currentItem.getLength()
					currentItem.setCursorPosition(setIndex)
					n=n+1
				}

				Component.onCompleted: {
					if (lView.model.count == 0) {
						lView.addBlock(0)
					}
				}
			}
		}
	}
}