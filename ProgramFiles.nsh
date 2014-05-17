; These can be found in a column in the excel checklist FilesToCopy tab
SetOutPath $INSTDIR  
File "setborder.lsp";
File "TPA Imperial.dwg";
File "TPA Metric.dwg";
File "TPA Imperial Start.dwt";
File "TPA Metric Start.dwt";
File "TPA CAD ribbon.cuix"; remove features and replace with open template imp, metric and open palette
File "TPA CAD ribbon.mnl"; lisps to load with menu
File "Sheet list.xlsx"; template sheet list for use in new projects - should be copied local on new template
File "LayerControl.lsp";main controller
File "TPA Blocks Template.dwg";holds all symbols
File "Layers List TPA Master.xls";
File "LayerControl.odcl";interface for layer control
File "OpenDCL.Runtime.7.0.0.12.msi";OpenDCL support     
File "TPA.stb"; print support file - moved to print directory on install
File "TPA install.scr";run once upon install

  
