#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=assets\Help.ico
#AutoIt3Wrapper_Outfile=bin\helper.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_UseX64=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

; KyTs Font Viewer Helper

#cs
		░░▓▓███  ████████████████████████████████▄▄
		░░▓▓███  ██         ▓███
		░░▓▓███ ██   ██  ██ ▓███  ██████
		░░▓▓█████    ██  ██ ▓███  ██   █
		░░▓▓███████  ██  ██ ▓███  ██
		░░▓▓▌█▐  ▌█  ▌▄  █▐ ▓▐██  ██████
		░░▓▓▌▄▐  ▌█  ▌▄  █▐ ▓▐██       █
		░░▓▓▌█▐  ▌█  ▌▀███▐ ▓▐██  ██████
						 ██
 ▄▄████████████████████████
#ce

Opt("TrayIconHide", 1)
Opt("GUICloseOnESC", 1)
Opt("GUIOnEventMode", 1)

#include <GDIPlus.au3>
#include <GuiRichEdit.au3>
#include <GuiConstants.au3>
#include <WindowsConstants.au3>
#include <StaticConstants.au3>

#Region	; Load Font Awesome Resource and Detect default fonts
Global Const $sFontAwesomePath = @ScriptDir & "\Resource\FontAwesome.otf"
Global Const $sFontAwesomeName = _WinAPI_GetFontResourceInfo($sFontAwesomePath, True)
_WinAPI_AddFontResourceEx($sFontAwesomePath, $FR_PRIVATE)

Global $CurentFontPath = @WindowsDir & '\Fonts\Arial.ttf', $CurentFontName = 'Arial'
Global $DefaultFont
If (StringInStr(@OSVersion, "WIN_VISTA|WIN_XP|WIN_XPe|WIN_2008R2|WIN_2008|WIN_2003") == 0) Then
	$DefaultFont = "Segoe UI"
Else
	$DefaultFont = "Arial"
EndIf
#EndRegion

Global Const $Tile = 'KyTs Font Viewer Helper'
Global Const $gW = 600, $gH = 500
Global Const $TileBarHeigth = 35
Global $CurentLanguage = 'EN'
Global $sHelper_EN = @ScriptDir & '\Resource\Help_EN.rtf'
Global $sHelper_VN = @ScriptDir & '\Resource\Help_VN.rtf'

If (Not FileExists($sHelper_EN)) Or (Not FileExists($sHelper_VN)) Then MsgBox(16, 'Missing File!', 'The construction file is not available. Reinstall the software to fix this!')

#Region 	;Create GUI
Global $hGUI = GUICreate($Tile, $gW, $gH, -1, -1, BitOR($WS_POPUP, $WS_BORDER), BitOR($WS_EX_TOOLWINDOW, $WS_EX_TOPMOST))
GUISetBkColor(0xFFFFFF)

_GDIPlus_Startup()
; Create tile bar
GUICtrlCreateLabel('', 0, 0, $gW, $TileBarHeigth)
GUICtrlSetBkColor(-1, 0x2D2D30)
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKRIGHT + $GUI_DOCKHEIGHT)

_GDIPlus_CreatePic(@ScriptDir & "\Resource\Icon_mini.png", 5, 5, 25, 25)
GUICtrlSetBkColor(-1, -2)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)

GUICtrlCreateLabel($Tile, 35, 0, $gW-185, $TileBarHeigth, $SS_CENTERIMAGE)
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

Global $hRichEdit = _GUICtrlRichEdit_Create($hGUI, "", 0, $TileBarHeigth, $gW, $gH-$TileBarHeigth-30, BitOR($ES_MULTILINE, $ES_READONLY, $WS_VSCROLL), $WS_EX_TOOLWINDOW)
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