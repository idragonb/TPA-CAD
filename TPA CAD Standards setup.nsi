
; This section sets file properties of the install file

!define _VERSION "1.0.1.4"
!include VersionInfo.nsh


; Where the program will be installed
InstallDir "$LOCALAPPDATA\TPA CAD Standards"

; Pages
Page directory
Page instfiles
;UninstPage uninstConfirm
UninstPage instfiles
RequestExecutionLevel admin

; get autocad key from registry
!include AutocadLocate.nsh

; The stuff to install
Section "" ;No components page, name is not important

  ; Set output path to the installation directory.
  ; should check if 32 or 64 bit before install and run accordingly
  SetOutPath $INSTDIR
  SetRegView 64
  WriteRegStr HKCU "SOFTWARE\TPA CAD Standards" "InstallDirectory" "$INSTDIR"

  ; Copy all files
  !include ProgramFiles.nsh
  
  SetOutPath $INSTDIR
  
  ; if installed don't run...
  ExecShell "" "$INSTDIR\OpenDCL.Runtime.7.0.0.12.msi"
  ;Delete "$INSTDIR\OpenDCL.Runtime.7.0.0.12.msi"
  
  Call GetCurrentAutoCADKey
  StrCpy $4 "\acad.exe"; /b "$INSTDIR\TPA install.scr"'; $INSTDIR\TPA install.scr"
  ;MessageBox MB_OK '"$3$4" /b "$INSTDIR\TPA install.scr"';   "$3$4"
  MessageBox MB_OK "Please close all instances of Autocad and excel before continuing..."
  MessageBox MB_OK "**Please note:** You will have to manually close Autocad to complete the install..."

  ExecWait '"$3$4" /b "$INSTDIR\TPA install.scr"';
    
  
  WriteUninstaller $INSTDIR\uninstaller.exe

  
SectionEnd ; end the section

Section "Uninstall"
  SetRegView 64
  DeleteRegKey HKLM "SOFTWARE\TPA CAD Standards\InstallDirectory"
  DeleteRegKey HKLM "SOFTWARE\TPA CAD Standards"

  ;Delete "$INSTDIR\setborder.lsp"
  Delete "$INSTDIR\uninstaller.exe"
  ;Delete "$INSTDIR\TPA BORDER A0.dwg"
  ;Delete "$INSTDIR\Print template.dwg"
  ; change following to dwt
  Delete "$INSTDIR\TPA Imperial.dwg"
  Delete "$INSTDIR\TPA Metric.dwg"
  Delete "$INSTDIR\TPA Imperial Start.dwt"
  Delete "$INSTDIR\TPA Metric Start.dwt"
  Delete "$INSTDIR\TPA CAD ribbon.cuix"
  Delete "$INSTDIR\TPA CAD ribbon.mnl"
  ;Delete "$INSTDIR\first setup.lsp"
  ;Delete "$INSTDIR\Symbols.dwg"
  Delete "$INSTDIR\Sheet list.xlsx"
  Delete "$INSTDIR\LayerControl.lsp"
  Delete "$INSTDIR\Layers List TPA Master.xls"
  Delete "$INSTDIR\LayerControl.odcl"
  Delete "$INSTDIR\Revision history.txt"
  Delete "$INSTDIR\TPA install.scr"
  Delete "$INSTDIR\TPA Blocks Template.dwg"

 ; best to leave directory - if installed to common dir can wipe out unrelated files  
 ; RMDir $INSTDIR
  


SectionEnd


