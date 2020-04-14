#RequireAdmin
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=assets\Icon.ico
#AutoIt3Wrapper_Outfile=bin\kfv-installer.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_Res_Description=Kyts Font Viewer Installer
#AutoIt3Wrapper_Res_Fileversion=1.0.0.0
#AutoIt3Wrapper_Res_ProductName=Kyts Font Viewer
#AutoIt3Wrapper_Res_ProductVersion=1.0
#AutoIt3Wrapper_Res_CompanyName=JK. Kyts
#AutoIt3Wrapper_Res_LegalCopyright=www.hieuda.com
#AutoIt3Wrapper_Res_Language=1033
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

Opt("TrayIconHide", 1)
Opt("GUICloseOnESC", 1)
Opt("GUIOnEventMode", 1)
Opt("GUIResizeMode", 802)

#include "lib\Installer\Installer.au3"

_InstallTempResources()

_LoadFontAwesomeResource()

_GDIPlus_Startup()

#Region Create GUI and controls
_Create_MainGUI()

WinSetTrans($hGUI, "", 0)
GUISetState(@SW_SHOW, $hGUI)
_ShowForm()
#EndRegion

_GUI_Loop()
