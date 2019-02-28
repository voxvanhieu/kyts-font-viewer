#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=Resource\Icon.ico
#AutoIt3Wrapper_Outfile=bin\KyTs Font Viewer.exe
#AutoIt3Wrapper_Outfile_x64=bin\KyTs Font Viewer_x64.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_Compile_Both=y
#AutoIt3Wrapper_Res_Comment=KyTs Font Viewer is a program help users easily to view and install font in Windows computers.
#AutoIt3Wrapper_Res_Description=KyTs Font Viewer
#AutoIt3Wrapper_Res_Fileversion=1.2.0.0
#AutoIt3Wrapper_Res_LegalCopyright=KyTs Tech
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
;~ #RequireAdmin

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

#include <File.au3>
#include <GDIPlus.au3>
#include <WinAPI.au3>
#include <GUITab.au3>
#include <GuiConstants.au3>
#include <WindowsConstants.au3>
#include <StaticConstants.au3>
#include "UDF\TVExplorer.au3"

#Region	; Load Font Awesome Resource and Detect default font
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

Global Const $iMargin = 10; distance from edge of window where dragging is possible
Global Const $SC_DRAGMOVE = 0xF012
Global Const $TileBarHeigth = 35
Global Const $sStringShow = 'The quick brown fox jumps over the lazy dog. 1234567890'
Global Const $TypeFont = '.FON.FNT.TTF.TTC.FOT.OTF.MMM.PFB.PFM'
Global $hGUI
Global Const $Tile = "KyTs Font Viewer"
Global $gW = 950, $gH = 600
Global $lb_FontLocation, $lb_FontName, $hTV, $hTab, $inp_Tab_MoreInfo
Global $lb_Tab_Overview_12, $lb_Tab_Overview_18, $lb_Tab_Overview_24, $lb_Tab_Overview_36, $lb_Tab_Overview_48, $lb_Tab_Overview_60, $lb_Tab_Overview_78
Global $inp_Tab_CustomText_Style_Underline = 0
Global $inp_Tab_CustomText_Style_Bold = 0
Global $inp_Tab_CustomText_Style_Italic = 0
Global $inp_Tab_CustomText_Size
Global $inp_Tab_CustomText_CurentAlgin
Global $GUIState = @SW_SHOWNORMAL
Global $CurentTab, $hFocus = 0
Global $CharMapCtrlSize = 0, $CharMapCtrlTop = 1
Global $CurentTV_Input_Data = ''

_GDIPlus_Startup()

#Region ;	Create GUI and mesages
$hGUI = GUICreate($Tile, $gW, $gH, -1, -1, BitOR($WS_POPUP, $WS_BORDER))
GUISetIcon(@ScriptFullPath)
GUISetBkColor(0xFFFFFF)
GUISetOnEvent($GUI_EVENT_CLOSE, "_Exit")
GUISetOnEvent($GUI_EVENT_RESTORE, "_Restore")
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
GUICtrlSetFont(-1, 13, 0, 0, $DefaultFont & " SemiBold", 5)
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

GUICtrlCreateLabel(ChrW(0xf17a), $gW-77, 0, 35, 35, BitOR($SS_CENTER, $SS_CENTERIMAGE))
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetBkColor(-1, 0x0081FF)
GUICtrlSetCursor(-1, 0)
GUICtrlSetFont(-1, 12, 0, 0, $sFontAwesomeName, 5)
GUICtrlSetTip(-1, "Maximize")
GUICtrlSetOnEvent(-1, "_Maximize")
GUICtrlSetResizing(-1, $GUI_DOCKTOP + $GUI_DOCKRIGHT + $GUI_DOCKHEIGHT + $GUI_DOCKWIDTH)

;Because font awesome is'nt have minimize icon =))))
GUICtrlCreateLabel('', $gW-113, 0, 35, 35)
GUICtrlSetBkColor(-1, 0x0081FF)
GUICtrlSetCursor(-1, 0)
GUICtrlSetFont(-1, 15, 0, 0, $sFontAwesomeName, 5)
GUICtrlSetTip(-1, "Minimize")
GUICtrlSetOnEvent(-1, "_Minimize")
GUICtrlSetResizing(-1, $GUI_DOCKTOP + $GUI_DOCKRIGHT + $GUI_DOCKHEIGHT + $GUI_DOCKWIDTH)
GUICtrlCreateLabel(ChrW(0xf068), $gW-113, 15, 35, 20, $SS_CENTER)
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetBkColor(-1, -2)
GUICtrlSetFont(-1, 12, 0, 0, $sFontAwesomeName, 5)
GUICtrlSetResizing(-1, $GUI_DOCKTOP + $GUI_DOCKRIGHT + $GUI_DOCKHEIGHT + $GUI_DOCKWIDTH)

GUICtrlCreateLabel(ChrW(0xf059), $gW-149, 0, 35, 35, BitOR($SS_CENTER, $SS_CENTERIMAGE))
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetBkColor(-1, 0x2D2D30)
GUICtrlSetCursor(-1, 0)
GUICtrlSetFont(-1, 16, 0, 0, $sFontAwesomeName, 5)
GUICtrlSetTip(-1, "Help")
GUICtrlSetOnEvent(-1, "_ShowHelp")
GUICtrlSetResizing(-1, $GUI_DOCKTOP + $GUI_DOCKRIGHT + $GUI_DOCKHEIGHT + $GUI_DOCKWIDTH)

; Create status bar
Global $lb_StatusBar = GUICtrlCreateLabel('    ' & $Tile & ' version 1.2 - KyTs Tech', 0, $gH-24, $gW, 25, $SS_CENTERIMAGE)
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetBkColor(-1, 0x1C8BFF)
GUICtrlSetCursor(-1, 0)
GUICtrlSetFont(-1, 9, 0, 0, $DefaultFont, 5)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKBOTTOM + $GUI_DOCKHEIGHT)
GUICtrlSetOnEvent(-1, '_GoToHomePage')
; Tree View
GUICtrlCreateLabel(ChrW(0xf07c), 10, 45, 35, 35, BitOR($SS_CENTER, $SS_CENTERIMAGE))
GUICtrlSetCursor(-1, 0)
GUICtrlSetTip(-1, 'Browse')
GUICtrlSetFont(-1, 18, 0, 0, $sFontAwesomeName, 5)
GUICtrlSetOnEvent(-1, '_OpenFileDialog')
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKHEIGHT + $GUI_DOCKWIDTH)
$TV_Input = GUICtrlCreateInput('', 45, 55, 195, 20, -1, 0)
GUICtrlSetFont(-1, 12)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKHEIGHT + $GUI_DOCKWIDTH)
GUICtrlCreateLabel('', 45, 75, 195, 2)
GUICtrlSetBkColor(-1, 0x000000)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKHEIGHT + $GUI_DOCKWIDTH)
GUICtrlCreateLabel('', 245, 40, 3, $gH-70)
GUICtrlSetBkColor(-1, 0x000000)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKBOTTOM + $GUI_DOCKWIDTH)

$hTV = _GUICtrlTVExplorer_Create('', 10, 90, 230, $gH-120, -1, $WS_EX_CLIENTEDGE, -1, '_TVEvent')
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKBOTTOM + $GUI_DOCKWIDTH)

; Body GUI
$lb_FontName = GUICtrlCreateLabel("Font name:", 255, 40, $gW-335, 35, $SS_CENTERIMAGE)
GUICtrlSetFont(-1, 20, 0, 0, $DefaultFont)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKRIGHT + $GUI_DOCKHEIGHT)
$lb_FontLocation = GUICtrlCreateLabel("Location:", 255, 75, $gW-335, 20, $SS_CENTERIMAGE)
GUICtrlSetFont(-1, 10, 0, 0, $DefaultFont)
GUICtrlSetOnEvent(-1, '_GotoAndCopy')
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKRIGHT + $GUI_DOCKHEIGHT)

