#Region Header

#cs

    Title:          TreeView Explorer Control UDF Library for AutoIt3
    Filename:       TVExplorer.au3
    Description:    Creates and manages the TreeView Explorer GUI controls
    Author:         Yashied
    Version:        1.3
    Requirements:   AutoIt v3.3.x.x, Developed/Tested on Windows XP Pro Service Pack 2 and Windows 7
    Uses:           APIConstants.au3, GUIImageList.au3, GUITreeView.au3, WinAPIEx.au3 (v3.3+)
    Notes:          The library registers (permanently) the following window message:

                    WM_DEVICECHANGE
                    WM_NOTIFY

    Available functions:

    _GUICtrlTVExplorer_AttachFolder
    _GUICtrlTVExplorer_Create
    _GUICtrlTVExplorer_Destroy
    _GUICtrlTVExplorer_DestroyAll
    _GUICtrlTVExplorer_Expand
    _GUICtrlTVExplorer_GetMsg
    _GUICtrlTVExplorer_GetPathFromItem
    _GUICtrlTVExplorer_GetRootPath
    _GUICtrlTVExplorer_GetSelected
    _GUICtrlTVExplorer_SetExplorerStyle
    _GUICtrlTVExplorer_UpdateIcon

    Example:

    #Include <APIConstants.au3>
    #Include <GUIConstantsEx.au3>
    #Include <GUITreeView.au3>
    #Include <TVExplorer.au3>
    #Include <TreeViewConstants.au3>
    #Include <WindowsConstants.au3>
    #Include <WinAPIEx.au3>

    Opt('MustDeclareVars', 1)

    Global $hForm, $hTV[3], $Input[3], $hFocus = 0, $Dummy, $Path, $Style

    If Not _WinAPI_DwmIsCompositionEnabled() Then
        $Style = $WS_EX_COMPOSITED
    Else
        $Style = -1
    EndIf
    $hForm = GUICreate('TVExplorer UDF Example', 700, 736, -1, -1, BitOR($GUI_SS_DEFAULT_GUI, $WS_MAXIMIZEBOX, $WS_SIZEBOX), $Style)
    GUISetIcon(@WindowsDir & '\explorer.exe')
    $Input[0] = GUICtrlCreateInput('', 20, 20, 320, 19)
    GUICtrlSetState(-1, $GUI_DISABLE)
    $hTV[0] = _GUICtrlTVExplorer_Create(@ProgramFilesDir, 20, 48, 320, 310, -1, $WS_EX_CLIENTEDGE, -1, '_TVEvent')
    $Input[1] = GUICtrlCreateInput('', 360, 20, 320, 19)
    GUICtrlSetState(-1, $GUI_DISABLE)
    $hTV[1] = _GUICtrlTVExplorer_Create(@UserProfileDir, 360, 48, 320, 310, -1, $WS_EX_CLIENTEDGE, -1, '_TVEvent')
    $Input[2] = GUICtrlCreateInput('', 20, 378, 660, 19)
    GUICtrlSetState(-1, $GUI_DISABLE)
    $hTV[2] = _GUICtrlTVExplorer_Create('', 20, 406, 660, 310, -1, $WS_EX_CLIENTEDGE, -1, '_TVEvent')
    For $i = 0 To 2
        _TVSetPath($Input[$i], _GUICtrlTVExplorer_GetSelected($hTV[$i]))
        _GUICtrlTVExplorer_SetExplorerStyle($hTV[$i])
    Next
    $Dummy = GUICtrlCreateDummy()
    GUIRegisterMsg($WM_GETMINMAXINFO, 'WM_GETMINMAXINFO')
    GUIRegisterMsg($WM_SIZE, 'WM_SIZE')
    HotKeySet('{F5}', '_TVRefresh')
    GUISetState()

    _GUICtrlTVExplorer_Expand($hTV[0], @ProgramFilesDir & '\AutoIt3')
    _GUICtrlTVExplorer_Expand($hTV[1])

    While 1
        Switch _GUICtrlTVExplorer_GetMsg()
            Case $GUI_EVENT_CLOSE
                GUIDelete()
                _GUICtrlTVExplorer_DestroyAll()
                Exit
            Case $Dummy
                $Path = _GUICtrlTVExplorer_GetSelected($hFocus)
                _GUICtrlTVExplorer_AttachFolder($hFocus)
                _GUICtrlTVExplorer_Expand($hFocus, $Path, 0)
                $hFocus = 0
        EndSwitch
    WEnd

    Func _TVEvent($hWnd, $iMsg, $sPath, $hItem)
        Switch $iMsg
            Case $TV_NOTIFY_BEGINUPDATE
                GUISetCursor(1, 1)
            Case $TV_NOTIFY_ENDUPDATE
                GUISetCursor(2)
            Case $TV_NOTIFY_SELCHANGED
                For $i = 0 To 2
                    If $hTV[$i] = $hWnd Then
                        _TVSetPath($Input[$i], $sPath)
                        ExitLoop
                    EndIf
                Next
            Case $TV_NOTIFY_DBLCLK
                ; Nothing
            Case $TV_NOTIFY_RCLICK
                ; Nothing
            Case $TV_NOTIFY_DELETINGITEM
                ; Nothing
            Case $TV_NOTIFY_DISKMOUNTED
                ; Nothing
            Case $TV_NOTIFY_DISKUNMOUNTED
                ; Nothing
        EndSwitch
    EndFunc   ;==>_TVEvent

    Func _TVSetPath($iInput, $sPath)

        Local $Text = _WinAPI_PathCompactPath(GUICtrlGetHandle($iInput), $sPath, -2)

        If GUICtrlRead($iInput) <> $Text Then
            GUICtrlSetData($iInput, $Text)
        EndIf
    EndFunc   ;==>_TVSetPath

    Func _TVRefresh()

        Local $hWnd = _WinAPI_GetFocus()

        For $i = 0 To 2
            If $hTV[$i] = $hWnd Then
                If Not $hFocus Then
                    $hFocus = $hWnd
                    GUICtrlSendToDummy($Dummy)
                EndIf
                Return
            EndIf
        Next
        HotKeySet('{F5}')
        Send('{F5}')
        HotKeySet('{F5}', '_TVRefresh')
    EndFunc   ;==>_TVRefresh

    Func WM_GETMINMAXINFO($hWnd, $iMsg, $wParam, $lParam)

        Local $tMMI = DllStructCreate('long Reserved[2];long MaxSize[2];long MaxPosition[2];long MinTrackSize[2];long MaxTrackSize[2]', $lParam)

        Switch $hWnd
            Case $hForm
                DllStructSetData($tMMI, 'MinTrackSize', 428, 1)
                DllStructSetData($tMMI, 'MinTrackSize', 450, 2)
        EndSwitch
        Return $GUI_RUNDEFMSG
    EndFunc   ;==>WM_GETMINMAXINFO

    Func WM_SIZE($hWnd, $iMsg, $wParam, $lParam)

        Local $WC, $HC, $WT, $HT

        Switch $hWnd
            Case $hForm
                $WC = _WinAPI_LoWord($lParam)
                $HC = _WinAPI_HiWord($lParam)
                $WT = Floor(($WC - 60) / 2)
                $HT = Floor(($HC - 116) / 2)
                GUICtrlSetPos(_WinAPI_GetDlgCtrlID($hTV[0]), 20, 48, $WT, $HT)
                GUICtrlSetPos(_WinAPI_GetDlgCtrlID($hTV[1]), $WT + 40, 48, $WC - $WT - 60, $HT)
                GUICtrlSetPos(_WinAPI_GetDlgCtrlID($hTV[2]), 20, $HT + 96, $WC - 40, $HC - $HT - 116)
                GUICtrlSetPos($Input[0], 20, 20, $WT)
                GUICtrlSetPos($Input[1], $WT + 40, 20, $WC - $WT - 60)
                GUICtrlSetPos($Input[2], 20, $HT + 68, $WC - 40)
                For $i = 0 To 2
                    _TVSetPath($Input[$i], _GUICtrlTVExplorer_GetSelected($hTV[$i]))
                Next
                Return 0
        EndSwitch
        Return $GUI_RUNDEFMSG
    EndFunc   ;==>WM_SIZE

#ce

#Include-once

#Include <APIConstants.au3>
#Include <GUIImageList.au3>
#Include <GUITreeView.au3>
#Include <WinAPIEx.au3>

#EndRegion Header

#Region Global Variables and Constants

Global Const $TV_FLAG_SHOWHIDDEN = 0x0001
Global Const $TV_FLAG_SHOWSYSTEM = 0x0002
Global Const $TV_FLAG_SHOWFILESEXTENSION = 0x0004
Global Const $TV_FLAG_SHOWFILES = 0x0008
Global Const $TV_FLAG_SHOWFOLDERICON = 0x0010
Global Const $TV_FLAG_SHOWFILEICON = 0x0020
Global Const $TV_FLAG_SHOWLIKEEXPLORER = 0x1000
Global Const $TV_FLAG_DEFAULT = BitOR($TV_FLAG_SHOWLIKEEXPLORER, $TV_FLAG_SHOWSYSTEM, $TV_FLAG_SHOWFOLDERICON, $TV_FLAG_SHOWFILEICON, $TV_FLAG_SHOWFILES)
Global Const $TV_FLAG_DIRTREE = BitOR($TV_FLAG_SHOWLIKEEXPLORER, $TV_FLAG_SHOWSYSTEM, $TV_FLAG_SHOWFOLDERICON)

Global Const $TV_NOTIFY_BEGINUPDATE = 1
Global Const $TV_NOTIFY_ENDUPDATE = 2
Global Const $TV_NOTIFY_SELCHANGED = 3
Global Const $TV_NOTIFY_DELETINGITEM = 4
Global Const $TV_NOTIFY_DBLCLK = 5
Global Const $TV_NOTIFY_RCLICK = 6
Global Const $TV_NOTIFY_DISKMOUNTED = 7
Global Const $TV_NOTIFY_DISKUNMOUNTED = 8

#EndRegion Global Variables and Constants

#Region Local Variables and Constants

Global $tvData[1][31] = [[0, _GUIImageList_Create(_WinAPI_GetSystemMetrics(49), _WinAPI_GetSystemMetrics(50), 5, 1), GUICreate('')]]

