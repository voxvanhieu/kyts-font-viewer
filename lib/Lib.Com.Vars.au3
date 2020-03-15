#Region	Detect default fonts
Global $DefaultFont
If (StringInStr(@OSVersion, "WIN_VISTA|WIN_XP|WIN_XPe|WIN_2008R2|WIN_2008|WIN_2003") == 0) Then
	$DefaultFont = "Segoe UI"
Else
	$DefaultFont = "Arial"
EndIf
#EndRegion

Global Const $homePageLink = "www.hieuda.com"