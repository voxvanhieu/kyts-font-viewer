#RequireAdmin
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=Resource\Icon.ico
#AutoIt3Wrapper_Outfile=bin\kfv-installer.exe
#AutoIt3Wrapper_Outfile_x64=bin\kfv-installer(x64).exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_Compile_Both=y
#AutoIt3Wrapper_Res_Comment=KyTs Font Viewer Installer Software
#AutoIt3Wrapper_Res_Description=KyTs Installer
#AutoIt3Wrapper_Res_Fileversion=1.0.0.0
#AutoIt3Wrapper_Res_LegalCopyright=JK. KyTs
#AutoIt3Wrapper_Res_Language=1066
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

Opt("TrayIconHide", 1)
Opt("GUICloseOnESC", 1)
Opt("GUIOnEventMode", 1)
Opt("GUIResizeMode", 802)

#include <GDIPlus.au3>
#include <WinAPI.au3>
#include <GUITab.au3>
#include <GuiRichEdit.au3>
#include <GuiConstants.au3>
#include "UDF\TVExplorer.au3"

Global $SoftwareName = 'KyTs Font Viewer'
Global $Tile = $SoftwareName & " Installer"
Global $gW = 600, $gH = 150

#Region	;Install resource
If @Compiled Then
	Global $sTempDir = @TempDir & '\KyTs Tech'
	DirCreate($sTempDir)
	FileInstall("Resource\FontAwesome.otf", $sTempDir & '\FontAwesome.otf')
	Global $sFontAwesomePatch = $sTempDir & '\FontAwesome.otf'
	FileInstall('Resource\Logo.png', $sTempDir & '\Logo.png')
	Global $sLogoDir = $sTempDir & '\Logo.png'
	FileInstall('Resource\Icon.png', $sTempDir & '\Icon.png')
	Global $sIconDir = $sTempDir & '\Icon.png'
	FileInstall("Resource\ReadMe.rtf", $sTempDir & '\ReadMe.rtf')
	Global $sDieuKhoan = $sTempDir & '\ReadMe.rtf'
Else
	Global $sFontAwesomePatch = @ScriptDir & '\Resource\FontAwesome.otf'
	Global $sLogoDir = @ScriptDir & '\Resource\Logo.png'
	Global $sIconDir = @ScriptDir & '\Resource\Icon.png'
	Global $sDieuKhoan = @ScriptDir & '\Resource\ReadMe.rtf'
EndIf
#EndRegion

#Region	; Load Font Awesome Resource and Detect default font
Global Const $sFontAwesomeName = _WinAPI_GetFontResourceInfo($sFontAwesomePatch, True)
_WinAPI_AddFontResourceEx($sFontAwesomePatch, $FR_PRIVATE)

Global $DefaultFont
If (StringInStr(@OSVersion, "WIN_VISTA|WIN_XP|WIN_XPe|WIN_2008R2|WIN_2008|WIN_2003") == 0) Then
	$DefaultFont = "Segoe UI"
Else
	$DefaultFont = "Arial"
EndIf
#EndRegion

_GDIPlus_Startup()

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

#Region ; Main GUI and Controls
$hGUI = GUICreate($Tile, $gW, $gH+50, -1, -1, BitOR($WS_POPUP, $WS_BORDER))
GUISetBkColor(0xFFFFFF)
GUISetOnEvent($GUI_EVENT_CLOSE, "_Exit")

GUICtrlSetOnEvent(_GDIPlus_CreatePic($sLogoDir, 0, 0, $gH, $gH), '_FormMove')

GUICtrlCreateLabel('KyTs Tech', $gH, 0, Int(($gW-$gH)/2)-25, Int($gH/2), BitOR($SS_CENTER, $SS_CENTERIMAGE))
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetBkColor(-1, 0x266996)
GUICtrlSetFont(-1, 20, 0, 0, $DefaultFont & ' Bold', 5)
GUICtrlSetOnEvent(-1, '_FormMove')

GUICtrlCreateLabel('KyTs Font Viewer', $gH+Int(($gW-$gH)/2)-25, 0, Int(($gW-$gH)/2)+25, Int($gH/2), BitOR($SS_CENTER, $SS_CENTERIMAGE))
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetBkColor(-1, 0x0082CD)
GUICtrlSetFont(-1, 20, 0, 0, $DefaultFont, 5)
GUICtrlSetOnEvent(-1, '_FormMove')

GUICtrlCreateLabel('', $gH, Int($gH/2), Int($gH/2), 5, BitOR($SS_CENTER, $SS_CENTERIMAGE))
GUICtrlSetBkColor(-1, 0x16A180)
Global $MenuBar1 = GUICtrlCreateLabel(ChrW(0xf015), $gH, Int($gH/2)+5, Int($gH/2), Int($gH/2)-5, BitOR($SS_CENTER, $SS_CENTERIMAGE))
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetBkColor(-1, 0x19BD9B)
GUICtrlSetTip(-1, "Home Page: kytstech.blogspot.com")
GUICtrlSetCursor(-1, 0)
GUICtrlSetFont(-1, 25, 0, 0, $sFontAwesomeName, 5)
GUICtrlSetOnEvent(-1, '_MenuBarClicked')

GUICtrlCreateLabel('', $gH+Int($gH/2)*1, Int($gH/2), Int($gH/2), 5, BitOR($SS_CENTER, $SS_CENTERIMAGE))
GUICtrlSetBkColor(-1, 0x2883BA)
Global $MenuBar2 = GUICtrlCreateLabel(ChrW(0xf230), $gH+Int($gH/2)*1, Int($gH/2)+5, Int($gH/2), Int($gH/2)-5, BitOR($SS_CENTER, $SS_CENTERIMAGE))
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetBkColor(-1, 0x3598DB)
GUICtrlSetTip(-1, "Facebook: fb.me/kytstech")
GUICtrlSetCursor(-1, 0)
GUICtrlSetFont(-1, 25, 0, 0, $sFontAwesomeName, 5)
GUICtrlSetOnEvent(-1, '_MenuBarClicked')

