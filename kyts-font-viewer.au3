#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=assets\Icon.ico
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

#include "lib\Lib.App.au3"


_GDIPlus_Startup()

        
#Region ;	Create GUI, Get Cmd argument
_Create_MainGUI()
_Get_CmdArgs_InstallFont()

;~ Check something I don't know :(
;~ I forgetted
If StringInStr($TypeFont, _GetFileType($CurentFontPath)) <> 0 Then
	_ViewFont($CurentFontPath)
Else
	_ViewFile()
EndIf

WinSetTrans($hGUI, "", 0)
GUISetState()
_ShowForm()
_GUICtrlTVExplorer_Expand($hTV, $CurentFontPath)
#EndRegion ;	Create GUI and mesages

_GUI_Loop()

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
		DllCall("user32.dll", "int", "SendMessage", "HWND", $hGUI, "int", 0x0112, "int", 0xF012, "int", 0)
	EndIf
EndFunc		;Moving Form
Func _ShowForm()
	Local $I
	For $I = 0 To 255 Step +15
		WinSetTrans($hGUI,"", $I)
		Sleep(10)
	Next
EndFunc
Func _HideForm()
	Local $I
	For $I = 255 To 0 Step -15
		WinSetTrans($hGUI,"", $I)
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
	If $CurentTab == $lb_Tab_Chrmap Then WinSetTrans($hGUI, "", 0)	;Hide GUI to hide unwanted efect
	If $GUIState == @SW_SHOWNORMAL Then
		WinMove($hGUI, "", 0, 0, @DesktopWidth - $TaskBarSize[0], $TaskBarSize[1])
		If $CharMapCtrlSize == 0 Then
			$CharMapCtrlSize = _GetCharMapControlPos()
			$CharMapCtrlTop = $CharMapCtrlSize[0]
			$CharMapCtrlSize = $CharMapCtrlSize[1]
		EndIf
		ControlMove($hGUI, "", $Ctrl_Tab_BackLabel, 255, 177, $CharMapCtrlSize*13-1, $CharMapCtrlSize*10-1)
		;Move Controls
		For $I = 0 To 9
			For $J = 0 To 12
				ControlMove($hGUI, "",$Ctrl_Tab_CharMap[$I][$J], 255+($J*$CharMapCtrlSize), 177+($I*$CharMapCtrlSize), $CharMapCtrlSize-1, $CharMapCtrlSize-1)
			Next
		Next
		$I = 255+(13*$CharMapCtrlSize)+Int((@DesktopWidth-255-10-(13*$CharMapCtrlSize))/2-100)
		ControlMove($hGUI, "", $Ctrl_Tab_CurrentChar, $I, 177, 200, 200)
		ControlMove($hGUI, "", $Ctrl_Tab_CurrentChar_Dec, $I, 397, 200, 30)
		ControlMove($hGUI, "", $Ctrl_Tab_CurrentChar_Hex, $I, 427, 200, 30)
		ControlMove($hGUI, "", $Ctrl_Tab_CurrentChar_UNI, $I, 457, 200, 30)
		ControlMove($hGUI, "", $Ctrl_Tab_CurrentChar_UTF8, $I, 487, 200, 30)
		ControlMove($hGUI, "", $Ctrl_Tab_CurrentChar_Java, $I, 517, 200, 30)
		ControlMove($hGUI, "", $Ctrl_Tab_CurrentChar_HTML, $I, 547, 200, 30)
		$I = 255+(13*$CharMapCtrlSize)+Int((@DesktopWidth-255-10-(13*$CharMapCtrlSize))/2-150)
		$J = 177+(9*$CharMapCtrlSize)+($CharMapCtrlSize-30)
		ControlMove($hGUI, "", $Ctrl_Tab_CharMap_Edit, $I, $J-30, 300, 20)
		ControlMove($hGUI, "", $Ctrl_Tab_CharMap_Copy, $I, $J, 300, 30)
		_WinAPI_RedrawWindow($hGUI)
		$GUIState = @SW_MAXIMIZE
	ElseIf $GUIState == @SW_MAXIMIZE Then
		WinMove($hGUI, "", (@DesktopWidth - $gW) /2, (@DesktopHeight-$gH)/2, $gW, $gH)
		ControlMove($hGUI, "", $Ctrl_Tab_BackLabel, 255, 171, 519, 399)
		;Move Controls
		For $I = 0 To 9
			For $J = 0 To 12
				ControlMove($hGUI, "",$Ctrl_Tab_CharMap[$I][$J], 255+($J*40), 171+($I*40), 39, 39)
			Next
		Next
		ControlMove($hGUI, "", $Ctrl_Tab_CurrentChar, 775, 171, 165, 165)
		ControlMove($hGUI, "", $Ctrl_Tab_CurrentChar_Dec, 785, 335, 155, 30)
		ControlMove($hGUI, "", $Ctrl_Tab_CurrentChar_Hex, 785, 365, 155, 30)
		ControlMove($hGUI, "", $Ctrl_Tab_CurrentChar_UNI, 785, 395, 155, 30)
		ControlMove($hGUI, "", $Ctrl_Tab_CurrentChar_UTF8, 785, 425, 155, 30)
		ControlMove($hGUI, "", $Ctrl_Tab_CurrentChar_Java, 785, 455, 155, 30)
		ControlMove($hGUI, "", $Ctrl_Tab_CurrentChar_HTML, 785, 485, 155, 30)
		ControlMove($hGUI, "", $Ctrl_Tab_CharMap_Edit, 775, 525, 165, 20)
		ControlMove($hGUI, "", $Ctrl_Tab_CharMap_Copy, 775, 550, 165, 20)
		_WinAPI_RedrawWindow($hGUI)
		$GUIState = @SW_SHOWNORMAL
	EndIf
	If $CurentTab == $lb_Tab_Chrmap Then WinSetTrans($hGUI, "", 255)
