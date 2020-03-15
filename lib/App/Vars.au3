#include-once

;~ Variables to store user viewing font
Global $CurentFontPath = @WindowsDir & "\Fonts\Arial.ttf", $CurentFontName = "Arial"

#Region Load Font Awesome Resource
Global Const $sFontAwesomePath = @ScriptDir & "\assets\FontAwesome.otf"
Global Const $sFontAwesomeName = _WinAPI_GetFontResourceInfo($sFontAwesomePath, True)
_WinAPI_AddFontResourceEx($sFontAwesomePath, $FR_PRIVATE)
#EndRegion

Global Const $iMargin = 10; distance from edge of window where dragging is possible
Global Const $SC_DRAGMOVE = 0xF012
Global Const $TitleBarHeigth = 35
Global Const $sStringShow = "The quick brown fox jumps over the lazy dog. 1234567890"
Global Const $TypeFont = ".FON.FNT.TTF.TTC.FOT.OTF.MMM.PFB.PFM"
Global $hGUI
Global Const $Title = "KyTs Font Viewer"
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
Global $CurentTV_Input_Data = ""

#region Helper
Global Const $Helper_Title = 'Kyts Font Viewer Helper'
Global Const $Helper_gW = 600, $Helper_gH = 500
Global $CurentLanguage = 'EN'
Global $sHelper_EN = @ScriptDir & '\assets\Help_EN.rtf'
Global $sHelper_VN = @ScriptDir & '\assets\Help_VN.rtf'

#endregion