GUICtrlCreateLabel('', $gH+Int($gH/2)*2, Int($gH/2), Int($gH/2), 5, BitOR($SS_CENTER, $SS_CENTERIMAGE))
GUICtrlSetBkColor(-1, 0xD1A802)
Global $MenuBar3 = GUICtrlCreateLabel(ChrW(0xf0e0), $gH+Int($gH/2)*2, Int($gH/2)+5, Int($gH/2), Int($gH/2)-5, BitOR($SS_CENTER, $SS_CENTERIMAGE))
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetBkColor(-1, 0xF2CA2A)
GUICtrlSetTip(-1, "Send an Email to us!")
GUICtrlSetCursor(-1, 0)
GUICtrlSetFont(-1, 25, 0, 0, $sFontAwesomeName, 5)
GUICtrlSetOnEvent(-1, '_MenuBarClicked')

GUICtrlCreateLabel('', $gH+Int($gH/2)*3, Int($gH/2), Int($gH/2), 5, BitOR($SS_CENTER, $SS_CENTERIMAGE))
GUICtrlSetBkColor(-1, 0xD05400)
Global $MenuBar4 = GUICtrlCreateLabel(ChrW(0xf09b), $gH+Int($gH/2)*3, Int($gH/2)+5, Int($gH/2), Int($gH/2)-5, BitOR($SS_CENTER, $SS_CENTERIMAGE))
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetBkColor(-1, 0xE77E23)
GUICtrlSetTip(-1, "KyTs Tech's GitHub")
GUICtrlSetCursor(-1, 0)
GUICtrlSetFont(-1, 25, 0, 0, $sFontAwesomeName, 5)
GUICtrlSetOnEvent(-1, '_MenuBarClicked')

GUICtrlCreateLabel('', $gH+Int($gH/2)*4, Int($gH/2), Int($gH/2), 5, BitOR($SS_CENTER, $SS_CENTERIMAGE))
GUICtrlSetBkColor(-1, 0xB63D32)
Global $MenuBar5 = GUICtrlCreateLabel(ChrW(0xf16a), $gH+Int($gH/2)*4, Int($gH/2)+5, Int($gH/2), Int($gH/2)-5, BitOR($SS_CENTER, $SS_CENTERIMAGE))
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetBkColor(-1, 0xE84C3D)
GUICtrlSetTip(-1, "Youtube Chanel")
GUICtrlSetCursor(-1, 0)
GUICtrlSetFont(-1, 25, 0, 0, $sFontAwesomeName, 5)
GUICtrlSetOnEvent(-1, '_MenuBarClicked')

GUICtrlCreateLabel('', $gH+Int($gH/2)*5, Int($gH/2), Int($gH/2), 5, BitOR($SS_CENTER, $SS_CENTERIMAGE))
GUICtrlSetBkColor(-1, 0x2C2C2C)
Global $MenuBar6 = GUICtrlCreateLabel(ChrW(0xf21b), $gH+Int($gH/2)*5, Int($gH/2)+5, Int($gH/2), Int($gH/2)-5, BitOR($SS_CENTER, $SS_CENTERIMAGE))
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetBkColor(-1, 0x4D4D4D)
GUICtrlSetTip(-1, "Some infomations about KyTs Tech!")
GUICtrlSetCursor(-1, 0)
GUICtrlSetFont(-1, 25, 0, 0, $sFontAwesomeName, 5)
GUICtrlSetOnEvent(-1, '_MenuBarClicked')