#cs

WARNING: DO NOT CHANGE THIS ARRAY, FOR INTERNAL USE ONLY!

$tvData[0][0 ]   - Number of items in array
       [0][1 ]   - Handle to the shared image list
       [0][2 ]   - Handle to the window
       [0][3-30] - Reserved

$tvData[i][0 ]   - Handle to the TreeView control
       [i][1 ]   - Handle to the selected item
       [i][2 ]   - Dummy1 (Mount)
       [i][3 ]   - Dummy2 (Enumerate and expand)
       [i][4 ]   - Dummy3 (Verify item)
       [i][5 ]   - Dummy4 (Change selection)
       [i][6 ]   - Dummy5 (Double-click primary mouse button)
       [i][7 ]   - Dummy6 (Context menu)
       [i][8 ]   - Dummy7 (Unmount)
       [i][9 ]   - Path to the root directory
       [i][10]   - User's callback function
       [i][11]   - Show hidden items control flag
       [i][12]   - Show system items control flag
       [i][13]   - Show files extension control flag
       [i][14]   - Show files control flag
       [i][15]   - Show folder icons control flag
       [i][16]   - Show file icons control flag
       [i][17]   - Template to enumerating files
       [i][18]   - Shortcut

                   [0][0] - Number of items in array
                   [0][1] - Reserved

                   [n][0] - Handle to the item
                   [n][1] - Path

       [i][19]   - Param1 (Queue: C0x{16}D0x{16}E0x{16}, etc)
       [i][20]   - Param2 (Queue: CDE, etc)
       [i][21]   - Param3 (Item handle)
       [i][22]   - Param4 (Item handle)
       [i][23]   - Param5 (Item handle)
       [i][24]   - Param6 (Item handle)
       [i][25]   - Param7 (Item handle)
       [i][26]   - Source user's control flags (original)
       [i][27]   - Attaching root folder(s) state flag
       [i][28]   - Updating state flag
       [i][29]   - ID of the TreeView control
       [i][30]   - Reserved

#ce

Global $tvIcon[101][3] = [[0]]

#cs

$tvIcon[0][0]   - Number of items in array
       [0][1-2] - Reserved

$tvIcon[i][0]   - Index in the Explorer's system image list
       [i][1]   - Index in the image list (normal)
       [i][2]   - Index in the image list (hidden)

#ce

#cs

TreeView Explorer's Image List

0  - No associated
1  - No associated (50%)
2  - Folder
3  - Folder (50%)
4  - Open folder
5  - Open folder (50%)
6  - Inaccessible folder
7  - Inaccessible folder (50%)
8  - Fixed drive
9  - Removable drive
10 - RAM disk drive
11 - CD drive
12 - Network drive
*  - Cached icons

#ce

#EndRegion Local Variables and Constants

#Region Initialization

; IMPORTANT: If you register the following window messages in your code, you should call handlers from this library until
; you return from your handlers, otherwise, the library will not work properly! For example:
;
; Func MY_WM_NOTIFY($hWnd, $iMsg, $wParam, $lParam)
;     Local $Result = TV_WM_NOTIFY($hWnd, $iMsg, $wParam, $lParam)
;     If $Result <> $GUI_RUNDEFMSG Then
;         Return $Result
;     EndIf
;     ...
; EndFunc

GUIRegisterMsg(0x0219, 'TV_WM_DEVICECHANGE')
GUIRegisterMsg(0x004E, 'TV_WM_NOTIFY')

#EndRegion Initialization

#Region Public Functions

; #FUNCTION# ====================================================================================================================
; Name...........: _GUICtrlTVExplorer_AttachFolder
; Description....: Attaches a new folder with a specified path to the TreeView Explorer.
; Syntax.........: _GUICtrlTVExplorer_AttachFolder ( $hTV [, $sPath] )
; Parameters.....: $hTV    - Handle to the TreeView Explorer control that was previously created by using the _GUICtrlTVExplorer_Create().
;                  $sPath  - The new path to attach.
; Return values..: Success - 1.
;                  Failure - 0.
; Author.........: Yashied
; Modified.......:
; Remarks........: IMPORTANT: Do not call _GUICtrlTVExplorer_AttachFolder() within the any user's functions that was specified in
;                  $sFunc parameter when creating TreeView Explorer control.
;
;                  Note, only one folder can be attached to the TreeView Explorer at the same time except a drive list.
; Related........:
; Link...........:
; Example........: Yes
; ===============================================================================================================================

Func _GUICtrlTVExplorer_AttachFolder($hTV, $sPath = '')

	Local $Index = _TV_Index($hTV)

	If Not $Index Then
		Return 0
	EndIf
	If Not $sPath Then
		$sPath = $tvData[$Index][9]
	EndIf
	Return _TV_Attach($Index, $sPath)
EndFunc   ;==>_GUICtrlTVExplorer_AttachFolder

; #FUNCTION# ====================================================================================================================
; Name...........: _GUICtrlTVExplorer_Create
; Description....: Creates a TreeView Explorer control.
; Syntax.........: _GUICtrlTVExplorer_Create ( $sRoot, $iX, $iY [, $iWidth [, $iHeight [, $iStyle [, $iExStyle [, $iFlags [, $sFunc [, $sTemplate]]]]]]] )
; Parameters.....: $sRoot     - The root folder from which to start browsing. Only the specified folder and its subfolders in the
;                               namespace hierarchy appear in the TreeView Explorer. If this parameter is specified as an empty string,
;                               TreeView Explorer will dinamical display all available drives that are mounted on your computer.
;                  $iX        - The left side of the control.
;                  $iY        - The top of the control.
;                  $iWidth    - The width of the control (default is the previously used width).
;                  $iHeight   - The height of the control (default is the previously used height).
;                  $iStyle    - The style of the control.
;                  $iExStyle  - The extended style of the control.
;                  $iFlags    - The flags that specify the options for the TreeView Explorer. This parameter can be 0 or
;                               a combination of the following values.
;
;                               $TV_FLAG_SHOWHIDDEN
;                               $TV_FLAG_SHOWSYSTEM
;                               $TV_FLAG_SHOWFILESEXTENSION
;                               $TV_FLAG_SHOWFILES
;                               $TV_FLAG_SHOWFOLDERICON
;                               $TV_FLAG_SHOWFILEICON
;                               $TV_FLAG_SHOWLIKEEXPLORER
;                               $TV_FLAG_DEFAULT
;                               $TV_FLAG_DIRTREE
;
;                  $sFunc     - The name of the user function to call when the message appears. Note, to make the user function
;                               workable you have to define it with maximum 4 function parameters otherwise the function won't
;                               be called.
;
;                               Func MyFunc($hWnd, $iMsg, $sPath, $hItem)
;                               ...
;                               EndFunc
;
;                               When the user function is called then these 4 parameters have the following values:
;
;                               $hWnd  - Handle to the TreeView Explorer control in which the message appears.
;                               $iMsg  - The message ID. It can be one of the following values.
;
;                                        $TV_NOTIFY_BEGINUPDATE
;                                        $TV_NOTIFY_ENDUPDATE
;                                        $TV_NOTIFY_SELCHANGED
;                                        $TV_NOTIFY_DELETINGITEM
;                                        $TV_NOTIFY_DBLCLK
;                                        $TV_NOTIFY_RCLICK
;                                        $TV_NOTIFY_DISKMOUNTED
;                                        $TV_NOTIFY_DISKUNMOUNTED
;
;                               $sPath - The full path for the item that is associated with this message.
;                               $hItem - Handle to the item.
;
;                               NOTE: Any user-defined functions will be called only if the TreeView Explorer's parent window is visible.
;
;                  $sTemplate - A template that using to enumerating and displaying files. For example, "*.jpe;*.jpeg;*.jpg".
; Return values..: Success    - Handle to the created TreeView Explorer control.
;                  Failure    - 0.
; Author.........: Yashied
; Modified.......:
; Remarks........: IMPORTANT: Use _GUICtrlTVExplorer_Destroy() function to delete TreeView Explorer control and release all
;                  resources used them. In addition, you must call this function even if GUIDelete() was called before. Also you
;                  can call _GUICtrlTVExplorer_DestroyAll() to delete all previously created TreeView Explorer controls.
; Related........:
; Link...........:
; Example........: Yes
; ===============================================================================================================================

Func _GUICtrlTVExplorer_Create($sRoot, $iX, $iY, $iWidth = -1, $iHeight = -1, $iStyle = -1, $iExStyle = 0, $iFlags = -1, $sFunc = '', $sTemplate = '')

	Local $hTV, $ID, $Index = $tvData[0][0] + 1

	ReDim $tvData[$Index + 1][31]
	For $i = 2 To 8
		$tvData[$Index][$i] = GUICtrlCreateDummy()
;~		If $tvData[$Index][$i] Then
			GUICtrlSetOnEvent(-1, '_TV_Event')
;~		EndIf
	Next
	If $iStyle = -1 Then
		$iStyle = BitOR($TVS_HASBUTTONS, $TVS_HASLINES, $TVS_LINESATROOT, $TVS_DISABLEDRAGDROP, $TVS_SHOWSELALWAYS)
	Else
		$iStyle = BitAND($iStyle, BitNOT(BitOR($TVS_EDITLABELS, $TVS_SINGLEEXPAND)))
	EndIf
	$ID = GUICtrlCreateTreeView($iX, $iY, $iWidth, $iHeight, $iStyle, $iExStyle)
	If Not $ID Then
		For $i = 2 To 8
			If $tvData[$Index][$i] Then
				GUICtrlDelete($tvData[$Index][$i])
			EndIf
		Next
		Return 0
	EndIf
	If $iFlags = -1 Then
		$iFlags = $TV_FLAG_DEFAULT
	EndIf
	$hTV = GUICtrlGetHandle($ID)
	$tvData[$Index][0 ] = $hTV
	$tvData[$Index][10] = ''
	$tvData[$Index][17] = $sTemplate
	$tvData[$Index][26] = $iFlags
	$tvData[$Index][27] = 0
	$tvData[$Index][28] = 0
	$tvData[$Index][29] = $ID
	$tvData[$Index][30] = 0
	If $Index = 1 Then
		_TV_Initialize()
	EndIf
	_GUICtrlTreeView_SetUnicodeFormat($hTV)
	_GUICtrlTreeView_SetNormalImageList($hTV, $tvData[0][1])
	If Not _TV_Attach($Index, $sRoot) Then
		; Nothing
	EndIf
	$tvData[$Index][10] = $sFunc
	$tvData[0][0] += 1
	Return $hTV