EndFunc
Func _Minimize()
	_HideForm()
	GUISetState(@SW_MINIMIZE, $hGUI)
EndFunc

Func _ShowHelp()
	If Not FileExists(@ScriptDir & "\Helper.exe") Then
		MsgBox(16, "Error", "Something went wrong! Reinstall this product to fix this error!")
	Else
		ShellExecute(@ScriptDir & "\Helper.exe")
		_HideForm()
		WinWaitActive("KyTs Font Viewer Helper")
		WinWaitClose("KyTs Font Viewer Helper")
		_ShowForm()
	EndIf
EndFunc

Func _GoToHomePage()
	ShellExecute("http://kytstech.blogspot.com")
EndFunc

Func _GDIPlus_CreatePic($FileName, $Left, $Top, $Width, $Heigth)
	Local $hPicCtrl, $hImage, $iHeight, $hGDIBitmap
	$hImage = _GDIPlus_ImageResize(_GDIPlus_ImageLoadFromFile($FileName), $Width, $Heigth)
		$iWidth = _GDIPlus_ImageGetWidth($hImage)
		$iHeight = _GDIPlus_ImageGetHeight($hImage)
		$hGDIBitmap = _GDIPlus_BitmapCreateHBITMAPFromBitmap($hImage)
		_GDIPlus_ImageDispose($hImage)
	$hPicCtrl = GUICtrlCreateLabel("", $Left, $Top, $Width, $Heigth, $SS_BITMAP)
	_WinAPI_DeleteObject(GUICtrlSendMsg($hPicCtrl, 0x0172, $IMAGE_BITMAP, $hGDIBitmap)) ;$STM_SETIMAGE = 0x0172
    _WinAPI_DeleteObject($hGDIBitmap)
	Return $hPicCtrl
EndFunc			;~	Using GDIPlus to create Picture control, shouldn"t create many control with this and project use GDIPlus