#Region	;Create Tab
Global $hTab = GUICtrlCreateTab(0, $gH-5, $gW, $gH*2+5, BitOR($TCS_FLATBUTTONS, $TCS_FIXEDWIDTH))
_GUICtrlTab_SetItemSize($hTab,0,1)
GUICtrlSetResizing($hTab, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
	GUICtrlCreateTabItem(" ")	; Tab Start
		_GDIPlus_CreatePic($sIconDir, 10, $gH+10, 100, 100)
		GUICtrlCreateLabel('', 115, $gH+10, 5, 100)
		GUICtrlSetBkColor(-1, 0x1C8BFF)
		GUICtrlCreateLabel(' ' & $Tile, 120, $gH+10, $gW-130, 100, $SS_CENTERIMAGE)
		GUICtrlSetBkColor(-1, 0xEEEEEE)
		GUICtrlSetFont(-1, 25, 0, 0, $DefaultFont & ' SemiBold', 5)

		Local $_iH = $gH+110
		Local $__iH = $gH*3-$_iH

		Global $lb_AutoInstall = GUICtrlCreateLabel("Auto Install", Int($gW/2)-150, $_iH+($__iH/4-50/2)+10, 300, 50, BitOR($SS_CENTER, $SS_CENTERIMAGE))
		GUICtrlSetColor(-1, 0xFFFFFF)
		GUICtrlSetBkColor(-1, 0x1C8BFF)
		GUICtrlSetCursor(-1, 0)
		GUICtrlSetFont(-1, 18, 0, 0, $DefaultFont, 5)
		GUICtrlSetOnEvent(-1, '_TabChange')
		Global $lb_AutoInstall_Icon = GUICtrlCreateLabel(ChrW(0xf04b), Int($gW/2)-150, $_iH+($__iH/4-50/2)+10, 50, 50, BitOR($SS_CENTER, $SS_CENTERIMAGE))
		GUICtrlSetColor(-1, 0xFFFFFF)
		GUICtrlSetBkColor(-1, 0x266996)
		GUICtrlSetCursor(-1, 0)
		GUICtrlSetFont(-1, 18, 0, 0, $sFontAwesomeName, 5)
		GUICtrlSetOnEvent(-1, '_TabChange')

		Global $lb_CustomInstall = GUICtrlCreateLabel("Custom Install", Int($gW/2)-150, 360, 300, 50, BitOR($SS_CENTER, $SS_CENTERIMAGE))
		GUICtrlSetColor(-1, 0xFFFFFF)
		GUICtrlSetBkColor(-1, 0x1C8BFF)
		GUICtrlSetCursor(-1, 0)
		GUICtrlSetFont(-1, 18, 0, 0, $DefaultFont, 5)
		GUICtrlSetOnEvent(-1, '_TabChange')
		Global $lb_CustomInstall_Icon = GUICtrlCreateLabel(ChrW(0xf013), Int($gW/2)-150, 360, 50, 50, BitOR($SS_CENTER, $SS_CENTERIMAGE))
		GUICtrlSetColor(-1, 0xFFFFFF)
		GUICtrlSetBkColor(-1, 0x266996)
		GUICtrlSetCursor(-1, 0)
		GUICtrlSetFont(-1, 18, 0, 0, $sFontAwesomeName, 5)
		GUICtrlSetOnEvent(-1, '_TabChange')
	GUICtrlCreateTabItem(" ")	; Tab Users Licence
		Global $hRichEdit = _GUICtrlRichEdit_Create($hGUI, "", 10, 160, $gW-20, 220, BitOR($ES_MULTILINE, $ES_READONLY, $WS_VSCROLL), $WS_EX_TOOLWINDOW)
		_GUICtrlRichEdit_StreamFromFile($hRichEdit, $sDieuKhoan)
		_GUICtrlRichEdit_SetScrollPos($hRichEdit, 0, 0)
		ControlDisable($hGUI, '', $hRichEdit)
		ControlHide($hGUI, '', $hRichEdit)

		Global $lb_TabUL_NotAgree_Icon = GUICtrlCreateLabel(ChrW(0xf00d), 10, 390, 40, 50, BitOR($SS_CENTER, $SS_CENTERIMAGE))
		GUICtrlSetColor(-1, 0xFFFFFF)
		GUICtrlSetBkColor(-1, 0xEA3121)
		GUICtrlSetCursor(-1, 0)
		GUICtrlSetFont(-1, 20, 0, 0, $sFontAwesomeName, 5)
		GUICtrlSetOnEvent(-1, '_Exit')
		Global $lb_TabUL_NotAgree = GUICtrlCreateLabel("I don't agree with Users Licences", 50, 390, 245, 50, $SS_CENTERIMAGE)
		GUICtrlSetColor(-1, 0xFFFFFF)
		GUICtrlSetBkColor(-1, 0xEA3121)
		GUICtrlSetCursor(-1, 0)
		GUICtrlSetFont(-1, 12, 0, 0, $DefaultFont, 5)
		GUICtrlSetOnEvent(-1, '_Exit')

		Global $lb_TabUL_Agree_Icon = GUICtrlCreateLabel(ChrW(0xf00c), 305, 390, 40, 50, BitOR($SS_CENTER, $SS_CENTERIMAGE))
		GUICtrlSetColor(-1, 0xFFFFFF)
		GUICtrlSetBkColor(-1, 0x118408)
		GUICtrlSetCursor(-1, 0)
		GUICtrlSetFont(-1, 20, 0, 0, $sFontAwesomeName, 5)
		GUICtrlSetOnEvent(-1, '_TabChange')
		Global $lb_TabUL_Agree = GUICtrlCreateLabel('I agree with Users Licences', 345, 390, 245, 50, $SS_CENTERIMAGE)
		GUICtrlSetColor(-1, 0xFFFFFF)
		GUICtrlSetBkColor(-1, 0x118408)
		GUICtrlSetCursor(-1, 0)
		GUICtrlSetFont(-1, 12, 0, 0, $DefaultFont, 5)
		GUICtrlSetOnEvent(-1, '_TabChange')
	GUICtrlCreateTabItem(" ") ;Chose Location
		Global $InstallDir = @ProgramFilesDir & '\KyTs Tech\KyTs Font Viewer'

		GUICtrlCreateLabel("Sellect location to install this software:", 10, 170, $gW-20, 30, $SS_CENTERIMAGE)
		GUICtrlSetFont(-1, 15, 0, 0, $DefaultFont, 5)

		GUICtrlCreateLabel(ChrW(0xf07c), 20, 210, 30, 30, BitOR($SS_CENTER, $SS_CENTERIMAGE))
		GUICtrlSetColor(-1, 0x000000)
		GUICtrlSetBkColor(-1, 0xFFFFFF)
		GUICtrlSetCursor(-1, 0)
		GUICtrlSetTip(-1, 'Browse')
		GUICtrlSetFont(-1, 20, 0, 0, $sFontAwesomeName, 5)
		GUICtrlSetOnEvent(-1, '_SellectFolder')

		Global $inp_TabCL_InstallDir = GUICtrlCreateInput($InstallDir, 60, 210, 500, 30, -1, 0)
		GUICtrlSetFont(-1, 15, 0, 0, $DefaultFont, 5)
		GUICtrlCreateLabel('', 60, 240, 500, 2)
		GUICtrlSetBkColor(-1, 0x000000)

		Global $_IsOpt1 = 0
		Global $lb_TabCL_Sel1_Icon = GUICtrlCreateLabel(ChrW(0xf14a), 60, 270, 30, 30, BitOR($SS_CENTER, $SS_CENTERIMAGE))
		GUICtrlSetColor(-1, 0x118408)
		GUICtrlSetCursor(-1, 0)
		GUICtrlSetFont(-1, 20, 0, 0, $sFontAwesomeName, 5)
		GUICtrlSetOnEvent(-1, '_OptionsClicked')
		Global $lb_TabCL_Sel1 = GUICtrlCreateLabel(' Set KyTs Font Viewer as default font viewer!', 90, 270, 400, 30, $SS_CENTERIMAGE)
		GUICtrlSetCursor(-1, 0)
		GUICtrlSetFont(-1, 12, 0, 0, $DefaultFont, 5)
		GUICtrlSetOnEvent(-1, '_OptionsClicked')

		Global $_IsOpt2 = 0
		Global $lb_TabCL_Sel2_Icon = GUICtrlCreateLabel(ChrW(0xf14a), 60, 300, 30, 30, BitOR($SS_CENTER, $SS_CENTERIMAGE))
		GUICtrlSetColor(-1, 0x118408)
		GUICtrlSetCursor(-1, 0)
		GUICtrlSetFont(-1, 20, 0, 0, $sFontAwesomeName, 5)
		GUICtrlSetOnEvent(-1, '_OptionsClicked')
		Global $lb_TabCL_Sel2 = GUICtrlCreateLabel(' Create Open with KyTs Font Viewer in context menu.', 90, 300, 400, 30, $SS_CENTERIMAGE)
		GUICtrlSetCursor(-1, 0)
		GUICtrlSetFont(-1, 12, 0, 0, $DefaultFont, 5)
		GUICtrlSetOnEvent(-1, '_OptionsClicked')

		Global $_IsOpt3 = 0
		Global $lb_TabCL_Sel3_Icon = GUICtrlCreateLabel(ChrW(0xf14a), 60, 330, 30, 30, BitOR($SS_CENTER, $SS_CENTERIMAGE))
		GUICtrlSetColor(-1, 0x118408)
		GUICtrlSetCursor(-1, 0)
		GUICtrlSetFont(-1, 20, 0, 0, $sFontAwesomeName, 5)
		GUICtrlSetOnEvent(-1, '_OptionsClicked')
		Global $lb_TabCL_Sel3 = GUICtrlCreateLabel(' Visit KyTs Tech Blog after installed!', 90, 330, 400, 30, $SS_CENTERIMAGE)
		GUICtrlSetCursor(-1, 0)
		GUICtrlSetFont(-1, 12, 0, 0, $DefaultFont, 5)
		GUICtrlSetOnEvent(-1, '_OptionsClicked')

		Global $lb_TabCL_Back_Icon = GUICtrlCreateLabel(ChrW(0xf060), 10, 390, 50, 50, BitOR($SS_CENTER, $SS_CENTERIMAGE))
		GUICtrlSetColor(-1, 0xFFFFFF)
		GUICtrlSetBkColor(-1, 0x266996)
		GUICtrlSetCursor(-1, 0)
		GUICtrlSetFont(-1, 20, 0, 0, $sFontAwesomeName, 5)
		GUICtrlSetOnEvent(-1, '_TabChange')
		Global $lb_TabCL_Back = GUICtrlCreateLabel('   I want to read again.', 60, 390, 235, 50, BitOR($SS_LEFT, $SS_CENTERIMAGE))
		GUICtrlSetColor(-1, 0xFFFFFF)
		GUICtrlSetBkColor(-1, 0x0082CD)
		GUICtrlSetCursor(-1, 0)
		GUICtrlSetFont(-1, 13, 0, 0, $DefaultFont, 5)
		GUICtrlSetOnEvent(-1, '_TabChange')

		Global $lb_TabCL_Next = GUICtrlCreateLabel("Let's install   ", 305, 390, 235, 50, BitOR($SS_RIGHT, $SS_CENTERIMAGE))
		GUICtrlSetColor(-1, 0xFFFFFF)
		GUICtrlSetBkColor(-1, 0x0082CD)
		GUICtrlSetCursor(-1, 0)
		GUICtrlSetFont(-1, 13, 0, 0, $DefaultFont, 5)
		GUICtrlSetOnEvent(-1, '_TabChange')
		Global $lb_TabCL_Next_Icon = GUICtrlCreateLabel(ChrW(0xf061), 540, 390, 50, 50, BitOR($SS_CENTER, $SS_CENTERIMAGE))
		GUICtrlSetColor(-1, 0xFFFFFF)
		GUICtrlSetBkColor(-1, 0x266996)
		GUICtrlSetCursor(-1, 0)
		GUICtrlSetFont(-1, 20, 0, 0, $sFontAwesomeName, 5)
		GUICtrlSetOnEvent(-1, '_TabChange')
	GUICtrlCreateTabItem(' ') ;Tab Install
		Global $lb_TabIN_Text = GUICtrlCreateLabel('Installing, please wait a moment...', 0, 170, $gW, 30, BitOR($SS_CENTER, $SS_CENTERIMAGE))
		GUICtrlSetFont(-1, 15, 0, 0, $DefaultFont, 5)

		Global $lb_TabIN_Progress = GUICtrlCreateLabel('', ($gW/2)-(150/2), 215, 150, 150)
		Global $lb_TabIN_Progress_Handle = GUICtrlGetHandle(-1)

		#Region	;GDI+ Init
		Global $hGraphics = _GDIPlus_GraphicsCreateFromHWND($lb_TabIN_Progress_Handle)
		Global $hBitmap = _GDIPlus_BitmapCreateFromGraphics(150, 150, $hGraphics)
		Global $hBackbuffer = _GDIPlus_ImageGetGraphicsContext($hBitmap)
		; Using antialiasing
		_GDIPlus_GraphicsSetSmoothingMode($hBackbuffer, 2)
		; Create a Brush object
		Global $tRectF = _GDIPlus_RectFCreate(0, 0, 150 / 5, 150 / 5)
		;Global $hBrush = _GDIPlus_LineBrushCreateFromRectWithAngle($tRectF, 0xFF0078D7, 0xFF0078D7, 90, True, 1)
		Global $hBrush = _GDIPlus_LineBrushCreateFromRectWithAngle($tRectF, 0xFFFFC100, 0xFFFFC100, 90, True, 1)
		; Create a Pen object
		Global $pen_size = 5	; Circle widht
		Global $hPen = _GDIPlus_PenCreate(0, $pen_size)
		Global $hPen2 = _GDIPlus_PenCreate2($hBrush, $pen_size)
		; Setup font parameters
		Global $fx, $sString
		Global $font = $DefaultFont
		Global $fsize = 20	; Persent number in circle font size
		Global $sf = "%.2f"
		Global $CurentPersent = 0
		#EndRegion	; GDI+ init

		Global $lb_TabIN_Next = GUICtrlCreateLabel("Perfect, go on now!", 305, 390, 235, 50, BitOR($SS_CENTER, $SS_CENTERIMAGE))
		GUICtrlSetColor(-1, 0xFFFFFF)
		GUICtrlSetBkColor(-1, 0xFFFFFF)
		GUICtrlSetFont(-1, 13, 0, 0, $DefaultFont, 5)
		Global $lb_TabIN_Next_Icon = GUICtrlCreateLabel(ChrW(0xf061), 540, 390, 50, 50, BitOR($SS_CENTER, $SS_CENTERIMAGE))
		GUICtrlSetColor(-1, 0xFFFFFF)
		GUICtrlSetBkColor(-1, 0xFFFFFF)
		GUICtrlSetFont(-1, 20, 0, 0, $sFontAwesomeName, 5)

	GUICtrlCreateTabItem(' ') ;Tab Thankyou
		GUICtrlCreateLabel('Thank you for using my sofware!', 0, 170, $gW, 40, BitOR($SS_CENTER, $SS_CENTERIMAGE))
		;GUICtrlCreateLabel('The installation is completed sucessfully!', 0, 170, $gW, 30, BitOR($SS_CENTER, $SS_CENTERIMAGE))
		GUICtrlSetFont(-1, 18, 0, 0, $DefaultFont, 5)

		GUICtrlCreateLabel(ChrW(0xf113), $gW/2-75, 215, 150, 150, BitOR($SS_CENTER, $SS_CENTERIMAGE))
		;GUICtrlCreateLabel(ChrW(0xf05d), $gW/2-50, 235, 100, 100, BitOR($SS_CENTER, $SS_CENTERIMAGE))
		;ChrW(0xf19d)  -> Mũ
		GUICtrlSetColor(-1, 0x118408)
		GUICtrlSetFont(-1, 120, 0, 0, $sFontAwesomeName, 5)

		GUICtrlCreateLabel(ChrW(0xf082), 160, 375, 40, 40, BitOR($SS_CENTER, $SS_CENTERIMAGE))
		GUICtrlSetColor(-1, 0x3B5998)
		GUICtrlSetCursor(-1, 0)
		GUICtrlSetFont(-1, 25, 0, 0, $sFontAwesomeName, 5)
		GUICtrlSetOnEvent(-1, '_GotoFacebookPage')
		Global $lb_TabTY_Launch = GUICtrlCreateLabel('www.facebook.com/kytstech', 200, 375, 250, 40, $SS_CENTERIMAGE)
		GUICtrlSetCursor(-1, 0)
		GUICtrlSetFont(-1, 14, 0, 0, $DefaultFont, 5)
		GUICtrlSetOnEvent(-1, '_GotoFacebookPage')
	GUICtrlCreateTabItem('')
#EndRegion

GUICtrlCreateLabel('', 0, $gH, $gW-50, 50)
GUICtrlSetBkColor(-1, 0x4D4D4D)
GUICtrlSetOnEvent(-1, '_FormMove')
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKBOTTOM + $GUI_DOCKSIZE)
GUICtrlCreateLabel("Don't say NO - Just live MORE!", 10, $gH, 250, 50, $SS_CENTERIMAGE)
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetBkColor(-1, -2)
GUICtrlSetFont(-1, 12, 0, 0, $DefaultFont, 5)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKBOTTOM + $GUI_DOCKSIZE)

