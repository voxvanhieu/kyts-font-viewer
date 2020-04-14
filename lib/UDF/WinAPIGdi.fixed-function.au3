;~ ==============================================================================================================================
;~ JK. KyTs
;~ Replace this function in to WinAPIGdi.au3 to fix conflict with .VN fonts
;~ ==============================================================================================================================

; #FUNCTION# ====================================================================================================================
; Author ........: funkey
; Modified ......: UEZ, jpm
; ===============================================================================================================================
Func _WinAPI_GetFontMemoryResourceInfo($pMemory, $iFlag = 1)
	Local Const $tagTT_OFFSET_TABLE = "USHORT uMajorVersion;USHORT uMinorVersion;USHORT uNumOfTables;USHORT uSearchRange;USHORT uEntrySelector;USHORT uRangeShift"
	Local Const $tagTT_TABLE_DIRECTORY = "char szTag[4];ULONG uCheckSum;ULONG uOffset;ULONG uLength"
	Local Const $tagTT_NAME_TABLE_HEADER = "USHORT uFSelector;USHORT uNRCount;USHORT uStorageOffset"
	Local Const $tagTT_NAME_RECORD = "USHORT uPlatformID;USHORT uEncodingID;USHORT uLanguageID;USHORT uNameID;USHORT uStringLength;USHORT uStringOffset"

	Local $tTTOffsetTable = DllStructCreate($tagTT_OFFSET_TABLE, $pMemory)
	Local $iNumOfTables = _WinAPI_SwapWord(DllStructGetData($tTTOffsetTable, "uNumOfTables"))

	;check is this is a true type font and the version is 1.0
	If Not (_WinAPI_SwapWord(DllStructGetData($tTTOffsetTable, "uMajorVersion")) = 1 And _WinAPI_SwapWord(DllStructGetData($tTTOffsetTable, "uMinorVersion")) = 0) Then Return SetError(1, 0, "")

	Local $iTblDirSize = DllStructGetSize(DllStructCreate($tagTT_TABLE_DIRECTORY))
	Local $bFound = False, $iOffset, $tTblDir
	For $i = 0 To $iNumOfTables - 1
		$tTblDir = DllStructCreate($tagTT_TABLE_DIRECTORY, $pMemory + DllStructGetSize($tTTOffsetTable) + $i * $iTblDirSize)
		If StringLeft(DllStructGetData($tTblDir, "szTag"), 4) = "name" Then
			$bFound = True
			$iOffset = _WinAPI_SwapDWord(DllStructGetData($tTblDir, "uOffset"))
			ExitLoop
		EndIf
	Next

	If Not $bFound Then Return SetError(2, 0, "")

	Local $tNTHeader = DllStructCreate($tagTT_NAME_TABLE_HEADER, $pMemory + $iOffset)
	Local $iNTHeaderSize = DllStructGetSize($tNTHeader)
	Local $iNRCount = _WinAPI_SwapWord(DllStructGetData($tNTHeader, "uNRCount"))
	Local $iStorageOffset = _WinAPI_SwapWord(DllStructGetData($tNTHeader, "uStorageOffset"))

	Local $iTTRecordSize = DllStructGetSize(DllStructCreate($tagTT_NAME_RECORD))
	Local $tResult, $sResult, $iStringLength, $iStringOffset, $iEncodingID, $tTTRecord
	For $i = 0 To $iNRCount - 1
		$tTTRecord = DllStructCreate($tagTT_NAME_RECORD, $pMemory + $iOffset + $iNTHeaderSize + $i * $iTTRecordSize)

		If _WinAPI_SwapWord($tTTRecord.uNameID) = $iFlag Then ;1 says that this is font name. 0 for example determines copyright info
			$iStringLength = _WinAPI_SwapWord(DllStructGetData($tTTRecord, "uStringLength"))
			$iStringOffset = _WinAPI_SwapWord(DllStructGetData($tTTRecord, "uStringOffset"))
			$iEncodingID = _WinAPI_SwapWord(DllStructGetData($tTTRecord, "uEncodingID"))

			Local $sWchar = "char"
			If $iEncodingID = 1 Then
				$sWchar = "word"
				$iStringLength = $iStringLength / 2
			EndIf
            If Not $iStringLength Then
                $sResult = ""
                ContinueLoop
			EndIf
			
			$tResult = DllStructCreate($sWchar & " szTTFName[" & $iStringLength & "]", $pMemory + $iOffset + $iStringOffset + $iStorageOffset)

			If $iEncodingID = 1 Then
				$sResult = ""
				For $j = 1 To $iStringLength
					$sResult &= ChrW(_WinAPI_SwapWord(DllStructGetData($tResult, 1, $j)))
				Next
			Else
				$sResult = $tResult.szTTFName
			EndIf

			If StringLen($sResult) > 0 Then ExitLoop
		EndIf
	Next

	Return $sResult
EndFunc   ;==>_WinAPI_GetFontMemoryResourceInfo
