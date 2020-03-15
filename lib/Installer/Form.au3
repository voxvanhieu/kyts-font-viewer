
Func _InstallTempResources()
    If @Compiled Then
        Global $sTempDir = @TempDir & "\KyTs Tech"
        DirCreate($sTempDir)
        FileInstall("assets\FontAwesome.otf", $sTempDir & "\FontAwesome.otf")
        Global $sFontAwesomePatch = $sTempDir & "\FontAwesome.otf"
        FileInstall("assets\Logo.png", $sTempDir & "\Logo.png")
        Global $sLogoDir = $sTempDir & "\Logo.png"
        FileInstall("assets\Icon.png", $sTempDir & "\Icon.png")
        Global $sIconDir = $sTempDir & "\Icon.png"
        FileInstall("assets\ReadMe.rtf", $sTempDir & "\ReadMe.rtf")
        Global $sDieuKhoan = $sTempDir & "\ReadMe.rtf"
    Else
        Global $sFontAwesomePatch = @ScriptDir & "\assets\FontAwesome.otf"
        Global $sLogoDir = @ScriptDir & "\assets\Logo.png"
        Global $sIconDir = @ScriptDir & "\assets\Icon.png"
        Global $sDieuKhoan = @ScriptDir & "\assets\ReadMe.rtf"
    EndIf
EndFunc

Func _LoadFontAwesomeResource()
    Global Const $sFontAwesomeName = _WinAPI_GetFontResourceInfo($sFontAwesomePatch, True)
    _WinAPI_AddFontResourceEx($sFontAwesomePatch, $FR_PRIVATE)
EndFunc