Func _ViewFile($sPath = @WindowsDir & "\Fonts\arial.ttf", $_IsDBClick = 0)
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
	Local $sFontInfo, $sInfo = ""
	$sFontInfo  = "File name" & @TAB & @TAB & @TAB & ":" & @TAB & _GetFileName($CurentFontPath) & @CRLF
	$sFontInfo &= "Location" & @TAB & @TAB & @TAB & ":" & @TAB & _GetFilePath($CurentFontPath) & @CRLF
	$sInfo = _WinAPI_GetFontResourceInfo($sPath, Default, 0)
	If Not @error And $sInfo Then $sFontInfo &= "Copyright" & @TAB & @TAB & @TAB & ":" & @TAB & $sInfo & @CRLF
	$sInfo = _WinAPI_GetFontResourceInfo($sPath, Default, 1)
	If Not @error And $sInfo Then $sFontInfo &= "Font Family name" & @TAB & @TAB & ":" & @TAB & $sInfo & @CRLF
	$sInfo = _WinAPI_GetFontResourceInfo($sPath, Default, 2)
	If Not @error And $sInfo Then $sFontInfo &= "Font SubFamily name" & @TAB & ":" & @TAB & $sInfo & @CRLF
	$sInfo = _WinAPI_GetFontResourceInfo($sPath, Default, 3)
	If Not @error And $sInfo Then $sFontInfo &= "Unique font identifier" & @TAB & ":" & @TAB & $sInfo & @CRLF
	$sInfo = _WinAPI_GetFontResourceInfo($sPath, Default, 4)
	If Not @error And $sInfo Then $sFontInfo &= "Font full name" & @TAB & @TAB & ":" & @TAB & $sInfo & @CRLF
	$sInfo = _WinAPI_GetFontResourceInfo($sPath, Default, 5)
	If Not @error And $sInfo Then $sFontInfo &= "Version string" & @TAB & @TAB & ":" & @TAB & $sInfo & @CRLF
	$sInfo = _WinAPI_GetFontResourceInfo($sPath, Default, 6)
	If Not @error And $sInfo Then $sFontInfo &= "Postscript name" & @TAB & @TAB & ":" & @TAB & $sInfo & @CRLF
	$sInfo = _WinAPI_GetFontResourceInfo($sPath, Default, 7)
	If Not @error And $sInfo Then $sFontInfo &= "Trademark" & @TAB & @TAB & ":" & @TAB & $sInfo & @CRLF
	$sInfo = _WinAPI_GetFontResourceInfo($sPath, Default, 8)
	If Not @error And $sInfo Then $sFontInfo &= "Manufacturer Name" & @TAB & @TAB & ":" & @TAB & $sInfo & @CRLF
	$sInfo = _WinAPI_GetFontResourceInfo($sPath, Default, 9)
	If Not @error And $sInfo Then $sFontInfo &= "Designer" & @TAB & @TAB & @TAB & ":" & @TAB & $sInfo & @CRLF
	$sInfo = _WinAPI_GetFontResourceInfo($sPath, Default, 10)
	If Not @error And $sInfo Then $sFontInfo &= "Description" & @TAB & @TAB & ":" & @TAB & $sInfo & @CRLF
	$sInfo = _WinAPI_GetFontResourceInfo($sPath, Default, 11)
	If Not @error And $sInfo Then $sFontInfo &= "URL Vendor" & @TAB & @TAB & ":" & @TAB & $sInfo & @CRLF
	$sInfo = _WinAPI_GetFontResourceInfo($sPath, Default, 16)
	If Not @error And $sInfo Then $sFontInfo &= "Preferred Family (Windows only)" & @TAB & ":" & @TAB & $sInfo & @CRLF
	$sInfo = _WinAPI_GetFontResourceInfo($sPath, Default, 17)
	If Not @error And $sInfo Then $sFontInfo &= "Preferred SubFamily (Windows only)" & @TAB & ":" & @TAB & $sInfo & @CRLF
	$sInfo = _WinAPI_GetFontResourceInfo($sPath, Default, 18)
	If Not @error And $sInfo Then $sFontInfo &= "Compatible Full (Mac OS only)" & @TAB & ":" & @TAB & $sInfo & @CRLF
	$sInfo = _WinAPI_GetFontResourceInfo($sPath, Default, 19)
	If Not @error And $sInfo Then $sFontInfo &= "Sample text" & @TAB & @TAB & ":" & @TAB & $sInfo & @CRLF
	$sInfo = _WinAPI_GetFontResourceInfo($sPath, Default, 20)
	If Not @error And $sInfo Then $sFontInfo &= "PostScript CID findfont name" & @TAB & ":" & @TAB & $sInfo & @CRLF
	$sInfo = _WinAPI_GetFontResourceInfo($sPath, Default, 256)
	If Not @error And $sInfo Then $sFontInfo &= "PostScript CID findfont name" & @TAB & ":" & @TAB & $sInfo & @CRLF

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
Func _GetFileName($sPath = "")
	If $sPath <> "" Then
		Local $I = StringLen($sPath), $Name = ""
		While ($I >= 1) And (StringMid($sPath, $I, 1) <> "\")
			$Name = StringMid($sPath, $I, 1) & $Name
			$I -= 1
		WEnd
		Return $Name
	EndIf
	Return ""
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
	$FileList = _FileListToArrayRec($FontPath, "*.FON;*.FNT;*.TTF;*.TTC;*.FOT;*.OTF;*.MMM;*.PFB;*.PFM", $FLTAR_FILES, $FLTAR_NORECUR, $FLTAR_SORT, $FLTAR_FULLPATH)
	Switch $CtrlID
		Case $lb_InstallFont
			If (StringUpper(_GetFilePath($CurentFontPath)) <> StringUpper(@WindowsDir & "\Fonts")) Or _
			(Not FileExists(@WindowsDir & "\Fonts\" & _GetFileName($CurentFontPath))) Then
				_InstallFont($CurentFontPath)
			Else
				Msgbox(16,"Message","This font is already installed!", 0, $hGUI)
			EndIf
		Case $lb_DeleteFont
			$GotoFile = _GotoFile($FileList) ;Goto next font
			If @Compiled Then
				_WinAPI_RemoveFontResourceEx($CurentFontPath, $FR_PRIVATE)
				FileDelete($CurentFontPath)
				_GUICtrlTVExplorer_Expand($hTV, $GotoFile, 0)
				_ViewFile($GotoFile)
			Else
				Msgbox(48,"Notice","Delete file: " & $CurentFontPath & @CRLF & "and open file: " & $GotoFile, 0, $hGUI) ;Debug only
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
	If (StringLeft($CmdLineRaw,1)==""") And (StringRight($CmdLineRaw,1)==""") Then
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
			ShellExecute(@AutoItExe, "\AutoIt3ExecuteScript "" & @ScriptFullPath & "" " & $CommandLine, @WorkingDir, "runas")
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
	If Not @error Then Msgbox(64,"Message","Install Successfuly!", 0, $hGUI)
    DllClose($hGdi32_DllOpen)
    DllCall("user32.dll", "Int", "SendMessage", "hwnd", $HWND_BROADCAST, "int", $WM_FONTCHANGE, "int", 0, "int", 0)
    Return 1
EndFunc
Func _OpenFileDialog()
	Local $hFile = FileOpenDialog("Sellect Font Files!", _GetFilePath($CurentFontPath), "Font Files(*.FON;*.FNT;*.TTF;*.TTC;*.FOT;*.OTF;*.MMM;*.PFB;*.PFM)|All files (*.*)", $FD_FILEMUSTEXIST, "", $hGUI)
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
	If $Clip_Temp == "" Then
		MsgBox(16, $Tile & " Error!", "No data to copy to Clipboard!", 0, $hGUI)
	Else
		ClipPut($Clip_Temp)
		MsgBox(64, $Tile & " Copied!", "Copied: "&GUICtrlRead($Ctrl_Tab_CharMap_Edit)&" to Clipboard!", 0, $hGUI)
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
		GUICtrlSetData($Ctrl_Tab_CurrentChar_Dec, "Demical Code:" & @TAB & $CharID)
		GUICtrlSetData($Ctrl_Tab_CurrentChar_Hex, "Hex Value:" & @TAB & $CharID_Hex)
		GUICtrlSetData($Ctrl_Tab_CurrentChar_UNI, "Unicode:" & @TAB & "U+" & $CharID_Hex)
		GUICtrlSetData($Ctrl_Tab_CurrentChar_UTF8, "UTF-8:" & @TAB  & @TAB & "0x" & $CharID_Hex)
		GUICtrlSetData($Ctrl_Tab_CurrentChar_Java, "JavaScript Escaped:  " & "%u" & $CharID_Hex)
		GUICtrlSetData($Ctrl_Tab_CurrentChar_HTML, "HTML Entity:" & @TAB & "&&#" & $CharID)
	EndIf
EndFunc
Func _Tab_CharMap_SetCharInfo2()	; Là hàm phụ của _Tab_CharMap_SetCharInfo()
	_Tab_CharMap_SetCharInfo(0)
EndFunc
Func _Hex($iDec)
	Local $iHex = Hex($iDec), $iHex2 = "", $I
	For $I=1 To StringLen($iHex)
		If StringMid($iHex, $I, 1) <> "0" Then $iHex2 &= StringMid($iHex, $I, 1)
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
	$iBot = ControlGetPos($hGUI, "", $lb_StatusBar)[1] - 5
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
	If $CurentFontPath <> "" Then
		Local $sPath = _GetFilePath($CurentFontPath)
		ClipPut($sPath)
		If StringUpper($sPath) == StringUpper(@WindowsDir & "\Fonts") Then
			ShellExecute($sPath)
		Else
			Run("explorer.exe /n,/e,/select, " & $CurentFontPath)
		EndIf
	EndIf
EndFunc
Func _CopyFontInfo()
	ClipPut(GUICtrlRead($inp_Tab_MoreInfo))
	Msgbox(64,$Tile & "Font info!","Copied to Clipboard!", 0, $hGUI)
EndFunc
Func _SearchGoogleFont()
	Local $sFontName = _WinAPI_GetFontResourceInfo($CurentFontPath, Default, 1)
	If $sFontName == "" Then $sFontName = _WinAPI_GetFontResourceInfo($CurentFontPath, Default, 4) & " " & _GetFileName($CurentFontPath)
	Local $sFontSubName = _WinAPI_GetFontResourceInfo($CurentFontPath, Default, 2)
	Local $sKeyWord = "Font " & $sFontName & " " & $sFontSubName
	ShellExecute("https://www.google.com.vn/?gws_rd=ssl#q=" & $sKeyWord)
EndFunc

