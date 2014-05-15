

; This section sets file properties of the install file

!define _VERSION "1.0.1.2"

Icon "logo.ico"
BrandingText "created by Michael Berman via elance michael@ilact.com"
Caption "TPA CAD Standards"
Name "TPA CAD Standards ${_VERSION}"
OutFile "TPA CAD Standards setup ${_VERSION}.exe"


VIProductVersion "${_VERSION}"
VIAddVersionKey ProductVersion "${_VERSION}"
VIAddVersionKey FileVersion "${_VERSION}"
VIAddVersionKey FileDescription "TPA CAD Standards installer"
VIAddVersionKey LegalCopyright "Michael Berman, for TPA use only"
VIAddVersionKey ProductName "TPA CAD Standards"

; Where the program will be installed
InstallDir "$PROGRAMFILES\TPA CAD Standards"

; Pages

Page directory
Page instfiles
;UninstPage uninstConfirm
UninstPage instfiles
RequestExecutionLevel admin

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

; The stuff to install
Section "" ;No components page, name is not important

  ; Set output path to the installation directory.
  ; should check if 32 or 64 bit before install and run accordingly
  SetOutPath $INSTDIR
  SetRegView 64
  WriteRegStr HKLM "SOFTWARE\TPA CAD Standards" "InstallDirectory" "$INSTDIR"

  ; Put file there
  File "setborder.lsp" ; deprecated - will need to modify to extract from template if continued
  ;File "TPA BORDER A0.dwg" ; deprecated
  ;File "Print template.dwg" ; deprecated
  ; Modify following to dwt files
  File "TPA Imperial.dwg"
  File "TPA Metric.dwg"
  File "TPA Imperial Start.dwt"
  File "TPA Metric Start.dwt"
  File "TPA CAD ribbon.cuix"  ; remove features and replace with open template imp, metric and open palette
  File "TPA CAD ribbon.mnl"    ; lisps to load with menu
  ;File "first setup.lsp"  ; deprecated - transfer to script
  ;File "Symbols.dwg" ; deprecated
  File "Sheet list.xlsx"  ; template sheet list for use in new projects - should be copied local on new template
  File "LayerControl.lsp"  ; main controller
  File "TPA Blocks Template.dwg" ; holds all symbols
  File "Layers List TPA Master.xls" ; deprecated - all layers are preloaded
  File "LayerControl.odcl" ; deprecated - interface for layer control
  File "OpenDCL.Runtime.7.0.0.12.msi" ; OpenDCL support       
  ; try to move these to the appropriate directory
  File "TPA.stb"  ; print support file - moved to print directory on install
 ; File "TPA Layers.xtp" ; palette file - need to load at install
 ; File "TPA Layers.xpg" ; palette file - need to load at install
  File "Revision history.txt" ; tracks revisions of files
   
  File "TPA install.scr" ; run once upon install
  
  SetOutPath $INSTDIR\Palettes
  File "Palettes\TPA Access Control_BC9619CF-0498-4581-9C54-41C95D96673A.atc"
  File "Palettes\TPA Communication_D91E6CC9-0D62-48DD-AC52-5E615AFC40CD.atc"
  File "Palettes\TPA Fire Alarm_21698E45-0EA4-40C5-BB29-436550603DAA.atc"
  File "Palettes\TPA Graphic Symbols_30FC80E0-7F50-4D18-942B-9F607CC82FE8.atc"
  File "Palettes\TPA Hatches_9D3FCCDA-CF32-401C-A46C-A3E52BE62A65.atc"
  File "Palettes\TPA Lighting_95564819-39D1-40C2-A345-C5EFAD26185F.atc"
  File "Palettes\TPA Power_C094C185-53E3-4A67-BB33-4FBECD88A20A.atc"
  File "Palettes\TPA Security_530A0244-0057-413E-AAE0-B0188FB8C314.atc"
  
  SetOutPath $INSTDIR\Palettes\Images

	File "Palettes\Images\2 WAY SWITCH32.PNG"
	File "Palettes\Images\2 WAY SWITCH64.PNG"
	File "Palettes\Images\220 VOLT RECEPTACLE32.PNG"
	File "Palettes\Images\220 VOLT RECEPTACLE64.PNG"
	File "Palettes\Images\3 WAY SWITCH32.PNG"
	File "Palettes\Images\3 WAY SWITCH64.PNG"
	File "Palettes\Images\4 WAY SWITCH32.PNG"
	File "Palettes\Images\4 WAY SWITCH64.PNG"
	File /nonfatal "Palettes\Images\57 °C FIXED TEMPERATURE THERMAL DETECTOR32.PNG"
	File /nonfatal "Palettes\Images\57 °C FIXED TEMPERATURE THERMAL DETECTOR64.PNG"
	File "Palettes\Images\ABOVE COUNTER RECEPTACLE32.PNG"
	File "Palettes\Images\ABOVE COUNTER RECEPTACLE64.PNG"
	File "Palettes\Images\ANSI3132.PNG"
	File "Palettes\Images\ANSI3164.PNG"
	File "Palettes\Images\ANSI3232.PNG"
	File "Palettes\Images\ANSI3264.PNG"
	File "Palettes\Images\ANSI3732.PNG"
	File "Palettes\Images\ANSI3764.PNG"
	File "Palettes\Images\AR-BRSTD32.PNG"
	File "Palettes\Images\AR-BRSTD64.PNG"
	File "Palettes\Images\AR-CONC32.PNG"
	File "Palettes\Images\AR-CONC64.PNG"
	File "Palettes\Images\AR-SAND32.PNG"
	File "Palettes\Images\AR-SAND64.PNG"
	File "Palettes\Images\BELL CHIMES32.PNG"
	File "Palettes\Images\BELL CHIMES64.PNG"
	File "Palettes\Images\Bell Push32.PNG"
	File "Palettes\Images\Bell Push64.PNG"
	File "Palettes\Images\BELOW COUNTER RECEPTACLE32.PNG"
	File "Palettes\Images\BELOW COUNTER RECEPTACLE64.PNG"
	File "Palettes\Images\Block tool_00368765-492F-4EC3-8F55-1CA5D21704AA.PNG"
	File "Palettes\Images\Block tool_00368765-492F-4EC3-8F55-1CA5D21704AA_2.PNG"
	File "Palettes\Images\Block tool_84DA8E97-25A4-4448-9C96-CB63952F11E0.PNG"
	File "Palettes\Images\Block tool_84DA8E97-25A4-4448-9C96-CB63952F11E0_2.PNG"
	File "Palettes\Images\Block tool_8CCE0F3A-2705-45A4-9CDE-F70023ED5348.PNG"
	File "Palettes\Images\Block tool_8CCE0F3A-2705-45A4-9CDE-F70023ED5348_2.PNG"
	File "Palettes\Images\Block tool_B0331748-97E4-4F5D-A9B2-9CBC48C4E4CD.PNG"
	File "Palettes\Images\Block tool_B0331748-97E4-4F5D-A9B2-9CBC48C4E4CD_2.PNG"
	File "Palettes\Images\Building Section32.PNG"
	File "Palettes\Images\Building Section64.PNG"
	File "Palettes\Images\Buzzer32.PNG"
	File "Palettes\Images\Buzzer64.PNG"
	File "Palettes\Images\C.C. T.V. CAMERA32.PNG"
	File "Palettes\Images\C.C. T.V. CAMERA64.PNG"
	File "Palettes\Images\CARD READER32.PNG"
	File "Palettes\Images\CARD READER64.PNG"
	File "Palettes\Images\CCTV CAMERA (INFRA RED)32.PNG"
	File "Palettes\Images\CCTV CAMERA (INFRA RED)64.PNG"
	File "Palettes\Images\CCTV CAMERA (PTZ - PAN TILT ZOOM)32.PNG"
	File "Palettes\Images\CCTV CAMERA (PTZ - PAN TILT ZOOM)64.PNG"
	File "Palettes\Images\CCTV CAMERA INFRA RED (PTZ - PAN TILT ZOOM)32.PNG"
	File "Palettes\Images\CCTV CAMERA INFRA RED (PTZ - PAN TILT ZOOM)64.PNG"
	File "Palettes\Images\CCTV MONITOR32.PNG"
	File "Palettes\Images\CCTV MONITOR64.PNG"
	File "Palettes\Images\CEILING CARBON MONOXIDE32.PNG"
	File "Palettes\Images\CEILING CARBON MONOXIDE64.PNG"
	File "Palettes\Images\CEILING FAN W-LIGHT32.PNG"
	File "Palettes\Images\CEILING FAN W-LIGHT64.PNG"
	File "Palettes\Images\CEILING FAN32.PNG"
	File "Palettes\Images\CEILING FAN64.PNG"
	File "Palettes\Images\CEILING FIXTURE32.PNG"
	File "Palettes\Images\CEILING FIXTURE64.PNG"
	File "Palettes\Images\CEILING MOUNTED COMPACT FLUORESCENT LIGHT32.PNG"
	File "Palettes\Images\CEILING MOUNTED COMPACT FLUORESCENT LIGHT64.PNG"
	File "Palettes\Images\CEILING MOUNTED SMOKE DETECTOR32.PNG"
	File "Palettes\Images\CEILING MOUNTED SMOKE DETECTOR64.PNG"
	File "Palettes\Images\CEILING MOUNTED SPEAKER32.PNG"
	File "Palettes\Images\CEILING MOUNTED SPEAKER64.PNG"
	File "Palettes\Images\Ceiling Mounted Track Complete with Head32.PNG"
	File "Palettes\Images\Ceiling Mounted Track Complete with Head64.PNG"
	File "Palettes\Images\CEILING RECEPTACLE32.PNG"
	File "Palettes\Images\CEILING RECEPTACLE64.PNG"
	File "Palettes\Images\Cove Light32.PNG"
	File "Palettes\Images\Cove Light64.PNG"
	File "Palettes\Images\CROSS32.PNG"
	File "Palettes\Images\CROSS64.PNG"
	File "Palettes\Images\Data Line32.PNG"
	File "Palettes\Images\Data Line64.PNG"
	File "Palettes\Images\Detail Reference32.PNG"
	File "Palettes\Images\Detail Reference64.PNG"
	File "Palettes\Images\DIMMER SWITCH32.PNG"
	File "Palettes\Images\DIMMER SWITCH64.PNG"
	File "Palettes\Images\DISCONNECT32.PNG"
	File "Palettes\Images\DISCONNECT64.PNG"
	File "Palettes\Images\DOME CAMERA32.PNG"
	File "Palettes\Images\DOME CAMERA64.PNG"
	File "Palettes\Images\Dome Light32.PNG"
	File "Palettes\Images\Dome Light64.PNG"
	File "Palettes\Images\DOOR ACCESS AUDIO ENTRY PANEL32.PNG"
	File "Palettes\Images\DOOR ACCESS AUDIO ENTRY PANEL64.PNG"
	File "Palettes\Images\DOOR ACCESS AUDIO ENTRY PHONE32.PNG"
	File "Palettes\Images\DOOR ACCESS AUDIO ENTRY PHONE64.PNG"
	File "Palettes\Images\DOOR ACCESS VIDEO ENTRY PANEL32.PNG"
	File "Palettes\Images\DOOR ACCESS VIDEO ENTRY PANEL64.PNG"
	File "Palettes\Images\DOOR ACCESS VIDEO MONITOR32.PNG"
	File "Palettes\Images\DOOR ACCESS VIDEO MONITOR64.PNG"
	File "Palettes\Images\DOOR BELL PUSH32.PNG"
	File "Palettes\Images\DOOR BELL PUSH64.PNG"
	File "Palettes\Images\Door Number32.PNG"
	File "Palettes\Images\Door Number64.PNG"
	File "Palettes\Images\DOOR RELEASE32.PNG"
	File "Palettes\Images\DOOR RELEASE64.PNG"
	File "Palettes\Images\DUPLEX RECEPTACLE32.PNG"
	File "Palettes\Images\DUPLEX RECEPTACLE64.PNG"
	File "Palettes\Images\EARTH32.PNG"
	File "Palettes\Images\EARTH64.PNG"
	File "Palettes\Images\Electric Heater32.PNG"
	File "Palettes\Images\Electric Heater64.PNG"
	File "Palettes\Images\Electric Water Heater32.PNG"
	File "Palettes\Images\Electric Water Heater64.PNG"
	File "Palettes\Images\ELECTRICAL PANEL BOX32.PNG"
	File "Palettes\Images\ELECTRICAL PANEL BOX64.PNG"
	File "Palettes\Images\Elevation32.PNG"
	File "Palettes\Images\Elevation64.PNG"
	File "Palettes\Images\EMERGENCY EXIT SIGN - DIRECTIONAL 132.PNG"
	File "Palettes\Images\EMERGENCY EXIT SIGN - DIRECTIONAL 164.PNG"
	File "Palettes\Images\EMERGENCY EXIT SIGN - DIRECTIONAL32.PNG"
	File "Palettes\Images\EMERGENCY EXIT SIGN - DIRECTIONAL64.PNG"
	File "Palettes\Images\EMERGENCY EXIT SIGN - MULTI DIRECTIONAL 132.PNG"
	File "Palettes\Images\EMERGENCY EXIT SIGN - MULTI DIRECTIONAL 164.PNG"
	File "Palettes\Images\EMERGENCY EXIT SIGN - MULTI DIRECTIONAL 232.PNG"
	File "Palettes\Images\EMERGENCY EXIT SIGN - MULTI DIRECTIONAL 264.PNG"
	File "Palettes\Images\EMERGENCY EXIT SIGN - MULTI DIRECTIONAL32.PNG"
	File "Palettes\Images\EMERGENCY EXIT SIGN - MULTI DIRECTIONAL64.PNG"
	File "Palettes\Images\EMERGENCY EXIT SIGN32.PNG"
	File "Palettes\Images\EMERGENCY EXIT SIGN64.PNG"
	File "Palettes\Images\EXHAUST FAN W-LIGHT32.PNG"
	File "Palettes\Images\EXHAUST FAN W-LIGHT64.PNG"
	File "Palettes\Images\EXHAUST FAN32.PNG"
	File "Palettes\Images\EXHAUST FAN64.PNG"
	File "Palettes\Images\EYEBALL RECESSED FIXTURE32.PNG"
	File "Palettes\Images\EYEBALL RECESSED FIXTURE64.PNG"
	File "Palettes\Images\FIRE ALARM CONTROL PANEL32.PNG"
	File "Palettes\Images\FIRE ALARM CONTROL PANEL64.PNG"
	File "Palettes\Images\FLOODLIGHT FIXTURE32.PNG"
	File "Palettes\Images\FLOODLIGHT FIXTURE64.PNG"
	File "Palettes\Images\Floor finish change32.PNG"
	File "Palettes\Images\Floor finish change64.PNG"
	File "Palettes\Images\FLOOR RECEPTACLE32.PNG"
	File "Palettes\Images\FLOOR RECEPTACLE64.PNG"
	File "Palettes\Images\FLUORESCENT FIXTURE32.PNG"
	File "Palettes\Images\FLUORESCENT FIXTURE64.PNG"
	File "Palettes\Images\FLUSH MOUNTED POWER PANEL32.PNG"
	File "Palettes\Images\FLUSH MOUNTED POWER PANEL64.PNG"
	File "Palettes\Images\GOST_GLASS32.PNG"
	File "Palettes\Images\GOST_GLASS64.PNG"
	File "Palettes\Images\GRAVEL32.PNG"
	File "Palettes\Images\GRAVEL64.PNG"
	File "Palettes\Images\Grid Bubble32.PNG"
	File "Palettes\Images\Grid Bubble64.PNG"
	File "Palettes\Images\GROUND FAULT RECEPT.32.PNG"
	File "Palettes\Images\GROUND FAULT RECEPT.64.PNG"
	File "Palettes\Images\GYPSUM32.PNG"
	File "Palettes\Images\GYPSUM64.PNG"
	File "Palettes\Images\Hatch tool_1070B06E-D2EF-4A64-9D2A-905BB5C048D9.PNG"
	File "Palettes\Images\Hatch tool_1070B06E-D2EF-4A64-9D2A-905BB5C048D9_2.PNG"
	File "Palettes\Images\Hatch tool_29EA7E5F-2355-40C7-B955-04105DC55807.PNG"
	File "Palettes\Images\Hatch tool_29EA7E5F-2355-40C7-B955-04105DC55807_2.PNG"
	File "Palettes\Images\Hatch tool_2B02008A-9A5D-4B9B-ADCB-FCDE2AB2DE4A.PNG"
	File "Palettes\Images\Hatch tool_2B02008A-9A5D-4B9B-ADCB-FCDE2AB2DE4A_2.PNG"
	File "Palettes\Images\Hatch tool_2B2C024C-A4EA-4F66-BB9C-8868EF6B4F3E.PNG"
	File "Palettes\Images\Hatch tool_2B2C024C-A4EA-4F66-BB9C-8868EF6B4F3E_2.PNG"
	File "Palettes\Images\Hatch tool_3C351D1F-553B-4F4D-9782-5B5A2E276693.PNG"
	File "Palettes\Images\Hatch tool_3C351D1F-553B-4F4D-9782-5B5A2E276693_2.PNG"
	File "Palettes\Images\Hatch tool_3DD4B75E-E995-4B6F-AF1C-06E3B7BDD711.PNG"
	File "Palettes\Images\Hatch tool_3DD4B75E-E995-4B6F-AF1C-06E3B7BDD711_2.PNG"
	File "Palettes\Images\Hatch tool_5303FB57-CAB5-437B-9978-8D6242CCD4EB.PNG"
	File "Palettes\Images\Hatch tool_5303FB57-CAB5-437B-9978-8D6242CCD4EB_2.PNG"
	File "Palettes\Images\Hatch tool_530B9C4E-F256-4DF8-9C13-EAB40B419BC9.PNG"
	File "Palettes\Images\Hatch tool_530B9C4E-F256-4DF8-9C13-EAB40B419BC9_2.PNG"
	File "Palettes\Images\Hatch tool_54470CCD-BA4A-4FF8-A846-0B8D5C310602.PNG"
	File "Palettes\Images\Hatch tool_54470CCD-BA4A-4FF8-A846-0B8D5C310602_2.PNG"
	File "Palettes\Images\Hatch tool_6966B164-66D3-44C4-82C7-E0BCA2AD0CDB.PNG"
	File "Palettes\Images\Hatch tool_6966B164-66D3-44C4-82C7-E0BCA2AD0CDB_2.PNG"
	File "Palettes\Images\Hatch tool_6B3F5778-D92D-49F8-90F1-A3C63F152E4F.PNG"
	File "Palettes\Images\Hatch tool_6B3F5778-D92D-49F8-90F1-A3C63F152E4F_2.PNG"
	File "Palettes\Images\Hatch tool_75EC4615-C746-420B-891B-0C0A13A77FF7.PNG"
	File "Palettes\Images\Hatch tool_75EC4615-C746-420B-891B-0C0A13A77FF7_2.PNG"
	File "Palettes\Images\Hatch tool_8D2EA578-5797-4654-A856-F6D1165492B0.PNG"
	File "Palettes\Images\Hatch tool_8D2EA578-5797-4654-A856-F6D1165492B0_2.PNG"
	File "Palettes\Images\Hatch tool_AF5FA740-A7E6-4FD5-BB3A-6C3500C0B5FD.PNG"
	File "Palettes\Images\Hatch tool_AF5FA740-A7E6-4FD5-BB3A-6C3500C0B5FD_2.PNG"
	File "Palettes\Images\Hatch tool_B14E313C-7AA6-4BDA-9A87-594494927166.PNG"
	File "Palettes\Images\Hatch tool_B14E313C-7AA6-4BDA-9A87-594494927166_2.PNG"
	File "Palettes\Images\Hatch tool_CAB98B8A-26A3-48F0-950C-69169C8FA8D3.PNG"
	File "Palettes\Images\Hatch tool_CAB98B8A-26A3-48F0-950C-69169C8FA8D3_2.PNG"
	File "Palettes\Images\Hatch tool_D664142E-8867-4550-9CE1-09F2AADA4F68.PNG"
	File "Palettes\Images\Hatch tool_D664142E-8867-4550-9CE1-09F2AADA4F68_2.PNG"
	File "Palettes\Images\Hatch tool_DBD239AA-BAF9-40E8-96E3-54F61B61CDB9.PNG"
	File "Palettes\Images\Hatch tool_DBD239AA-BAF9-40E8-96E3-54F61B61CDB9_2.PNG"
	File "Palettes\Images\Hatch tool_E43045ED-5C4C-46EC-81EC-CA4E74C378C2.PNG"
	File "Palettes\Images\Hatch tool_E43045ED-5C4C-46EC-81EC-CA4E74C378C2_2.PNG"
	File "Palettes\Images\Hatch tool_FB83FD13-771E-4A7A-A4A6-7DCA22455B0F.PNG"
	File "Palettes\Images\Hatch tool_FB83FD13-771E-4A7A-A4A6-7DCA22455B0F_2.PNG"
	File "Palettes\Images\Hatch tool_FEF91A1C-94E7-488B-8E59-1F1AF07A018A.PNG"
	File "Palettes\Images\Hatch tool_FEF91A1C-94E7-488B-8E59-1F1AF07A018A_2.PNG"
	File "Palettes\Images\HEAT DETECTOR32.PNG"
	File "Palettes\Images\HEAT DETECTOR64.PNG"
	File "Palettes\Images\HEAT_LIGHT & EXHAUST FAN32.PNG"
	File "Palettes\Images\HEAT_LIGHT & EXHAUST FAN64.PNG"
	File "Palettes\Images\HVAC COMPRESSOR32.PNG"
	File "Palettes\Images\HVAC COMPRESSOR64.PNG"
	File "Palettes\Images\Insolation32.PNG"
	File "Palettes\Images\Insolation64.PNG"
	File "Palettes\Images\Interior Elevation32.PNG"
	File "Palettes\Images\Interior Elevation64.PNG"
	File "Palettes\Images\Junction Box32.PNG"
	File "Palettes\Images\Junction Box64.PNG"
	File "Palettes\Images\Keynote32.PNG"
	File "Palettes\Images\Keynote64.PNG"
	File "Palettes\Images\Led 1W32.PNG"
	File "Palettes\Images\Led 1W64.PNG"
	File "Palettes\Images\Led 3-9W32.PNG"
	File "Palettes\Images\Led 3-9W64.PNG"
	File "Palettes\Images\Level32.PNG"
	File "Palettes\Images\Level64.PNG"
	File "Palettes\Images\North32.PNG"
	File "Palettes\Images\North64.PNG"
	File "Palettes\Images\PANIC BUTTON32.PNG"
	File "Palettes\Images\PANIC BUTTON64.PNG"
	File "Palettes\Images\Pendant Light32.PNG"
	File "Palettes\Images\Pendant Light64.PNG"
	File "Palettes\Images\PL32.PNG"
	File "Palettes\Images\PL64.PNG"
	File "Palettes\Images\PULL CHAIN CEILING FIXTURE32.PNG"
	File "Palettes\Images\PULL CHAIN CEILING FIXTURE64.PNG"
	File "Palettes\Images\QUADRUPLEX RECEPTACLE32.PNG"
	File "Palettes\Images\QUADRUPLEX RECEPTACLE64.PNG"
	File "Palettes\Images\Recessed Downlight32.PNG"
	File "Palettes\Images\Recessed Downlight64.PNG"
	File "Palettes\Images\RECESSED FIXTURE32.PNG"
	File "Palettes\Images\RECESSED FIXTURE64.PNG"
	File "Palettes\Images\RECESSED SYSTEM PANEL32.PNG"
	File "Palettes\Images\RECESSED SYSTEM PANEL64.PNG"
	File "Palettes\Images\REMOTE KEY PAD32.PNG"
	File "Palettes\Images\REMOTE KEY PAD64.PNG"
	File "Palettes\Images\REVISION32.PNG"
	File "Palettes\Images\REVISION64.PNG"
	File "Palettes\Images\Room Name-Number32.PNG"
	File "Palettes\Images\Room Name-Number64.PNG"
	File "Palettes\Images\SINGLE POLE RECEPTACLE32.PNG"
	File "Palettes\Images\SINGLE POLE RECEPTACLE64.PNG"
	File "Palettes\Images\Slot Light32.PNG"
	File "Palettes\Images\Slot Light64.PNG"
	File "Palettes\Images\SMOKE DETECTOR32.PNG"
	File "Palettes\Images\SMOKE DETECTOR64.PNG"
	File "Palettes\Images\SOLID32.PNG"
	File "Palettes\Images\SOLID64.PNG"
	File "Palettes\Images\SPECIAL CONNECTION32.PNG"
	File "Palettes\Images\SPECIAL CONNECTION64.PNG"
	File "Palettes\Images\Spot Elevation32.PNG"
	File "Palettes\Images\Spot Elevation64.PNG"
	File "Palettes\Images\SPRINKLER HEAD IN CEILING TILE32.PNG"
	File "Palettes\Images\SPRINKLER HEAD IN CEILING TILE64.PNG"
	File "Palettes\Images\SPRINKLER HEAD IN CEILING VOID HIGH LEVEL32.PNG"
	File "Palettes\Images\SPRINKLER HEAD IN CEILING VOID HIGH LEVEL64.PNG"
	File "Palettes\Images\SPRINKLER HEAD IN CEILING VOID LOW LEVEL32.PNG"
	File "Palettes\Images\SPRINKLER HEAD IN CEILING VOID LOW LEVEL64.PNG"
	File "Palettes\Images\SURFACE MOUNTED POWER PANEL32.PNG"
	File "Palettes\Images\SURFACE MOUNTED POWER PANEL64.PNG"
	File "Palettes\Images\SWITCH32.PNG"
	File "Palettes\Images\SWITCH64.PNG"
	File "Palettes\Images\SWITCHED RECEPTACLE32.PNG"
	File "Palettes\Images\SWITCHED RECEPTACLE64.PNG"
	File "Palettes\Images\TELEPHONE DISTRIBUTION FRAME32.PNG"
	File "Palettes\Images\TELEPHONE DISTRIBUTION FRAME64.PNG"
	File "Palettes\Images\TELEPHONE JACK32.PNG"
	File "Palettes\Images\TELEPHONE JACK64.PNG"
	File "Palettes\Images\TELEPHONE MAIN DISTRIBUTION FRAME32.PNG"
	File "Palettes\Images\TELEPHONE MAIN DISTRIBUTION FRAME64.PNG"
	File "Palettes\Images\TELEPHONE SOCKET32.PNG"
	File "Palettes\Images\TELEPHONE SOCKET64.PNG"
	File "Palettes\Images\TELEVISION JACK32.PNG"
	File "Palettes\Images\TELEVISION JACK64.PNG"
	File "Palettes\Images\THERMOSTAT32.PNG"
	File "Palettes\Images\THERMOSTAT64.PNG"
	File "Palettes\Images\Tube Light32.PNG"
	File "Palettes\Images\Tube Light64.PNG"
	File "Palettes\Images\VANITY LIGHT32.PNG"
	File "Palettes\Images\VANITY LIGHT64.PNG"
	File "Palettes\Images\VAPOR PROTECTED LIGHT32.PNG"
	File "Palettes\Images\VAPOR PROTECTED LIGHT64.PNG"
	File "Palettes\Images\VIDEO ENTRY PANEL32.PNG"
	File "Palettes\Images\VIDEO ENTRY PANEL64.PNG"
	File "Palettes\Images\VIDEO RECORDER32.PNG"
	File "Palettes\Images\VIDEO RECORDER64.PNG"
	File "Palettes\Images\View Title32.PNG"
	File "Palettes\Images\View Title64.PNG"
	File "Palettes\Images\WALL MOUNTED COMPACT FLUORESCENT LIGHT32.PNG"
	File "Palettes\Images\WALL MOUNTED COMPACT FLUORESCENT LIGHT64.PNG"
	File "Palettes\Images\WALL MOUNTED FIXTURE32.PNG"
	File "Palettes\Images\WALL MOUNTED FIXTURE64.PNG"
	File "Palettes\Images\Wall Mounted Fluorescent Light32.PNG"
	File "Palettes\Images\Wall Mounted Fluorescent Light64.PNG"
	File "Palettes\Images\WALL MOUNTED SPEAKER32.PNG"
	File "Palettes\Images\WALL MOUNTED SPEAKER64.PNG"
	File "Palettes\Images\Wall Section32.PNG"
	File "Palettes\Images\Wall Section64.PNG"
	File "Palettes\Images\Wall Type32.PNG"
	File "Palettes\Images\Wall Type64.PNG"
	File "Palettes\Images\WATERPROOF RECEPTACLE32.PNG"
	File "Palettes\Images\WATERPROOF RECEPTACLE64.PNG"
	File "Palettes\Images\Window Number32.PNG"
	File "Palettes\Images\Window Number64.PNG"
	File "Palettes\Images\WOOD BLOCK32.PNG"
	File "Palettes\Images\WOOD BLOCK64.PNG"
	File "Palettes\Images\WOOD FRAME32.PNG"
	File "Palettes\Images\WOOD FRAME64.PNG"

  
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


