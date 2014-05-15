  File "setborder.lsp"
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
  
!include PalettesAndImages.nsh