; Create Tab Label
$lb_Tab_Overview = GUICtrlCreateLabel("Overview", 255, 105, 75, 30, BitOR($SS_CENTER, $SS_CENTERIMAGE))
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetBkColor(-1, 0x1C8BFF)
GUICtrlSetFont(-1, 10, 0, 0, $DefaultFont & " Bold")
GUICtrlSetOnEvent(-1, "_TabChange")
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
$lb_Tab_Custom = GUICtrlCreateLabel("Custom text", 255+75, 105, 95, 30, BitOR($SS_CENTER, $SS_CENTERIMAGE))
GUICtrlSetBkColor(-1, 0xFFFFFF)
GUICtrlSetFont(-1, 10, 0, 0, $DefaultFont & " Bold")
GUICtrlSetOnEvent(-1, "_TabChange")
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
$lb_Tab_Chrmap = GUICtrlCreateLabel("Char Map", 255+170, 105, 75, 30, BitOR($SS_CENTER, $SS_CENTERIMAGE))
GUICtrlSetBkColor(-1, 0xFFFFFF)
GUICtrlSetFont(-1, 10, 0, 0, $DefaultFont & " Bold")
GUICtrlSetOnEvent(-1, "_TabChange")
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
$lb_Tab_Morinf = GUICtrlCreateLabel("More Info", 255+245, 105, 75, 30, BitOR($SS_CENTER, $SS_CENTERIMAGE))
GUICtrlSetBkColor(-1, 0xFFFFFF)
GUICtrlSetFont(-1, 10, 0, 0, $DefaultFont & " Bold")
GUICtrlSetOnEvent(-1, "_TabChange")
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)

; Navigation Controls
Global $lb_InstallFont = GUICtrlCreateLabel(ChrW(0xf019), $gW-40, 105, 30, 30, BitOR($SS_CENTER, $SS_CENTERIMAGE))
GUICtrlSetTip(-1, 'Install this Font')
GUICtrlSetCursor(-1, 0)
GUICtrlSetFont(-1, 12, 0, 0, $sFontAwesomeName, 5)
GUICtrlSetOnEvent(-1, '_NavigationBarSelect')
GUICtrlSetResizing(-1, $GUI_DOCKTOP + $GUI_DOCKRIGHT + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)

Global $lb_DeleteFont = GUICtrlCreateLabel(ChrW(0xf1f8 ), $gW-70, 105, 30, 30, BitOR($SS_CENTER, $SS_CENTERIMAGE))
GUICtrlSetTip(-1, 'Delete File')
GUICtrlSetCursor(-1, 0)
GUICtrlSetFont(-1, 12, 0, 0, $sFontAwesomeName, 5)
GUICtrlSetOnEvent(-1, '_NavigationBarSelect')
GUICtrlSetResizing(-1, $GUI_DOCKTOP + $GUI_DOCKRIGHT + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)

Global $lb_NextFont = GUICtrlCreateLabel(ChrW(0xf054), $gW-100, 105, 30, 30, BitOR($SS_CENTER, $SS_CENTERIMAGE))
GUICtrlSetTip(-1, 'Next Font')
GUICtrlSetCursor(-1, 0)
GUICtrlSetFont(-1, 12, 0, 0, $sFontAwesomeName, 5)
GUICtrlSetOnEvent(-1, '_NavigationBarSelect')
GUICtrlSetResizing(-1, $GUI_DOCKTOP + $GUI_DOCKRIGHT + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)

Global $lb_PreviousFont = GUICtrlCreateLabel(ChrW(0xf053), $gW-130, 105, 30, 30, BitOR($SS_CENTER, $SS_CENTERIMAGE))
GUICtrlSetTip(-1, 'Previous Font')
GUICtrlSetCursor(-1, 0)
GUICtrlSetFont(-1, 12, 0, 0, $sFontAwesomeName, 5)
GUICtrlSetOnEvent(-1, '_NavigationBarSelect')
GUICtrlSetResizing(-1, $GUI_DOCKTOP + $GUI_DOCKRIGHT + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
; Navigation Controls

GUICtrlCreateLabel('',255, 135, $gW-(255+10), 5)
GUICtrlSetBkColor(-1, 0x1C8BFF)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKRIGHT + $GUI_DOCKHEIGHT)
$CurentTab = $lb_Tab_Overview

#Region	;Create Tab Controls
$hTab = GUICtrlCreateTab(255, 135, $gW-(255+10), $gH-165, BitOR($TCS_FLATBUTTONS, $TCS_FIXEDWIDTH))
_GUICtrlTab_SetItemSize($hTab,0,1)
GUICtrlSetResizing($hTab, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKRIGHT + $GUI_DOCKBOTTOM)
GUICtrlCreateLabel('', 255, 140, 5, $gH-165)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKBOTTOM + $GUI_DOCKWIDTH)
GUICtrlCreateLabel('', 255, $gH-35, $gW-(255+10), 5)
GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKBOTTOM + $GUI_DOCKHEIGHT)
GUICtrlCreateLabel('', $gW-15, 140, 5, $gH-165)
GUICtrlSetResizing(-1, $GUI_DOCKTOP + $GUI_DOCKRIGHT + $GUI_DOCKBOTTOM + $GUI_DOCKWIDTH)
	#Region	;Tab Overview
	GUICtrlCreateTabItem(" ")
		$lb_Tab_Overview_Alphabet = GUICtrlCreateLabel("abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLMNOPQRSTUVWXYZ", 255, 145, $gW-(255+10), 20)
		GUICtrlSetFont(-1, 12)
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKRIGHT + $GUI_DOCKHEIGHT)
		$lb_Tab_Overview_Others = GUICtrlCreateLabel("1234567890.:,;'" & '"~!#@$%^&&*_ +-*/= {[()]} \|' , 255, 170, $gW-(255+10), 20)
		GUICtrlSetFont(-1, 12)
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKRIGHT + $GUI_DOCKHEIGHT)

		GUICtrlCreateLabel('', 255, 195, $gW-(255+10), 1)
		GUICtrlSetBkColor(-1, 0x000000)
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKRIGHT + $GUI_DOCKHEIGHT)
		GUICtrlCreateLabel('', 295, 195, 1, $gH-225)
		GUICtrlSetBkColor(-1, 0x000000)
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKBOTTOM + $GUI_DOCKWIDTH)

