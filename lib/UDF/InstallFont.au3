#RequireAdmin
;~ InstallFont("\\server.local\Software\_Install\_Default\1\CORPORATE FONT\*.*")
;~ InstallFont('C:\Users\PC\Desktop\TestFont\HLHOCTRO.TTF')

Func InstallFont($sSourceFile, $sFontDescript="", $sFontsPath="")
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

    DllClose($hGdi32_DllOpen)
    DllCall("user32.dll", "Int", "SendMessage", "hwnd", $HWND_BROADCAST, "int", $WM_FONTCHANGE, "int", 0, "int", 0)
    Return 1
EndFunc