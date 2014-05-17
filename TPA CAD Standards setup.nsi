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
Section "Install" ;No components page, name is not important

	; Copy all files
	!include FilesToCopy.nsh
  
	; install OpenDcl
	!include InstallOpenDCL.nsh

	; open Autocad and run script
;;	!include AutocadScript.nsh

	WriteUninstaller $INSTDIR\uninstaller.exe

SectionEnd ; end the section

Section "Uninstall"

	; open Autocad and run delete script
;;	!include CleanAutocad.nsh
	;ExecShell "msiexec.exe /x" "$INSTDIR\OpenDCL.Runtime.7.0.0.12.msi";; test!! 
	nsExec::ExecToStack "msiexec.exe /x '$INSTDIR\OpenDCL.Runtime.7.0.0.12.msi'";; test!
	; remove installed files
;;	!include FilesToRemove.nsh


 ; best to leave directory - if installed to common dir can wipe out unrelated files  
 ; RMDir $INSTDIR
  


SectionEnd


