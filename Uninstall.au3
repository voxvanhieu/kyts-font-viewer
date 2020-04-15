#RequireAdmin
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=assets\uninstall.ico
#AutoIt3Wrapper_Outfile=bin\uninstall.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_Res_Description=Uninstall Kyts Font Viewer
#AutoIt3Wrapper_Res_Fileversion=0.0.0.1
#AutoIt3Wrapper_Res_ProductName=Kyts Font Viewer
#AutoIt3Wrapper_Res_ProductVersion=1.0
#AutoIt3Wrapper_Res_CompanyName=JK. Kyts
#AutoIt3Wrapper_Res_LegalCopyright=www.hieuda.com
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

Global Const $UninstallKey = 'HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\KyTs Font Viewer'
Global Const $SoftwareKey  = 'HKCU\Software\JK.Kyts\KyTs Font Viewer'
Global Const $_ErrorMesage = 'Uninstaller can not find KyTs Font Viewer in registry!' & @CRLF & 'May be KyTs Font Viewer is not installed on your PC or the setup was not successfully.'

If RegRead($SoftwareKey, "Install") <> '' Then
	If Msgbox(BitOR(0x4, 0x20),'KyTs Font Viewer','Do you really want to remove KyTs Font Viewer?') == 6 Then _Uninstall()
Else
	Msgbox(16,'KyTs Font Viewer - Uninstaller',$_ErrorMesage)
EndIf

; Uninstall script
Func _Uninstall()
	If @Compiled Then
		Global Const $sInstallDir = RegRead($SoftwareKey, "Install")

		RegDelete($UninstallKey)
		RegDelete($SoftwareKey)

		RegWrite('HKCR\ttffile\shell\preview\command', '', 'REG_EXPAND_SZ', '%SystemRoot%\System32\fontview.exe %1')
		RegWrite('HKCR\otffile\shell\preview\command', '', 'REG_EXPAND_SZ', '%SystemRoot%\System32\fontview.exe %1')
		RegWrite('HKCR\fonfile\shell\preview\command', '', 'REG_EXPAND_SZ', '%SystemRoot%\System32\fontview.exe %1')

		RegDelete('HKCR\ttffile\shell', '')
		RegDelete('HKCR\otffile\shell', '')
		RegDelete('HKCR\fonfile\shell', '')

		RegDelete('HKCR\ttffile\shell\KyTs Font Viewer')
		RegDelete('HKCR\otffile\shell\KyTs Font Viewer')
		RegDelete('HKCR\fonfile\shell\KyTs Font Viewer')

		
		$CMD = '@RD /S /Q "' & @AppDataDir & '\Microsoft\Windows\Start Menu\Programs\KyTs Font Viewer"'
		RunWait(@ComSpec & " /c " & $CMD, @WorkingDir, @SW_HIDE)

		FileDelete(@DesktopDir & '\KyTs Font Viewer.lnk')
	EndIf

	Msgbox(0x40,'♥ KyTs Font Viewer ♥','Thank you for using my software!')

	If @Compiled Then
		$CMD_DELAY = "SLEEP 5"
		$CMD = '@RD /S /Q "' & $sInstallDir & '"'
		Run(@ComSpec & " /c ping 127.0.0.1 -n 5 && " & $CMD, @WorkingDir, @SW_HIDE)
	EndIf
EndFunc