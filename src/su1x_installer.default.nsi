;SU1X Installer script use with NSIS Installer
;http://su1x.swan.ac.uk
;http://nsis.sourceforge.net

; -------------------------------
; Start
  !define MUI_PRODUCT "Eduroam Tool"
  !define MUI_FILE "su1x-setup"
  !define MUI_VERSION ""
  !define MUI_BRANDINGTEXT "Eduroam @ Swansea"
  !define MUI_HEADERIMAGE
  ; !define MUI_HEADERIMAGE_BITMAP "images\jrs-header.bmp"
  CRCCheck On

;--------------------------------
;Include Modern UI
  !include "MUI2.nsh"

;--------------------------------
;General
  Name "Eduroam @ Swansea"
  OutFile "su1x-installer.exe"
  ShowInstDetails "nevershow"
  ShowUninstDetails "nevershow"
  !define MUI_ICON "compile_assets\SETUP07.ico"
  !define MUI_UNICON "compile_assets\SETUP07.ico"
  ;Request application privileges for Windows Vista
  RequestExecutionLevel admin

;--------------------------------
;Folder selection page
  InstallDir "$PROGRAMFILES\${MUI_PRODUCT}"

;--------------------------------
;Pages
;install
  !insertmacro MUI_PAGE_WELCOME
  !insertmacro MUI_PAGE_LICENSE "..\LICENSE"
  !insertmacro MUI_PAGE_INSTFILES
  !insertmacro MUI_PAGE_FINISH

  ;uninstall
  !insertmacro MUI_UNPAGE_CONFIRM
  !insertmacro MUI_UNPAGE_INSTFILES

;--------------------------------
;Language
  !insertmacro MUI_LANGUAGE "English"


;--------------------------------
;Installer Sections
Section "Eduroam @ Swansea" install

;Add files
  SetOutPath "$INSTDIR"
  File /r "..\bin\*.*"



;create desktop shortcut
  CreateShortCut "$DESKTOP\${MUI_PRODUCT}.lnk" "$INSTDIR\${MUI_FILE}.exe" "$INSTDIR\${MUI_ICON}" ""

;create start-menu items
  CreateDirectory "$SMPROGRAMS\${MUI_PRODUCT}"
  CreateShortCut "$SMPROGRAMS\${MUI_PRODUCT}\Uninstall.lnk" "$INSTDIR\Uninstall.exe" "" "$INSTDIR\Uninstall.exe" 0
  CreateShortCut "$SMPROGRAMS\${MUI_PRODUCT}\${MUI_PRODUCT}.lnk" "$INSTDIR\${MUI_FILE}.exe" "" "$INSTDIR\${MUI_FILE}.exe" 0

;write uninstall information to the registry
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${MUI_PRODUCT}" "DisplayName" "${MUI_PRODUCT} (remove only)"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\${MUI_PRODUCT}" "UninstallString" "$INSTDIR\Uninstall.exe"

  WriteUninstaller "$INSTDIR\Uninstall.exe"

SectionEnd


;--------------------------------
;Uninstaller Section
Section "Uninstall"

;Delete Files
  RMDir /r "$INSTDIR\*.*"

;Remove the installation directory
  RMDir "$INSTDIR"

;Delete Start Menu Shortcuts
  Delete "$DESKTOP\${MUI_PRODUCT}.lnk"
  Delete "$SMPROGRAMS\${MUI_PRODUCT}\*.*"
  RmDir  "$SMPROGRAMS\${MUI_PRODUCT}"

;Delete Uninstaller And Unistall Registry Entries
  DeleteRegKey HKEY_LOCAL_MACHINE "SOFTWARE\${MUI_PRODUCT}"
  DeleteRegKey HKEY_LOCAL_MACHINE "SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\${MUI_PRODUCT}"

SectionEnd








;Function that calls a messagebox when installation finished correctly
Function .onInstSuccess
  Exec '"$INSTDIR\${MUI_FILE}.exe"'

FunctionEnd

  Function un.onInit
    MessageBox MB_YESNO "This will uninstall ${MUI_PRODUCT} and wireless networks. Continue?" IDYES NoAbort
      Abort ; causes uninstaller to quit.
    NoAbort:	Exec '"$INSTDIR\${MUI_FILE}.exe" remove'
  FunctionEnd

Function un.onUninstSuccess
  MessageBox MB_OK "You have successfully uninstalled ${MUI_PRODUCT}."
FunctionEnd


;eof