Func _Create_MainGUI()
    Global $hGUI = GUICreate($Tile, $gW, $gH+50, -1, -1, BitOR($WS_POPUP, $WS_BORDER))
    GUISetBkColor(0xFFFFFF)
    GUISetOnEvent($GUI_EVENT_CLOSE, "_Exit")
    
    GUICtrlSetOnEvent(_GDIPlus_CreatePic($sLogoDir, 0, 0, $gH, $gH), "_FormMove")
    
    GUICtrlCreateLabel("JK. KYTS", $gH, 0, Int(($gW-$gH)/2)-25, Int($gH/2), BitOR($SS_CENTER, $SS_CENTERIMAGE))
    GUICtrlSetColor(-1, 0xFFFFFF)
    GUICtrlSetBkColor(-1, 0x266996)
    GUICtrlSetFont(-1, 20, 0, 0, $DefaultFont & " Bold", 5)
    GUICtrlSetOnEvent(-1, "_FormMove")
    
    GUICtrlCreateLabel("KyTs Font Viewer", $gH+Int(($gW-$gH)/2)-25, 0, Int(($gW-$gH)/2)+25, Int($gH/2), BitOR($SS_CENTER, $SS_CENTERIMAGE))
    GUICtrlSetColor(-1, 0xFFFFFF)
    GUICtrlSetBkColor(-1, 0x0082CD)
    GUICtrlSetFont(-1, 20, 0, 0, $DefaultFont, 5)
    GUICtrlSetOnEvent(-1, "_FormMove")
    
    GUICtrlCreateLabel("", $gH, Int($gH/2), Int($gH/2), 5, BitOR($SS_CENTER, $SS_CENTERIMAGE))
    GUICtrlSetBkColor(-1, 0x16A180)
    Global $MenuBar1 = GUICtrlCreateLabel(ChrW(0xf015), $gH, Int($gH/2)+5, Int($gH/2), Int($gH/2)-5, BitOR($SS_CENTER, $SS_CENTERIMAGE))
    GUICtrlSetColor(-1, 0xFFFFFF)
    GUICtrlSetBkColor(-1, 0x19BD9B)
    GUICtrlSetTip(-1, "My Blog: www.hieuda.com")
    GUICtrlSetCursor(-1, 0)
    GUICtrlSetFont(-1, 25, 0, 0, $sFontAwesomeName, 5)
    GUICtrlSetOnEvent(-1, "_MenuBarClicked")
    
    GUICtrlCreateLabel("", $gH+Int($gH/2)*1, Int($gH/2), Int($gH/2), 5, BitOR($SS_CENTER, $SS_CENTERIMAGE))
    GUICtrlSetBkColor(-1, 0x2883BA)
    Global $MenuBar2 = GUICtrlCreateLabel(ChrW(0xf230), $gH+Int($gH/2)*1, Int($gH/2)+5, Int($gH/2), Int($gH/2)-5, BitOR($SS_CENTER, $SS_CENTERIMAGE))
    GUICtrlSetColor(-1, 0xFFFFFF)
    GUICtrlSetBkColor(-1, 0x3598DB)
    GUICtrlSetTip(-1, "Facebook: Hieu Vo Van")
    GUICtrlSetCursor(-1, 0)
    GUICtrlSetFont(-1, 25, 0, 0, $sFontAwesomeName, 5)
    GUICtrlSetOnEvent(-1, "_MenuBarClicked")
    
    GUICtrlCreateLabel("", $gH+Int($gH/2)*2, Int($gH/2), Int($gH/2), 5, BitOR($SS_CENTER, $SS_CENTERIMAGE))
    GUICtrlSetBkColor(-1, 0xD1A802)
    Global $MenuBar3 = GUICtrlCreateLabel(ChrW(0xf0e0), $gH+Int($gH/2)*2, Int($gH/2)+5, Int($gH/2), Int($gH/2)-5, BitOR($SS_CENTER, $SS_CENTERIMAGE))
    GUICtrlSetColor(-1, 0xFFFFFF)
    GUICtrlSetBkColor(-1, 0xF2CA2A)
    GUICtrlSetTip(-1, "Email: hieuvv.dev@gmail.com")
    GUICtrlSetCursor(-1, 0)
    GUICtrlSetFont(-1, 25, 0, 0, $sFontAwesomeName, 5)
    GUICtrlSetOnEvent(-1, "_MenuBarClicked")
    
    GUICtrlCreateLabel("", $gH+Int($gH/2)*3, Int($gH/2), Int($gH/2), 5, BitOR($SS_CENTER, $SS_CENTERIMAGE))
    GUICtrlSetBkColor(-1, 0xD05400)
    Global $MenuBar4 = GUICtrlCreateLabel(ChrW(0xf09b), $gH+Int($gH/2)*3, Int($gH/2)+5, Int($gH/2), Int($gH/2)-5, BitOR($SS_CENTER, $SS_CENTERIMAGE))
    GUICtrlSetColor(-1, 0xFFFFFF)
    GUICtrlSetBkColor(-1, 0xE77E23)
    GUICtrlSetTip(-1, "My GitHub repo")
    GUICtrlSetCursor(-1, 0)
    GUICtrlSetFont(-1, 25, 0, 0, $sFontAwesomeName, 5)
    GUICtrlSetOnEvent(-1, "_MenuBarClicked")
    
    GUICtrlCreateLabel("", $gH+Int($gH/2)*4, Int($gH/2), Int($gH/2), 5, BitOR($SS_CENTER, $SS_CENTERIMAGE))
    GUICtrlSetBkColor(-1, 0xB63D32)
    Global $MenuBar5 = GUICtrlCreateLabel(ChrW(0xf16a), $gH+Int($gH/2)*4, Int($gH/2)+5, Int($gH/2), Int($gH/2)-5, BitOR($SS_CENTER, $SS_CENTERIMAGE))
    GUICtrlSetColor(-1, 0xFFFFFF)
    GUICtrlSetBkColor(-1, 0xE84C3D)
    GUICtrlSetTip(-1, "Youtube Chanel")
    GUICtrlSetCursor(-1, 0)
    GUICtrlSetFont(-1, 25, 0, 0, $sFontAwesomeName, 5)
    GUICtrlSetOnEvent(-1, "_MenuBarClicked")
    
    GUICtrlCreateLabel("", $gH+Int($gH/2)*5, Int($gH/2), Int($gH/2), 5, BitOR($SS_CENTER, $SS_CENTERIMAGE))
    GUICtrlSetBkColor(-1, 0x2C2C2C)
    Global $MenuBar6 = GUICtrlCreateLabel(ChrW(0xf21b), $gH+Int($gH/2)*5, Int($gH/2)+5, Int($gH/2), Int($gH/2)-5, BitOR($SS_CENTER, $SS_CENTERIMAGE))
    GUICtrlSetColor(-1, 0xFFFFFF)
    GUICtrlSetBkColor(-1, 0x4D4D4D)
    GUICtrlSetTip(-1, "Some infomations about me!")
    GUICtrlSetCursor(-1, 0)
    GUICtrlSetFont(-1, 25, 0, 0, $sFontAwesomeName, 5)
    GUICtrlSetOnEvent(-1, "_MenuBarClicked")
    
    #Region	;Create Tab
    Global $hTab = GUICtrlCreateTab(0, $gH-5, $gW, $gH*2+5, BitOR($TCS_FLATBUTTONS, $TCS_FIXEDWIDTH))
    _GUICtrlTab_SetItemSize($hTab,0,1)
    GUICtrlSetResizing($hTab, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
        GUICtrlCreateTabItem(" ")	; Tab Start
            _GDIPlus_CreatePic($sIconDir, 10, $gH+10, 100, 100)
            GUICtrlCreateLabel("", 115, $gH+10, 5, 100)
            GUICtrlSetBkColor(-1, 0x1C8BFF)
            GUICtrlCreateLabel(" " & $Tile, 120, $gH+10, $gW-130, 100, $SS_CENTERIMAGE)
            GUICtrlSetBkColor(-1, 0xEEEEEE)
            GUICtrlSetFont(-1, 25, 0, 0, $DefaultFont & " SemiBold", 5)
    
            Local $_iH = $gH+110
            Local $__iH = $gH*3-$_iH
    
            Global $lb_AutoInstall = GUICtrlCreateLabel("Auto Install", Int($gW/2)-150, $_iH+($__iH/4-50/2)+10, 300, 50, BitOR($SS_CENTER, $SS_CENTERIMAGE))
            GUICtrlSetColor(-1, 0xFFFFFF)
            GUICtrlSetBkColor(-1, 0x1C8BFF)
            GUICtrlSetCursor(-1, 0)
            GUICtrlSetFont(-1, 18, 0, 0, $DefaultFont, 5)
            GUICtrlSetOnEvent(-1, "_TabChange")
            Global $lb_AutoInstall_Icon = GUICtrlCreateLabel(ChrW(0xf04b), Int($gW/2)-150, $_iH+($__iH/4-50/2)+10, 50, 50, BitOR($SS_CENTER, $SS_CENTERIMAGE))
            GUICtrlSetColor(-1, 0xFFFFFF)
            GUICtrlSetBkColor(-1, 0x266996)
            GUICtrlSetCursor(-1, 0)
            GUICtrlSetFont(-1, 18, 0, 0, $sFontAwesomeName, 5)
            GUICtrlSetOnEvent(-1, "_TabChange")
    
            Global $lb_CustomInstall = GUICtrlCreateLabel("Custom Install", Int($gW/2)-150, 360, 300, 50, BitOR($SS_CENTER, $SS_CENTERIMAGE))
            GUICtrlSetColor(-1, 0xFFFFFF)
            GUICtrlSetBkColor(-1, 0x1C8BFF)
            GUICtrlSetCursor(-1, 0)
            GUICtrlSetFont(-1, 18, 0, 0, $DefaultFont, 5)
            GUICtrlSetOnEvent(-1, "_TabChange")
            Global $lb_CustomInstall_Icon = GUICtrlCreateLabel(ChrW(0xf013), Int($gW/2)-150, 360, 50, 50, BitOR($SS_CENTER, $SS_CENTERIMAGE))
            GUICtrlSetColor(-1, 0xFFFFFF)
            GUICtrlSetBkColor(-1, 0x266996)
            GUICtrlSetCursor(-1, 0)
            GUICtrlSetFont(-1, 18, 0, 0, $sFontAwesomeName, 5)
            GUICtrlSetOnEvent(-1, "_TabChange")
        GUICtrlCreateTabItem(" ")	; Tab Users Licence
            Global $hRichEdit = _GUICtrlRichEdit_Create($hGUI, "", 10, 160, $gW-20, 220, BitOR($ES_MULTILINE, $ES_READONLY, $WS_VSCROLL), $WS_EX_TOOLWINDOW)
            _GUICtrlRichEdit_StreamFromFile($hRichEdit, $sDieuKhoan)
            _GUICtrlRichEdit_SetScrollPos($hRichEdit, 0, 0)
            ControlDisable($hGUI, "", $hRichEdit)
            ControlHide($hGUI, "", $hRichEdit)
    
            Global $lb_TabUL_NotAgree_Icon = GUICtrlCreateLabel(ChrW(0xf00d), 10, 390, 50, 50, BitOR($SS_CENTER, $SS_CENTERIMAGE))
            GUICtrlSetColor(-1, 0xFFFFFF)
            GUICtrlSetBkColor(-1, 0xB92E39)
            GUICtrlSetCursor(-1, 0)
            GUICtrlSetFont(-1, 20, 0, 0, $sFontAwesomeName, 5)
            GUICtrlSetOnEvent(-1, "_Exit")
            Global $lb_TabUL_NotAgree = GUICtrlCreateLabel("    I do NOT agree!", 60, 390, 235, 50, $SS_CENTERIMAGE)
            GUICtrlSetColor(-1, 0xFFFFFF)
            GUICtrlSetBkColor(-1, 0xDC3545)
            GUICtrlSetCursor(-1, 0)
            GUICtrlSetFont(-1, 12, 0, 0, $DefaultFont, 5)
            GUICtrlSetOnEvent(-1, "_Exit")
    
            
            Global $lb_TabUL_Agree = GUICtrlCreateLabel("I agree with user agreements!   ", 305, 390, 235, 50, BitOR($SS_RIGHT, $SS_CENTERIMAGE))
            GUICtrlSetColor(-1, 0xFFFFFF)
            GUICtrlSetBkColor(-1, 0x28A745)
            GUICtrlSetCursor(-1, 0)
            GUICtrlSetFont(-1, 12, 0, 0, $DefaultFont, 5)
            GUICtrlSetOnEvent(-1, "_TabChange")
            Global $lb_TabUL_Agree_Icon = GUICtrlCreateLabel(ChrW(0xf00c), 540, 390, 50, 50, BitOR($SS_CENTER, $SS_CENTERIMAGE))
            GUICtrlSetColor(-1, 0xFFFFFF)
            GUICtrlSetBkColor(-1, 0x217C34)
            GUICtrlSetCursor(-1, 0)
            GUICtrlSetFont(-1, 20, 0, 0, $sFontAwesomeName, 5)
            GUICtrlSetOnEvent(-1, "_TabChange")
        GUICtrlCreateTabItem(" ") ;Chose Location
            Global $InstallDir = @ProgramFilesDir & "\KyTs Tech\KyTs Font Viewer"
    
            GUICtrlCreateLabel("Installation Location:", 10, 170, $gW-20, 30, $SS_CENTERIMAGE)
            GUICtrlSetFont(-1, 15, 0, 0, $DefaultFont, 5)
    
            GUICtrlCreateLabel(ChrW(0xf07c), 20, 210, 30, 30, BitOR($SS_CENTER, $SS_CENTERIMAGE))
            GUICtrlSetColor(-1, 0x000000)
            GUICtrlSetBkColor(-1, 0xFFFFFF)
            GUICtrlSetCursor(-1, 0)
            GUICtrlSetTip(-1, "Browse")
            GUICtrlSetFont(-1, 20, 0, 0, $sFontAwesomeName, 5)
            GUICtrlSetOnEvent(-1, "_SellectFolder")
    
            Global $inp_TabCL_InstallDir = GUICtrlCreateInput($InstallDir, 60, 210, 500, 30, -1, 0)
            GUICtrlSetFont(-1, 15, 0, 0, $DefaultFont, 5)
            GUICtrlCreateLabel("", 60, 240, 500, 2)
            GUICtrlSetBkColor(-1, 0x000000)
    
            Global $_IsOpt1 = 0
            Global $lb_TabCL_Sel1_Icon = GUICtrlCreateLabel(ChrW(0xf14a), 60, 270, 30, 30, BitOR($SS_CENTER, $SS_CENTERIMAGE))
            GUICtrlSetColor(-1, 0x118408)
            GUICtrlSetCursor(-1, 0)
            GUICtrlSetFont(-1, 20, 0, 0, $sFontAwesomeName, 5)
            GUICtrlSetOnEvent(-1, "_OptionsClicked")
            Global $lb_TabCL_Sel1 = GUICtrlCreateLabel(" Set KyTs Font Viewer as default font viewer!", 90, 270, 400, 30, $SS_CENTERIMAGE)
            GUICtrlSetCursor(-1, 0)
            GUICtrlSetFont(-1, 12, 0, 0, $DefaultFont, 5)
            GUICtrlSetOnEvent(-1, "_OptionsClicked")
    
            Global $_IsOpt2 = 0
            Global $lb_TabCL_Sel2_Icon = GUICtrlCreateLabel(ChrW(0xf14a), 60, 300, 30, 30, BitOR($SS_CENTER, $SS_CENTERIMAGE))
            GUICtrlSetColor(-1, 0x118408)
            GUICtrlSetCursor(-1, 0)
            GUICtrlSetFont(-1, 20, 0, 0, $sFontAwesomeName, 5)
            GUICtrlSetOnEvent(-1, "_OptionsClicked")
            Global $lb_TabCL_Sel2 = GUICtrlCreateLabel(" Open with KyTs Font Viewer in right-click nemu.", 90, 300, 400, 30, $SS_CENTERIMAGE)
            GUICtrlSetCursor(-1, 0)
            GUICtrlSetFont(-1, 12, 0, 0, $DefaultFont, 5)
            GUICtrlSetOnEvent(-1, "_OptionsClicked")
    
            Global $_IsOpt3 = 0
            Global $lb_TabCL_Sel3_Icon = GUICtrlCreateLabel(ChrW(0xf14a), 60, 330, 30, 30, BitOR($SS_CENTER, $SS_CENTERIMAGE))
            GUICtrlSetColor(-1, 0x118408)
            GUICtrlSetCursor(-1, 0)
            GUICtrlSetFont(-1, 20, 0, 0, $sFontAwesomeName, 5)
            GUICtrlSetOnEvent(-1, "_OptionsClicked")
            Global $lb_TabCL_Sel3 = GUICtrlCreateLabel(" Visit hieuda.com after installed!", 90, 330, 400, 30, $SS_CENTERIMAGE)
            GUICtrlSetCursor(-1, 0)
            GUICtrlSetFont(-1, 12, 0, 0, $DefaultFont, 5)
            GUICtrlSetOnEvent(-1, "_OptionsClicked")
    
            Global $lb_TabCL_Back_Icon = GUICtrlCreateLabel(ChrW(0xf060), 10, 390, 50, 50, BitOR($SS_CENTER, $SS_CENTERIMAGE))
            GUICtrlSetColor(-1, 0xFFFFFF)
            GUICtrlSetBkColor(-1, 0x266996)
            GUICtrlSetCursor(-1, 0)
            GUICtrlSetFont(-1, 20, 0, 0, $sFontAwesomeName, 5)
            GUICtrlSetOnEvent(-1, "_TabChange")
            Global $lb_TabCL_Back = GUICtrlCreateLabel("   I want to read again", 60, 390, 235, 50, BitOR($SS_LEFT, $SS_CENTERIMAGE))
            GUICtrlSetColor(-1, 0xFFFFFF)
            GUICtrlSetBkColor(-1, 0x0082CD)
            GUICtrlSetCursor(-1, 0)
            GUICtrlSetFont(-1, 13, 0, 0, $DefaultFont, 5)
            GUICtrlSetOnEvent(-1, "_TabChange")
    
            Global $lb_TabCL_Next = GUICtrlCreateLabel("Looks good   ", 305, 390, 235, 50, BitOR($SS_RIGHT, $SS_CENTERIMAGE))
            GUICtrlSetColor(-1, 0xFFFFFF)
            GUICtrlSetBkColor(-1, 0x0082CD)
            GUICtrlSetCursor(-1, 0)
            GUICtrlSetFont(-1, 13, 0, 0, $DefaultFont, 5)
            GUICtrlSetOnEvent(-1, "_TabChange")
            Global $lb_TabCL_Next_Icon = GUICtrlCreateLabel(ChrW(0xf061), 540, 390, 50, 50, BitOR($SS_CENTER, $SS_CENTERIMAGE))
            GUICtrlSetColor(-1, 0xFFFFFF)
            GUICtrlSetBkColor(-1, 0x266996)
            GUICtrlSetCursor(-1, 0)
            GUICtrlSetFont(-1, 20, 0, 0, $sFontAwesomeName, 5)
            GUICtrlSetOnEvent(-1, "_TabChange")
        GUICtrlCreateTabItem(" ") ;Tab Install
            Global $lb_TabIN_Text = GUICtrlCreateLabel("Installing, please wait a moment...", 0, 170, $gW, 30, BitOR($SS_CENTER, $SS_CENTERIMAGE))
            GUICtrlSetFont(-1, 15, 0, 0, $DefaultFont, 5)
    
            Global $lb_TabIN_Progress = GUICtrlCreateLabel("", ($gW/2)-(150/2), 215, 150, 150)
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
    
            Global $lb_TabIN_Next = GUICtrlCreateLabel("I fell lucky!", 305, 390, 235, 50, BitOR($SS_CENTER, $SS_CENTERIMAGE))
            GUICtrlSetColor(-1, 0xFFFFFF)
            GUICtrlSetBkColor(-1, 0xFFFFFF)
            GUICtrlSetFont(-1, 13, 0, 0, $DefaultFont, 5)
            Global $lb_TabIN_Next_Icon = GUICtrlCreateLabel(ChrW(0xf061), 540, 390, 50, 50, BitOR($SS_CENTER, $SS_CENTERIMAGE))
            GUICtrlSetColor(-1, 0xFFFFFF)
            GUICtrlSetBkColor(-1, 0xFFFFFF)
            GUICtrlSetFont(-1, 20, 0, 0, $sFontAwesomeName, 5)
    
        GUICtrlCreateTabItem(" ") ;Tab Thankyou
            GUICtrlCreateLabel("Thank you for using my sofware!", 0, 170, $gW, 40, BitOR($SS_CENTER, $SS_CENTERIMAGE))
            ;GUICtrlCreateLabel("The installation is completed sucessfully!", 0, 170, $gW, 30, BitOR($SS_CENTER, $SS_CENTERIMAGE))
            GUICtrlSetFont(-1, 18, 0, 0, $DefaultFont, 5)
    
            GUICtrlCreateLabel(ChrW(0xf109), $gW/2-75, 215, 150, 150, BitOR($SS_CENTER, $SS_CENTERIMAGE))
            ;GUICtrlCreateLabel(ChrW(0xf05d), $gW/2-50, 235, 100, 100, BitOR($SS_CENTER, $SS_CENTERIMAGE))
            ;ChrW(0xf19d)  -> Mũ
            GUICtrlSetColor(-1, 0x118408)
            GUICtrlSetFont(-1, 120, 0, 0, $sFontAwesomeName, 5)
    
            GUICtrlCreateLabel(ChrW(0xf113), 160, 375, 40, 40, BitOR($SS_CENTER, $SS_CENTERIMAGE))
            GUICtrlSetColor(-1, 0x3B5998)
            GUICtrlSetCursor(-1, 0)
            GUICtrlSetFont(-1, 25, 0, 0, $sFontAwesomeName, 5)
            GUICtrlSetOnEvent(-1, "_GotoGithubRepo")
            Global $lb_TabTY_Launch = GUICtrlCreateLabel("", 200, 375, 250, 40, $SS_CENTERIMAGE)
            GUICtrlSetCursor(-1, 0)
            GUICtrlSetFont(-1, 14, 0, 0, $DefaultFont, 5)
            GUICtrlSetOnEvent(-1, "_GotoGithubRepo")
        GUICtrlCreateTabItem("")
    #EndRegion
    
    GUICtrlCreateLabel("", 0, $gH, $gW-50, 50)
    GUICtrlSetBkColor(-1, 0x4D4D4D)
    GUICtrlSetOnEvent(-1, "_FormMove")
    GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKBOTTOM + $GUI_DOCKSIZE)
    GUICtrlCreateLabel("</> with ♥ from JK.KYTS", 10, $gH, 250, 50, $SS_CENTERIMAGE)
    GUICtrlSetColor(-1, 0xFFFFFF)
    GUICtrlSetBkColor(-1, -2)
    GUICtrlSetFont(-1, 12, 0, 0, $DefaultFont, 5)
    GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKBOTTOM + $GUI_DOCKSIZE)
    
    GUICtrlCreateLabel(ChrW(0xf08b), $gW-50, $gH, 50, 50, BitOR($SS_CENTER, $SS_CENTERIMAGE))
    GUICtrlSetColor(-1, 0xFFFFFF)
    GUICtrlSetBkColor(-1, 0x4D4D4D)
    GUICtrlSetCursor(-1, 0)
    GUICtrlSetTip(-1, "Exit")
    GUICtrlSetFont(-1, 20, 0, 0, $sFontAwesomeName, 5)
    GUICtrlSetOnEvent(-1, "_Exit")
    GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKBOTTOM + $GUI_DOCKSIZE)
