#RequireAdmin
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=Resource\uninstall.ico
#AutoIt3Wrapper_Outfile=bin\uninstall.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_UseX64=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

Global Const $UninstallKey = 'HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\KyTs Font Viewer'
Global Const $SoftwareKey  = 'HKCU\Software\KyTs Tech\KyTs Font Viewer'
Global Const $_ErrorMesage = 'Uninstaller can not find KyTs Font Viewer in registry!' & @CRLF & 'May be KyTs Font Viewer is not installed on your PC or the setup was not successfully.'

If RegRead($SoftwareKey, "Install") <> '' Then
	If Msgbox(BitOR(0x4, 0x20),'KyTs Font Viewer - Uninstaller','Do you really want to uninstall KyTs Font Viewer product?') == 6 Then _Uninstall()
Else
	Msgbox(16,'KyTs Font Viewer - Uninstaller',$_ErrorMesage)
EndIf

; Uninstall script
Func _Uninstall()
	If @Compiled Then
		Global Const $sInstallDir = RegRead($SoftwareKey, "Install")
		RegDelete($UninstallKey)
		RegDelete($SoftwareKey)
		FileDelete($sInstallDir & '\Resource\FontAwesome.otf')
		FileDelete($sInstallDir & '\Resource\Icon_mini.png')
		FileDelete($sInstallDir & 'Resource\Help_EN.rtf')
		FileDelete($sInstallDir & 'Resource\Help_VN.rtf')
		DirRemove($sInstallDir & '\Resource')
		FileDelete(@DesktopDir & '\KyTs Font Viewer.lnk')
		FileDelete($sInstallDir & '\KyTs Font Viewer.exe')
		FileDelete($sInstallDir & '\Helper.exe')
		FileDelete($sInstallDir & '\ReadMe.rtf')

		RegWrite('HKCR\ttffile\shell\preview\command', '', 'REG_EXPAND_SZ', '%SystemRoot%\System32\fontview.exe %1')
		RegWrite('HKCR\otffile\shell\preview\command', '', 'REG_EXPAND_SZ', '%SystemRoot%\System32\fontview.exe %1')
		RegWrite('HKCR\fonfile\shell\preview\command', '', 'REG_EXPAND_SZ', '%SystemRoot%\System32\fontview.exe %1')

		RegDelete('HKCR\ttffile\shell', '')
		RegDelete('HKCR\otffile\shell', '')
		RegDelete('HKCR\fonfile\shell', '')

		RegDelete('HKCR\ttffile\shell\KyTs Font Viewer')
		RegDelete('HKCR\otffile\shell\KyTs Font Viewer')
		RegDelete('HKCR\fonfile\shell\KyTs Font Viewer')
	EndIf
	Msgbox(0x40,'KyTs Font Viewer - Uninstaller','Uninstall Complete!')
EndFunc