GUICtrlCreateLabel(ChrW(0xf08b), $gW-50, $gH, 50, 50, BitOR($SS_CENTER, $SS_CENTERIMAGE))
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetBkColor(-1, 0x4D4D4D)
GUICtrlSetCursor(-1, 0)
GUICtrlSetTip(-1, 'Exit')
GUICtrlSetFont(-1, 20, 0, 0, $sFontAwesomeName, 5)
GUICtrlSetOnEvent(-1, '_Exit')
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKBOTTOM + $GUI_DOCKSIZE)
#EndRegion

WinSetTrans($hGUI, '', 0)
GUISetState(@SW_SHOW, $hGUI)
_ShowForm()
While 1
	Sleep(1000)
WEnd


Func _FormMove()
	DllCall('user32.dll', 'int', 'SendMessage', 'HWND', $hGUI, 'int', 0x0112, 'int', 0xF012, 'int', 0)
EndFunc		;Moving Form
Func _ShowForm()
	Local $I
	For $I = 0 To 255 Step +15
		WinSetTrans($hGUI,'', $I)
		Sleep(10)
	Next

	Local $_gW = $gW
	Local $_gH = $gH*3+50
	Local $_GUIPos = WinGetPos($hGUI)

	For $I = $_GUIPos[1] To $_GUIPos[1]-Int(($gH*2+50)/2)+25 Step -5
		WinMove($hGUI, '', $_GUIPos[0], $I)
		Sleep(1)
	Next

	$_GUIPos = WinGetPos($hGUI)
	For $I=1 To $gH*2 Step +4
		WinMove($hGUI, '', $_GUIPos[0], $_GUIPos[1], $gW, $gH+50+$I)
	Next

	WinFlash($hGUI, '', 1)