EndFunc   ;==>_GUICtrlTVExplorer_Create

; #FUNCTION# ====================================================================================================================
; Name...........: _GUICtrlTVExplorer_Destroy
; Description....: Deletes a TreeView Explorer control.
; Syntax.........: _GUICtrlTVExplorer_Destroy ( $hTV )
; Parameters.....: $hTV    - Handle to the TreeView Explorer control that was previously created by using the _GUICtrlTVExplorer_Create().
; Return values..: Success - 1.
;                  Failure - 0.
; Author.........: Yashied
; Modified.......:
; Remarks........: None
; Related........:
; Link...........:
; Example........: Yes
; ===============================================================================================================================

Func _GUICtrlTVExplorer_Destroy($hTV)

	Local $Index = _TV_Index($hTV)

	If (Not $Index) Or ($tvData[$Index][27]) Or ($tvData[$Index][28]) Then
		Return 0
	EndIf
	$tvData[$Index][0] = 0
	For $i = 2 To 8
		GUICtrlDelete($tvData[$Index][$i])
	Next
	GUICtrlDelete($tvData[$Index][29])
	For $i = $Index To $tvData[0][0] - 1
		For $j = 0 To 30
			$tvData[$i][$j] =  $tvData[$i + 1][$j]
		Next
	Next
	ReDim $tvData[$tvData[0][0]][31]
	$tvData[0][0] -= 1
	If Not $tvData[0][0] Then
		_TV_Purge()
	EndIf
	Return 1
EndFunc   ;==>_GUICtrlTVExplorer_Destroy

; #FUNCTION# ====================================================================================================================
; Name...........: _GUICtrlTVExplorer_DestroyAll
; Description....: Deletes all created TreeView Explorer controls.
; Syntax.........: _GUICtrlTVExplorer_DestroyAll ( )
; Parameters.....: None
; Return values..: Success - 1.
;                  Failure - 0.
; Author.........: Yashied
; Modified.......:
; Remarks........: None
; Related........:
; Link...........:
; Example........: Yes
; ===============================================================================================================================

Func _GUICtrlTVExplorer_DestroyAll()

	Local $hTV = $tvData, $Result = 1

	For $i = 1 To $hTV[0][0]
		If Not _GUICtrlTVExplorer_Destroy($hTV[$i][0]) Then
			$Result = 0
		EndIf
	Next
	Return $Result
EndFunc   ;==>_GUICtrlTVExplorer_DestroyAll

; #FUNCTION# ====================================================================================================================
; Name...........: _GUICtrlTVExplorer_Expand
; Description....: Expands a specified folder in the TreeView Explorer.
; Syntax.........: _GUICtrlTVExplorer_Expand ( $hTV [, $sPath [, $fComplete]] )
; Parameters.....: $hTV       - Handle to the TreeView Explorer control that was previously created by using the _GUICtrlTVExplorer_Create().
;                  $sPath     - The fully-qualified path to the folder or file to expand.
;                  $fComplete - Specifies whether to extend the last folder in the specified path, valid values:
;                  |TRUE      - All folders that are included in the path will be expanded. (Default)
;                  |FALSE     - The last folder will not be the expanded.
; Return values..: Success    - 1.
;                  Failure    - 0.
; Author.........: Yashied
; Modified.......:
; Remarks........: Note, since all the folders that are included in the specified path are scanned during the expanding, it may take
;                  a long time to expand the folders containing many files and subfolders.
;
;                  If the $sPath parameter is the path to a file, $fComplete parameter will be ignored and all parent folder that
;                  are included in this path will be expanded.
; Related........:
; Link...........:
; Example........: Yes
; ===============================================================================================================================