EndFunc

#region Form events
Func _GUI_Loop()
    While 1
        Sleep(1000)
    WEnd
EndFunc

Func _FormMove()
	DllCall("user32.dll", "int", "SendMessage", "HWND", $hGUI, "int", 0x0112, "int", 0xF012, "int", 0)
EndFunc		;Moving Form
Func _ShowForm()
	Local $I
	For $I = 0 To 255 Step +15
		WinSetTrans($hGUI,"", $I)
		Sleep(10)
	Next

	Local $_gW = $gW
	Local $_gH = $gH*3+50
	Local $_GUIPos = WinGetPos($hGUI)

	For $I = $_GUIPos[1] To $_GUIPos[1]-Int(($gH*2+50)/2)+25 Step -5
		WinMove($hGUI, "", $_GUIPos[0], $I)
		Sleep(1)
	Next

	$_GUIPos = WinGetPos($hGUI)
	For $I=1 To $gH*2 Step +4
		WinMove($hGUI, "", $_GUIPos[0], $_GUIPos[1], $gW, $gH+50+$I)
	Next

	WinFlash($hGUI, "", 1)
EndFunc
Func _HideForm()
	Local $I
	Local $_GUIPos = WinGetPos($hGUI)

	For $I=$gH*2 To 0 Step -4
		WinMove($hGUI, "", $_GUIPos[0], $_GUIPos[1], $gW, $gH+50+$I)
	Next

	For $I = 255 To 0 Step -15
		WinSetTrans($hGUI,"", $I)
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

	If (@Compiled) Then ShellExecute($InstallDir & "\KyTs Font Viewer.exe")
	If (@Compiled) And ($_IsOpt3 < 2) Then ShellExecute($homePageLink)
	Exit
