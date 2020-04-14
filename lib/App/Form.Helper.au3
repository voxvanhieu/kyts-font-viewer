#region Helper
Global Const $Helper_Title = 'Kyts Font Viewer Helper'
Global Const $Helper_gW = 600, $Helper_gH = 500
Global $CurentLanguage = 'EN'
Global $sHelper_EN = @ScriptDir & '\assets\Help_EN.rtf'
Global $sHelper_VN = @ScriptDir & '\assets\Help_VN.rtf'
#endregion

If (Not FileExists($sHelper_EN)) Or (Not FileExists($sHelper_VN)) Then
	MsgBox(16, 'Missing File!', 'The construction file is not available. Reinstall the software to fix this!')
EndIf

Func _Create_HelperGUI()
	
	#Region 	;Create GUI
	Global $hHelper = GUICreate($Helper_Title, $Helper_gW, $Helper_gH, -1, -1, BitOR($WS_POPUP, $WS_BORDER), BitOR($WS_EX_TOOLWINDOW, $WS_EX_TOPMOST))
	GUISetBkColor(0xFFFFFF)

	_GDIPlus_Startup()
	; Create Title bar
	GUICtrlCreateLabel('', 0, 0, $Helper_gW, $TitleBarHeigth)
	GUICtrlSetBkColor(-1, 0x2D2D30)
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKRIGHT + $GUI_DOCKHEIGHT)

	_GDIPlus_CreatePic(@ScriptDir & "\assets\Icon_mini.png", 5, 5, 25, 25)
	GUICtrlSetBkColor(-1, -2)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)

	GUICtrlCreateLabel($Helper_Title, 35, 0, $Helper_gW-185, $TitleBarHeigth, $SS_CENTERIMAGE)
	GUICtrlSetColor(-1, 0xFFFFFF)
	GUICtrlSetBkColor(-1, -2)
	GUICtrlSetFont(-1, 12, 0, 0, $DefaultFont & " SemiBold", 5)
	;~ GUICtrlSetOnEvent(-1,'_FormMove')
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKRIGHT + $GUI_DOCKHEIGHT)

	GUICtrlCreateLabel(ChrW(0xf00d), $Helper_gW-40, 0, 35, 35, BitOR($SS_CENTER, $SS_CENTERIMAGE))
	GUICtrlSetColor(-1, 0xFFFFFF)
	GUICtrlSetBkColor(-1, 0xFF0F15)
	GUICtrlSetCursor(-1, 0)
	GUICtrlSetFont(-1, 15, 0, 0, $sFontAwesomeName, 5)
	GUICtrlSetTip(-1, "Exit")
	GUICtrlSetOnEvent(-1, "_Hide")
	GUICtrlSetResizing(-1, $GUI_DOCKTOP + $GUI_DOCKRIGHT + $GUI_DOCKHEIGHT + $GUI_DOCKWIDTH)

	Global $hRichEdit = _GUICtrlRichEdit_Create($hHelper, "", 0, $TitleBarHeigth, $Helper_gW, $Helper_gH-$TitleBarHeigth-30, BitOR($ES_MULTILINE, $ES_READONLY, $WS_VSCROLL), $WS_EX_TOOLWINDOW)
			_GUICtrlRichEdit_StreamFromFile($hRichEdit, $sHelper_EN)
			_GUICtrlRichEdit_SetScrollPos($hRichEdit, 0, 0)

	GUICtrlCreateLabel(' Click here to change language: English/Vietnamese', 0, $Helper_gH-30, $Helper_gW, 30, $SS_CENTERIMAGE)
	GUICtrlSetColor(-1, 0xFFFFFF)
	GUICtrlSetBkColor(-1, 0x1C8BFF)
	GUICtrlSetFont(-1, 10, 0, 0, $DefaultFont, 500)
	GUICtrlSetCursor(-1, 0)
	GUICtrlSetOnEvent(-1, "_ChangeLanguage")

	GUISetState(@SW_SHOW, $hHelper)
	#EndRegion 	;Create GUI

EndFunc
Func _Hide()
	GUISetState(@SW_HIDE, $hHelper)
	_ShowForm()
Endfunc

Func _ChangeLanguage()
	Switch $CurentLanguage
		Case 'VN'
			$CurentLanguage = 'EN'
			_GUICtrlRichEdit_StreamFromFile($hRichEdit, $sHelper_EN)
			_GUICtrlRichEdit_SetScrollPos($hRichEdit, 0, 0)
		Case 'EN'
			$CurentLanguage = 'VN'
			_GUICtrlRichEdit_StreamFromFile($hRichEdit, $sHelper_VN)
			_GUICtrlRichEdit_SetScrollPos($hRichEdit, 0, 0)
	EndSwitch
EndFunc