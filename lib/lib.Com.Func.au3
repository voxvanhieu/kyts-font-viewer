#Region 	; Gabarge collection, Reduce Memory
AdlibRegister(_ReduceMemory, 500)
Func _ReduceMemory()
    Local $ai_GetCurrentProcessId = DllCall("kernel32.dll", "int", "GetCurrentProcessId")
    Local $ai_Handle = DllCall("kernel32.dll", "int", "OpenProcess", "int", 0x1f0fff, "int", False, "int", $ai_GetCurrentProcessId[0])
    Local $ai_Return = DllCall("psapi.dll", "int", "EmptyWorkingSet", "long", $ai_Handle[0])
    DllCall("kernel32.dll", "int", "CloseHandle", "int", $ai_Handle[0])
    Return $ai_Return[0]
EndFunc
#EndRegion

#cs
;~	Using GDIPlus to create Picture control, shouldn"t create many control with this and project use GDIPlus
#ce
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
EndFunc			