EndFunc

Func _TabChange()
	Switch @GUI_CtrlId
		Case $lb_AutoInstall, $lb_AutoInstall_Icon
			GUICtrlSendMsg($hTab, $TCM_SETCURFOCUS, 3, 0)
			_StartInstall()
		Case $lb_CustomInstall, $lb_TabCL_Back, $lb_TabCL_Back_Icon
			GUICtrlSendMsg($hTab, $TCM_SETCURFOCUS, 1, 0)
			ControlEnable($hGUI, "", $hRichEdit)
			ControlShow($hGUI, "", $hRichEdit)
		Case $lb_TabUL_Agree, $lb_TabUL_Agree_Icon
			ControlDisable($hGUI, "", $hRichEdit)
			ControlHide($hGUI, "", $hRichEdit)
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
	Local $hFile = FileSelectFolder("Sellect install location!", @ProgramFilesDir, BitOR($FSF_CREATEBUTTON, $FSF_NEWDIALOG, $FSF_EDITCONTROL), "", $hGUI)
	If Not @error Then
		If Not StringInStr($hFile, "KyTs Font Viewer") Then $InstallDir = $hFile & "\KyTs Font Viewer"
		GUICtrlSetData($inp_TabCL_InstallDir, $InstallDir)
	EndIf
EndFunc
Func _GotoGithubRepo()
	ShellExecute("https://github.com/voxvanhieu/kyts-font-viewer")
