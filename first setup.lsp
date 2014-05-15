(setq TPA_PATH (vl-registry-read  "HKEY_LOCAL_MACHINE\\SOFTWARE\\TPA CAD Standards" "InstallDirectory"))

(defun c:LoadRibbonTPA ()
  (setq acad (vlax-get-acad-object))
  (setq menugroups (vlax-get-property acad 'MenuGroups))
  (setq gg (vlax-invoke-method menugroups 'Load (strcat TPA_PATH "\\TPA CAD ribbon.cuix")))
)
(defun c:UnloadRibbonTPA ()
  (setq acad (vlax-get-acad-object))
  (setq menugroups (vlax-get-property acad 'MenuGroups))
   (setq cg (vlax-invoke-method menugroups 'Item "TPA_CAD_RIBBON"))
   (vlax-invoke-method cg 'Unload)
)
(defun copyFile (fromDir toDir fileName)
	(vl-file-copy
		(strcat fromDir "\\" fileName)
		(strcat toDir "\\" fileName)
	)
)
(copyfile TPA_PATH (getenv "PrinterStyleSheetDir") "TPA.stb")

;(vla-get-ToolPalettePath (vla-get-files (vla-get-preferences (vlax-get-acad-object))))
; expand to add path to TPA directory and access atc files (toolpalette files)
; http://goldtack.wordpress.com/intro_acad_toolpalettes/