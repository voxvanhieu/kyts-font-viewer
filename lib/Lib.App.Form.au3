#include-once
#include "Lib.App.Vars.au3"

#cs
    This is function to create GUI
#ce
Func _Create_MainGUI()
    $hGUI = GUICreate($Tile, $gW, $gH, -1, -1, BitOR($WS_POPUP, $WS_BORDER))
    GUISetIcon(@ScriptFullPath)
    GUISetBkColor(0xFFFFFF)
    GUISetOnEvent($GUI_EVENT_CLOSE, "_Exit")
    GUISetOnEvent($GUI_EVENT_RESTORE, "_Restore")
    ; Create tile bar
    GUICtrlCreateLabel("", 0, 0, $gW, $TileBarHeigth)
    GUICtrlSetBkColor(-1, 0x2D2D30)
    GUICtrlSetState(-1, $GUI_DISABLE)
    GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKRIGHT + $GUI_DOCKHEIGHT)

    _GDIPlus_CreatePic(@ScriptDir & "\assets\Icon_mini.png", 5, 5, 25, 25)
    GUICtrlSetBkColor(-1, -2)
    GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)

    GUICtrlCreateLabel($Tile, 35, 0, $gW-185, $TileBarHeigth, $SS_CENTERIMAGE)
    GUICtrlSetColor(-1, 0xFFFFFF)
    GUICtrlSetBkColor(-1, -2)
    GUICtrlSetFont(-1, 13, 0, 0, $DefaultFont & " SemiBold", 5)
    GUICtrlSetOnEvent(-1,"_FormMove")
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

    ;Because font awesome is"nt have minimize icon =))))
    GUICtrlCreateLabel("", $gW-113, 0, 35, 35)
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
    Global $lb_StatusBar = GUICtrlCreateLabel("    " & $Tile & " version 1.2 - KyTs Tech", 0, $gH-24, $gW, 25, $SS_CENTERIMAGE)
    GUICtrlSetColor(-1, 0xFFFFFF)
    GUICtrlSetBkColor(-1, 0x1C8BFF)
    GUICtrlSetCursor(-1, 0)
    GUICtrlSetFont(-1, 9, 0, 0, $DefaultFont, 5)
    GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKBOTTOM + $GUI_DOCKHEIGHT)
    GUICtrlSetOnEvent(-1, "_GoToHomePage")
    ; Tree View
    GUICtrlCreateLabel(ChrW(0xf07c), 10, 45, 35, 35, BitOR($SS_CENTER, $SS_CENTERIMAGE))
    GUICtrlSetCursor(-1, 0)
    GUICtrlSetTip(-1, "Browse")
    GUICtrlSetFont(-1, 18, 0, 0, $sFontAwesomeName, 5)
    GUICtrlSetOnEvent(-1, "_OpenFileDialog")
    GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKHEIGHT + $GUI_DOCKWIDTH)
    Global $TV_Input = GUICtrlCreateInput("", 45, 55, 195, 20, -1, 0)
    GUICtrlSetFont(-1, 12)
    GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKHEIGHT + $GUI_DOCKWIDTH)
    GUICtrlCreateLabel("", 45, 75, 195, 2)
    GUICtrlSetBkColor(-1, 0x000000)
    GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKHEIGHT + $GUI_DOCKWIDTH)
    GUICtrlCreateLabel("", 245, 40, 3, $gH-70)
    GUICtrlSetBkColor(-1, 0x000000)
    GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKBOTTOM + $GUI_DOCKWIDTH)

    Global $hTV = _GUICtrlTVExplorer_Create("", 10, 90, 230, $gH-120, -1, $WS_EX_CLIENTEDGE, -1, "_TVEvent")
    GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKBOTTOM + $GUI_DOCKWIDTH)

    ; Body GUI
    Global $lb_FontName = GUICtrlCreateLabel("Font name:", 255, 40, $gW-335, 35, $SS_CENTERIMAGE)
    GUICtrlSetFont(-1, 20, 0, 0, $DefaultFont)
    GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKRIGHT + $GUI_DOCKHEIGHT)
    Global $lb_FontLocation = GUICtrlCreateLabel("Location:", 255, 75, $gW-335, 20, $SS_CENTERIMAGE)
    GUICtrlSetFont(-1, 10, 0, 0, $DefaultFont)
    GUICtrlSetOnEvent(-1, "_GotoAndCopy")
    GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKRIGHT + $GUI_DOCKHEIGHT)

    ; Create Tab Label
    Global $lb_Tab_Overview = GUICtrlCreateLabel("Overview", 255, 105, 75, 30, BitOR($SS_CENTER, $SS_CENTERIMAGE))
    GUICtrlSetColor(-1, 0xFFFFFF)
    GUICtrlSetBkColor(-1, 0x1C8BFF)
    GUICtrlSetFont(-1, 10, 0, 0, $DefaultFont & " Bold")
    GUICtrlSetOnEvent(-1, "_TabChange")
    GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
    Global $lb_Tab_Custom = GUICtrlCreateLabel("Custom text", 255+75, 105, 95, 30, BitOR($SS_CENTER, $SS_CENTERIMAGE))
    GUICtrlSetBkColor(-1, 0xFFFFFF)
    GUICtrlSetFont(-1, 10, 0, 0, $DefaultFont & " Bold")
    GUICtrlSetOnEvent(-1, "_TabChange")
    GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
    Global $lb_Tab_Chrmap = GUICtrlCreateLabel("Char Map", 255+170, 105, 75, 30, BitOR($SS_CENTER, $SS_CENTERIMAGE))
    GUICtrlSetBkColor(-1, 0xFFFFFF)
    GUICtrlSetFont(-1, 10, 0, 0, $DefaultFont & " Bold")
    GUICtrlSetOnEvent(-1, "_TabChange")
    GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
    Global $lb_Tab_Morinf = GUICtrlCreateLabel("More Info", 255+245, 105, 75, 30, BitOR($SS_CENTER, $SS_CENTERIMAGE))
    GUICtrlSetBkColor(-1, 0xFFFFFF)
    GUICtrlSetFont(-1, 10, 0, 0, $DefaultFont & " Bold")
    GUICtrlSetOnEvent(-1, "_TabChange")
    GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)

    ; Navigation Controls
    Global $lb_InstallFont = GUICtrlCreateLabel(ChrW(0xf019), $gW-40, 105, 30, 30, BitOR($SS_CENTER, $SS_CENTERIMAGE))
    GUICtrlSetTip(-1, "Install this Font")
    GUICtrlSetCursor(-1, 0)
    GUICtrlSetFont(-1, 12, 0, 0, $sFontAwesomeName, 5)
    GUICtrlSetOnEvent(-1, "_NavigationBarSelect")
    GUICtrlSetResizing(-1, $GUI_DOCKTOP + $GUI_DOCKRIGHT + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)

    Global $lb_DeleteFont = GUICtrlCreateLabel(ChrW(0xf1f8 ), $gW-70, 105, 30, 30, BitOR($SS_CENTER, $SS_CENTERIMAGE))
    GUICtrlSetTip(-1, "Delete File")
    GUICtrlSetCursor(-1, 0)
    GUICtrlSetFont(-1, 12, 0, 0, $sFontAwesomeName, 5)
    GUICtrlSetOnEvent(-1, "_NavigationBarSelect")
    GUICtrlSetResizing(-1, $GUI_DOCKTOP + $GUI_DOCKRIGHT + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)

    Global $lb_NextFont = GUICtrlCreateLabel(ChrW(0xf054), $gW-100, 105, 30, 30, BitOR($SS_CENTER, $SS_CENTERIMAGE))
    GUICtrlSetTip(-1, "Next Font")
    GUICtrlSetCursor(-1, 0)
    GUICtrlSetFont(-1, 12, 0, 0, $sFontAwesomeName, 5)
    GUICtrlSetOnEvent(-1, "_NavigationBarSelect")
    GUICtrlSetResizing(-1, $GUI_DOCKTOP + $GUI_DOCKRIGHT + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)

    Global $lb_PreviousFont = GUICtrlCreateLabel(ChrW(0xf053), $gW-130, 105, 30, 30, BitOR($SS_CENTER, $SS_CENTERIMAGE))
    GUICtrlSetTip(-1, "Previous Font")
    GUICtrlSetCursor(-1, 0)
    GUICtrlSetFont(-1, 12, 0, 0, $sFontAwesomeName, 5)
    GUICtrlSetOnEvent(-1, "_NavigationBarSelect")
    GUICtrlSetResizing(-1, $GUI_DOCKTOP + $GUI_DOCKRIGHT + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
    ; Navigation Controls

    GUICtrlCreateLabel("",255, 135, $gW-(255+10), 5)
    GUICtrlSetBkColor(-1, 0x1C8BFF)
    GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKRIGHT + $GUI_DOCKHEIGHT)
    Global $CurentTab = $lb_Tab_Overview

    #Region	;Create Tab Controls
    Global $hTab = GUICtrlCreateTab(255, 135, $gW-(255+10), $gH-165, BitOR($TCS_FLATBUTTONS, $TCS_FIXEDWIDTH))
    _GUICtrlTab_SetItemSize($hTab,0,1)
    GUICtrlSetResizing($hTab, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKRIGHT + $GUI_DOCKBOTTOM)
    GUICtrlCreateLabel("", 255, 140, 5, $gH-165)
    GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKBOTTOM + $GUI_DOCKWIDTH)
    GUICtrlCreateLabel("", 255, $gH-35, $gW-(255+10), 5)
    GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKBOTTOM + $GUI_DOCKHEIGHT)
    GUICtrlCreateLabel("", $gW-15, 140, 5, $gH-165)
    GUICtrlSetResizing(-1, $GUI_DOCKTOP + $GUI_DOCKRIGHT + $GUI_DOCKBOTTOM + $GUI_DOCKWIDTH)
        #Region	;Tab Overview
        GUICtrlCreateTabItem(" ")
            Global $lb_Tab_Overview_Alphabet = GUICtrlCreateLabel("abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLMNOPQRSTUVWXYZ", 255, 145, $gW-(255+10), 20)
            GUICtrlSetFont(-1, 12)
            GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKRIGHT + $GUI_DOCKHEIGHT)
            Global $lb_Tab_Overview_Others = GUICtrlCreateLabel("1234567890.:,;"" & ""~!#@$%^&&*_ +-*/= {[()]} \|" , 255, 170, $gW-(255+10), 20)
            GUICtrlSetFont(-1, 12)
            GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKRIGHT + $GUI_DOCKHEIGHT)

            GUICtrlCreateLabel("", 255, 195, $gW-(255+10), 1)
            GUICtrlSetBkColor(-1, 0x000000)
            GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKRIGHT + $GUI_DOCKHEIGHT)
            GUICtrlCreateLabel("", 295, 195, 1, $gH-225)
            GUICtrlSetBkColor(-1, 0x000000)
            GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKBOTTOM + $GUI_DOCKWIDTH)

    ;~ 		GUICtrlCreateLabel("", 296, 196, $gW-(255+10+40), $gH-225)
    ;~ 		GUICtrlSetBkColor(-1, 0xabcdef)

            GUICtrlCreateLabel("12", 255, 196, 40, 20, BitOR($SS_CENTER, $SS_CENTERIMAGE))
            GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
            Global $lb_Tab_Overview_12 = GUICtrlCreateLabel($sStringShow, 300, 196, $gW-310, 20, $SS_LEFTNOWORDWRAP)
            GUICtrlSetBkColor(-1, -2)
            GUICtrlSetFont(-1, 12)
            GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKRIGHT + $GUI_DOCKHEIGHT)

            GUICtrlCreateLabel("18", 255, 221, 40, 25, BitOR($SS_CENTER, $SS_CENTERIMAGE))
            GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
            Global $lb_Tab_Overview_18 = GUICtrlCreateLabel($sStringShow, 300, 221, $gW-310, 30, $SS_LEFTNOWORDWRAP)
            GUICtrlSetBkColor(-1, -2)
            GUICtrlSetFont(-1, 18)
            GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKRIGHT + $GUI_DOCKHEIGHT)

            GUICtrlCreateLabel("24", 255, 246, 40, 35, BitOR($SS_CENTER, $SS_CENTERIMAGE))
            GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
            Global $lb_Tab_Overview_24 = GUICtrlCreateLabel($sStringShow, 300, 246, $gW-310, 35, $SS_LEFTNOWORDWRAP)
            GUICtrlSetBkColor(-1, -2)
            GUICtrlSetFont(-1, 24)
            GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKRIGHT + $GUI_DOCKHEIGHT)

            GUICtrlCreateLabel("36", 255, 276, 40, 65, BitOR($SS_CENTER, $SS_CENTERIMAGE))
            GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
            Global $lb_Tab_Overview_36 = GUICtrlCreateLabel($sStringShow, 300, 276, $gW-310, 65, $SS_LEFTNOWORDWRAP)
            GUICtrlSetBkColor(-1, -2)
            GUICtrlSetFont(-1, 36)
            GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKRIGHT + $GUI_DOCKHEIGHT)

            GUICtrlCreateLabel("48", 255, 316, 40, 75, BitOR($SS_CENTER, $SS_CENTERIMAGE))
            GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
            Global $lb_Tab_Overview_48 = GUICtrlCreateLabel($sStringShow, 300, 316, $gW-310, 75, $SS_LEFTNOWORDWRAP)
            GUICtrlSetBkColor(-1, -2)
            GUICtrlSetFont(-1, 48)
            GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKRIGHT + $GUI_DOCKHEIGHT)

            GUICtrlCreateLabel("60", 255, 371, 40, 90, BitOR($SS_CENTER, $SS_CENTERIMAGE))
            GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
            Global $lb_Tab_Overview_60 = GUICtrlCreateLabel($sStringShow, 300, 371, $gW-310, 90, $SS_LEFTNOWORDWRAP)
            GUICtrlSetBkColor(-1, -2)
            GUICtrlSetFont(-1, 60)
            GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKRIGHT + $GUI_DOCKHEIGHT)

            GUICtrlCreateLabel("78", 255, 441, 40, 120, BitOR($SS_CENTER, $SS_CENTERIMAGE))
            GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
            Global $lb_Tab_Overview_78 = GUICtrlCreateLabel($sStringShow, 300, 441, $gW-310, 120, $SS_LEFTNOWORDWRAP)
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

            GUICtrlCreateLabel("", 760, 180, 180, 1)
            GUICtrlSetBkColor(-1, 0x000000)
            GUICtrlSetResizing(-1, $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)

            Global $bt_ALeft   = GUICtrlCreateLabel(ChrW(0xf036), 785, 185, 30, 30, BitOR($SS_CENTER, $SS_CENTERIMAGE))
            GUICtrlSetBkColor(-1, 0xABCDEF)
            GUICtrlSetFont(-1, 14, 0, 0, $sFontAwesomeName)
            GUICtrlSetOnEvent(-1, "_TabCustomText_SetState")
            GUICtrlSetResizing(-1, $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
            Global $inp_Tab_CustomText_CurentAlgin = $bt_ALeft

            Global $bt_ACenter = GUICtrlCreateLabel(ChrW(0xf037), 830, 185, 30, 30, BitOR($SS_CENTER, $SS_CENTERIMAGE))
            GUICtrlSetFont(-1, 14, 0, 0, $sFontAwesomeName)
            GUICtrlSetOnEvent(-1, "_TabCustomText_SetState")
            GUICtrlSetResizing(-1, $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)

            Global $bt_ARight  = GUICtrlCreateLabel(ChrW(0xf038), 875, 185, 30, 30, BitOR($SS_CENTER, $SS_CENTERIMAGE))
            GUICtrlSetFont(-1, 14, 0, 0, $sFontAwesomeName)
            Global $inp_Tab_CustomText_Size = GUICtrlSetOnEvent(-1, "_TabCustomText_SetState")
            GUICtrlSetResizing(-1, $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)

            GUICtrlCreateLabel("", 760, 220, 180, 1)
            GUICtrlSetBkColor(-1, 0x000000)
            GUICtrlSetResizing(-1, $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)

            GUICtrlCreateLabel("Font size:", 765, 225, 90, 30, BitOR($SS_CENTER, $SS_CENTERIMAGE))
            GUICtrlSetFont(-1, 13)
            GUICtrlSetResizing(-1, $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
            $inp_Tab_CustomText_Size = GUICtrlCreateCombo("", 865, 230, 50, 30, $CBS_DROPDOWNLIST)
            GUICtrlSetData(-1, "8|9|10|11|12|14|16|18|20|22|24|26|28|36|48|72", "12")
            GUICtrlSetOnEvent(-1, "_inp_Tab_CustomText_SetStyle")
            GUICtrlSetResizing(-1, $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
        #EndRegion
        #Region	;Tab Char Map
        GUICtrlCreateTabItem(" ")
            Global $CharMapFrom = 33
            Global $CharMapTo = $CharMapFrom + 129

            GUICtrlCreateLabel("", 255, 140, $gW-(255+10), 30)
            GUICtrlSetStyle(-1, $GUI_DISABLE)
            GUICtrlSetBkColor(-1, 0xFFAA48)
            GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKRIGHT + $GUI_DOCKHEIGHT)

            GUICtrlCreateLabel("Character from", 265, 140, 100, 30, $SS_CENTERIMAGE)
            GUICtrlSetFont(-1, 11, 0, 0, $DefaultFont)
            GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)

            Global $inp_Tab_CharMap_From = GUICtrlCreateInput($CharMapFrom, 365, 145, 50, 15, BitOR($ES_NUMBER, $ES_CENTER), 0)
            GUICtrlSetBkColor(-1, 0xFFAA48)
            GUICtrlSetFont(-1, 11, 0, 0, $DefaultFont)
            GUICtrlSetLimit(-1, 65405, 0)
            GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
            GUICtrlCreateLabel("", 365, 163, 50, 2)
            GUICtrlSetBkColor(-1, 0x000000)
            GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)

            GUICtrlCreateLabel("to", 430, 140, 20, 30, $SS_CENTERIMAGE)
            GUICtrlSetFont(-1, 11, 0, 0, $DefaultFont)
            GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)

            Global $inp_Tab_CharMap_To = GUICtrlCreateInput($CharMapTo, 450, 145, 50, 15, BitOR($ES_NUMBER, $ES_CENTER), 0)
            GUICtrlSetBkColor(-1, 0xFFAA48)
            GUICtrlSetFont(-1, 11, 0, 0, $DefaultFont)
            GUICtrlSetLimit(-1, 65535, 130)
            GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
            GUICtrlCreateLabel("", 450, 163, 50, 2)
            GUICtrlSetBkColor(-1, 0x000000)
            GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)

            GUICtrlCreateLabel("in Unicode table. {0->65535 | 0x0000->0xFFFF}", 505, 140, 300, 30, $SS_CENTERIMAGE)
            GUICtrlSetFont(-1, 11, 0, 0, $DefaultFont)
            GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)

            ; Navigation Controls Char map
            Global $lb_Tab_CharMap_Next130Char = GUICtrlCreateLabel(ChrW(0xf04e), $gW-40, 140, 30, 30, BitOR($SS_CENTER, $SS_CENTERIMAGE))
            GUICtrlSetTip(-1, "The next 130 characters")
            GUICtrlSetCursor(-1, 0)
            GUICtrlSetFont(-1, 8, 0, 0, $sFontAwesomeName, 5)
            GUICtrlSetOnEvent(-1, "_Tab_CharMap_NavigationBarSelect")
            GUICtrlSetResizing(-1, $GUI_DOCKTOP + $GUI_DOCKRIGHT + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)

            Global $lb_Tab_CharMap_Prev130Char = GUICtrlCreateLabel(ChrW(0xf04a), $gW-70, 140, 30, 30, BitOR($SS_CENTER, $SS_CENTERIMAGE))
            GUICtrlSetTip(-1, "The previous 130 characters")
            GUICtrlSetCursor(-1, 0)
            GUICtrlSetFont(-1, 8, 0, 0, $sFontAwesomeName, 5)
            GUICtrlSetOnEvent(-1, "_Tab_CharMap_NavigationBarSelect")
            GUICtrlSetResizing(-1, $GUI_DOCKTOP + $GUI_DOCKRIGHT + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
            ; Navigation Controls Char map

            Global $Ctrl_Tab_BackLabel = GUICtrlCreateLabel("", 255, 171, 519, 399)
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
                    GUICtrlSetOnEvent(-1, "_Tab_CharMap_SetCharInfo2")
                Next
            Next

            Global $Ctrl_Tab_CurrentCharID = 33
            Global $Ctrl_Tab_CurrentChar = GUICtrlCreateLabel("", 775, 171, 165, 165, BitOR($SS_CENTER, $SS_CENTERIMAGE))
            GUICtrlSetBkColor(-1, 0x43A0FF)
            GUICtrlSetFont(-1, 100, 0, 0, $CurentFontName, 5)
            Global $Ctrl_Tab_CurrentChar_Dec = GUICtrlCreateLabel("Demical Code:", 785, 335, 155, 30, $SS_CENTERIMAGE)
            Global $Ctrl_Tab_CurrentChar_Hex = GUICtrlCreateLabel("Hex Value:", 785, 365, 155, 30, $SS_CENTERIMAGE)
            Global $Ctrl_Tab_CurrentChar_UNI = GUICtrlCreateLabel("Unicode:", 785, 395, 155, 30, $SS_CENTERIMAGE)
            Global $Ctrl_Tab_CurrentChar_UTF8 = GUICtrlCreateLabel("UTF-8:", 785, 425, 155, 30, $SS_CENTERIMAGE)
            Global $Ctrl_Tab_CurrentChar_Java = GUICtrlCreateLabel("JavaScript Escaped:", 785, 455, 155, 30, $SS_CENTERIMAGE)
            Global $Ctrl_Tab_CurrentChar_HTML = GUICtrlCreateLabel("HTML Entity:", 785, 485, 155, 30, $SS_CENTERIMAGE)

            Global $Ctrl_Tab_CharMap_Edit = GUICtrlCreateInput("", 775, 525, 165, 20)
            Global $Ctrl_Tab_CharMap_Copy = GUICtrlCreateLabel("Copy", 775, 550, 165, 20, BitOR($SS_CENTER, $SS_CENTERIMAGE))
            GUICtrlSetCursor(-1, 0)
            GUICtrlSetBkColor(-1, 0x43A0FF)
            GUICtrlSetOnEvent(-1, "_Tab_CharMap_btCopy")
        #EndRegion
        #Region	;Tab More Info
        GUICtrlCreateTabItem(" ");More Info
            Global $inp_Tab_MoreInfo = GUICtrlCreateEdit("", 255, 145, 500, 425, BitOR($ES_READONLY, $ES_AUTOHSCROLL, $ES_MULTILINE, $ES_WANTRETURN))
            GUICtrlSetFont(-1, 11, 0, 0, $DefaultFont)
            GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKRIGHT + $GUI_DOCKBOTTOM)

            GUICtrlCreateLabel(ChrW(0xf0ea), 760, 145, 180, 40, BitOR($SS_CENTER, $SS_CENTERIMAGE))
            GUICtrlSetColor(-1, 0xFFFFFF)
            GUICtrlSetBkColor(-1, 0x4D4D4D)
            GUICtrlSetCursor(-1, 0)
            GUICtrlSetFont(-1, 25, 0, 0, $sFontAwesomeName, 5)
            GUICtrlSetOnEvent(-1, "_CopyFontInfo")
            GUICtrlSetResizing(-1, $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
            GUICtrlCreateLabel("Copy all info", 760, 185, 180, 40, BitOR($SS_CENTER, $SS_CENTERIMAGE))
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
EndFunc

Func _Get_CmdArgs_InstallFont()
	$CurentFontPath = _GetCmdLine()
	If StringInStr($CurentFontPath, "\install") Then
		StringTrimLeft($CurentFontPath, 9)
		_InstallFont()
	EndIf
EndFunc

Func _GUI_Loop()  
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
EndFunc


