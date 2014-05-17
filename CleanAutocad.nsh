; run script in Autocad that removes program elements

  Call GetCurrentAutoCADKey
  StrCpy $4 "\acad.exe"; /b "$INSTDIR\TPA install.scr"'; $INSTDIR\TPA install.scr"
  ;MessageBox MB_OK '"$3$4" /b "$INSTDIR\TPA install.scr"';   "$3$4"
  MessageBox MB_OK "Please close all instances of Autocad and excel before continuing..."
  MessageBox MB_OK "**Please note:** You will have to manually close Autocad to complete the uninstall..."

  ExecWait '"$3$4" /b "$INSTDIR\TPA uninstall.scr"';