EndFunc
Func _HideForm()
	Local $I
	Local $_GUIPos = WinGetPos($hGUI)

	For $I=$gH*2 To 0 Step -4
		WinMove($hGUI, '', $_GUIPos[0], $_GUIPos[1], $gW, $gH+50+$I)
	Next

	For $I = 255 To 0 Step -15
		WinSetTrans($hGUI,'', $I)
		Sleep(10)
	Next
EndFunc
Func _Exit()
	_HideForm()
	 _GUICtrlRichEdit_Destroy($hRichEdit)
	_WinAPI_RemoveFontResourceEx($sFontAwesomePatch, $FR_PRIVATE)

    ; Clean up GDI+
    _GDIPlus_BrushDispose($hBrush)
    _GDIPlus_PenDispose($hPen)
    _GDIPlus_BitmapDispose($hBitmap)
    _GDIPlus_GraphicsDispose($hBackbuffer)
    _GDIPlus_GraphicsDispose($hGraphics)
	_GDIPlus_Shutdown()

	GUIDelete($hGUI)

	If @Compiled Then
		FileDelete($sFontAwesomePatch)
		FileDelete($sLogoDir)
		FileDelete($sIconDir)
		FileDelete($sDieuKhoan)
		DirRemove($sTempDir)
	EndIf

	If (@Compiled) Then ShellExecute($InstallDir & '\KyTs Font Viewer.exe')
	If (@Compiled) And ($_IsOpt3 < 2) Then ShellExecute('http://kytstech.blogspot.com')
	Exit