EndFunc
Func _DrawProgress($iPersent = 50)
	If $iPersent >= 100 Then $iPersent = 100
	$angle = Int($iPersent/100 * 360)
	_GDIPlus_GraphicsClear($hBackbuffer, 0xFFFFFFFF)
	_GDIPlus_PenSetColor($hPen, 0xFFE0FFE0)
	_GDIPlus_GraphicsDrawArc($hBackbuffer, $pen_size / 2, $pen_size / 2, 150 - $pen_size, 150 - $pen_size, -90, $angle, $hPen2)
	$sString = $iPersent
	$fx = StringLen($sString&"%") * $fsize / 2.5
	_GDIPlus_GraphicsDrawString($hBackbuffer, $sString&"%", 150 / 2 - $fx, 150 / 2 - $fsize * 0.75, $font, $fsize)
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
			FileInstall("bin\KyTs Font Viewer.exe", $sInstallDir & "\KyTs Font Viewer.exe", 1)
		Else
			FileInstall("bin\KyTs Font Viewer_x64.exe", $sInstallDir & "\KyTs Font Viewer.exe", 1)
		EndIf
		FileCreateShortcut($sInstallDir & "\KyTs Font Viewer.exe", @DesktopDir & "\KyTs Font Viewer.lnk")
		FileInstall("bin\Helper.exe", $sInstallDir & "\Helper.exe", 1)
		FileInstall("assets\ReadMe.rtf", $sInstallDir & "\ReadMe.rtf", 1)
		FileInstall("bin\Uninstall.exe", $sInstallDir & "\Uninstall.exe", 1)
		DirCreate($sInstallDir & "\assets")
		FileInstall("assets\Icon_mini.png", $sInstallDir & "\assets\Icon_mini.png", 1)
		FileInstall("assets\FontAwesome.otf", $sInstallDir & "\assets\FontAwesome.otf", 1)
		FileInstall("assets\Help_EN.rtf", $sInstallDir & "\assets\Help_EN.rtf", 1)
		FileInstall("assets\Help_VN.rtf", $sInstallDir & "\assets\Help_VN.rtf", 1)
		_SetProgressTo(20)

		Global Const $Key  = "HKCU\Software\KyTs Tech\KyTs Font Viewer"
		Global Const $UKey = "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\KyTs Font Viewer"
		_SetProgressTo(45)

		RegWrite($Key, "Install", "REG_SZ", $sInstallDir)
		RegWrite($UKey , "DisplayName", "REG_SZ", "KyTs Font Viewer")
		RegWrite($UKey , "Comments", "REG_SZ", "A better font viewer than windows font viewer!")
		RegWrite($UKey , "Contact", "REG_SZ", "www.hieuda.com")
		RegWrite($UKey , "DisplayVersion", "REG_SZ", "1.0")
		;RegWrite($UKey , "HelpTelephone", "REG_SZ", "+84*********")
		RegWrite($UKey , "Publisher", "REG_SZ", "JK.Kyts")
		RegWrite($UKey , "DisplayIcon", "REG_SZ", $sInstallDir & "\KyTs Font Viewer.exe")
		RegWrite($UKey , "HelpLink", "REG_SZ", "github.com/voxvanhieu/kyts-font-viewer")
		RegWrite($UKey , "UninstallString", "REG_SZ", $sInstallDir & "\Uninstall.exe")
		RegWrite($UKey , "URLInfoAbout", "REG_SZ", "github.com/voxvanhieu/kyts-font-viewer")
		RegWrite($UKey , "URLUpdateInfo", "REG_SZ", "github.com/voxvanhieu/kyts-font-viewer")
		_SetProgressTo(65)

		RegDelete("HKCR\ttffile\shell", "")
		RegDelete("HKCR\otffile\shell", "")
		RegDelete("HKCR\fonfile\shell", "")
		_SetProgressTo(90)

		If ($_IsOpt1 <2) Then
			RegWrite("HKCR\ttffile\shell\KyTs Font Viewer", "Icon", "REG_EXPAND_SZ", $sInstallDir & "\KyTs Font Viewer.exe")