;~ 		GUICtrlCreateLabel('', 296, 196, $gW-(255+10+40), $gH-225)
;~ 		GUICtrlSetBkColor(-1, 0xabcdef)

		GUICtrlCreateLabel("12", 255, 196, 40, 20, BitOR($SS_CENTER, $SS_CENTERIMAGE))
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		$lb_Tab_Overview_12 = GUICtrlCreateLabel($sStringShow, 300, 196, $gW-310, 20, $SS_LEFTNOWORDWRAP)
		GUICtrlSetBkColor(-1, -2)
		GUICtrlSetFont(-1, 12)
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKRIGHT + $GUI_DOCKHEIGHT)

		GUICtrlCreateLabel("18", 255, 221, 40, 25, BitOR($SS_CENTER, $SS_CENTERIMAGE))
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		$lb_Tab_Overview_18 = GUICtrlCreateLabel($sStringShow, 300, 221, $gW-310, 30, $SS_LEFTNOWORDWRAP)
		GUICtrlSetBkColor(-1, -2)
		GUICtrlSetFont(-1, 18)
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKRIGHT + $GUI_DOCKHEIGHT)

		GUICtrlCreateLabel("24", 255, 246, 40, 35, BitOR($SS_CENTER, $SS_CENTERIMAGE))
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		$lb_Tab_Overview_24 = GUICtrlCreateLabel($sStringShow, 300, 246, $gW-310, 35, $SS_LEFTNOWORDWRAP)
		GUICtrlSetBkColor(-1, -2)
		GUICtrlSetFont(-1, 24)
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKRIGHT + $GUI_DOCKHEIGHT)

		GUICtrlCreateLabel("36", 255, 276, 40, 65, BitOR($SS_CENTER, $SS_CENTERIMAGE))
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		$lb_Tab_Overview_36 = GUICtrlCreateLabel($sStringShow, 300, 276, $gW-310, 65, $SS_LEFTNOWORDWRAP)
		GUICtrlSetBkColor(-1, -2)
		GUICtrlSetFont(-1, 36)
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKRIGHT + $GUI_DOCKHEIGHT)

		GUICtrlCreateLabel("48", 255, 316, 40, 75, BitOR($SS_CENTER, $SS_CENTERIMAGE))
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		$lb_Tab_Overview_48 = GUICtrlCreateLabel($sStringShow, 300, 316, $gW-310, 75, $SS_LEFTNOWORDWRAP)
		GUICtrlSetBkColor(-1, -2)
		GUICtrlSetFont(-1, 48)
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKRIGHT + $GUI_DOCKHEIGHT)

		GUICtrlCreateLabel("60", 255, 371, 40, 90, BitOR($SS_CENTER, $SS_CENTERIMAGE))
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		$lb_Tab_Overview_60 = GUICtrlCreateLabel($sStringShow, 300, 371, $gW-310, 90, $SS_LEFTNOWORDWRAP)
		GUICtrlSetBkColor(-1, -2)
		GUICtrlSetFont(-1, 60)
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKRIGHT + $GUI_DOCKHEIGHT)

		GUICtrlCreateLabel("78", 255, 441, 40, 120, BitOR($SS_CENTER, $SS_CENTERIMAGE))
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		$lb_Tab_Overview_78 = GUICtrlCreateLabel($sStringShow, 300, 441, $gW-310, 120, $SS_LEFTNOWORDWRAP)
		GUICtrlSetBkColor(-1, -2)
		GUICtrlSetFont(-1, 78)
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKRIGHT + $GUI_DOCKHEIGHT)

	#EndRegion
	#Region	;Tab Custom Text
	GUICtrlCreateTabItem(" ")
		Global $inp_Tab_CustomText = GUICtrlCreateEdit("This is a custom text, type any thing into this.", 255, 145, 500, 425)
		GUICtrlSetStyle(-1, BitOR($ES_WANTRETURN, $ES_AUTOVSCROLL, $ES_AUTOHSCROLL))
		GUICtrlSetFont(-1, 12)
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKRIGHT + $GUI_DOCKBOTTOM)

		Global $bt_Bold = GUICtrlCreateLabel(ChrW(0xf032), 785, 145, 30, 30, BitOR($SS_CENTER, $SS_CENTERIMAGE))
		GUICtrlSetFont(-1, 14, 0, 0, $sFontAwesomeName)
		GUICtrlSetTip(-1, "Bold")
		GUICtrlSetOnEvent(-1, "_TabCustomText_SetState")
		GUICtrlSetResizing(-1, $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)

		Global $bt_Italic = GUICtrlCreateLabel(ChrW(0xf033), 830, 145, 30, 30, BitOR($SS_CENTER, $SS_CENTERIMAGE))
		GUICtrlSetFont(-1, 14, 0, 0, $sFontAwesomeName)
		GUICtrlSetTip(-1, "Italic")
		GUICtrlSetOnEvent(-1, "_TabCustomText_SetState")
		GUICtrlSetResizing(-1, $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)

		Global $bt_Underline = GUICtrlCreateLabel(ChrW(0xf0cd), 875, 145, 30, 30, BitOR($SS_CENTER, $SS_CENTERIMAGE))
		GUICtrlSetFont(-1, 14, 0, 0, $sFontAwesomeName)
		GUICtrlSetTip(-1, "Underline")
		GUICtrlSetOnEvent(-1, "_TabCustomText_SetState")
		GUICtrlSetResizing(-1, $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)

		GUICtrlCreateLabel('', 760, 180, 180, 1)
		GUICtrlSetBkColor(-1, 0x000000)
		GUICtrlSetResizing(-1, $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)

		Global $bt_ALeft   = GUICtrlCreateLabel(ChrW(0xf036), 785, 185, 30, 30, BitOR($SS_CENTER, $SS_CENTERIMAGE))
		GUICtrlSetBkColor(-1, 0xABCDEF)
		GUICtrlSetFont(-1, 14, 0, 0, $sFontAwesomeName)
		GUICtrlSetOnEvent(-1, "_TabCustomText_SetState")
		GUICtrlSetResizing(-1, $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		$inp_Tab_CustomText_CurentAlgin = $bt_ALeft

		Global $bt_ACenter = GUICtrlCreateLabel(ChrW(0xf037), 830, 185, 30, 30, BitOR($SS_CENTER, $SS_CENTERIMAGE))
		GUICtrlSetFont(-1, 14, 0, 0, $sFontAwesomeName)
		GUICtrlSetOnEvent(-1, "_TabCustomText_SetState")
		GUICtrlSetResizing(-1, $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)

		Global $bt_ARight  = GUICtrlCreateLabel(ChrW(0xf038), 875, 185, 30, 30, BitOR($SS_CENTER, $SS_CENTERIMAGE))
		GUICtrlSetFont(-1, 14, 0, 0, $sFontAwesomeName)
		$inp_Tab_CustomText_Size = GUICtrlSetOnEvent(-1, "_TabCustomText_SetState")
		GUICtrlSetResizing(-1, $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)

		GUICtrlCreateLabel('', 760, 220, 180, 1)
		GUICtrlSetBkColor(-1, 0x000000)
		GUICtrlSetResizing(-1, $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)

		GUICtrlCreateLabel("Font size:", 765, 225, 90, 30, BitOR($SS_CENTER, $SS_CENTERIMAGE))
		GUICtrlSetFont(-1, 13)
		GUICtrlSetResizing(-1, $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		$inp_Tab_CustomText_Size = GUICtrlCreateCombo('', 865, 230, 50, 30, $CBS_DROPDOWNLIST)
		GUICtrlSetData(-1, "8|9|10|11|12|14|16|18|20|22|24|26|28|36|48|72", '12')
		GUICtrlSetOnEvent(-1, "_inp_Tab_CustomText_SetStyle")
		GUICtrlSetResizing(-1, $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
	#EndRegion
	#Region	;Tab Char Map
	GUICtrlCreateTabItem(" ")
		Global $CharMapFrom = 33
		Global $CharMapTo = $CharMapFrom + 129

		GUICtrlCreateLabel('', 255, 140, $gW-(255+10), 30)
		GUICtrlSetStyle(-1, $GUI_DISABLE)
		GUICtrlSetBkColor(-1, 0xFFAA48)
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKRIGHT + $GUI_DOCKHEIGHT)

		GUICtrlCreateLabel('Character from', 265, 140, 100, 30, $SS_CENTERIMAGE)
		GUICtrlSetFont(-1, 11, 0, 0, $DefaultFont)
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)

		$inp_Tab_CharMap_From = GUICtrlCreateInput($CharMapFrom, 365, 145, 50, 15, BitOR($ES_NUMBER, $ES_CENTER), 0)
		GUICtrlSetBkColor(-1, 0xFFAA48)
		GUICtrlSetFont(-1, 11, 0, 0, $DefaultFont)
		GUICtrlSetLimit(-1, 65405, 0)
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		GUICtrlCreateLabel('', 365, 163, 50, 2)
		GUICtrlSetBkColor(-1, 0x000000)
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)

		GUICtrlCreateLabel('to', 430, 140, 20, 30, $SS_CENTERIMAGE)
		GUICtrlSetFont(-1, 11, 0, 0, $DefaultFont)
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)

		$inp_Tab_CharMap_To = GUICtrlCreateInput($CharMapTo, 450, 145, 50, 15, BitOR($ES_NUMBER, $ES_CENTER), 0)
		GUICtrlSetBkColor(-1, 0xFFAA48)
		GUICtrlSetFont(-1, 11, 0, 0, $DefaultFont)
		GUICtrlSetLimit(-1, 65535, 130)
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		GUICtrlCreateLabel('', 450, 163, 50, 2)
		GUICtrlSetBkColor(-1, 0x000000)
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)

		GUICtrlCreateLabel('in Unicode table. {0->65535 / 0x0000->0xFFFF}', 505, 140, 300, 30, $SS_CENTERIMAGE)
		GUICtrlSetFont(-1, 11, 0, 0, $DefaultFont)
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)

		; Navigation Controls Char map
		Global $lb_Tab_CharMap_Next130Char = GUICtrlCreateLabel(ChrW(0xf04e), $gW-40, 140, 30, 30, BitOR($SS_CENTER, $SS_CENTERIMAGE))
		GUICtrlSetTip(-1, 'The next 130 characters')
		GUICtrlSetCursor(-1, 0)
		GUICtrlSetFont(-1, 8, 0, 0, $sFontAwesomeName, 5)
		GUICtrlSetOnEvent(-1, '_Tab_CharMap_NavigationBarSelect')
		GUICtrlSetResizing(-1, $GUI_DOCKTOP + $GUI_DOCKRIGHT + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)

		Global $lb_Tab_CharMap_Prev130Char = GUICtrlCreateLabel(ChrW(0xf04a), $gW-70, 140, 30, 30, BitOR($SS_CENTER, $SS_CENTERIMAGE))
		GUICtrlSetTip(-1, 'The previous 130 characters')
		GUICtrlSetCursor(-1, 0)
		GUICtrlSetFont(-1, 8, 0, 0, $sFontAwesomeName, 5)
		GUICtrlSetOnEvent(-1, '_Tab_CharMap_NavigationBarSelect')
		GUICtrlSetResizing(-1, $GUI_DOCKTOP + $GUI_DOCKRIGHT + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		; Navigation Controls Char map

		Global $Ctrl_Tab_BackLabel = GUICtrlCreateLabel('', 255, 171, 519, 399)
		GUICtrlSetBkColor(-1, 0x000000)
		GUICtrlSetStyle(-1, $GUI_DISABLE)

		Local $I, $J, $K = $CharMapFrom-1
		Global $Ctrl_Tab_CharMap[10][13]
		For $I = 0 To 9
			For $J = 0 To 12
				$K += 1
				$Ctrl_Tab_CharMap[$I][$J] = GUICtrlCreateLabel(ChrW($K), 255+($J*40), 171+($I*40), 39, 39, BitOR($SS_CENTER, $SS_CENTERIMAGE))
				GUICtrlSetBkColor(-1, 0xABCDEF)
				GUICtrlSetFont(-1, 18, 0, 0, $CurentFontName)
				GUICtrlSetOnEvent(-1, '_Tab_CharMap_SetCharInfo2')
			Next
		Next

		$Ctrl_Tab_CurrentCharID = 33
		$Ctrl_Tab_CurrentChar = GUICtrlCreateLabel('', 775, 171, 165, 165, BitOR($SS_CENTER, $SS_CENTERIMAGE))
		GUICtrlSetBkColor(-1, 0x43A0FF)
		GUICtrlSetFont(-1, 100, 0, 0, $CurentFontName, 5)
		$Ctrl_Tab_CurrentChar_Dec = GUICtrlCreateLabel('Demical Code:', 785, 335, 155, 30, $SS_CENTERIMAGE)
		$Ctrl_Tab_CurrentChar_Hex = GUICtrlCreateLabel('Hex Value:', 785, 365, 155, 30, $SS_CENTERIMAGE)
		$Ctrl_Tab_CurrentChar_UNI = GUICtrlCreateLabel('Unicode:', 785, 395, 155, 30, $SS_CENTERIMAGE)
		$Ctrl_Tab_CurrentChar_UTF8 = GUICtrlCreateLabel('UTF-8:', 785, 425, 155, 30, $SS_CENTERIMAGE)
		$Ctrl_Tab_CurrentChar_Java = GUICtrlCreateLabel('JavaScript Escaped:', 785, 455, 155, 30, $SS_CENTERIMAGE)
		$Ctrl_Tab_CurrentChar_HTML = GUICtrlCreateLabel('HTML Entity:', 785, 485, 155, 30, $SS_CENTERIMAGE)

		$Ctrl_Tab_CharMap_Edit = GUICtrlCreateInput('', 775, 525, 165, 20)
		Global $Ctrl_Tab_CharMap_Copy = GUICtrlCreateLabel('Copy', 775, 550, 165, 20, BitOR($SS_CENTER, $SS_CENTERIMAGE))
		GUICtrlSetCursor(-1, 0)
		GUICtrlSetBkColor(-1, 0x43A0FF)
		GUICtrlSetOnEvent(-1, '_Tab_CharMap_btCopy')
	#EndRegion
	#Region	;Tab More Info
	GUICtrlCreateTabItem(" ");More Info
		$inp_Tab_MoreInfo = GUICtrlCreateEdit("", 255, 145, 500, 425, BitOR($ES_READONLY, $ES_AUTOHSCROLL, $ES_MULTILINE, $ES_WANTRETURN))
		GUICtrlSetFont(-1, 11, 0, 0, $DefaultFont)
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKRIGHT + $GUI_DOCKBOTTOM)

		GUICtrlCreateLabel(ChrW(0xf0ea), 760, 145, 180, 40, BitOR($SS_CENTER, $SS_CENTERIMAGE))
		GUICtrlSetColor(-1, 0xFFFFFF)
		GUICtrlSetBkColor(-1, 0x4D4D4D)
		GUICtrlSetCursor(-1, 0)
		GUICtrlSetFont(-1, 25, 0, 0, $sFontAwesomeName, 5)
		GUICtrlSetOnEvent(-1, "_CopyFontInfo")
		GUICtrlSetResizing(-1, $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		GUICtrlCreateLabel('Copy all info', 760, 185, 180, 40, BitOR($SS_CENTER, $SS_CENTERIMAGE))
		GUICtrlSetColor(-1, 0xFFFFFF)
		GUICtrlSetBkColor(-1, 0x4D4D4D)
		GUICtrlSetCursor(-1, 0)
		GUICtrlSetFont(-1, 16, 0, 0, $DefaultFont, 5)
		GUICtrlSetOnEvent(-1, "_CopyFontInfo")
		GUICtrlSetResizing(-1, $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)

		GUICtrlCreateLabel(ChrW(0xf1a0), 760, 240, 180, 40, BitOR($SS_CENTER, $SS_CENTERIMAGE))
		GUICtrlSetColor(-1, 0xFFFFFF)
		GUICtrlSetBkColor(-1, 0x4285F4)
		GUICtrlSetCursor(-1, 0)
		GUICtrlSetFont(-1, 25, 0, 0, $sFontAwesomeName)
		GUICtrlSetOnEvent(-1, "_SearchGoogleFont")
		GUICtrlSetResizing(-1, $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		GUICtrlCreateLabel("Search Google for this font", 760, 280, 180, 50, $SS_CENTER)
		GUICtrlSetColor(-1, 0xFFFFFF)
		GUICtrlSetBkColor(-1, 0x4285F4)
		GUICtrlSetCursor(-1, 0)
		GUICtrlSetFont(-1, 12, 0, 0, $DefaultFont)
		GUICtrlSetOnEvent(-1, "_SearchGoogleFont")
		GUICtrlSetResizing(-1, $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
	#EndRegion
#EndRegion	;Create Tab Controls
$CurentFontPath = _GetCmdLine()
If StringInStr($CurentFontPath, '/install') Then
	StringTrimLeft($CurentFontPath, 9)
	_InstallFont()
EndIf
If StringInStr($TypeFont, _GetFileType($CurentFontPath)) <> 0 Then
	_ViewFont($CurentFontPath)
Else
	_ViewFile()
EndIf
WinSetTrans($hGUI, '', 0)
GUISetState()
_ShowForm()
_GUICtrlTVExplorer_Expand($hTV, $CurentFontPath)
#EndRegion ;	Create GUI and mesages



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


While 1	;Wait
	If ($GUIState<>@SW_MINIMIZE) And ($CurentTab==$lb_Tab_Chrmap) Then
		If GUICtrlRead($TV_Input) <> $CurentTV_Input_Data Then
			If FileExists(GUICtrlRead($TV_Input)) Then
				_ViewFile(GUICtrlRead($TV_Input))
				_TVSetPath($TV_Input, GUICtrlRead($TV_Input))
				_TVRefresh()
			Else
				_TVSetPath($TV_Input, GUICtrlRead($TV_Input))
			EndIf
		EndIf

		If GUICtrlRead($inp_Tab_CharMap_From) <> $CharMapFrom Then
			If GUICtrlRead($inp_Tab_CharMap_From)>65535 Then
				GUICtrlSetData($inp_Tab_CharMap_From, 65535-129)
			EndIf
			$CharMapFrom = GUICtrlRead($inp_Tab_CharMap_From)
			$CharMapTo = $CharMapFrom + 129
			GUICtrlSetData($inp_Tab_CharMap_To, $CharMapTo)
			_Tab_CharMap_SetChar()
			_Tab_CharMap_SetCharInfo()
		ElseIf GUICtrlRead($inp_Tab_CharMap_To) <> $CharMapTo Then
			If GUICtrlRead($inp_Tab_CharMap_To) > 65535 Then
				GUICtrlSetData($inp_Tab_CharMap_To, 65535)
			EndIf
			$CharMapTo = GUICtrlRead($inp_Tab_CharMap_To)
			$CharMapFrom = $CharMapTo - 129
			GUICtrlSetData($inp_Tab_CharMap_From, $CharMapFrom)
			_Tab_CharMap_SetChar()
			_Tab_CharMap_SetCharInfo()
		EndIf
	EndIf
	Sleep(200)
WEnd

Func _TVEvent($hWnd, $iMsg, $sPath, $hItem)
	Switch $iMsg
		Case $TV_NOTIFY_BEGINUPDATE
			GUISetCursor(1, 1)
		Case $TV_NOTIFY_ENDUPDATE
			GUISetCursor(2)
		Case $TV_NOTIFY_SELCHANGED
			If $hTV = $hWnd Then
				_TVSetPath($TV_Input, $sPath)
				_ViewFile($sPath)
			EndIf
		Case $TV_NOTIFY_DBLCLK
				_ViewFile($sPath, 1)
		Case $TV_NOTIFY_RCLICK
			; Nothing
		Case $TV_NOTIFY_DELETINGITEM
			; Nothing
		Case $TV_NOTIFY_DISKMOUNTED
			_TVRefresh()
		Case $TV_NOTIFY_DISKUNMOUNTED
			_TVRefresh()
	EndSwitch
EndFunc
Func _TVSetPath($iInput, $sPath)
	Local $Text = _WinAPI_PathCompactPath(GUICtrlGetHandle($iInput), $sPath, -2)

	If GUICtrlRead($iInput) <> $Text Then
		$CurentTV_Input_Data = $Text
		GUICtrlSetData($iInput, $Text)
	EndIf
EndFunc   ;==>_TVSetPath
Func _TVRefresh()
;~ 	$Path = _GUICtrlTVExplorer_GetSelected($hTV)
	$Path = $CurentFontPath
	_GUICtrlTVExplorer_AttachFolder($hTV)
	_GUICtrlTVExplorer_Expand($hTV, $Path, 0)
EndFunc   ;==>_TVRefresh

Func _FormMove()
	If ($GUIState==@SW_SHOWNORMAL) Then
		DllCall('user32.dll', 'int', 'SendMessage', 'HWND', $hGUI, 'int', 0x0112, 'int', 0xF012, 'int', 0)
	EndIf
EndFunc		;Moving Form
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
Func _Restore()
	_ShowForm()
EndFunc
Func _Exit()
	_HideForm()
	_WinAPI_RemoveFontResourceEx($CurentFontPath, $FR_PRIVATE)
	_WinAPI_RemoveFontResourceEx($sFontAwesomePath, $FR_PRIVATE)
	_GDIPlus_Shutdown()
	GUIDelete($hGUI)
	Exit
EndFunc
Func _Maximize()
	Local $TaskBarSize = WinGetPos("[CLASS:Shell_TrayWnd]")
	Local $I, $J
	If $CurentTab == $lb_Tab_Chrmap Then WinSetTrans($hGUI, '', 0)	;Hide GUI to hide unwanted efect
	If $GUIState == @SW_SHOWNORMAL Then
		WinMove($hGUI, '', 0, 0, @DesktopWidth - $TaskBarSize[0], $TaskBarSize[1])
		If $CharMapCtrlSize == 0 Then
			$CharMapCtrlSize = _GetCharMapControlPos()
			$CharMapCtrlTop = $CharMapCtrlSize[0]
			$CharMapCtrlSize = $CharMapCtrlSize[1]
		EndIf
		ControlMove($hGUI, '', $Ctrl_Tab_BackLabel, 255, 177, $CharMapCtrlSize*13-1, $CharMapCtrlSize*10-1)
		;Move Controls
		For $I = 0 To 9
			For $J = 0 To 12
				ControlMove($hGUI, '',$Ctrl_Tab_CharMap[$I][$J], 255+($J*$CharMapCtrlSize), 177+($I*$CharMapCtrlSize), $CharMapCtrlSize-1, $CharMapCtrlSize-1)
			Next
		Next
		$I = 255+(13*$CharMapCtrlSize)+Int((@DesktopWidth-255-10-(13*$CharMapCtrlSize))/2-100)
		ControlMove($hGUI, '', $Ctrl_Tab_CurrentChar, $I, 177, 200, 200)
		ControlMove($hGUI, '', $Ctrl_Tab_CurrentChar_Dec, $I, 397, 200, 30)
		ControlMove($hGUI, '', $Ctrl_Tab_CurrentChar_Hex, $I, 427, 200, 30)
		ControlMove($hGUI, '', $Ctrl_Tab_CurrentChar_UNI, $I, 457, 200, 30)
		ControlMove($hGUI, '', $Ctrl_Tab_CurrentChar_UTF8, $I, 487, 200, 30)
		ControlMove($hGUI, '', $Ctrl_Tab_CurrentChar_Java, $I, 517, 200, 30)
		ControlMove($hGUI, '', $Ctrl_Tab_CurrentChar_HTML, $I, 547, 200, 30)
		$I = 255+(13*$CharMapCtrlSize)+Int((@DesktopWidth-255-10-(13*$CharMapCtrlSize))/2-150)
		$J = 177+(9*$CharMapCtrlSize)+($CharMapCtrlSize-30)
		ControlMove($hGUI, '', $Ctrl_Tab_CharMap_Edit, $I, $J-30, 300, 20)
		ControlMove($hGUI, '', $Ctrl_Tab_CharMap_Copy, $I, $J, 300, 30)
		_WinAPI_RedrawWindow($hGUI)
		$GUIState = @SW_MAXIMIZE
	ElseIf $GUIState == @SW_MAXIMIZE Then
		WinMove($hGUI, '', (@DesktopWidth - $gW) /2, (@DesktopHeight-$gH)/2, $gW, $gH)
		ControlMove($hGUI, '', $Ctrl_Tab_BackLabel, 255, 171, 519, 399)
		;Move Controls
		For $I = 0 To 9
			For $J = 0 To 12
				ControlMove($hGUI, '',$Ctrl_Tab_CharMap[$I][$J], 255+($J*40), 171+($I*40), 39, 39)
			Next
		Next
		ControlMove($hGUI, '', $Ctrl_Tab_CurrentChar, 775, 171, 165, 165)
		ControlMove($hGUI, '', $Ctrl_Tab_CurrentChar_Dec, 785, 335, 155, 30)
		ControlMove($hGUI, '', $Ctrl_Tab_CurrentChar_Hex, 785, 365, 155, 30)
		ControlMove($hGUI, '', $Ctrl_Tab_CurrentChar_UNI, 785, 395, 155, 30)
		ControlMove($hGUI, '', $Ctrl_Tab_CurrentChar_UTF8, 785, 425, 155, 30)
		ControlMove($hGUI, '', $Ctrl_Tab_CurrentChar_Java, 785, 455, 155, 30)
		ControlMove($hGUI, '', $Ctrl_Tab_CurrentChar_HTML, 785, 485, 155, 30)
		ControlMove($hGUI, '', $Ctrl_Tab_CharMap_Edit, 775, 525, 165, 20)
		ControlMove($hGUI, '', $Ctrl_Tab_CharMap_Copy, 775, 550, 165, 20)
		_WinAPI_RedrawWindow($hGUI)
		$GUIState = @SW_SHOWNORMAL
	EndIf
	If $CurentTab == $lb_Tab_Chrmap Then WinSetTrans($hGUI, '', 255)
EndFunc
Func _Minimize()
	_HideForm()
	GUISetState(@SW_MINIMIZE, $hGUI)
EndFunc

Func _ShowHelp()
	If Not FileExists(@ScriptDir & '\Helper.exe') Then
		MsgBox(16, 'Error', 'Something went wrong! Reinstall this product to fix this error!')
	Else
		ShellExecute(@ScriptDir & '\Helper.exe')
		_HideForm()
		WinWaitActive("KyTs Font Viewer Helper")
		WinWaitClose("KyTs Font Viewer Helper")
		_ShowForm()
	EndIf
EndFunc

Func _GoToHomePage()
	ShellExecute('http://kytstech.blogspot.com')
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

Func _ViewFile($sPath = @WindowsDir & '\Fonts\arial.ttf', $_IsDBClick = 0)
	Local $FileType = StringUpper(StringRight($sPath, 3))

	If (StringInStr($TypeFont, $FileType)==0) And ($_IsDBClick==1) Then
		ShellExecute($sPath)
	ElseIf (StringInStr($TypeFont, $FileType)<>0) And ($CurentFontPath<>$sPath) Then
		_ViewFont($sPath)
	EndIf
EndFunc
Func _ViewFont($sPath)
	_WinAPI_RemoveFontResourceEx($CurentFontPath, $FR_PRIVATE)
	$CurentFontPath = $sPath
	$CurentFontName = _WinAPI_GetFontResourceInfo($CurentFontPath, True)

	GUICtrlSetData($lb_FontName, "Font name: " & $CurentFontName)
	GUICtrlSetData($lb_FontLocation, "Location: " & $CurentFontPath)
	GUICtrlSetTip($lb_FontLocation, "Click to go to font directory!")
	GUICtrlSetCursor($lb_FontLocation, 0)
	_WinAPI_AddFontResourceEx($CurentFontPath, $FR_PRIVATE)
	GUICtrlSetFont($lb_Tab_Overview_Alphabet, 12, 0, 0, $CurentFontName, 5)
	GUICtrlSetFont($lb_Tab_Overview_Others, 12, 0, 0, $CurentFontName, 5)
	GUICtrlSetFont($lb_Tab_Overview_12, 12, 0, 0, $CurentFontName, 5)
	GUICtrlSetFont($lb_Tab_Overview_18, 18, 0, 0, $CurentFontName, 5)
	GUICtrlSetFont($lb_Tab_Overview_24, 24, 0, 0, $CurentFontName, 5)
	GUICtrlSetFont($lb_Tab_Overview_36, 36, 0, 0, $CurentFontName, 5)
	GUICtrlSetFont($lb_Tab_Overview_48, 48, 0, 0, $CurentFontName, 5)
	GUICtrlSetFont($lb_Tab_Overview_60, 60, 0, 0, $CurentFontName, 5)
	GUICtrlSetFont($lb_Tab_Overview_78, 78, 0, 0, $CurentFontName, 5)
	GUICtrlSetData($inp_Tab_MoreInfo, _FontGetInfoFromFile($sPath))

	_inp_Tab_CustomText_SetStyle()
	_Tab_CharMap_SetFont()
	_Tab_CharMap_SetCharInfo()
EndFunc
Func _FontGetInfoFromFile($sPath)
	Local $sFontInfo, $sInfo = ''
	$sFontInfo  = "File name" & @TAB & @TAB & @TAB & ':' & @TAB & _GetFileName($CurentFontPath) & @CRLF
	$sFontInfo &= "Location" & @TAB & @TAB & @TAB & ':' & @TAB & _GetFilePath($CurentFontPath) & @CRLF
	$sInfo = _WinAPI_GetFontResourceInfo($sPath, Default, 0)
	If Not @error And $sInfo Then $sFontInfo &= "Copyright" & @TAB & @TAB & @TAB & ':' & @TAB & $sInfo & @CRLF
	$sInfo = _WinAPI_GetFontResourceInfo($sPath, Default, 1)
	If Not @error And $sInfo Then $sFontInfo &= "Font Family name" & @TAB & @TAB & ':' & @TAB & $sInfo & @CRLF
	$sInfo = _WinAPI_GetFontResourceInfo($sPath, Default, 2)
	If Not @error And $sInfo Then $sFontInfo &= "Font SubFamily name" & @TAB & ':' & @TAB & $sInfo & @CRLF
	$sInfo = _WinAPI_GetFontResourceInfo($sPath, Default, 3)
	If Not @error And $sInfo Then $sFontInfo &= "Unique font identifier" & @TAB & ':' & @TAB & $sInfo & @CRLF
	$sInfo = _WinAPI_GetFontResourceInfo($sPath, Default, 4)
	If Not @error And $sInfo Then $sFontInfo &= "Font full name" & @TAB & @TAB & ':' & @TAB & $sInfo & @CRLF
	$sInfo = _WinAPI_GetFontResourceInfo($sPath, Default, 5)
	If Not @error And $sInfo Then $sFontInfo &= "Version string" & @TAB & @TAB & ':' & @TAB & $sInfo & @CRLF
	$sInfo = _WinAPI_GetFontResourceInfo($sPath, Default, 6)
	If Not @error And $sInfo Then $sFontInfo &= "Postscript name" & @TAB & @TAB & ':' & @TAB & $sInfo & @CRLF
	$sInfo = _WinAPI_GetFontResourceInfo($sPath, Default, 7)
	If Not @error And $sInfo Then $sFontInfo &= "Trademark" & @TAB & @TAB & ':' & @TAB & $sInfo & @CRLF
	$sInfo = _WinAPI_GetFontResourceInfo($sPath, Default, 8)
	If Not @error And $sInfo Then $sFontInfo &= "Manufacturer Name" & @TAB & @TAB & ':' & @TAB & $sInfo & @CRLF
	$sInfo = _WinAPI_GetFontResourceInfo($sPath, Default, 9)
	If Not @error And $sInfo Then $sFontInfo &= "Designer" & @TAB & @TAB & @TAB & ':' & @TAB & $sInfo & @CRLF
	$sInfo = _WinAPI_GetFontResourceInfo($sPath, Default, 10)
	If Not @error And $sInfo Then $sFontInfo &= "Description" & @TAB & @TAB & ':' & @TAB & $sInfo & @CRLF
	$sInfo = _WinAPI_GetFontResourceInfo($sPath, Default, 11)
	If Not @error And $sInfo Then $sFontInfo &= "URL Vendor" & @TAB & @TAB & ':' & @TAB & $sInfo & @CRLF
	$sInfo = _WinAPI_GetFontResourceInfo($sPath, Default, 16)
	If Not @error And $sInfo Then $sFontInfo &= "Preferred Family (Windows only)" & @TAB & ':' & @TAB & $sInfo & @CRLF
	$sInfo = _WinAPI_GetFontResourceInfo($sPath, Default, 17)
	If Not @error And $sInfo Then $sFontInfo &= "Preferred SubFamily (Windows only)" & @TAB & ':' & @TAB & $sInfo & @CRLF
	$sInfo = _WinAPI_GetFontResourceInfo($sPath, Default, 18)
	If Not @error And $sInfo Then $sFontInfo &= "Compatible Full (Mac OS only)" & @TAB & ':' & @TAB & $sInfo & @CRLF
	$sInfo = _WinAPI_GetFontResourceInfo($sPath, Default, 19)
	If Not @error And $sInfo Then $sFontInfo &= "Sample text" & @TAB & @TAB & ':' & @TAB & $sInfo & @CRLF
	$sInfo = _WinAPI_GetFontResourceInfo($sPath, Default, 20)
	If Not @error And $sInfo Then $sFontInfo &= "PostScript CID findfont name" & @TAB & ':' & @TAB & $sInfo & @CRLF
	$sInfo = _WinAPI_GetFontResourceInfo($sPath, Default, 256)
	If Not @error And $sInfo Then $sFontInfo &= "PostScript CID findfont name" & @TAB & ':' & @TAB & $sInfo & @CRLF

	Return $sFontInfo
EndFunc
Func _GetBorderType($hUnder)
    Local $aCurInfo = GUIGetCursorInfo($hUnder)
    Local $aWinPos = WinGetPos($hUnder)
    Local $iSide = 0
    Local $iTopBot = 0
    If $aCurInfo[0] < $iMargin Then $iSide = 1
    If $aCurInfo[0] > $aWinPos[2] - $iMargin Then $iSide = 2
    If $aCurInfo[1] < $iMargin Then $iTopBot = 3
    If $aCurInfo[1] > $aWinPos[3] - $iMargin Then $iTopBot = 6
    Return $iSide + $iTopBot
EndFunc   ;==>_GetBorderType
Func _GetFileName($sPath = '')
	If $sPath <> '' Then
		Local $I = StringLen($sPath), $Name = ''
		While ($I >= 1) And (StringMid($sPath, $I, 1) <> '\')
			$Name = StringMid($sPath, $I, 1) & $Name
			$I -= 1
		WEnd
		Return $Name
	EndIf
	Return ''
EndFunc   ;==>GetNameOfDir
Func _GetFilePath($sPath)
	Return StringLeft($sPath, StringLen($sPath)-StringLen(_GetFileName($sPath))-1)
EndFunc
Func _GetFileType($sPath)
	Return StringRight($sPath, 3)
EndFunc
Func _NavigationBarSelect()
	Local $CtrlID = @GUI_CtrlId, $FileList, $GotoFile
	Local $FontPath = _GetFilePath($CurentFontPath)
	$FileList = _FileListToArrayRec($FontPath, '*.FON;*.FNT;*.TTF;*.TTC;*.FOT;*.OTF;*.MMM;*.PFB;*.PFM', $FLTAR_FILES, $FLTAR_NORECUR, $FLTAR_SORT, $FLTAR_FULLPATH)
	Switch $CtrlID
		Case $lb_InstallFont
			If (StringUpper(_GetFilePath($CurentFontPath)) <> StringUpper(@WindowsDir & '\Fonts')) Or _
			(Not FileExists(@WindowsDir & '\Fonts\' & _GetFileName($CurentFontPath))) Then
				_InstallFont($CurentFontPath)
			Else
				Msgbox(16,'Message','This font is already installed!', 0, $hGUI)
			EndIf
		Case $lb_DeleteFont
			$GotoFile = _GotoFile($FileList) ;Goto next font
			If @Compiled Then
				_WinAPI_RemoveFontResourceEx($CurentFontPath, $FR_PRIVATE)
				FileDelete($CurentFontPath)
				_GUICtrlTVExplorer_Expand($hTV, $GotoFile, 0)
				_ViewFile($GotoFile)
			Else
				Msgbox(48,'Notice','Delete file: ' & $CurentFontPath & @CRLF & 'and open file: ' & $GotoFile, 0, $hGUI) ;Debug only
				_ViewFile($GotoFile)
			EndIf
			_TVRefresh()
		Case $lb_NextFont
			$GotoFile = _GotoFile($FileList)
			_GUICtrlTVExplorer_Expand($hTV, $GotoFile, 0)
			_ViewFile($GotoFile)
		Case $lb_PreviousFont
			$GotoFile = _GotoFile($FileList, 1)
			_GUICtrlTVExplorer_Expand($hTV, $GotoFile, 0)
			_ViewFile($GotoFile)
	EndSwitch
EndFunc
;================
 ; $aFileList = _FileListToArrayRec()
 ; $sCurrentFilePath = The name that said any thing about it =)))
 ;$iFlag = 0 => GetNextFile; $iFlag = 1 => GetPreviousFile
;================
Func _GotoFile($aFileList, $iFlag = 0)
	Local $I
	For $I = 1 To $aFileList[0]
		If $CurentFontPath == $aFileList[$I] Then ExitLoop
	Next
	Switch $iFlag
		Case 0
			If $I == $aFileList[0] Then
				Return $aFileList[1]	;if curent is the last file then return the previous file
			Else
				Return $aFileList[$I+1]	;return the next file if not thing happend
			EndIf
		Case Else
			If $I == 1 Then
				Return $aFileList[$aFileList[0]]	;if curent is the last file then return the next file
			Else
				Return $aFileList[$I-1]	;return the previous file if not thing happend
			EndIf
	EndSwitch
EndFunc
Func _GetCmdLine()
	Local $Cmd
	If (StringLeft($CmdLineRaw,1)=='"') And (StringRight($CmdLineRaw,1)=='"') Then
		$Cmd = StringTrimLeft($CmdLineRaw, 1)
		$Cmd = StringTrimRight($Cmd, 1)
		Return $Cmd
	Else
		Return $CmdLineRaw
	EndIf
EndFunc   ;==>_GetCmdLine
Func _RunAsAdmin($CommandLine)
	If Not IsAdmin() Then
		If @Compiled Then
			ShellExecute(@ScriptFullPath, $CommandLine, @WorkingDir, "RunAs")
		Else
			ShellExecute(@AutoItExe, '/AutoIt3ExecuteScript "' & @ScriptFullPath & '" ' & $CommandLine, @WorkingDir, "runas")
		EndIf
		Exit
	EndIf
EndFunc   ;==>Admin

;~ From AutoIT forum, edited
Func _InstallFont($sSourceFile = $CurentFontPath, $sFontDescript="", $sFontsPath="")
	_RunAsAdmin($sSourceFile)
    Local Const $HWND_BROADCAST = 0xFFFF
    Local Const $WM_FONTCHANGE = 0x1D

    If $sFontsPath = "" Then $sFontsPath = @WindowsDir & "\fonts"

    Local $sFontName = StringRegExpReplace($sSourceFile, "^.*\\", "")
    If Not FileCopy($sSourceFile, $sFontsPath & "\" & $sFontName, 1) Then Return SetError(1, 0, 0)

    Local $hSearch = FileFindFirstFile($sSourceFile)
    Local $iFontIsWildcard = StringRegExp($sFontName, "\*|\?")
    Local $aRet, $hGdi32_DllOpen = DllOpen("gdi32.dll")

    If $hSearch = -1 Then Return SetError(2, 0, 0)
    If $hGdi32_DllOpen = -1 Then Return SetError(3, 0, 0)

    While 1
        $sFontName = FileFindNextFile($hSearch)
        If @error Then ExitLoop

        If $iFontIsWildcard Then $sFontDescript = StringRegExpReplace($sFontName, "\.[^\.]*$", "")

        $aRet = DllCall($hGdi32_DllOpen, "Int", "AddFontResource", "str", $sFontsPath & "\" & $sFontName)
        If IsArray($aRet) And $aRet[0] > 0 Then
            RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts", _
                $sFontDescript, "REG_SZ", $sFontsPath & "\" & $sFontName)
        EndIf
    WEnd
	If Not @error Then Msgbox(64,'Message','Install Successfuly!', 0, $hGUI)
    DllClose($hGdi32_DllOpen)
    DllCall("user32.dll", "Int", "SendMessage", "hwnd", $HWND_BROADCAST, "int", $WM_FONTCHANGE, "int", 0, "int", 0)
    Return 1
EndFunc
Func _OpenFileDialog()
	Local $hFile = FileOpenDialog('Sellect Font Files!', _GetFilePath($CurentFontPath), 'Font Files(*.FON;*.FNT;*.TTF;*.TTC;*.FOT;*.OTF;*.MMM;*.PFB;*.PFM)|All files (*.*)', $FD_FILEMUSTEXIST, '', $hGUI)
	If Not @error Then
		_TVSetPath($TV_Input, $hFile)
		_GUICtrlTVExplorer_Expand($hTV, $hFile)
		_ViewFile($hFile)
	EndIf
EndFunc
Func _Tab_CharMap_NavigationBarSelect()
	$CtrlID = @GUI_CtrlId
	Switch $CtrlID
		Case $lb_Tab_CharMap_Next130Char
			If ($CharMapTo>65535-130) Then
				$CharMapTo = 65535
				$CharMapFrom = $CharMapTo-129
			Else
				$CharMapFrom += 130
				$CharMapTo += 130
			EndIf
			GUICtrlSetData($inp_Tab_CharMap_From, $CharMapFrom)
			GUICtrlSetData($inp_Tab_CharMap_To, $CharMapTo)
;~ 			_Tab_CharMap_SetCharInfo(3)
			_Tab_CharMap_SetChar()
		Case $lb_Tab_CharMap_Prev130Char
			If ($CharMapFrom<130) Then
				$CharMapFrom = 0
				$CharMapTo = 129
			Else
				$CharMapFrom -= 130
				$CharMapTo -= 130
			EndIf
			GUICtrlSetData($inp_Tab_CharMap_From, $CharMapFrom)
			GUICtrlSetData($inp_Tab_CharMap_To, $CharMapTo)
;~ 			_Tab_CharMap_SetCharInfo(3)
			_Tab_CharMap_SetChar()
	EndSwitch
EndFunc
Func _Tab_CharMap_btCopy()
	Local $Clip_Temp = GUICtrlRead($Ctrl_Tab_CharMap_Edit)
	If $Clip_Temp == '' Then
		MsgBox(16, $Tile & ' Error!', 'No data to copy to Clipboard!', 0, $hGUI)
	Else
		ClipPut($Clip_Temp)
		MsgBox(64, $Tile & ' Copied!', 'Copied: '&GUICtrlRead($Ctrl_Tab_CharMap_Edit)&' to Clipboard!', 0, $hGUI)
	EndIf
EndFunc
Func _Tab_CharMap_SetFont()		; Hàm này để đặt lại font tất các control trong tab CharMap và đặt lại ký tự trong control $Ctrl_Tab_CurrentChar
	Local $I
	For $I = $Ctrl_Tab_CharMap[0][0] To $Ctrl_Tab_CharMap[9][12]
			GUICtrlSetFont($I, 18, 0, 0, $CurentFontName)
	Next

	GUICtrlSetFont($Ctrl_Tab_CurrentChar, 110, 0, 0, $CurentFontName, 5)
	GUICtrlSetFont($Ctrl_Tab_CharMap_Edit, 12, 0, 0, $CurentFontName, 5)
EndFunc
Func _Tab_CharMap_SetChar()
	Local $I, $J, $K = $CharMapFrom-1
	For $I = 0 To 9
		For $J = 0 To 12
			$K += 1
			GUICtrlSetData($Ctrl_Tab_CharMap[$I][$J], ChrW($K))
		Next
	Next
EndFunc
Func _Tab_CharMap_SetCharInfo($CtrlID = 1)	; Hàm đặt lại ký tự và các thông tin tương ứng của $Ctrl_Tab_CurrentChar
	Local $CharID
	Switch $CtrlID
		Case 0
			$CharID = @GUI_CtrlId - $Ctrl_Tab_CharMap[0][0] + $CharMapFrom
		Case 1
			$CharID = $Ctrl_Tab_CurrentCharID
;~ 		Case 3
;~ 			$CharID = $Ctrl_Tab_CurrentCharID - $Ctrl_Tab_CharMap[0][0] + $CharMapFrom
	EndSwitch

	If ($CtrlID<>1) And ($Ctrl_Tab_CurrentCharID == $CharID) Then
		GUICtrlSetData($Ctrl_Tab_CharMap_Edit, GUICtrlRead($Ctrl_Tab_CharMap_Edit) & Chrw($Ctrl_Tab_CurrentCharID))
	Else
		$Ctrl_Tab_CurrentCharID = $CharID
		Local $CharID_Hex = _Hex($CharID)
		GUICtrlSetData($Ctrl_Tab_CurrentChar, ChrW($CharID))
		GUICtrlSetData($Ctrl_Tab_CurrentChar_Dec, 'Demical Code:' & @TAB & $CharID)
		GUICtrlSetData($Ctrl_Tab_CurrentChar_Hex, 'Hex Value:' & @TAB & $CharID_Hex)
		GUICtrlSetData($Ctrl_Tab_CurrentChar_UNI, 'Unicode:' & @TAB & 'U+' & $CharID_Hex)
		GUICtrlSetData($Ctrl_Tab_CurrentChar_UTF8, 'UTF-8:' & @TAB  & @TAB & '0x' & $CharID_Hex)
		GUICtrlSetData($Ctrl_Tab_CurrentChar_Java, 'JavaScript Escaped:  ' & '%u' & $CharID_Hex)
		GUICtrlSetData($Ctrl_Tab_CurrentChar_HTML, 'HTML Entity:' & @TAB & '&&#' & $CharID)
	EndIf
EndFunc
Func _Tab_CharMap_SetCharInfo2()	; Là hàm phụ của _Tab_CharMap_SetCharInfo()
	_Tab_CharMap_SetCharInfo(0)
EndFunc
Func _Hex($iDec)
	Local $iHex = Hex($iDec), $iHex2 = '', $I
	For $I=1 To StringLen($iHex)
		If StringMid($iHex, $I, 1) <> '0' Then $iHex2 &= StringMid($iHex, $I, 1)
	Next
	Return $iHex2
EndFunc
Func _TabCustomText_SetState()
	Switch @GUI_CtrlId
		Case $bt_Bold
			If $inp_Tab_CustomText_Style_Bold = 0 Then
				$inp_Tab_CustomText_Style_Bold = $FW_BOLD
				GUICtrlSetBkColor($bt_Bold, 0xABCDEF)
			Else
				$inp_Tab_CustomText_Style_Bold = 0
				GUICtrlSetBkColor($bt_Bold, 0xFFFFFF)
			EndIf
			_inp_Tab_CustomText_SetStyle()
		Case $bt_Italic
			If $inp_Tab_CustomText_Style_Italic = 0 Then
				$inp_Tab_CustomText_Style_Italic = $GUI_FONTITALIC
				GUICtrlSetBkColor($bt_Italic, 0xABCDEF)
			Else
				$inp_Tab_CustomText_Style_Italic = 0
				GUICtrlSetBkColor($bt_Italic, 0xFFFFFF)
			EndIf
			_inp_Tab_CustomText_SetStyle()
		Case $bt_Underline
			If $inp_Tab_CustomText_Style_Underline = 0 Then
				$inp_Tab_CustomText_Style_Underline = $GUI_FONTUNDER
				GUICtrlSetBkColor($bt_Underline, 0xABCDEF)
			Else
				$inp_Tab_CustomText_Style_Underline = 0
				GUICtrlSetBkColor($bt_Underline, 0xFFFFFF)
			EndIf
			_inp_Tab_CustomText_SetStyle()
		Case $bt_ALeft
			GUICtrlSetBkColor($inp_Tab_CustomText_CurentAlgin, 0xFFFFFF)
			GUICtrlSetBkColor($bt_ALeft, 0xABCDEF)
			$inp_Tab_CustomText_CurentAlgin = $bt_ALeft
			GUICtrlSetStyle($inp_Tab_CustomText, BitOR($ES_MULTILINE, $ES_WANTRETURN, $ES_LEFT))
		Case $bt_ARight
			GUICtrlSetBkColor($inp_Tab_CustomText_CurentAlgin, 0xFFFFFF)
			GUICtrlSetBkColor($bt_ARight, 0xABCDEF)
			$inp_Tab_CustomText_CurentAlgin = $bt_ARight
			GUICtrlSetStyle($inp_Tab_CustomText, BitOR($ES_MULTILINE, $ES_WANTRETURN, $ES_RIGHT))
		Case $bt_ACenter
			GUICtrlSetBkColor($inp_Tab_CustomText_CurentAlgin, 0xFFFFFF)
			GUICtrlSetBkColor($bt_ACenter, 0xABCDEF)
			$inp_Tab_CustomText_CurentAlgin = $bt_ACenter
			GUICtrlSetStyle($inp_Tab_CustomText, BitOR($ES_MULTILINE, $ES_WANTRETURN, $ES_CENTER))
	EndSwitch
EndFunc
Func _inp_Tab_CustomText_SetStyle()
	GUICtrlSetFont($inp_Tab_CustomText, GUICtrlRead($inp_Tab_CustomText_Size), $inp_Tab_CustomText_Style_Bold, BitOR($inp_Tab_CustomText_Style_Italic, $inp_Tab_CustomText_Style_Underline), $CurentFontName)
EndFunc
Func _GetCharMapControlPos()
	Local $iTop, $iBot, $iSize, $aReturn[2]
	$iTop = 170
	$iBot = ControlGetPos($hGUI, '', $lb_StatusBar)[1] - 5
	$iSize = Int(($iBot-$iTop)/10)
	$iTop = $iBot-$iTop-$iSize*10
	$aReturn[0] = $iTop
	$aReturn[1] = $iSize
	Return $aReturn
EndFunc
Func _TabChange()
	GUICtrlSetColor($CurentTab, 0x000000)
	GUICtrlSetBkColor($CurentTab, 0xFFFFFF)
	GUICtrlSendMsg($hTab, $TCM_SETCURFOCUS, @GUI_CtrlId - $lb_Tab_Overview, 0)
	$CurentTab = @GUI_CtrlId
	GUICtrlSetColor($CurentTab, 0xFFFFFF)
	GUICtrlSetBkColor($CurentTab, 0x1C8BFF)
EndFunc
Func _GotoAndCopy()
	If $CurentFontPath <> '' Then
		Local $sPath = _GetFilePath($CurentFontPath)
		ClipPut($sPath)
		If StringUpper($sPath) == StringUpper(@WindowsDir & '\Fonts') Then
			ShellExecute($sPath)
		Else
			Run("explorer.exe /n,/e,/select, " & $CurentFontPath)
		EndIf
	EndIf
EndFunc
Func _CopyFontInfo()
	ClipPut(GUICtrlRead($inp_Tab_MoreInfo))
	Msgbox(64,$Tile & 'Font info!','Copied to Clipboard!', 0, $hGUI)
EndFunc
Func _SearchGoogleFont()
	Local $sFontName = _WinAPI_GetFontResourceInfo($CurentFontPath, Default, 1)
	If $sFontName == '' Then $sFontName = _WinAPI_GetFontResourceInfo($CurentFontPath, Default, 4) & ' ' & _GetFileName($CurentFontPath)
	Local $sFontSubName = _WinAPI_GetFontResourceInfo($CurentFontPath, Default, 2)
	Local $sKeyWord = "Font " & $sFontName & ' ' & $sFontSubName
	ShellExecute("https://www.google.com.vn/?gws_rd=ssl#q=" & $sKeyWord)
EndFunc

