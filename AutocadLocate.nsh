Function GetCurrentAutoCADKey
;// =====================================================================
;// Construct a product key for the last AutoCAD run or installed.
;// This is referred to as the "Primary" AutoCAD.  All CLSID entries
;// and path references in the registry should be consistent with this
;// entry.
;// Parameters
;//   $1           Upon successful return
;//                   this will contain the fully qualified key that
;//                   will be found under HKEY_LOCAL_MACHINE
;//   $2           Upon successful return
;//                   will contain the ACAD-ID InstallId
;//   $3           Upon successful return
;//                   this will contain the path to acad.exe that is
;//                   associated with the current AutoCAD.
;// =====================================================================
    ;// Inspect the CurVer value at the ..\AutoCAD level to
    ;// determine the major release version key.  This will
    ;// point us to a section in the registry based upon the
    ;// version number.
    ReadRegStr $1 HKCU "Software\Autodesk\AutoCAD" "CurVer"
    ;// Must have the release version
    IfErrors 0 NoError1
      Goto Error
    NoError1:
    ;// Inspect the CurVer value at the ..\AutoCAD\szKey level to
    ;// determine the registry key id.  This will point us to a
    ;// major registry key where the Applications Subkey can be found
    ReadRegStr $2 HKCU "Software\Autodesk\AutoCAD\$1" "CurVer"
    ;// Must have the ID
    IfErrors 0 NoError2
      StrCpy $1 ""
      Goto Error
    NoError2:
    ReadRegStr $3 HKLM "Software\Autodesk\AutoCAD\$1\$2" "Location"
    ;// Must have the Path
    IfErrors 0 NoError3
      StrCpy $1 ""
      StrCpy $2 ""
      Goto Error
    NoError3:
    Error:
FunctionEnd
