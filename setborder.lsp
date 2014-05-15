(setq TPA_PATH (vl-registry-read  "HKEY_CURRENT_USER\\SOFTWARE\\TPA CAD Standards" "InstallDirectory"))

(defun c:A0 ()
	(import_tab (getunitlayout) "A0")
)


; 3) A2
; 4) A3
; 5) Cover Sheet A0
; 6) Cover Sheet A1
; 7) Cover Sheet A2
; 8) Cover Sheet A3
; 9) Model
; 10) Presentation A0
; 11) Presentation A1
; 12) Presentation A2
; 13) Presentation A3

;(command "DATALINKUPDATE" "U" "K")
; 14) Symbols A0
; 15) Symbols A1
; 16) Symbols A2-1
; 17) Symbols A2-2
; 18) Symbols A2-3
; 19) Symbols A3-1
; 20) Symbols A3-2
; 21) Symbols A3-3
; 22) Symbols A3-4
; 23) Symbols A3-5

(defun C:TPA-layout ()
	(if (= (getvar "insunits") 1)
		(import_tab "TPA Imperial.dwg")
		(import_tab "TPA Metric.dwg")
	)
)

(defun getunitlayout ()
	(if (= (getvar "insunits") 1)
		(setq ret "TPA Imperial.dwg")
		(setq ret "TPA Metric.dwg")
	)
	ret
)