EndFunc

Func _GDIPlus_CreatePic($FileName, $Left, $Top, $Width, $Heigth)
	Local $hPicCtrl, $_hImage, $hImage, $iHeight, $hGDIBitmap
	$_hImage = _GDIPlus_ImageLoadFromFile($FileName)
	$hImage = _GDIPlus_ImageResize($_hImage, $Width, $Heigth)
		$iWidth = _GDIPlus_ImageGetWidth($hImage)
		$iHeight = _GDIPlus_ImageGetHeight($hImage)
		$hGDIBitmap = _GDIPlus_BitmapCreateHBITMAPFromBitmap($hImage)
		_GDIPlus_ImageDispose($hImage)
		_GDIPlus_ImageDispose($_hImage)
	$hPicCtrl = GUICtrlCreateLabel('', $Left, $Top, $Width, $Heigth, $SS_BITMAP)
	_WinAPI_DeleteObject(GUICtrlSendMsg($hPicCtrl, 0x0172, $IMAGE_BITMAP, $hGDIBitmap)) ;$STM_SETIMAGE = 0x0172
    _WinAPI_DeleteObject($hGDIBitmap)
	Return $hPicCtrl
EndFunc			;~	Using GDIPlus to create Picture control, shouldn't create many control with this and project use GDIPlus
Func _TabChange()
	Switch @GUI_CtrlId
		Case $lb_AutoInstall, $lb_AutoInstall_Icon
			GUICtrlSendMsg($hTab, $TCM_SETCURFOCUS, 3, 0)
			_StartInstall()
		Case $lb_CustomInstall, $lb_TabCL_Back, $lb_TabCL_Back_Icon
			GUICtrlSendMsg($hTab, $TCM_SETCURFOCUS, 1, 0)
			ControlEnable($hGUI, '', $hRichEdit)
			ControlShow($hGUI, '', $hRichEdit)
		Case $lb_TabUL_Agree, $lb_TabUL_Agree_Icon
			ControlDisable($hGUI, '', $hRichEdit)
			ControlHide($hGUI, '', $hRichEdit)
			GUICtrlSendMsg($hTab, $TCM_SETCURFOCUS, 2, 0)
		Case $lb_TabCL_Next, $lb_TabCL_Next_Icon
			GUICtrlSendMsg($hTab, $TCM_SETCURFOCUS, 3, 0)
			_StartInstall()
		Case $lb_TabIN_Next, $lb_TabIN_Next_Icon
			GUICtrlSendMsg($hTab, $TCM_SETCURFOCUS, 4, 0)
			_StartGoodBye()
	EndSwitch
EndFunc
Func _SellectFolder()
	Local $hFile = FileSelectFolder('Sellect install location!', @ProgramFilesDir, BitOR($FSF_CREATEBUTTON, $FSF_NEWDIALOG, $FSF_EDITCONTROL), "", $hGUI)
	If Not @error Then
		If Not StringInStr($hFile, 'KyTs Font Viewer') Then $InstallDir = $hFile & '\KyTs Font Viewer'
		GUICtrlSetData($inp_TabCL_InstallDir, $InstallDir)
	EndIf
EndFunc
Func _GotoFacebookPage()
	ShellExecute('https://www.facebook.com/kytstech')
