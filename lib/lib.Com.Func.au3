#Region 	; Reduce Memory Register
AdlibRegister(_ReduceMemory, 500)
Func _ReduceMemory()
    Local $ai_GetCurrentProcessId = DllCall("kernel32.dll", "int", "GetCurrentProcessId")
    Local $ai_Handle = DllCall("kernel32.dll", "int", "OpenProcess", "int", 0x1f0fff, "int", False, "int", $ai_GetCurrentProcessId[0])
    Local $ai_Return = DllCall("psapi.dll", "int", "EmptyWorkingSet", "long", $ai_Handle[0])
    DllCall("kernel32.dll", "int", "CloseHandle", "int", $ai_Handle[0])
    Return $ai_Return[0]
EndFunc
#EndRegion