;~ 			RegWrite("HKCR\ttffile\shell", "", "REG_SZ", "KyTs Font Viewer")
			RegWrite("HKCR\ttffile\shell\KyTs Font Viewer\command", "", "REG_EXPAND_SZ", $sInstallDir & "\KyTs Font Viewer.exe %1")

			RegWrite("HKCR\otffile\shell\KyTs Font Viewer", "Icon", "REG_EXPAND_SZ", $sInstallDir & "\KyTs Font Viewer.exe")
;~ 			RegWrite("HKCR\otffile\shell", "", "REG_SZ", "KyTs Font Viewer")
			RegWrite("HKCR\otffile\shell\KyTs Font Viewer\command", "", "REG_EXPAND_SZ", $sInstallDir & "\KyTs Font Viewer.exe %1")

			RegWrite("HKCR\fonfile\shell\KyTs Font Viewer", "Icon", "REG_EXPAND_SZ", $sInstallDir & "\KyTs Font Viewer.exe")
;~ 			RegWrite("HKCR\fonfile\shell", "", "REG_SZ", "KyTs Font Viewer")
			RegWrite("HKCR\fonfile\shell\KyTs Font Viewer\command", "", "REG_EXPAND_SZ", $sInstallDir & "\KyTs Font Viewer.exe %1")
		ElseIf ($_IsOpt2 < 2) Then
			RegWrite("HKCR\ttffile\shell\KyTs Font Viewer", "Icon", "REG_EXPAND_SZ", $sInstallDir & "\KyTs Font Viewer.exe")
			RegWrite("HKCR\ttffile\shell", "", "REG_SZ", "preview")
			RegWrite("HKCR\ttffile\shell\KyTs Font Viewer\command", "", "REG_EXPAND_SZ", $sInstallDir & "\KyTs Font Viewer.exe %1")

			RegWrite("HKCR\otffile\shell\KyTs Font Viewer", "Icon", "REG_EXPAND_SZ", $sInstallDir & "\KyTs Font Viewer.exe")
			RegWrite("HKCR\otffile\shell", "", "REG_SZ", "preview")
			RegWrite("HKCR\otffile\shell\KyTs Font Viewer\command", "", "REG_EXPAND_SZ", $sInstallDir & "\KyTs Font Viewer.exe %1")

			RegWrite("HKCR\fonfile\shell\KyTs Font Viewer", "Icon", "REG_EXPAND_SZ", $sInstallDir & "\KyTs Font Viewer.exe")
			RegWrite("HKCR\fonfile\shell", "", "REG_SZ", "preview")
			RegWrite("HKCR\fonfile\shell\KyTs Font Viewer\command", "", "REG_EXPAND_SZ", $sInstallDir & "\KyTs Font Viewer.exe %1")
		EndIf
		_SetProgressTo(100, 0)
	Else
		_SetProgressTo(100, 0)
	EndIf

	GUICtrlSetData($lb_TabIN_Text, "KyTs Font Viewer was installed!")
	GUICtrlSetBkColor($lb_TabIN_Next, 0x28A745)
	GUICtrlSetCursor($lb_TabIN_Next, 0)
	GUICtrlSetOnEvent($lb_TabIN_Next, "_TabChange")
	GUICtrlSetBkColor($lb_TabIN_Next_Icon, 0x217C34)
	GUICtrlSetCursor($lb_TabIN_Next_Icon, 0)
	GUICtrlSetOnEvent($lb_TabIN_Next_Icon, "_TabChange")
EndFunc
Func _StartGoodBye()
	Local $sString = "github.com/voxvanhieu", $I
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
	GUICtrlSetData($lb_TabTY_Launch, GUICtrlRead($lb_TabTY_Launch) == "github.com/voxvanhieu" ? "github.com/voxvanhieu_" : "github.com/voxvanhieu")
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
			ShellExecute($homePageLink)
		Case $MenuBar2
			ShellExecute("https://www.facebook.com/voxvanhieu")
		Case $MenuBar3
			ShellExecute("https://mail.google.com/mail/u/0/?view=cm" & _
					"&fs=1" & _
					"&to=hieuvv.dev@gmail.com" & _
					"&su=Feedback about KyTs product" & _
					"&body=[Do not delete this line - Feedback send from KyTs Installer - KyTsFontViewer]")
		Case $MenuBar4
			ShellExecute("https://github.com/voxvanhieu")
		Case $MenuBar5
			ShellExecute("https://www.youtube.com/")
		Case $MenuBar6
			If Not @Compiled Then Msgbox(0,"Thông Báo","Hiện tab thông tin tác giả!")
	EndSwitch
EndFunc
#EndRegion