EndFunc
Func _DrawProgress($iPersent = 50)
	If $iPersent >= 100 Then $iPersent = 100
	$angle = Int($iPersent/100 * 360)
	_GDIPlus_GraphicsClear($hBackbuffer, 0xFFFFFFFF)
	_GDIPlus_PenSetColor($hPen, 0xFFE0FFE0)
	_GDIPlus_GraphicsDrawArc($hBackbuffer, $pen_size / 2, $pen_size / 2, 150 - $pen_size, 150 - $pen_size, -90, $angle, $hPen2)
	$sString = $iPersent
	$fx = StringLen($sString&'%') * $fsize / 2.5
	_GDIPlus_GraphicsDrawString($hBackbuffer, $sString&'%', 150 / 2 - $fx, 150 / 2 - $fsize * 0.75, $font, $fsize)
	_GDIPlus_GraphicsDrawImageRect($hGraphics, $hBitmap, 0, 0, 150, 150)
EndFunc
Func _SetProgressTo($iPersent = 50, $_IsSleep = 0)
	Local $I, $K = 1
	If $iPersent<$CurentPersent Then $K=-1
	For	$I = $CurentPersent To $iPersent Step $K
		_DrawProgress($I)
		Sleep(50)
	Next
	$CurentPersent = $iPersent
	If $_IsSleep > 0 Then Sleep($_IsSleep)
EndFunc
Func _StartInstall()
	Global $sInstallDir = GUICtrlRead($inp_TabCL_InstallDir)
	If @Compiled Then
		DirCreate($sInstallDir)
		_SetProgressTo(10)
		If (@OSArch == "X86") Then
			FileInstall('KyTs Font Viewer.exe', $sInstallDir & '\KyTs Font Viewer.exe', 1)
		Else
			FileInstall('KyTs Font Viewer_x64.exe', $sInstallDir & '\KyTs Font Viewer.exe', 1)
		EndIf
		FileCreateShortcut($sInstallDir & '\KyTs Font Viewer.exe', @DesktopDir & '\KyTs Font Viewer.lnk')
		FileInstall('Helper.exe', $sInstallDir & '\Helper.exe', 1)
		FileInstall('Resource\ReadMe.rtf', $sInstallDir & '\ReadMe.rtf', 1)
		FileInstall('Uninstall.exe', $sInstallDir & '\Uninstall.exe', 1)
		DirCreate($sInstallDir & '\Resource')
		FileInstall('Resource\Icon_mini.png', $sInstallDir & '\Resource\Icon_mini.png', 1)
		FileInstall('Resource\FontAwesome.otf', $sInstallDir & '\Resource\FontAwesome.otf', 1)
		FileInstall('Resource\Help_EN.rtf', $sInstallDir & 'Resource\Help_EN.rtf', 1)
		FileInstall('Resource\Help_VN.rtf', $sInstallDir & 'Resource\Help_VN.rtf', 1)
		_SetProgressTo(20)

		Global Const $Key  = 'HKCU\Software\KyTs Tech\KyTs Font Viewer'
		Global Const $UKey = 'HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\KyTs Font Viewer'
		_SetProgressTo(45)

		RegWrite($Key, "Install", "REG_SZ", $sInstallDir)
		RegWrite($UKey , 'DisplayName', 'REG_SZ', 'KyTs Font Viewer')
		RegWrite($UKey , 'Comments', 'REG_SZ', 'A better font viewer than windows font viewer!')
		RegWrite($UKey , 'Contact', 'REG_SZ', 'kytstech.blogspot.com')
		RegWrite($UKey , 'DisplayVersion', 'REG_SZ', '1.0')
		;RegWrite($UKey , 'HelpTelephone', 'REG_SZ', '01658203839')
		RegWrite($UKey , 'Publisher', 'REG_SZ', 'KyTs Tech')
		RegWrite($UKey , 'DisplayIcon', 'REG_SZ', $sInstallDir & '\KyTs Font Viewer.exe')
		RegWrite($UKey , 'HelpLink', 'REG_SZ', 'kytstech.blogspot.com')
		RegWrite($UKey , 'UninstallString', 'REG_SZ', $sInstallDir & '\Uninstall.exe')
		RegWrite($UKey , 'URLInfoAbout', 'REG_SZ', 'kytstech.blogspot.com')
		RegWrite($UKey , 'URLUpdateInfo', 'REG_SZ', 'kytstech.blogspot.com')
		_SetProgressTo(65)

		RegDelete('HKCR\ttffile\shell', '')
		RegDelete('HKCR\otffile\shell', '')
		RegDelete('HKCR\fonfile\shell', '')
		_SetProgressTo(90)

		If ($_IsOpt1 <2) Then
			RegWrite('HKCR\ttffile\shell\KyTs Font Viewer', 'Icon', 'REG_EXPAND_SZ', $sInstallDir & '\KyTs Font Viewer.exe')
;~ 			RegWrite('HKCR\ttffile\shell', '', 'REG_SZ', 'KyTs Font Viewer')
			RegWrite('HKCR\ttffile\shell\KyTs Font Viewer\command', '', 'REG_EXPAND_SZ', $sInstallDir & '\KyTs Font Viewer.exe %1')

			RegWrite('HKCR\otffile\shell\KyTs Font Viewer', 'Icon', 'REG_EXPAND_SZ', $sInstallDir & '\KyTs Font Viewer.exe')
;~ 			RegWrite('HKCR\otffile\shell', '', 'REG_SZ', 'KyTs Font Viewer')
			RegWrite('HKCR\otffile\shell\KyTs Font Viewer\command', '', 'REG_EXPAND_SZ', $sInstallDir & '\KyTs Font Viewer.exe %1')

			RegWrite('HKCR\fonfile\shell\KyTs Font Viewer', 'Icon', 'REG_EXPAND_SZ', $sInstallDir & '\KyTs Font Viewer.exe')
