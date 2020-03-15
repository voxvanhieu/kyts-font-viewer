

If (Not FileExists($sHelper_EN)) Or (Not FileExists($sHelper_VN)) Then MsgBox(16, 'Missing File!', 'The construction file is not available. Reinstall the software to fix this!')

#Region 	;Create GUI
Global $hGUI = GUICreate($Title, $gW, $gH, -1, -1, BitOR($WS_POPUP, $WS_BORDER), BitOR($WS_EX_TOOLWINDOW, $WS_EX_TOPMOST))
GUISetBkColor(0xFFFFFF)

_GDIPlus_Startup()
; Create Title bar
GUICtrlCreateLabel('', 0, 0, $gW, $TitleBarHeigth)
GUICtrlSetBkColor(-1, 0x2D2D30)
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKRIGHT + $GUI_DOCKHEIGHT)

_GDIPlus_CreatePic(@ScriptDir & "\assets\Icon_mini.png", 5, 5, 25, 25)
GUICtrlSetBkColor(-1, -2)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)

GUICtrlCreateLabel($Title, 35, 0, $gW-185, $TitleBarHeigth, $SS_CENTERIMAGE)
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetBkColor(-1, -2)
GUICtrlSetFont(-1, 12, 0, 0, $DefaultFont & " SemiBold", 5)
GUICtrlSetOnEvent(-1,'_FormMove')
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKRIGHT + $GUI_DOCKHEIGHT)

GUICtrlCreateLabel(ChrW(0xf00d), $gW-40, 0, 35, 35, BitOR($SS_CENTER, $SS_CENTERIMAGE))
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetBkColor(-1, 0xFF0F15)
GUICtrlSetCursor(-1, 0)
GUICtrlSetFont(-1, 15, 0, 0, $sFontAwesomeName, 5)
GUICtrlSetTip(-1, "Exit")
GUICtrlSetOnEvent(-1, "_Exit")
GUICtrlSetResizing(-1, $GUI_DOCKTOP + $GUI_DOCKRIGHT + $GUI_DOCKHEIGHT + $GUI_DOCKWIDTH)

Global $hRichEdit = _GUICtrlRichEdit_Create($hGUI, "", 0, $TitleBarHeigth, $gW, $gH-$TitleBarHeigth-30, BitOR($ES_MULTILINE, $ES_READONLY, $WS_VSCROLL), $WS_EX_TOOLWINDOW)
		_GUICtrlRichEdit_StreamFromFile($hRichEdit, $sHelper_EN)
		_GUICtrlRichEdit_SetScrollPos($hRichEdit, 0, 0)

GUICtrlCreateLabel(' Click here to change language: English/Vietnamese', 0, $gH-30, $gW, 30, $SS_CENTERIMAGE)
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetBkColor(-1, 0x1C8BFF)
GUICtrlSetFont(-1, 10, 0, 0, $DefaultFont, 500)
GUICtrlSetCursor(-1, 0)
GUICtrlSetOnEvent(-1, "_ChangeLanguage")

WinSetTrans($hGUI, '', 0)
GUISetState()
_ShowForm()
#EndRegion 	;Create GUI

#Region 	; Reduce Memory Register
AdlibRegister(_ReduceMemory, 500)
Func _ReduceMemory()
    Local $ai_GetCurrentProcessId = DllCall('kernel32.dll', 'int', 'GetCurrentProcessId')
    Local $ai_Handle = DllCall("kernel32.dll", 'int', 'OpenProcess', 'int', 0x1f0fff, 'int', False, 'int', $ai_GetCurrentProcessId[0])
    Local $ai_Return = DllCall("psapi.dll", 'int', 'EmptyWorkingSet', 'long', $ai_Handle[0])
    DllCall('kernel32.dll', 'int', 'CloseHandle', 'int', $ai_Handle[0])
    Return $ai_Return[0]
EndFunc
#EndRegion

While 1
	Sleep(200)
WEnd

Func _ShowForm()
	Local $I
	For $I = 0 To 255 Step +15
		WinSetTrans($hGUI,'', $I)
		Sleep(10)
	Next
EndFunc
Func _HideForm()
	Local $I
	For $I = 255 To 0 Step -15
		WinSetTrans($hGUI,'', $I)
		Sleep(10)
	Next
EndFunc
Func _Exit()
	_HideForm()
	_GDIPlus_Shutdown()
	_WinAPI_RemoveFontResourceEx($sFontAwesomePath, $FR_PRIVATE)
	Exit
EndFunc
Func _FormMove()
	DllCall('user32.dll', 'int', 'SendMessage', 'HWND', $hGUI, 'int', 0x0112, 'int', 0xF012, 'int', 0)
EndFunc		;Moving Form
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
Func _GDIPlus_CreatePic($FileName, $Left, $Top, $Width, $Heigth)
	Local $hPicCtrl, $hImage, $iHeight, $hGDIBitmap
	$hImage = _GDIPlus_ImageResize(_GDIPlus_ImageLoadFromFile($FileName), $Width, $Heigth)
		$iWidth = _GDIPlus_ImageGetWidth($hImage)
		$iHeight = _GDIPlus_ImageGetHeight($hImage)
		$hGDIBitmap = _GDIPlus_BitmapCreateHBITMAPFromBitmap($hImage)
		_GDIPlus_ImageDispose($hImage)
	$hPicCtrl = GUICtrlCreateLabel('', $Left, $Top, $Width, $Heigth, $SS_BITMAP)
	_WinAPI_DeleteObject(GUICtrlSendMsg($hPicCtrl, 0x0172, $IMAGE_BITMAP, $hGDIBitmap)) ;$STM_SETIMAGE = 0x0172
    _WinAPI_DeleteObject($hGDIBitmap)
	Return $hPicCtrl
EndFunc			;~	Using GDIPlus to create Picture control, shouldn't create many control with this and project use GDIPlus