(defun import_tab (dwgname layoutname / dbxdoc template-layouts acad doc count nn layout layname choice layouts lblk layout-content lst)
	(setq   dbxdoc (vla-GetInterfaceObject
		(vlax-get-acad-object)
			(strcat "objectdbx.axdbdocument." (substr (getvar 'acadver) 1 2))
		)
	)
	(vlax-invoke-method dbxdoc 'Open (findfile dwgname))
	(setq template-layouts (vlax-get-property dbxdoc 'Layouts))
	
	(setq acad (vlax-get-acad-object))
	(setq doc (vlax-get-property acad 'ActiveDocument)) ; dwg to insert into
;	(setq docs (vlax-get-property acad 'Documents))
;	(setq doc-template (vlax-invoke-method docs 'Open (strcat TPA_PATH "\\" dwgname)))
;    (setq template-layouts (vlax-get-property doc-template 'Layouts))
	(setq count (vlax-get-property template-layouts 'Count))
	(setq nn 0)
	(while (< nn count)
		(setq layout (vlax-invoke-method template-layouts 'Item nn))
		(setq layname (vlax-get-property layout 'Name))
		(if (= layoutname layname)
			(progn
			

				;(textscr)
				;(setq choice (1- (getint "\nChoose layout: ")))
				(setq layout (vlax-invoke-method template-layouts 'Item nn)) ;source
				(setq layname (vlax-get-property layout 'Name))
				(setq layouts (vlax-get-property doc 'Layouts))
				
				;(setlayoutname layname doc)
				(setq nlayout (vlax-invoke-method layouts 'Add layname)) ;target
				(vlax-put-property doc 'ActiveLayout nlayout)
				
				; (setq ff (vlax-get-property doc 'ActiveLayout))
				;(setq lblk (vlax-get-property layout 'Block))
				;(command "erase" "all" "")
				
				(vlax-invoke-method nlayout 'CopyFrom layout)
				(setq lblk (vlax-get-property layout 'Block)) ;source
				(setq layout-content (vlax-get-property nlayout 'Block)) ; target
				
				

				(setq lst '())
				(vlax-for obj lblk (setq lst (cons obj lst)))
				(vlax-invoke dbxdoc 'CopyObjects lst layout-content)
				
				; (command "DATALINKUPDATE" "U" "K")
				
				(vlax-put-property nlayout 'Name (strcat layname "  " (substr (rtos (getvar "cdate") 2 6) 10)))
				(vlax-release-object dbxdoc)
				
				(setq ssset (ssget "X" '((0 . "VIEWPORT"))))
				(command "erase" ssset "")
				(command "zoom" "e")
	
	
				)
		)
		;(princ (strcat (itoa (1+ nn)) ") " layname "\n"))
		(setq nn (1+ nn))
	)
	
	;(graphscr)
	(princ)
	
	
)


	
	

(defun setSheetSize (SheetSize); Units)
    (loadPlotConfigurations) ; make more efficient!
    (setq acad (vlax-get-acad-object))
	(setq doc (vlax-get-property acad 'ActiveDocument))
	
	(setq InsertUnits (getvar "insunits"))
	(setq LengthUnits (getvar "lunits"))
	(if (= LengthUnits 4)
	   (setq Units "Imperial")
	   (setq Units "Metric")
	)
	
	(setq ps (vlax-get-property doc 'PaperSpace))
	(setq blk (vlax-invoke-method ps'InsertBlock (vlax-3D-point (list 0 0 0)) (strcat TPA_PATH "\\TPA BORDER A0.dwg")  1.0 1.0 1.0 0.0))
	(vlax-put-property blk 'XEffectiveScaleFactor 1.0)
	(vlax-put-property blk 'YEffectiveScaleFactor 1.0)
	(vlax-put-property blk	'ZEffectiveScaleFactor 1.0)
	(setPlotConfig doc (strcat SheetSize " " Units))
	(putDynamicPropertyOnBlock blk "Lookup1" SheetSize)
	ps
)

(defun c:SymbolBlock ()
    (setq ps (setSheetSize "A1" "Metric"))

	(if (not (findfile "Sheet list.xlsx"))
	    (copyLocal "Sheet list.xlsx")
	)
	(setq blk (vlax-invoke-method ps'InsertBlock (vlax-3D-point (list 0 0 0)) (strcat TPA_PATH "\\Symbols.dwg")  1.0 1.0 1.0 0.0))
)
(defun copyLocal (excelFile)
    (vl-file-copy (strcat TPA_PATH "\\" excelFile) (strcat (getvar "DWGPREFIX") excelFile))
)


(defun setPlotConfig (doc configName)
   (setq lyt (vlax-get-property doc 'ActiveLayout))
	(setq cfg (vlax-get-property doc 'PlotConfigurations))
	(setq pc (vlax-invoke-method cfg 'Item configName))
	(vlax-invoke-method lyt 'CopyFrom pc)
	(vlax-invoke-method doc 'Regen acActiveViewport)
)
(defun putDynamicPropertyOnBlock (blk prop val / dbp nn limit prt pn ret)
   (setq dbp (vlax-variant-value(vlax-invoke-method blk 'GetDynamicBlockProperties)))
   	(setq nn 0)
	(setq limit (vlax-safearray-get-u-bound dbp 1))
	(while (<= nn limit)
	   (setq prt (vlax-safearray-get-element dbp nn))
	   (setq pn (vlax-get-property prt 'PropertyName))
       (if (= pn prop)
     	   ;(setq ret (vlax-variant-value(vlax-get-property prt 'Value)))
		   (setq ret (vlax-put-property prt 'Value val))
		)
	   (setq nn (1+ nn))
	)
	ret
)

(defun c:LoadRibbonTPA ()
  (setq acad (vlax-get-acad-object))
  (setq menugroups (vlax-get-property acad 'MenuGroups))
  (setq gg (vlax-invoke-method menugroups 'Load (strcat TPA_PATH "\\TPA CAD ribbon.cuix")))
)
(defun c:UnloadRibbonTPA ()
  (setq acad (vlax-get-acad-object))
  (setq menugroups (vlax-get-property acad 'MenuGroups))
   (setq cg (vlax-invoke-method menugroups 'Item "TPA_CAD_RIBBON"))
   (vlax-invoke-method gg 'Unload)
)
(defun loadPlotConfigurations ()
   (setq acad (vlax-get-acad-object))
   (setq doc (vlax-get-property acad 'ActiveDocument))
   (setq docs (vlax-get-property acad 'Documents))
   (setq template (vlax-invoke-method docs 'Open (strcat TPA_PATH "\\Print template.dwg")))
   (setq cfgtemplate (vlax-get-property template 'PlotConfigurations))
   (setq cfg (vlax-get-property doc 'PlotConfigurations))
   (setq count (vlax-get-property cfgtemplate 'Count))
   (setq nn 0)
   (while (< nn count)
      (setq pctemplate (vlax-invoke-method cfgtemplate 'Item nn))
	  (setq pcname (vlax-get-property pctemplate 'Name))
	  (setq pc (vlax-invoke-method cfg 'Add pcname))
	  (vlax-invoke-method pc 'CopyFrom pctemplate)
	  (setq nn (1+ nn))
	)
	(vlax-invoke-method template 'Close :vlax-false)
)