;~ 			RegWrite('HKCR\fonfile\shell', '', 'REG_SZ', 'KyTs Font Viewer')
			RegWrite('HKCR\fonfile\shell\KyTs Font Viewer\command', '', 'REG_EXPAND_SZ', $sInstallDir & '\KyTs Font Viewer.exe %1')
		ElseIf ($_IsOpt2 < 2) Then
			RegWrite('HKCR\ttffile\shell\KyTs Font Viewer', 'Icon', 'REG_EXPAND_SZ', $sInstallDir & '\KyTs Font Viewer.exe')
			RegWrite('HKCR\ttffile\shell', '', 'REG_SZ', 'preview')
			RegWrite('HKCR\ttffile\shell\KyTs Font Viewer\command', '', 'REG_EXPAND_SZ', $sInstallDir & '\KyTs Font Viewer.exe %1')

			RegWrite('HKCR\otffile\shell\KyTs Font Viewer', 'Icon', 'REG_EXPAND_SZ', $sInstallDir & '\KyTs Font Viewer.exe')
			RegWrite('HKCR\otffile\shell', '', 'REG_SZ', 'preview')
			RegWrite('HKCR\otffile\shell\KyTs Font Viewer\command', '', 'REG_EXPAND_SZ', $sInstallDir & '\KyTs Font Viewer.exe %1')

			RegWrite('HKCR\fonfile\shell\KyTs Font Viewer', 'Icon', 'REG_EXPAND_SZ', $sInstallDir & '\KyTs Font Viewer.exe')
			RegWrite('HKCR\fonfile\shell', '', 'REG_SZ', 'preview')
			RegWrite('HKCR\fonfile\shell\KyTs Font Viewer\command', '', 'REG_EXPAND_SZ', $sInstallDir & '\KyTs Font Viewer.exe %1')
		EndIf
		_SetProgressTo(100, 0)
	Else
		_SetProgressTo(100, 0)
	EndIf

	GUICtrlSetData($lb_TabIN_Text, "Mission Complete! KyTs Font Viewer was installed!")
	GUICtrlSetBkColor($lb_TabIN_Next, 0x0082CD)
	GUICtrlSetCursor($lb_TabIN_Next, 0)
	GUICtrlSetOnEvent($lb_TabIN_Next, '_TabChange')
	GUICtrlSetBkColor($lb_TabIN_Next_Icon, 0x266996)
	GUICtrlSetCursor($lb_TabIN_Next_Icon, 0)
	GUICtrlSetOnEvent($lb_TabIN_Next_Icon, '_TabChange')
EndFunc
Func _StartGoodBye()
	Local $sString = "www.facebook.com/kytstech", $I
	Local $pPos = ControlGetPos($hGUI, "", $lb_TabTY_Launch)
	Local $gPos = WinGetPos($hGUI)
	MouseMove($gPos[0]+$pPos[0]+10, $gPos[1]+$pPos[1]+20)
	For $I = 1 To StringLen($sString)
		GUICtrlSetData($lb_TabTY_Launch, StringLeft($sString, $I) & "_")
		Sleep(Random(100, 250))
	Next
	GUICtrlSetData($lb_TabTY_Launch, $sString)
	AdlibRegister("_ChangeText", 250)
	Sleep(5000)
	_Exit()
EndFunc
Func _ChangeText()
	GUICtrlSetData($lb_TabTY_Launch, GUICtrlRead($lb_TabTY_Launch) == "www.facebook.com/kytstech" ? "www.facebook.com/kytstech_" : "www.facebook.com/kytstech")
EndFunc
Func _OptionsClicked()
	Switch @GUI_CtrlId
		Case $lb_TabCL_Sel1, $lb_TabCL_Sel1_Icon
			If $_IsOpt1 == 2 Then
				$_IsOpt1 = 1
				GUICtrlSetData($lb_TabCL_Sel1_Icon, ChrW(0xf14a))
			Else
				$_IsOpt1 = 2
				GUICtrlSetData($lb_TabCL_Sel1_Icon, ChrW(0xf0c8))
			EndIf
		Case $lb_TabCL_Sel2, $lb_TabCL_Sel2_Icon
			If $_IsOpt2 == 2 Then
				$_IsOpt2 = 1
				GUICtrlSetData($lb_TabCL_Sel2_Icon, ChrW(0xf14a))
			Else
				$_IsOpt2 = 2
				GUICtrlSetData($lb_TabCL_Sel2_Icon, ChrW(0xf0c8))
			EndIf
		Case $lb_TabCL_Sel3, $lb_TabCL_Sel3_Icon
			If $_IsOpt3 == 2 Then
				$_IsOpt3 = 1
				GUICtrlSetData($lb_TabCL_Sel3_Icon, ChrW(0xf14a))
			Else
				$_IsOpt3 = 2
				GUICtrlSetData($lb_TabCL_Sel3_Icon, ChrW(0xf0c8))
			EndIf
	EndSwitch
EndFunc
Func _MenuBarClicked()
	Switch @GUI_CtrlId
		Case $MenuBar1
			ShellExecute('http://kytstech.blogspot.com')
		Case $MenuBar2
			ShellExecute('https://www.facebook.com/kytstech')
		Case $MenuBar3
			ShellExecute('https://mail.google.com/mail/u/0/?view=cm' & _
					'&fs=1' & _
					'&to=kytstech@gmail.com' & _
					'&su=Feedback about KyTs product' & _
					'&body=[Do not delete this line - Feedback send from KyTs Installer - KyTsFontViewer]')
		Case $MenuBar4
			ShellExecute('https://github.com/KyTsTech')
		Case $MenuBar5
			ShellExecute('https://www.youtube.com/channel/UCafv7YUCiHycC6VUoBz0O1Q?sub_confirmation=1')
		Case $MenuBar6
			If Not @Compiled Then Msgbox(0,'Thông Báo','Hiện tab thông tin tác giả!')
	EndSwitch
EndFunc