Func _GUICtrlTVExplorer_Expand($hTV, $sPath = '', $fComplete = 1)

	Local $hItem, $hPrev, $Attrib, $Dir, $Sep = ''
	Local $Index = _TV_Index($hTV)
	Local $Image[101][2] = [[0]]

	If Not $Index Then
		Return 0
	EndIf
	If Not $sPath Then
		$sPath = $tvData[$Index][9]
	Else
		If Not _WinAPI_PathIsDirectory($sPath) Then
			$fComplete = 0
		Else
			$Sep = '\'
		EndIf
	EndIf
	$sPath = FileGetLongName(_WinAPI_PathRemoveBackslash(_WinAPI_PathSearchAndQualify($sPath & $Sep, 1)))
	If Not $sPath Then
		Return 0
	EndIf
	If Not _TV_IsValid($Index, $sPath) Then
		Return 0
	EndIf
	If Not $tvData[$Index][9] Then
		$Dir = $sPath
	Else
		$Dir = StringReplace($sPath, $tvData[$Index][9], '', 1)
		If Not @extended Then
			Return 0
		EndIf
	EndIf
	$Dir = StringRegExpReplace($Dir, '(\A\\+)|(\\+\Z)', '')
	$Dir = StringRegExpReplace(StringRegExpReplace($tvData[$Index][9], '(?:.+\\)?([^\\]+?)\\*', '\1') & '\' & $Dir, '(\A\\+)|(\\+\Z)', '')
	$Dir = StringSplit($Dir, '\')
	$tvData[$Index][28] += 1
	If ($tvData[$Index][10]) And (_WinAPI_IsWindowVisible(_WinAPI_GetParent($hTV))) Then
		Call($tvData[$Index][10], $hTV, $TV_NOTIFY_BEGINUPDATE, $sPath, 0)
	EndIf
	$hItem = _GUICtrlTreeView_GetFirstItem($hTV)
	For $i = 1 To $Dir[0]
		While $hItem
			If StringRegExpReplace(_TV_GetPath($Index, $hItem), '(?:.+\\)?([^\\]+?)\\*', '\1') = $Dir[$i] Then
				ExitLoop
			EndIf
			$hItem = _GUICtrlTreeView_GetNextSibling($hTV, $hItem)
		WEnd
		$hPrev = $hItem
		If Not $hPrev Then
			ExitLoop
		EndIf
		$Image[0][0] += 1
		If $Image[0][0] > UBound($Image) - 1 Then
			ReDim $Image[$Image[0][0] + 100][2]
		EndIf
		$Image[$Image[0][0]][0] = $hItem
		$Image[$Image[0][0]][1] = _TV_AddIcon($Index, _TV_GetPath($Index, $hItem), 1)
		If (Not _GUICtrlTreeView_ExpandedOnce($hTV, $hItem)) And (($fComplete) Or ($i < $Dir[0])) Then
			If Not _TV_Update($Index, $hItem, 0) Then
				_TV_Send(4, $Index, $hItem, 1, 1)
				$hPrev = 0
				ExitLoop
			EndIf
		EndIf
		$hItem = _GUICtrlTreeView_GetFirstChild($hTV, $hItem)
	Next
	If ($tvData[$Index][10]) And (_WinAPI_IsWindowVisible(_WinAPI_GetParent($hTV))) Then
		Call($tvData[$Index][10], $hTV, $TV_NOTIFY_ENDUPDATE, $sPath, $hPrev)
	EndIf
	$tvData[$Index][28] -= 1
	If Not $hPrev Then
		Return 0
	EndIf
;~	_GUICtrlTreeView_BeginUpdate($hTV)
	If Not $fComplete Then
		$Image[0][0] -= 1
	EndIf
	For $i = 1 To $Image[0][0]
		_TV_SetImage($hTV, $Image[$i][0], $Image[$i][1])
	Next
	_TV_SetSelected($Index, $hPrev, 1, 1)
	If $fComplete Then
		_GUICtrlTreeView_Expand($hTV, $hPrev, 1)
	EndIf
;~	_GUICtrlTreeView_EndUpdate($hTV)
	Return 1
EndFunc   ;==>_GUICtrlTVExplorer_Expand

; #FUNCTION# ====================================================================================================================
; Name...........: _GUICtrlTVExplorer_GetMsg
; Description....: Polls the GUI to see if any events have occurred.
; Syntax.........: _GUICtrlTVExplorer_GetMsg ( [$fAdvanced] )
; Parameters.....: $fAdvanced - Specifies whether to return extended information in an array, valid values:
;                  |TRUE      - Returns an array containing the event and extended information (see GUIGetMsg() function).
;                  |FALSE     - Returns a single event. (Default)
; Return values..: Success    - An event, or an array depending on the $fAdvanced parameter.
;                  Failure    - 0 and sets the @error flag to 1.
; Author.........: Yashied
; Modified.......:
; Remarks........: IMPORTANT: If the "GUIOnEventMode" option is set to 0, you should use _GUICtrlTVExplorer_GetMsg() instead of native
;                  GUIGetMsg() function, otherwise, the TreeView Explorer controls will not work! In using, these two functions are
;                  completely equivalent.
; Related........:
; Link...........:
; Example........: Yes
; ===============================================================================================================================

Func _GUICtrlTVExplorer_GetMsg($fAdvanced = 0)

	Local $Msg = GUIGetMsg($fAdvanced)

	If @error Then
		Return SetError(1, 0, 0)
	EndIf

	Local $ID

	If IsArray($Msg) Then
		$ID = $Msg[0]
	Else
		$ID = $Msg
	EndIf
	For $i = 1 To $tvData[0][0]
		For $j = 2 To 8
			If $ID = $tvData[$i][$j] Then
				_TV_Dummy(GUICtrlRead($ID))
				If IsArray($Msg) Then
					For $i = 0 To UBound($Msg) - 1
						$Msg[$i] = 0
					Next
				Else
					$Msg = 0
				EndIf
				ExitLoop
			EndIf
		Next
	Next
	Return $Msg
EndFunc   ;==>_GUICtrlTVExplorer_GetMsg

; #FUNCTION# ====================================================================================================================
; Name...........: _GUICtrlTVExplorer_GetPathFromItem
; Description....: Retrieves the full path for the specified item from the TreeView Explorer.
; Syntax.........: _GUICtrlTVExplorer_GetPathFromItem ( $hTV, $hItem )
; Parameters.....: $hTV    - Handle to the TreeView Explorer control that was previously created by using the _GUICtrlTVExplorer_Create().
;                  $hItem  - Handle to the item for which you want to retrieve the path.
; Return values..: Success - The fully qualified path.
;                  Failure - An empty string.
; Author.........: Yashied
; Modified.......:
; Remarks........: IMPORTANT: Do not use _GUICtrlTreeView_GetTree() function, because some items in TreeView Explorer may contain
;                  incomplete file names! For example, "MyProg.lnk" is shown as "MyProg", etc.
; Related........:
; Link...........:
; Example........: Yes
; ===============================================================================================================================

Func _GUICtrlTVExplorer_GetPathFromItem($hTV, $hItem)

	Local $Index = _TV_Index($hTV)

	If Not $Index Then
		Return ''
	EndIf
	Return _TV_GetPath($Index, $hItem)
EndFunc   ;==>_GUICtrlTVExplorer_GetPathFromItem

; #FUNCTION# ====================================================================================================================
; Name...........: _GUICtrlTVExplorer_GetRootPath
; Description....: Retrieves the root path which associated with TreeView Explorer.
; Syntax.........: _GUICtrlTVExplorer_GetRootPath ( $hTV )
; Parameters.....: $hTV    - Handle to the TreeView Explorer control that was previously created by using the _GUICtrlTVExplorer_Create().
; Return values..: Success - The fully qualified path.
;                  Failure - An empty string and sets the @error flag to non-zero.
; Author.........: Yashied
; Modified.......:
; Remarks........: The path returned by this function corresponds to a path that was specified when TreeView Explorer is created.
; Related........:
; Link...........:
; Example........: Yes
; ===============================================================================================================================

Func _GUICtrlTVExplorer_GetRootPath($hTV)

	Local $Index = _TV_Index($hTV)

	If Not $Index Then
		Return SetError(1, 0, '')
	EndIf
	Return $tvData[$Index][9]
EndFunc   ;==>_GUICtrlTVExplorer_GetRootPath

; #FUNCTION# ====================================================================================================================
; Name...........: _GUICtrlTVExplorer_GetSelected
; Description....: Retrieves the full path for the selected item from the TreeView Explorer.
; Syntax.........: _GUICtrlTVExplorer_GetSelected ( $hTV )
; Parameters.....: $hTV    - Handle to the TreeView Explorer control that was previously created by using the _GUICtrlTVExplorer_Create().
; Return values..: Success - The fully qualified path.
;                  Failure - An empty string.
; Author.........: Yashied
; Modified.......:
; Remarks........: IMPORTANT: Do not use _GUICtrlTreeView_GetTree() function, because some items in TreeView Explorer may contain
;                  incomplete file names! For example, "MyProg.lnk" is shown as "MyProg", etc.
; Related........:
; Link...........:
; Example........: Yes
; ===============================================================================================================================

Func _GUICtrlTVExplorer_GetSelected($hTV)

	Local $Index = _TV_Index($hTV)

	If Not $Index Then
		Return ''
	EndIf
	Return _TV_GetPath($Index,  $tvData[$Index][1])
EndFunc   ;==>_GUICtrlTVExplorer_GetSelected

; #FUNCTION# ====================================================================================================================
; Name...........: _GUICtrlTVExplorer_SetExplorerStyle
; Description....: Sets a visual style for the TreeView Explorer like Windows Explorer on Windows Vista.
; Syntax.........: _GUICtrlTVExplorer_SetExplorerStyle ( $hTV [, $fStyle] )
; Parameters.....: $hTV    - Handle to the TreeView Explorer control that was previously created by using the _GUICtrlTVExplorer_Create().
;                  $fStyle - Specifies whether to use a new Windows Explorer style, valid values:
;                  |TRUE   - The control will use new style. (Default)
;                  |FALSE  - The control will use old style.
; Return values..: Success - 1.
;                  Failure - 0.
; Author.........: Yashied
; Modified.......:
; Remarks........: This function requires Windows Vista or later.
; Related........:
; Link...........:
; Example........: Yes
; ===============================================================================================================================

Func _GUICtrlTVExplorer_SetExplorerStyle($hTV, $fStyle = 1)

	Local $Index = _TV_Index($hTV)

	If (Not $Index) Or (_WinAPI_GetVersion() < '6.0') Then
		Return 0
	EndIf
	If $fStyle Then
		Return _WinAPI_SetWindowTheme($hTV, 'Explorer')
	Else
		Return _WinAPI_SetWindowTheme($hTV)
	EndIf
EndFunc   ;==>_GUICtrlTVExplorer_SetExplorerStyle

; #FUNCTION# ====================================================================================================================
; Name...........: _GUICtrlTVExplorer_UpdateIcon
; Description....: Updates the associated icon for the specified item from the TreeView Explorer.
; Syntax.........: _GUICtrlTVExplorer_UpdateItemIcon ( $hTV, $hItem )
; Parameters.....: $hTV    - Handle to the TreeView Explorer control that was previously created by using the _GUICtrlTVExplorer_Create().
;                  $hItem  - Handle to the item for which you want to update the associated icon.
; Return values..: Success - The fully qualified path.
;                  Failure - An empty string.
; Author.........: Yashied
; Modified.......:
; Remarks........: This function can be useful, for example, to update the icons of removable drives.
; Related........:
; Link...........:
; Example........: Yes
; ===============================================================================================================================

Func _GUICtrlTVExplorer_UpdateIcon($hTV, $hItem)

	Local $Index = _TV_Index($hTV)

	If Not $Index Then
		Return 0
	EndIf

	Local $hSearch, $Attrib, $Image = 0, $Result = 0
	Local $Mode = _WinAPI_SetErrorMode(BitOR($SEM_FAILCRITICALERRORS, $SEM_NOOPENFILEERRORBOX))
	Local $Path = _TV_GetPath($Index, $hItem)

	Do
		$Attrib = FileGetAttrib($Path)
		If @error Then
			ExitLoop
		EndIf
		If (Not _WinAPI_PathIsRoot($Path)) And (StringInStr($Attrib, 'D')) Then
			$hSearch = FileFindFirstFile($Path & '\*')
			If $hSearch <> -1 Then
				FileClose($hSearch)
			Else
				If Not @error Then
					If StringInStr($Attrib, 'H') Then
						$Image = 7
					Else
						$Image = 6
					EndIf
				EndIf
			EndIf
		EndIf
		If Not $Image Then
			$Image = _TV_AddIcon($Index, $Path, _GUICtrlTreeView_GetExpanded($hTV, $hItem), $Attrib)
		EndIf
		_TV_SetImage($hTV, $hItem, $Image)
		$Result = 1
	Until 1
	_WinAPI_SetErrorMode($Mode)
	Return $Result
EndFunc   ;==>_GUICtrlTVExplorer_UpdateIcon

#EndRegion Public Functions

#Region Internal Functions

#cs

_TV_AddDrive
_TV_AddIcon
_TV_AddShortcut
_TV_Attach
_TV_DeleteShortcut
_TV_Dummy
_TV_Event
_TV_GetDrive
_TV_GetLabel
_TV_GetPath
_TV_Index
_TV_Initialize
_TV_IsEmpty
_TV_IsValid
_TV_HWnd
_TV_Purge
_TV_Send
_TV_SetImage
_TV_SetSelected
_TV_Update

#ce

Func _TV_AddChild($hWnd, $hParent, $sText, $iImage = -1, $iSelImage = -1, $iParam = 0)

;~	Local Static $tTVIS = DllStructCreate($tagTVINSERTSTRUCT)
	Local Static $tTVIS = DllStructCreate('handle;handle;uint;handle;uint;uint;ptr;int;int;int;int;lparam')
	Local Static $pTVIS = DllStructGetPtr($tTVIS)
	Local Static $tText = DllStructCreate('wchar[4096]')
	Local Static $pText = DllStructGetPtr($tText)

	DllStructSetData($tTVIS, 1,  $hParent)
	DllStructSetData($tTVIS, 2,  $TVI_LAST)
	DllStructSetData($tTVIS, 3,  BitOR($TVIF_TEXT, $TVIF_PARAM, _TV_Iif($iImage >= 0, $TVIF_IMAGE, 0), _TV_Iif($iSelImage >= 0, $TVIF_SELECTEDIMAGE, 0)))
	DllStructSetData($tTVIS, 7,  $pText)
	DllStructSetData($tTVIS, 8,  4096)
	DllStructSetData($tTVIS, 9,  $iImage)
	DllStructSetData($tTVIS, 10, $iSelImage)
	DllStructSetData($tTVIS, 12, $iParam)
	DllStructSetData($tText, 1,  $sText)

	Local $hItem = DllCall('user32.dll', 'handle', 'SendMessageW', 'hwnd', $hWnd, 'uint', $TVM_INSERTITEMW, 'wparam', 0, 'ptr', $pTVIS)

	If @Error Then
		Return 0
	EndIf
	Return $hItem[0]
EndFunc   ;==>_TV_AddChild

Func _TV_AddDrive($iIndex, $sDrive)

	Local $hRoot, $hPrev = 0, $Path, $Image, $Empty = 1
	Local $Label = _TV_GetLabel($sDrive)
	Local $hTV = $tvData[$iIndex][0]

	If Not $Label Then
		Return 0
	EndIf
	$hRoot = _GUICtrlTreeView_GetFirstItem($hTV)
	If $hRoot Then
		While 1
			$hPrev = $hRoot
			$hRoot = _GUICtrlTreeView_GetNextSibling($hTV, $hRoot)
			If (Not $hRoot) Or (StringLeft(_TV_GetPath($iIndex, $hRoot), 2) > $sDrive) Then
				ExitLoop
			EndIf
		WEnd
	EndIf
	$Path = $Label & ' (' & $sDrive & ')'
	$sDrive &= '\'
	If _TV_IsEmpty($iIndex, $sDrive) Then
		Switch @error
			Case 0 ; OK

			Case 1 ; Access denied

			Case Else
				Return 0
		EndSwitch
	Else
		$Empty = 0
	EndIf
	$Image = _TV_AddIcon($iIndex, $sDrive)
	If $hPrev Then
		$hRoot = _GUICtrlTreeView_InsertItem($hTV, $Path, 0, $hPrev, $Image, $Image)
	Else
;~		$hRoot = _GUICtrlTreeView_AddChild($hTV, 0, $Path, $Image, $Image)
		$hRoot = _TV_AddChild($hTV, 0, $Path, $Image, $Image)
	EndIf
	If Not $Empty Then
		_GUICtrlTreeView_SetChildren($hTV, $hRoot, 1)
	EndIf
;~	If $Label Then
		_TV_AddShortcut($iIndex, $hRoot, $sDrive)
;~	EndIf
	Return $hRoot
EndFunc   ;==>_TV_AddDrive

Func _TV_AddIcon($iIndex, $sPath, $fOpen = 0, $iAttrib = 0)

	Local $HA, $ID, $hIL = 0, $hIcon = 0, $Index = 0, $Image
	Local $Flags = BitOR($SHGFI_SMALLICON, $SHGFI_SYSICONINDEX)
	Local $tSHFI = DllStructCreate($tagSHFILEINFO)

	If $fOpen Then
		$Flags = BitOR($SHGFI_OPENICON, $Flags)
	EndIf
	If Not $iAttrib Then
		$iAttrib = FileGetAttrib($sPath)
	EndIf
	If StringInStr($iAttrib, 'D') Then
		If ($tvData[$iIndex][15]) Or (_WinAPI_PathIsRoot($sPath)) Then
			$hIL = _WinAPI_ShellGetFileInfo($sPath, $Flags, 0, $tSHFI)
			If Not DllStructGetData($tSHFI, 'iIcon') Then
				$hIL = 0
			EndIf
		EndIf
		If Not $hIL Then
			If _WinAPI_PathIsRoot($sPath) Then
				Switch DriveGetType(StringLeft($sPath, 2))
					Case 'Fixed'
						Return 8
					Case 'Removable'
						Return 9
					Case 'RAMDisk'
						Return 10
					Case 'CDROM'
						Return 11
					Case 'Network'
						Return 12
					Case Else
						Return 0
				EndSwitch
			EndIf
			If StringInStr($iAttrib, 'H') Then
				If $fOpen Then
					Return 5
				Else
					Return 3
				EndIf
			Else
				If $fOpen Then
					Return 4
				Else
					Return 2
				EndIf
			EndIf
		EndIf
	Else
		If $tvData[$iIndex][16] Then
			$hIL = _WinAPI_ShellGetFileInfo($sPath, BitOR($SHGFI_ICON, $SHGFI_OVERLAYINDEX, $SHGFI_USEFILEATTRIBUTES, $Flags), 0, $tSHFI)
		EndIf
		If $hIL Then
			$hIcon = DllStructGetData($tSHFI, 'hIcon')
		Else
			If StringInStr($iAttrib, 'H') Then
				Return 1
			Else
				Return 0
			EndIf
		EndIf
	EndIf
	$Image = DllStructGetData($tSHFI, 'iIcon')
	If (Not _WinAPI_PathIsRoot($sPath)) And (StringInStr($iAttrib, 'H')) Then
		$HA = 1
		$ID = 2
	Else
		$HA = 0
		$ID = 1
	EndIf
	For $i = 1 To $tvIcon[0][0]
		If $tvIcon[$i][0] = $Image Then
			$Index = $i
			ExitLoop
		EndIf
	Next
	If $Index Then
		If $tvIcon[$Index][$ID] <> -1 Then
			If $hIcon Then
				_WinAPI_DestroyIcon($hIcon)
			EndIf
			Return $tvIcon[$Index][$ID]
		EndIf
	Else
		$tvIcon[0][0] += 1
		If $tvIcon[0][0] > UBound($tvIcon) - 1 Then
			ReDim $tvIcon[$tvIcon[0][0] + 100][3]
		EndIf
		$tvIcon[$tvIcon[0][0]][0] = $Image
		$tvIcon[$tvIcon[0][0]][1] = -1
		$tvIcon[$tvIcon[0][0]][2] = -1
		$Index = $tvIcon[0][0]
	EndIf
	If Not $hIcon Then
		$hIcon = DllCall('comctl32.dll', 'ptr', 'ImageList_GetIcon', 'ptr', $hIL, 'int', _WinAPI_LoWord($Image), 'uint', _WinAPI_HiWord($Image))
		If (Not @error) And ($hIcon[0]) Then
			$hIcon = $hIcon[0]
		Else
			Return 0
		EndIf
	EndIf
	If $HA Then
		$hIcon = _WinAPI_AddIconTransparency($hIcon, 50, 1)
		If @error Then
			Return 0
		EndIf
	EndIf
	$Image = _GUIImageList_ReplaceIcon($tvData[0][1], -1, $hIcon)
	_WinAPI_DestroyIcon($hIcon)
	If $Image = -1 Then
		Return 0
	EndIf
	$tvIcon[$Index][$ID] = $Image
	Return $Image
EndFunc   ;==>_TV_AddIcon

Func _TV_AddShortcut($iIndex, $hItem, $sPath)

	Local $Shortcut = $tvData[$iIndex][18]

	$Shortcut[0][0] += 1
	If $Shortcut[0][0] > UBound($Shortcut) - 1 Then
		ReDim $Shortcut[$Shortcut[0][0] + 100][2]
	EndIf
	$Shortcut[$Shortcut[0][0]][0] = $hItem
	$Shortcut[$Shortcut[0][0]][1] = $sPath
	$tvData[$iIndex][18] = $Shortcut
EndFunc   ;==>_TV_AddShortcut

Func _TV_Attach($iIndex, $sPath)

	If ($tvData[$iIndex][27]) Or ($tvData[$iIndex][28]) Then
		Return 0
	EndIf

	Local $Attrib, $Drive, $Empty, $Image, $Shortcut, $hRoot
	Local $Mode = _WinAPI_SetErrorMode(BitOR($SEM_FAILCRITICALERRORS, $SEM_NOOPENFILEERRORBOX))
;~	Local $Param[3] = [$SSF_SHOWALLOBJECTS, $SSF_SHOWSUPERHIDDEN, $SSF_SHOWEXTENSIONS]
	Local $Param[3] = [$SSF_SHOWALLOBJECTS, 0, $SSF_SHOWEXTENSIONS]
	Local $Shortcut[101][2] = [[0]]

	$tvData[$iIndex][1 ] = 0
	$tvData[$iIndex][27] = 1
	$tvData[$iIndex][11] = BitAND($TV_FLAG_SHOWHIDDEN, $tvData[$iIndex][26])
	$tvData[$iIndex][12] = BitAND($TV_FLAG_SHOWSYSTEM, $tvData[$iIndex][26])
	$tvData[$iIndex][13] = BitAND($TV_FLAG_SHOWFILESEXTENSION, $tvData[$iIndex][26])
	$tvData[$iIndex][14] = BitAND($TV_FLAG_SHOWFILES, $tvData[$iIndex][26])
	$tvData[$iIndex][15] = BitAND($TV_FLAG_SHOWFOLDERICON, $tvData[$iIndex][26])
	$tvData[$iIndex][16] = BitAND($TV_FLAG_SHOWFILEICON, $tvData[$iIndex][26])
	$tvData[$iIndex][18] = $Shortcut
	$tvData[$iIndex][19] = ''
	$tvData[$iIndex][25] = ''
	For $i = 20 To 24
		$tvData[$iIndex][$i] = 0
	Next
	If BitAND($TV_FLAG_SHOWLIKEEXPLORER, $tvData[$iIndex][26]) Then
		For $i = 0 To 2
			If _WinAPI_ShellGetSettings($Param[$i]) Then
				$tvData[$iIndex][11 + $i] = 1
			EndIf
		Next
	EndIf
;~	_GUICtrlTreeView_BeginUpdate($tvData[$iIndex][0])
	_GUICtrlTreeView_DeleteAll($tvData[$iIndex][0])
	If $sPath Then
		$sPath = FileGetLongName(_WinAPI_PathRemoveBackslash(_WinAPI_PathSearchAndQualify($sPath & '\', 1)))
	EndIf
	If $sPath Then
		Do
			If _WinAPI_PathIsRoot($sPath) Then
				_TV_AddDrive($iIndex, StringUpper(StringLeft($sPath, 2)))
			Else
				$Attrib = FileGetAttrib($sPath)
				If (@error) Or (Not StringInStr($Attrib, 'D')) Or ((Not $tvData[$iIndex][11]) And (StringInStr($Attrib, 'H'))) Or ((Not $tvData[$iIndex][12]) And (StringInStr($Attrib, 'S'))) Then
					ExitLoop
				EndIf
				$Image = 0
				$Empty = 1
				If _TV_IsEmpty($iIndex, $sPath) Then
					Switch @error
						Case 0 ; OK

						Case 1 ; Access denied
							If StringInStr($Attrib, 'H') Then
								$Image = 7
							Else
								$Image = 6
							EndIf
						Case Else
							ExitLoop
					EndSwitch
				Else
					$Empty = 0
				EndIf
				If Not $Image Then
					$Image = _TV_AddIcon($iIndex, $sPath, 0, $Attrib)
				EndIf
;~				$hRoot = _GUICtrlTreeView_AddChild($tvData[$iIndex][0], 0, _WinAPI_PathStripPath($sPath), $Image, $Image)
				$hRoot = _TV_AddChild($tvData[$iIndex][0], 0, _WinAPI_PathStripPath($sPath), $Image, $Image)
				If Not $Empty Then
					_GUICtrlTreeView_SetChildren($tvData[$iIndex][0], $hRoot, 1)
				EndIf
			EndIf
		Until 1
	Else
		$Drive = DriveGetDrive('ALL')
		If IsArray($Drive) Then
			For $i = 1 To $Drive[0]
				_TV_AddDrive($iIndex, StringUpper($Drive[$i]))
			Next
		EndIf
	EndIf
	$hRoot = _GUICtrlTreeView_GetFirstItem($tvData[$iIndex][0])
	_TV_SetSelected($iIndex, $hRoot, 1, 1)
;~	_GUICtrlTreeView_EndUpdate($tvData[$iIndex][0])
	$tvData[$iIndex][9 ] = $sPath
	$tvData[$iIndex][27] = 0
	_WinAPI_SetErrorMode($Mode)
	Return 1
EndFunc   ;==>_TV_Attach

Func _TV_DeleteShortcut($iIndex, $hItem)

	Local $Shortcut = $tvData[$iIndex][18]

	For $i = 1 To $Shortcut[0][0]
		If $Shortcut[$i][0] = $hItem Then
			For $j = $i To $Shortcut[0][0] - 1
				For $k = 0 To 1
					$Shortcut[$j][$k] =  $Shortcut[$j + 1][$k]
				Next
			Next
			ReDim $Shortcut[$Shortcut[0][0]][2]
			$Shortcut[0][0] -= 1
			$tvData[$iIndex][18] = $Shortcut
			Return 1
		EndIf
	Next
	Return 0
EndFunc   ;==>_TV_DeleteShortcut

Func _TV_Dummy($wParam, $lParam = 0)

	Local $Dummy = _WinAPI_LoWord($wParam), $Index = _WinAPI_HiWord($wParam)
	Local $Mode = _WinAPI_SetErrorMode(BitOR($SEM_FAILCRITICALERRORS, $SEM_NOOPENFILEERRORBOX))
	Local $hTV = $tvData[$Index][0], $hItem = $tvData[$Index][$Dummy + 17]
	Local $hPrev = 0, $Path

	Do
		If (Not $hTV) Or ($hItem = -1) Then
			ExitLoop
		EndIf
		Switch $Dummy
			Case 2 ; Mount
				$Path = $tvData[$Index][19]
				$tvData[$Index][19] = StringTrimLeft($tvData[$Index][19], 19)
				If $tvData[$Index][10] Then
					Call($tvData[$Index][10], $hTV, $TV_NOTIFY_DISKMOUNTED, StringLeft($Path, 1) & ':', Ptr(StringStripWS(StringTrimLeft($Path, 1), 2)))
				EndIf
			Case 3 ; Enumerate and expand
				$Path = _TV_GetPath($Index, $hItem)
				$tvData[$Index][28] += 1
				If $tvData[$Index][10] Then
					Call($tvData[$Index][10], $hTV, $TV_NOTIFY_BEGINUPDATE, $Path, $hItem)
				EndIf
				If Not _TV_Update($Index, $hItem) Then
					If Not _GUICtrlTreeView_GetChildCount($hTV, $hItem) Then
						$lParam = 1
					EndIf
					_TV_Send(4, $Index, $hItem, 1)
					$hItem = 0
				EndIf
				If $tvData[$Index][10] Then
					Call($tvData[$Index][10], $hTV, $TV_NOTIFY_ENDUPDATE, $Path, $hItem)
				EndIf
				$tvData[$Index][28] -= 1
			Case 4 ; Verify item
				If $lParam Then
					$hPrev = $hItem
				Else
					While Not FileExists(_TV_GetPath($Index, $hItem))
						$hPrev = $hItem
						$hItem = _GUICtrlTreeView_GetParentHandle($hTV, $hItem)
						If Not $hItem Then
							ExitLoop
						EndIf
					WEnd
				EndIf
				If $hPrev Then
					If $tvData[$Index][10] Then
						Call($tvData[$Index][10], $hTV, $TV_NOTIFY_DELETINGITEM, _TV_GetPath($Index, $hPrev), $hPrev)
					EndIf
;~					_GUICtrlTreeView_BeginUpdate($hTV)
					_GUICtrlTreeView_Delete($hTV, $hPrev)
					$hItem = _GUICtrlTreeView_GetSelection($hTV)
					If (_GUICtrlTreeView_GetExpanded($hTV, $hItem)) And (_GUICtrlTreeView_GetChildCount($hTV, $hItem) < 1) Then
						_GUICtrlTreeView_SetChildren($hTV, $hItem, 0)
					EndIf
;~					_GUICtrlTreeView_EndUpdate($hTV)
				EndIf
				If $hItem <> $tvData[$Index][1] Then
					_TV_SetSelected($Index, $hItem, 1)
				EndIf
			Case 5 ; Change selection
				If $tvData[$Index][10] Then
					Call($tvData[$Index][10], $hTV, $TV_NOTIFY_SELCHANGED, _TV_GetPath($Index, $hItem), $hItem)
				EndIf
			Case 6 ; Double-click primary mouse button
				If $tvData[$Index][10] Then
					Call($tvData[$Index][10], $hTV, $TV_NOTIFY_DBLCLK, _TV_GetPath($Index, $hItem), $hItem)
				EndIf
			Case 7 ; Context menu
				If $tvData[$Index][10] Then
					Call($tvData[$Index][10], $hTV, $TV_NOTIFY_RCLICK, _TV_GetPath($Index, $hItem), $hItem)
				EndIf
			Case 8 ; Unmount
				$Path = $tvData[$Index][25]
				$tvData[$Index][25] = StringTrimLeft($tvData[$Index][25], 1)
				If $tvData[$Index][10] Then
					Call($tvData[$Index][10], $hTV, $TV_NOTIFY_DISKUNMOUNTED, StringLeft($Path, 1) & ':', 0)
				EndIf
		EndSwitch
	Until 1
	_WinAPI_SetErrorMode($Mode)
	Switch $Dummy
		Case 3 To 7
			$tvData[$Index][$Dummy + 17] = -1
		Case Else

	EndSwitch
	Return 1
EndFunc   ;==>_TV_Dummy

Func _TV_Event()
	_TV_Dummy(GUICtrlRead(@GUI_CtrlID))
EndFunc   ;==>_TV_Event

Func _TV_GetDrive($iMask)
	For $i = 0 To 25
		If BitAND(BitShift($iMask, $i), 1) Then
			Return Chr(65 + $i) & ':'
		EndIf
	Next
	Return ''
EndFunc   ;==>_TV_GetDrive

Func _TV_GetLabel($sDrive)

	Local $Label = DriveGetLabel($sDrive)

	If @error Then
		Return ''
	EndIf
	If Not $Label Then
		Switch DriveGetType($sDrive)
			Case 'Fixed'
				$Label = 'Local Disk'
			Case 'Removable'
				$Label = 'Removable Disk'
			Case 'RAMDisk'
				$Label = 'RAM Disk'
			Case 'CDROM'
				$Label = 'CD Disk'
			Case 'Network'
				$Label = 'Network Disk'
			Case Else
				$Label = 'Unknown Disk'
		EndSwitch
	EndIf
	Return $Label
EndFunc   ;==>_TV_GetLabel

Func _TV_GetPath($iIndex, $hItem)

	Local $Shortcut = $tvData[$iIndex][18]
	Local $Mode, $Path = ''

	For $i = 1 To $Shortcut[0][0]
		If $Shortcut[$i][0] = $hItem Then
			$Path = $Shortcut[$i][1]
			ExitLoop
		EndIf
	Next
	If Not $Path Then
		$Mode = Opt('GUIDataSeparatorChar', '\')
;		$Path = StringRegExpReplace(_GUICtrlTreeView_GetTree($tvData[$iIndex][0], $hItem), '([|]+)|(\\[|])', '\\')
		$Path = _GUICtrlTreeView_GetTree($tvData[$iIndex][0], $hItem)
		Opt('GUIDataSeparatorChar', $Mode)
		If Not $Path Then
			Return ''
		EndIf
	EndIf
	If StringInStr($Path, ':') Then
		$Path = StringReplace($Path, StringLeft($Path, StringInStr($Path, '\') - 1), StringMid($Path, StringInStr($Path, ':') - 1, 2), 1)
	Else
		$Path = StringRegExpReplace($tvData[$iIndex][9], '(\\[^\\]*(\\|)+)\Z', '\\') & $Path
	EndIf
	Return $Path
EndFunc   ;==>_TV_GetPath

Func _TV_Iif($fTest, $vTrue, $vFalse)
	If $fTest Then
		Return $vTrue
	Else
		Return $vFalse
	EndIf
EndFunc   ;==>_TV_Iif

Func _TV_Index($hTV)
	$hTV = _TV_HWnd($hTV)
	If Not $hTV Then
		Return 0
	EndIf
	For $i = 1 To $tvData[0][0]
		If $tvData[$i][0] = $hTV Then
			Return $i
		EndIf
	Next
	Return 0
EndFunc   ;==>_TV_Index

Func _TV_Initialize()

	Local $ID[5], $hIcon, $tIcon

	_TV_Purge()
	If _WinAPI_GetVersion() >= '6.0' Then
		$ID[0] = $SIID_DOCNOASSOC
		$ID[1] = $SIID_FOLDER
		$ID[2] = $SIID_FOLDEROPEN
		For $i = 0 To 2
			$tIcon = _WinAPI_ShellGetStockIconInfo($ID[$i], BitOR($SHGSI_ICON, $SHGSI_SMALLICON))
			$hIcon = DllStructGetData($tIcon, 'hIcon')
			_GUIImageList_ReplaceIcon($tvData[0][1], -1, $hIcon)
			$hIcon = _WinAPI_AddIconTransparency($hIcon, 50, 1)
			_GUIImageList_ReplaceIcon($tvData[0][1], -1, $hIcon)
			_WinAPI_DestroyIcon($hIcon)
		Next
	Else
		$ID[0] = 0
		$ID[1] = 3
		$ID[2] = 4
		For $i = 0 To 2
			$hIcon = _WinAPI_ExtractIcon(@SystemDir & '\shell32.dll', $ID[$i], 1)
			_GUIImageList_ReplaceIcon($tvData[0][1], -1, $hIcon)
			$hIcon = _WinAPI_AddIconTransparency($hIcon, 50, 1)
			_GUIImageList_ReplaceIcon($tvData[0][1], -1, $hIcon)
			_WinAPI_DestroyIcon($hIcon)
		Next
	EndIf
	If _WinAPI_GetVersion() >= '6.1' Then
		Dim $hIcon[3]
		$hIcon[0] = _GUIImageList_GetIcon($tvData[0][1], 2)
		$hIcon[1] = _WinAPI_ExtractIcon(@SystemDir & '\ntshrui.dll', 3, 1)
		$hIcon[2] = _WinAPI_AddIconOverlay($hIcon[0], $hIcon[1])
		_GUIImageList_ReplaceIcon($tvData[0][1], -1, $hIcon[2])
		$hIcon[2] = _WinAPI_AddIconTransparency($hIcon[2], 50, 1)
		_GUIImageList_ReplaceIcon($tvData[0][1], -1, $hIcon[2])
		For $i = 0 To 2
			_WinAPI_DestroyIcon($hIcon[$i])
		Next
	Else
		For $i = 2 To 3
			$hIcon = _GUIImageList_GetIcon($tvData[0][1], $i)
			_GUIImageList_ReplaceIcon($tvData[0][1], -1, $hIcon)
			_WinAPI_DestroyIcon($hIcon)
		Next
	EndIf
	If _WinAPI_GetVersion() >= '6.0' Then
		$ID[0] = $SIID_DRIVEFIXED
		$ID[1] = $SIID_DRIVEREMOVE
		$ID[2] = $SIID_DRIVERAM
		$ID[3] = $SIID_DRIVECD
		$ID[4] = $SIID_DRIVENET
		For $i = 0 To 4
			$tIcon = _WinAPI_ShellGetStockIconInfo($ID[$i], BitOR($SHGSI_ICON, $SHGSI_SMALLICON))
			$hIcon = DllStructGetData($tIcon, 'hIcon')
			_GUIImageList_ReplaceIcon($tvData[0][1], -1, $hIcon)
			_WinAPI_DestroyIcon($hIcon)
		Next
	Else
		$ID[0] = 8
		$ID[1] = 7
		$ID[2] = 12
		$ID[3] = 11
		$ID[4] = 9
		For $i = 0 To 4
			_GUIImageList_AddIcon($tvData[0][1], @SystemDir & '\shell32.dll', $ID[$i])
		Next
	EndIf
EndFunc   ;==>_TV_Initialize

Func _TV_IsEmpty($iIndex, $sPath)

	Local $hSearch = FileFindFirstFile($sPath & '\*')
	Local $Attrib, $File, $Result = 1

	If $hSearch = -1 Then
		If @error Then
			Return 1
		Else
			If _WinAPI_PathIsDirectory($sPath) Then
				Return SetError(1, 0, 1)
			Else
				Return SetError(2, 0, 1)
			EndIf
		EndIf
	EndIf
	If ($tvData[$iIndex][17]) Or (Not $tvData[$iIndex][11]) Or (Not $tvData[$iIndex][12]) Or (Not $tvData[$iIndex][14]) Then
		While $Result
			$File = FileFindNextFile($hSearch)
			If @error Then
				ExitLoop
			EndIf
			If (@extended) Or (Not $tvData[$iIndex][17]) Or (_WinAPI_PathMatchSpec($File, $tvData[$iIndex][17])) Then
				If _TV_IsValid($iIndex, $sPath & '\' & $File) Then
					$Result = 0
				EndIf
			EndIf
		WEnd
	Else
		$Result = 0
	EndIf
	FileClose($hSearch)
	Return $Result
EndFunc   ;==>_TV_IsEmpty

Func _TV_IsValid($iIndex, $sPath)

	Local $Attrib = FileGetAttrib($sPath)

	If (@error) Or ((Not $tvData[$iIndex][11]) And (StringInStr($Attrib, 'H'))) Or ((Not $tvData[$iIndex][12]) And (StringInStr($Attrib, 'S')))  Or ((Not $tvData[$iIndex][14]) And (Not StringInStr($Attrib, 'D'))) Then
		Return 0
	Else
		Return 1
	EndIf
EndFunc   ;==>_TV_IsValid

Func _TV_HWnd($hTV)
	If Not IsHWnd($hTV) Then
		Return GUICtrlGetHandle($hTV)
	Else
		Return $hTV
	EndIf
EndFunc   ;==>_TV_HWnd

Func _TV_Purge()
	Dim $tvIcon[101][3] = [[0]]
	If Not 	_GUIImageList_SetImageCount($tvData[0][1], 0) Then
		; Nothing
	EndIf
EndFunc   ;==>_TV_Purge

Func _TV_Send($iDummy, $iIndex, $hItem, $fDirect = 0, $lParam = 0)

	Local $wParam = _WinAPI_MakeLong($iDummy, $iIndex)

	If $hItem <> -1 Then
		$tvData[$iIndex][$iDummy + 17] = $hItem
	EndIf
	If $fDirect Then
		_TV_Dummy($wParam, $lParam)
	Else
		If Not GUICtrlSendToDummy($tvData[$iIndex][$iDummy], $wParam) Then
			Return 0
		EndIf
	EndIf
	Return 1
EndFunc   ;==>_TV_Send

Func _TV_SetImage($hTV, $hItem, $iImage)
	_GUICtrlTreeView_SetSelectedImageIndex($hTV, $hItem, $iImage)
	_GUICtrlTreeView_SetImageIndex($hTV, $hItem, $iImage)
EndFunc   ;==>_TV_SetImage

Func _TV_SetSelected($iIndex, $hItem, $fDirect = 0, $fSelect = 0)
	If $fSelect Then
		If _GUICtrlTreeView_GetSelection($tvData[$iIndex][0]) <> $hItem Then
			$tvData[$iIndex][27] += 1
			_GUICtrlTreeView_SelectItem($tvData[$iIndex][0], $hItem)
			$tvData[$iIndex][27] -= 1
		EndIf
	EndIf
	$tvData[$iIndex][1] = $hItem
	If Not _TV_Send(5, $iIndex, $hItem, $fDirect) Then
		; Nothing
	EndIf
	If $fSelect Then
		$tvData[$iIndex][21] = -1
;~		$tvData[$iIndex][22] = -1
	EndIf
EndFunc   ;==>_TV_SetSelected

Func _TV_Update($iIndex, $hItem, $fExpand = 1)

	Local $Path = StringRegExpReplace(_TV_GetPath($iIndex, $hItem), '\\+\Z', '')
	Local $hSearch, $hNext, $Attrib, $Empty, $File, $Title, $Image
	Local $hTV = $tvData[$iIndex][0]

	Do
		$hSearch = FileFindFirstFile($Path & '\*')
		If $hSearch = -1 Then
			If @error Then
				; The folder is empty
			Else
				; Access denied
				$Path = StringRegExpReplace($Path, ':\Z', ':\\')
				$Attrib = FileGetAttrib($Path)
				If @error Then
					Return 0
				EndIf
				If _WinAPI_PathIsRoot($Path) Then
					$Image = _TV_AddIcon($iIndex, $Path, 0, $Attrib)
				Else
					If (Not StringInStr($Attrib, 'D')) Or ((Not $tvData[$iIndex][11]) And (StringInStr($Attrib, 'H'))) Or ((Not $tvData[$iIndex][12]) And (StringInStr($Attrib, 'S'))) Then
						Return 0
					EndIf
					If StringInStr($Attrib, 'H') Then
						$Image = 7
					Else
						$Image = 6
					EndIf
				EndIf
				_GUICtrlTreeView_SetChildren($hTV, $hItem, 0)
				_TV_SetImage($hTV, $hItem, $Image)
				Return 1
			EndIf
		Else
			While 1
				$File = FileFindNextFile($hSearch)
				If @error Then
					ExitLoop
				EndIf
				If Not @extended Then
					ContinueLoop
				EndIf
				$Attrib = FileGetAttrib($Path & '\' & $File)
				If (@error) Or ((Not $tvData[$iIndex][11]) And (StringInStr($Attrib, 'H'))) Or ((Not $tvData[$iIndex][12]) And (StringInStr($Attrib, 'S'))) Then
					ContinueLoop
				EndIf
				$Image = 0
				$Empty = 1
				If _TV_IsEmpty($iIndex, $Path & '\' & $File) Then
					Switch @error
						Case 0 ; OK

						Case 1 ; Access denied
							If StringInStr($Attrib, 'H') Then
								$Image = 7
							Else
								$Image = 6
							EndIf
						Case Else
							ContinueLoop
					EndSwitch
				Else
					$Empty = 0
				EndIf
				If Not $Image Then
					$Image = _TV_AddIcon($iIndex, $Path & '\' & $File, 0, $Attrib)
				EndIf
;~				$hNext = _GUICtrlTreeView_AddChild($hTV, $hItem, $File, $Image, $Image)
				$hNext = _TV_AddChild($hTV, $hItem, $File, $Image, $Image)
				If Not $Empty Then
					_GUICtrlTreeView_SetChildren($hTV, $hNext, 1)
				EndIf
			WEnd
			FileClose($hSearch)
		EndIf
		If Not $tvData[$iIndex][14] Then
			ExitLoop
		EndIf
		$hSearch = FileFindFirstFile($Path & '\*')
		If $hSearch = -1 Then

		Else
			While 1
				$File = FileFindNextFile($hSearch)
				If @error Then
					ExitLoop
				EndIf
				If (@extended) Or (($tvData[$iIndex][17]) And (Not _WinAPI_PathMatchSpec($File, $tvData[$iIndex][17]))) Then
					ContinueLoop
				EndIf
				$Attrib = FileGetAttrib($Path & '\' & $File)
				If (@error) Or ((Not $tvData[$iIndex][11]) And (StringInStr($Attrib, 'H'))) Or ((Not $tvData[$iIndex][12]) And (StringInStr($Attrib, 'S'))) Then
					ContinueLoop
				EndIf
				$Title = 0
				$Image = _TV_AddIcon($iIndex, $Path & '\' & $File, 0, $Attrib)
				If $tvData[$iIndex][16] Then
					If $tvData[$iIndex][13] Then
						Switch StringRegExpReplace($File, '^.*\.', '')
							Case 'pif', 'lnk', 'url'
								$Title = StringRegExpReplace($File, '\.[^.]*\Z', '')
							Case Else

						EndSwitch
					Else
						$Title = _WinAPI_GetFileTitle($Path & '\' & $File)
						If (@error) Or ($Title = $File) Then
							$Title = 0
						EndIf
					EndIf
				EndIf
				If $Title Then
;~					_TV_AddShortcut($iIndex, _GUICtrlTreeView_AddChild($hTV, $hItem, $Title, $Image, $Image), $Path & '\' & $File)
					_TV_AddShortcut($iIndex, _TV_AddChild($hTV, $hItem, $Title, $Image, $Image), $Path & '\' & $File)
				Else
;~					If True Then
;~						_GUICtrlTreeView_AddChild($hTV, $hItem, $File, $Image, $Image)
						_TV_AddChild($hTV, $hItem, $File, $Image, $Image)
;~					EndIf
				EndIf
			WEnd
			FileClose($hSearch)
		EndIf
	Until 1
	If _GUICtrlTreeView_GetChildCount($hTV, $hItem) > 0 Then
		If Not $fExpand Then
			_GUICtrlTreeView_SetState($hTV, $hItem, $TVIS_EXPANDEDONCE, 1)
		Else
;~			_GUICtrlTreeView_BeginUpdate($hTV)
			_TV_SetImage($hTV, $hItem, _TV_AddIcon($iIndex, StringRegExpReplace($Path, ':\Z', ':\\'), 1))
			_GUICtrlTreeView_Expand($hTV, $hItem, 1)
;~			_GUICtrlTreeView_EndUpdate($hTV)
		EndIf
	Else
		_GUICtrlTreeView_SetChildren($hTV, $hItem, 0)
	EndIf
	Return 1
EndFunc   ;==>_TV_Update

#EndRegion Internal Functions

#Region Window Message Functions

#cs

TV_WM_DEVICECHANGE
TV_WM_NOTIFY

#ce

Func TV_WM_DEVICECHANGE($hWnd, $iMsg, $wParam, $lParam)
	Switch $hWnd
		Case $tvData[0][2]
			Switch $wParam
				Case 0x8000, 0x8004 ; DBT_DEVICEARRIVAL, DBT_DEVICEREMOVECOMPLETE

					Local $Mode = _WinAPI_SetErrorMode(BitOR($SEM_FAILCRITICALERRORS, $SEM_NOOPENFILEERRORBOX))
					Local $tDBV = DllStructCreate('dword Size;dword DeviceType;dword Reserved;dword Mask;ushort Flags', $lParam)
					Local $Type = DllStructGetData($tDBV, 'DeviceType')

					Switch $Type
						Case 2 ; DBT_DEVTYP_VOLUME

							Local $Drive = _TV_GetDrive(DllStructGetData($tDBV, 'Mask'))
							Local $hItem

							Switch $wParam
								Case 0x8000 ; DBT_DEVICEARRIVAL
									For $i = 1 To $tvData[0][0]
										If (Not $tvData[$i][0]) Or ($tvData[$i][27]) Or (Not _WinAPI_IsWindowVisible(_WinAPI_GetParent($tvData[$i][0]))) Then
											ContinueLoop
										EndIf
										If $tvData[$i][9] Then
											ContinueLoop
										EndIf
										$hItem = _TV_AddDrive($i, $Drive)
										If Not $hItem Then
											ContinueLoop
										EndIf
										$tvData[$i][19] &= StringFormat(StringLeft($Drive, 1) & '%-18s', $hItem)
										_TV_Send(2, $i, -1)
										If Not _GUICtrlTreeView_GetSelection($tvData[$i][0]) Then
											_GUICtrlTreeView_SelectItem($tvData[$i][0], 0)
										EndIf
									Next
								Case 0x8004 ; DBT_DEVICEREMOVECOMPLETE
									For $i = 1 To $tvData[0][0]
										If (Not $tvData[$i][0]) Or ($tvData[$i][27]) Or (Not _WinAPI_IsWindowVisible(_WinAPI_GetParent($tvData[$i][0]))) Then
											ContinueLoop
										EndIf
										If $tvData[$i][9] Then
											If StringLeft($tvData[$i][9], 2) = $Drive Then
												$hItem = _GUICtrlTreeView_GetFirstItem($tvData[$i][0])
											Else
												$hItem = 0
											EndIf
										Else
											$hItem = _GUICtrlTreeView_GetFirstItem($tvData[$i][0])
											While $hItem
												If StringLeft(_TV_GetPath($i, $hItem), 2) = $Drive Then
													ExitLoop
												EndIf
												$hItem = _GUICtrlTreeView_GetNextSibling($tvData[$i][0], $hItem)
											WEnd
										EndIf
										If Not $hItem Then
											ContinueLoop
										EndIf
;~										_GUICtrlTreeView_BeginUpdate($tvData[$i][0])
										_GUICtrlTreeView_Delete($tvData[$i][0], $hItem)
;~										_GUICtrlTreeView_EndUpdate($tvData[$i][0])
										$tvData[$i][25] &= StringLeft($Drive, 1)
										_TV_Send(8, $i, -1)
										If Not _GUICtrlTreeView_GetSelection($tvData[$i][0]) Then
											_TV_SetSelected($i, 0)
										EndIf
									Next
							EndSwitch
					EndSwitch
					_WinAPI_SetErrorMode($Mode)
			EndSwitch
	EndSwitch
	Return 'GUI_RUNDEFMSG'
EndFunc   ;==>TV_WM_DEVICECHANGE

Func TV_WM_NOTIFY($hWnd, $iMsg, $wParam, $lParam)

;~	Local $tNMTREEVIEW = DllStructCreate($tagNMTREEVIEW, $lParam)
	If @AutoItX64 Then
		Local $tNMTREEVIEW = DllStructCreate($tagNMHDR & ';uint Aligment1;uint Action;uint Aligment2;uint OldMask;ptr OldhItem;uint OldState;uint OldStateMask;ptr OldText;int OldTextMax;int OldImage;int OldSelectedImage;int OldChildren;lparam OldParam;uint Aligment3;uint NewMask;ptr NewhItem;uint NewState;uint NewStateMask;ptr NewText;int NewTextMax;int NewImage;int NewSelectedImage;int NewChildren;lparam NewParam;int X; int Y', $lParam)
	Else
		Local $tNMTREEVIEW = DllStructCreate($tagNMHDR & ';uint Action;uint OldMask;ptr OldhItem;uint OldState;uint OldStateMask;ptr OldText;int OldTextMax;int OldImage;int OldSelectedImage;int OldChildren;lparam OldParam;uint NewMask;ptr NewhItem;uint NewState;uint NewStateMask;ptr NewText;int NewTextMax;int NewImage;int NewSelectedImage;int NewChildren;lparam NewParam;int X; int Y', $lParam)
	EndIf
	Local $hTV = DllStructGetData($tNMTREEVIEW, 'hWndFrom')
	Local $Index = _TV_Index($hTV)

	If (Not $Index) Or ($tvData[$Index][27]) then
		Return 'GUI_RUNDEFMSG'
	EndIf

	Local $hItem = DllStructGetData($tNMTREEVIEW, 'NewhItem')
	Local $hPrev = DllStructGetData($tNMTREEVIEW, 'OldhItem')
	Local $State = DllStructGetData($tNMTREEVIEW, 'NewState')
	Local $ID = DllStructGetData($tNMTREEVIEW, 'Code')
	Local $Mode = _WinAPI_SetErrorMode(BitOR($SEM_FAILCRITICALERRORS, $SEM_NOOPENFILEERRORBOX))
	Local $tPoint, $Flag, $Path
	Local $tTVHTI

	Do
		Switch $ID
			Case $TVN_ITEMEXPANDINGW
				If $tvData[$Index][28] Then
					ExitLoop
				EndIf
				If Not _GUICtrlTreeView_ExpandedOnce($hTV, $hItem) Then
;~					_GUICtrlTreeView_SetState($hTV, $hItem, $TVIS_EXPANDEDONCE, 1)
					_TV_Send(3, $Index, $hItem)
				EndIf
			Case $TVN_ITEMEXPANDEDW
				$Path = _TV_GetPath($Index, $hItem)
				If BitAND($TVIS_EXPANDED, $State) Then
					$Flag = 1
				Else
					$Flag = 0
				EndIf
				If FileExists($Path) Then
					_TV_SetImage($hTV, $hItem, _TV_AddIcon($Index, $Path, $Flag))
				Else
					_TV_Send(4, $Index, $hItem)
				EndIf
			Case $TVN_SELCHANGEDW
				If BitAND($TVIS_SELECTED, $State) Then
					_TV_Send(4, $Index, $hItem)
				EndIf
			Case $TVN_DELETEITEMW
				_TV_DeleteShortcut($Index, $hPrev)
			Case -5 ; NM_RCLICK
				If $tvData[$Index][28] Then
					ExitLoop
				EndIf
				$tPoint = _WinAPI_GetMousePos(1, $hTV)
				$tTVHTI = _GUICtrlTreeView_HitTestEx($hTV, DllStructGetData($tPoint, 1), DllStructGetData($tPoint, 2))
				$hItem = DllStructGetData($tTVHTI, 'Item')
				If BitAND(DllStructGetData($tTVHTI, 'Flags'), $TVHT_ONITEM) Then
					_GUICtrlTreeView_SelectItem($hTV, $hItem)
					$Path = _TV_GetPath($Index, $hItem)
					If FileExists($Path) Then
						_TV_SetSelected($Index, $hItem)
						_TV_Send(7, $Index, $hItem)
					Else
						_TV_Send(4, $Index, $hItem)
					EndIf
				EndIf
			Case -3 ; NM_DBLCLK
				If $tvData[$Index][28] Then
					ExitLoop
				EndIf
				$tPoint = _WinAPI_GetMousePos(1, $hTV)
				$tTVHTI = _GUICtrlTreeView_HitTestEx($hTV, DllStructGetData($tPoint, 1), DllStructGetData($tPoint, 2))
				$hItem = DllStructGetData($tTVHTI, 'Item')
				If BitAND(DllStructGetData($tTVHTI, 'Flags'), $TVHT_ONITEM) Then
					$Path = _TV_GetPath($Index, $hItem)
					If Not _WinAPI_PathIsDirectory($Path) Then
						_TV_Send(6, $Index, $hItem)
					EndIf
				EndIf
		EndSwitch
	Until 1
	_WinAPI_SetErrorMode($Mode)
	Return 'GUI_RUNDEFMSG'
EndFunc   ;==>TV_WM_NOTIFY

#EndRegion Window Message Functions
