;(setq PROJECTPATH "D:\\WORK\\2061 Cad Standards Architect\\Work\\")
(setq PROJECTPATH (strcat (vl-registry-read  "HKEY_LOCAL_MACHINE\\SOFTWARE\\TPA CAD Standards" "InstallDirectory") "\\"))
;(setq PROJECTPATH "C:\\Users\\ACT\\AppData\\Local\\TPA CAD Standards\\")

(defun c:LayerControl () ; loads and opens dialog box
   (command "OpenDCL")
   (Setq rValue (dcl_Project_Load (strcat PROJECTPATH "LayerControl.odcl") T))
   (Setq rValue (dcl_Form_Show LayerControl_Form1))
)

(defun c:LayerControl_Form1_OnCancel (/) ; closes dialog box
  (dcl_Form_Close LayerControl_Form1)
)
(defun c:LayerControl_Form1_OnInitialize (/ discipline category subcategory) ; initializes dialog
  (setq wb (connectToMaster))
  (clearall)
  (setq discipline (loadDisciplines wb))
;  (setq category (loadCategoriesFromDiscipline wb discipline))
 ; (setq subcategory (loadSubCategoriesFromCategory wb discipline category))
 ; (loadSecondarySubCategoriesFromSubCategory wb discipline category subcategory)

  (setq thislayer (strcat discipline "-" category))               ; check in 4 levels - if "" set layer, remove here
  (dcl_Control_SetCaption LayerControl_Form1_Label6 thislayer) 
  (showLayerProperties wb thislayer)
)

(defun clearall()   ; clears dialog box
   (dcl_ComboBox_Clear LayerControl_Form1_ComboBox1)
   (dcl_ComboBox_Clear LayerControl_Form1_ComboBox2)
   (dcl_ComboBox_Clear LayerControl_Form1_ComboBox3)
   (dcl_ComboBox_Clear LayerControl_Form1_ComboBox4)
   (dcl_Control_SetCaption LayerControl_Form1_Label6 "")
   (dcl_Control_SetText LayerControl_Form1_TextBox1 "Please refine your selection...")
   (dcl_Control_SetCaption LayerControl_Form1_Label11 "")
   (dcl_Control_SetCaption LayerControl_Form1_Label12 "")
   (dcl_Control_SetCaption LayerControl_Form1_Label13 "")
   (dcl_Control_SetCaption LayerControl_Form1_Label15 "")
)

(defun connectToMaster ()  ; connects to excel
   (setq excel (vlax-get-or-create-object "Excel.Application"))
   (setq wbs (vlax-get-property excel 'Workbooks))
   
   
   ;(vlax-get-property wbs 'Item "Layers List TPA Master.xls")
   (setq nn 1)
   (setq flag nil)
   (setq count (vlax-get-property wbs 'Count))
   (while (< nn count)
      (setq item (vlax-get-property wbs 'Item nn))
	  (setq tname (vlax-get-property item 'Name))
	  (if (= tname "Layers List TPA Master.xls")
	     (setq flag T)
	  )
	  (setq nn (1+ nn))
	)
   
   (if flag
      (setq wb (vlax-get-property wbs 'Item "Layers List TPA Master.xls"))
      (setq wb (vlax-invoke-method wbs 'Open (strcat PROJECTPATH "Layers List TPA Master.xls")))
	)
   
   
 ;  (setq names (vlax-get-property wb 'Names))
 ;  (setq tname (vlax-invoke-method names 'Item "Discipline"))
 ;  (setq range (vlax-get-property tname 'RefersToRange))
   
;   (setq value (vlax-variant-value(vlax-get-property range 'Value)))
;   (setq element (vlax-variant-value(vlax-safearray-get-element value 1 1)))
 )
 
(defun showLayerProperties (wb thislayername)   ; loads layer description to dialog box
	(setq names (vlax-get-property wb 'Names))						; get each range from excel
	(setq tname1 (vlax-invoke-method names 'Item "LayerName"))
	(setq range1 (vlax-get-property tname1 'RefersToRange))
	(setq tname2 (vlax-invoke-method names 'Item "Layercolor"))
	(setq range2 (vlax-get-property tname2 'RefersToRange))
	(setq tname3 (vlax-invoke-method names 'Item "Lineweight"))
	(setq range3 (vlax-get-property tname3 'RefersToRange)) 
	(setq tname4 (vlax-invoke-method names 'Item "Plot"))
	(setq range4 (vlax-get-property tname4 'RefersToRange))
	(setq tname5 (vlax-invoke-method names 'Item "Description"))
	(setq range5 (vlax-get-property tname5 'RefersToRange))
	(setq tname6 (vlax-invoke-method names 'Item "Linetype"))
	(setq range6 (vlax-get-property tname6 'RefersToRange))
	(setq value1 (vlax-variant-value(vlax-get-property range1 'Value)))
	(setq value2 (vlax-variant-value(vlax-get-property range2 'Value)))
	(setq value3 (vlax-variant-value(vlax-get-property range3 'Value)))
	(setq value4 (vlax-variant-value(vlax-get-property range4 'Value)))
	(setq value5 (vlax-variant-value(vlax-get-property range5 'Value)))
	(setq value6 (vlax-variant-value(vlax-get-property range6 'Value)))

	(setq nn 1)
	(setq limit (vlax-safearray-get-u-bound value1 1))
	(while (< nn limit)
		(setq element1 (vlax-variant-value (vlax-safearray-get-element value1 nn 1)))
		(if (eq element1 thislayername)															; find layername index
			(progn
				(setq element2 (vlax-variant-value (vlax-safearray-get-element value2 nn 1)))	; color
				(if (= (type 4.0) (type element2))
					(progn
						(dcl_Control_SetBackColor LayerControl_Form1_Label11 (fix element2))
						(dcl_Control_SetCaption LayerControl_Form1_Label11 (rtos element2 2 0))
					)
				)				
				(setq element3 (vlax-variant-value (vlax-safearray-get-element value3 nn 1)))	; lineweight
				(if (= (type 4.0) (type element2))
					(dcl_Control_SetCaption LayerControl_Form1_Label12 (rtos element3 2 3))
				)
				(setq element4 (vlax-variant-value (vlax-safearray-get-element value4 nn 1)))	; plot
				(if (= element4 "TRUE")
					(dcl_Control_SetCaption LayerControl_Form1_Label13 "True")
					(dcl_Control_SetCaption LayerControl_Form1_Label13 "False")
				)
				(setq element5 (vlax-variant-value (vlax-safearray-get-element value5 nn 1)))	; description
				(dcl_Control_SetText LayerControl_Form1_TextBox1 element5)
				(setq element6 (vlax-variant-value (vlax-safearray-get-element value6 nn 1)))	; linetype
				(dcl_Control_SetCaption LayerControl_Form1_Label15 element6)
			)
		)
		(setq nn (1+ nn))
	)
)
 
(defun loadDisciplines (wb / excel sheet range value nn limit lastelement ret)	; loads disciplines column from excel
	(setq names (vlax-get-property wb 'Names))
	(setq tname (vlax-invoke-method names 'Item "Discipline"))
	(setq range (vlax-get-property tname 'RefersToRange))
	(setq value (vlax-variant-value(vlax-get-property range 'Value)))
	(setq element (vlax-variant-value(vlax-safearray-get-element value 1 1)))

	(setq nn 1)
	(setq limit (vlax-safearray-get-u-bound value 1))
	(setq lastelement nil)
	(while (< nn limit)
		(setq element (vlax-variant-value (vlax-safearray-get-element value nn 1)))
		(if (/= element lastelement)
			(dcl_ComboBox_AddList LayerControl_Form1_ComboBox1 (list element))	   
		)
		(setq lastelement element)
		(setq nn (1+ nn))
	)
	(dcl_ComboBox_SetCurSel LayerControl_Form1_ComboBox1 2)
	(setq ret(dcl_ComboBox_GetEBText LayerControl_Form1_ComboBox1))
	(loadCategoriesFromDiscipline wb ret)
	ret
)

(defun loadCategoriesFromDiscipline (wb thisdiscipline / excel sheet range1 range2 value1 value2 nn limit lastelement element element2 ret)
   (dcl_ComboBox_Clear LayerControl_Form1_ComboBox2)
   
  (setq names (vlax-get-property wb 'Names))
  (setq tname1 (vlax-invoke-method names 'Item "Discipline"))
  (setq range1 (vlax-get-property tname1 'RefersToRange))
   (setq tname2 (vlax-invoke-method names 'Item "Category"))
  (setq range2 (vlax-get-property tname2 'RefersToRange))

   (setq value1 (vlax-variant-value(vlax-get-property range1 'Value)))
   (setq value2 (vlax-variant-value(vlax-get-property range2 'Value)))
   (setq nn 2)
   (setq limit (vlax-safearray-get-u-bound value1 1))
   (setq lastelement nil)
   (while (< nn limit)
		(setq element (vlax-variant-value (vlax-safearray-get-element value1 nn 1)))
		(if (= element thisdiscipline)
		    (progn
			    (setq element2 (vlax-variant-value (vlax-safearray-get-element value2 nn 1)))
				(if (/= element2 lastelement)
		           (dcl_ComboBox_AddList LayerControl_Form1_ComboBox2 (list element2))
				 )
		   )
		)
		(setq lastelement element2)
		(setq nn (1+ nn))
	)
	(dcl_ComboBox_SetCurSel LayerControl_Form1_ComboBox2 0)
	(setq ret (dcl_ComboBox_GetEBText LayerControl_Form1_ComboBox2))
	(loadSubCategoriesFromCategory wb thisdiscipline ret)
	ret
)
   

(defun loadSubCategoriesFromCategory (wb thisdiscipline thiscategory / excel sheet range1 range2 range3 thisdiscipline value1 value2 value3 limit element element2 element3 nn)
 (dcl_ComboBox_Clear LayerControl_Form1_ComboBox3)
 (dcl_ComboBox_AddList LayerControl_Form1_ComboBox3 (list ""))

   (setq names (vlax-get-property wb 'Names))
  (setq tname1 (vlax-invoke-method names 'Item "Discipline"))
  (setq range1 (vlax-get-property tname1 'RefersToRange))
   (setq tname2 (vlax-invoke-method names 'Item "Category"))
  (setq range2 (vlax-get-property tname2 'RefersToRange))
   (setq tname3 (vlax-invoke-method names 'Item "Subcategory"))
  (setq range3 (vlax-get-property tname3 'RefersToRange)) 
 

   (setq value1 (vlax-variant-value(vlax-get-property range1 'Value)))
   (setq value2 (vlax-variant-value(vlax-get-property range2 'Value)))
   (setq value3 (vlax-variant-value(vlax-get-property range3 'Value)))
   (setq nn 2)
   (setq limit (vlax-safearray-get-u-bound value1 1))
   (setq lastelement nil)
   (while (< nn limit)
		(setq element (vlax-variant-value (vlax-safearray-get-element value1 nn 1)))
		(if (= element thisdiscipline)
		    (progn
			    (setq element2 (vlax-variant-value (vlax-safearray-get-element value2 nn 1)))
				(if (= element2 thiscategory)
				   (progn
			          (setq element3 (vlax-variant-value (vlax-safearray-get-element value3 nn 1)))
				      (if (/= element3 lastelement)
		                 (dcl_ComboBox_AddList LayerControl_Form1_ComboBox3 (list element3))
				       )
					)
			    )
		   )
		)
		(setq lastelement element3)
		(setq nn (1+ nn))
	)
	(dcl_ComboBox_SetCurSel LayerControl_Form1_ComboBox3 0)
	(setq ret (dcl_ComboBox_GetEBText LayerControl_Form1_ComboBox3))
	(loadSecondarySubCategoriesFromSubCategory wb thisdiscipline thiscategory ret)
	ret
)
(defun loadSecondarySubCategoriesFromSubCategory (wb thisdiscipline thiscategory thissubcategory / excel sheet range1 range2 range3 thisdiscipline value1 value2 value3 limit element element2 element3 nn)
 (dcl_ComboBox_Clear LayerControl_Form1_ComboBox4)
 (dcl_ComboBox_AddList LayerControl_Form1_ComboBox4 (list ""))
 
    (setq names (vlax-get-property wb 'Names))
  (setq tname1 (vlax-invoke-method names 'Item "Discipline"))
  (setq range1 (vlax-get-property tname1 'RefersToRange))
   (setq tname2 (vlax-invoke-method names 'Item "Category"))
  (setq range2 (vlax-get-property tname2 'RefersToRange))
   (setq tname3 (vlax-invoke-method names 'Item "Subcategory"))
  (setq range3 (vlax-get-property tname3 'RefersToRange)) 
     (setq tname4 (vlax-invoke-method names 'Item "Secondary"))
  (setq range4 (vlax-get-property tname4 'RefersToRange))
  

   (setq value1 (vlax-variant-value(vlax-get-property range1 'Value)))
   (setq value2 (vlax-variant-value(vlax-get-property range2 'Value)))
   (setq value3 (vlax-variant-value(vlax-get-property range3 'Value)))
   (setq value4 (vlax-variant-value(vlax-get-property range4 'Value)))
   (setq nn 2)
   (setq limit (vlax-safearray-get-u-bound value1 1))
   (setq lastelement nil)
   (while (< nn limit)
		(setq element (vlax-variant-value (vlax-safearray-get-element value1 nn 1)))
		(if (= element thisdiscipline)
		    (progn
			    (setq element2 (vlax-variant-value (vlax-safearray-get-element value2 nn 1)))
				(if (= element2 thiscategory)
					(progn
						(setq element3 (vlax-variant-value (vlax-safearray-get-element value3 nn 1)))
						(if (= element3 thissubcategory);lastelement)
							(progn
								(setq element4 (vlax-variant-value (vlax-safearray-get-element value4 nn 1)))
								(if (/= element4 lastelement)
									(dcl_ComboBox_AddList LayerControl_Form1_ComboBox4 (list element4))
								)					
							)
						)
					)
			    )
			)
		)
		(setq lastelement element4)
		(setq nn (1+ nn))
	)
	(dcl_ComboBox_SetCurSel LayerControl_Form1_ComboBox4 0)
	(dcl_ComboBox_GetEBText LayerControl_Form1_ComboBox4)
	
)


  
(defun c:LayerControl_Form1_ComboBox1_OnSelChanged (ItemIndexOrCount Value / category)		; changed discipline
	(setq category (loadCategoriesFromDiscipline wb Value))
	(loadSubCategoriesFromCategory wb Value category)
	(setq thislayer (strcat Value "-" category))
	(dcl_Control_SetCaption LayerControl_Form1_Label6 thislayer)
	(showLayerProperties wb thislayer)
)

(defun c:LayerControl_Form1_ComboBox2_OnSelChanged (ItemIndexOrCount Value / discipline)	; changed category
	(setq discipline (dcl_ComboBox_GetEBText LayerControl_Form1_ComboBox1))
	(loadSubCategoriesFromCategory wb discipline Value)
	(setq thislayer (strcat discipline "-" Value))
	(dcl_Control_SetCaption LayerControl_Form1_Label6 thislayer)
	(showLayerProperties wb thislayer)
)

(defun c:LayerControl_Form1_ComboBox3_OnSelChanged (ItemIndexOrCount Value /)				; changed subcategory
	(setq discipline (dcl_ComboBox_GetEBText LayerControl_Form1_ComboBox1))
	(setq category (dcl_ComboBox_GetEBText LayerControl_Form1_ComboBox2))
	(loadSecondarySubCategoriesFromSubCategory wb discipline category Value)
	(setq thislayer (strcat discipline "-" category "-" Value))
	(dcl_Control_SetCaption LayerControl_Form1_Label6 thislayer)
	(showLayerProperties wb thislayer)
)

(defun c:LayerControl_Form1_ComboBox4_OnSelChanged (ItemIndexOrCount Value /)				; changed secondary
	(setq discipline (dcl_ComboBox_GetEBText LayerControl_Form1_ComboBox1))
	(setq category (dcl_ComboBox_GetEBText LayerControl_Form1_ComboBox2))
	(setq subcategory (dcl_ComboBox_GetEBText LayerControl_Form1_ComboBox3))
	(setq thislayer (strcat discipline "-" category "-" subcategory "-" Value))
	(dcl_Control_SetCaption LayerControl_Form1_Label6 thislayer)
	(showLayerProperties wb thislayer)
)
(defun c:LayerControl_Form1_TextButton1_OnClicked (/)										; set current layer
	(setq layerStandard (createLayer))
	(setq acad (vlax-get-acad-object))
	(setq doc (vlax-get-property acad 'ActiveDocument))
	(vlax-put-property doc 'ActiveLayer layerStandard) 
)
(defun createLayer ()																		; create layer from properties in dialog
	(setq acad (vlax-get-acad-object))
	(setq doc (vlax-get-property acad 'ActiveDocument))
	(setq layers (vlax-get-property doc 'Layers))
	(setq layerStandard (dcl_Control_GetCaption LayerControl_Form1_Label6))		; get layer name from dialog
	(setq layer (vlax-invoke-method layers 'Add layerStandard))					; create layer from name
	(setq colorStandard (dcl_Control_GetCaption LayerControl_Form1_Label11))	; color from dialog
	(vlax-put-property layer 'Color colorStandard)								; set layer color
	(setq plottedStandard (dcl_Control_GetCaption LayerControl_Form1_Label13))	; is plottable
	(if (= "True" plottedStandard)
		(vlax-put-property layer 'Plottable -1)
		(vlax-put-property layer 'Plottable 0)
	)
	(setq layerDescription (dcl_Control_GetText LayerControl_Form1_TextBox1))	; layer desciption
	(vlax-put-property layer 'Description layerDescription)

	(setq layerLinetype (dcl_Control_GetCaption LayerControl_Form1_Label15))		; layer linetype
	(setq ltypes (vlax-get-property doc 'Linetypes))
	(setq nn 0)
	(setq flag nil)
	(setq count (vlax-get-property ltypes 'Count))
	(while (< nn count)
		(setq ltype (vlax-invoke-method ltypes 'Item nn))
		(setq ltname (vlax-get-property ltype 'Name))
		(if (= (strcase layerLinetype) (strcase ltname))
	      (setq flag T)
		)
		(setq nn (1+ nn))
	)
	(if flag
		(setq lt (vlax-invoke-method ltypes 'Item layerLinetype))
		(setq lt (vlax-invoke-method ltypes 'Load layerLinetype "acad.lin"))
	)
	(vlax-put-property layer 'Linetype layerLinetype);layerLinetype

	layer
)

(defun c:LayerControl_Form1_TextButton2_OnClicked (/)
   (setq layer (createLayer))
   (setq layerStandard (vlax-get-property layer 'Name))
   (setq acad (vlax-get-acad-object))
   (setq doc (vlax-get-property acad 'ActiveDocument))
   (setq ss (ssget))
	 (setq count (sslength ss))
      (setq nn 0)
	  (while (< nn count)
	     (setq ent (ssname ss nn))
         (setq obj (vlax-ename->vla-object ent))
		 (vlax-put-property obj 'Color 256)
	     (vlax-put-property obj 'Layer layerStandard)
	     (setq nn (1+ nn))
	  )

)


;;--------------------------style controls
(defun c:LayerControl_Form1_TextButton3_OnClicked (/)
	(setq isBold (dcl_Control_GetValue LayerControl_Form1_CheckBox1))
	(setq dimChecked (dcl_Control_GetEnabled LayerControl_Form1_CheckBox2))

  (loadStyle "SSMALL" 1.6 isBold)
	(if dimChecked
		(loaddimstyle "SSMALL" 1.6)
	)
		
)
(defun c:LayerControl_Form1_TextButton4_OnClicked (/)
	(setq isBold (dcl_Control_GetValue LayerControl_Form1_CheckBox1))
	(setq dimChecked (dcl_Control_GetEnabled LayerControl_Form1_CheckBox2))
  (loadStyle "SMALL" 2.4 isBold)
	(if dimChecked
		(loaddimstyle "SMALL" 2.4)
	)
)
(defun c:LayerControl_Form1_TextButton5_OnClicked (/)
	(setq isBold (dcl_Control_GetValue LayerControl_Form1_CheckBox1))
	(setq dimChecked (dcl_Control_GetEnabled LayerControl_Form1_CheckBox2))
  (loadStyle "MEDIUM" 3.2 isBold)
	(if dimChecked
		(loaddimstyle "MEDIUM" 3.2)
	)
)
(defun c:LayerControl_Form1_TextButton6_OnClicked (/)
	(setq isBold (dcl_Control_GetValue LayerControl_Form1_CheckBox1))
	(setq dimChecked (dcl_Control_GetEnabled LayerControl_Form1_CheckBox2))
  (loadStyle "LARGE" 4.8 isBold)
	(if dimChecked
		(loaddimstyle "LARGE" 4.8)
	)
)
(defun c:LayerControl_Form1_TextButton7_OnClicked (/)
	(setq isBold (dcl_Control_GetValue LayerControl_Form1_CheckBox1))
	(setq dimChecked (dcl_Control_GetEnabled LayerControl_Form1_CheckBox2))
  (loadStyle "LLARGE" 6.35 isBold)
	(if dimChecked
		(loaddimstyle "LLARGE" 6.35)
	)
)





(defun loadStyle (basestyle height isBold)
	(if (= (getvar "LUNITS") 4)
		(setq height (/ height 25.4))
	)
  
  (if (= isBold 1)
     (setq stylename (strcat basestyle " BOLD"))
	 (setq stylename basestyle)
   )
  (setq acad (vlax-get-acad-object))
  (setq doc (vlax-get-property acad 'ActiveDocument))
  (setq textStyles (vlax-get-property doc 'TextStyles))
  (setq textStyle (vlax-invoke-method textStyles 'Add stylename))
    (if (= isBold 1)
       (setq fontfile (findfile (strcat (getenv "WINDIR") "\\fonts\\arialbd.ttf")))
	   (setq fontfile (findfile (strcat (getenv "WINDIR") "\\fonts\\arial.ttf")))
    )
   (vlax-put-property textStyle 'fontFile fontfile)
  (vlax-put-property textStyle 'Height height)
  (SetTxtAnnotative stylename)
  (vlax-put-property doc 'ActiveTextStyle textStyle)
  (setq currentLayer (getvar "clayer"))
  (if (not (wcmatch currentLayer "*ANNO*"))
     (alert "Be sure to set layer to annotation layer!")
  )
)

(defun loaddimstyle (basestyle height)
	(if (= (getvar "LUNITS") 4)
		(progn
			(setvar "DIMLUNIT" 4)
			(setq height (/ height 25.4))
		)
	   (setvar "DIMLUNIT" 2)
	)
	(setq acad (vlax-get-acad-object))
	(setq doc (vlax-get-property acad 'ActiveDocument))
	(setq dimStyles (vlax-get-property doc 'DimStyles))
	;(setq dimStyle (vlax-invoke-method dimStyles 'Add basestyle))

	(setvar "DIMASSOC" 2)
	(setvar "DIMASZ" height)
	(setvar "DIMATFIT" 3)
	(setvar "DIMAUNIT" 0)
	(setvar "DIMAZIN" 0)
	(setvar "DIMCEN" (* 0.5 height))
	(setvar "DIMCLRD" 0)
	(setvar "DIMCLRE" 0)
	(setvar "DIMCLRT" 0)
	(setvar "DIMCONSTRAINTICON" 3)
	(setvar "DIMCONTINUEMODE" 1)
	(setvar "DIMDEC" 1)
	(setvar "DIMDLE" 0.0000)
	(setvar "DIMDLI" (* 2.11 height))
	(setvar "DIMEXE" height)
	(setvar "DIMEXO" (* 0.3472 height))
	(setvar "DIMFRAC" 0)
	(setvar "DIMFXL" 1.0000)
	(setvar "DIMFXLON" 0)
	(setvar "DIMGAP" (* 0.5 height))
	(setvar "DIMJOGANG" 0.7854)
	(setvar "DIMJUST" 0)
	(setvar "DIMLFAC" 1.0000)
	(setvar "DIMLIM" 0)
	
	(setvar "DIMLWD" -2)
	(setvar "DIMLWE" -2)
	(setvar "DIMRND" 0.0000)
	(setvar "DIMSAH" 0)
	(setvar "DIMSD1" 0)
	(setvar "DIMSD2" 0)
	(setvar "DIMSE1" 0)
	(setvar "DIMSE2" 0)
	(setvar "DIMSOXD" 0)
	(setvar "DIMTAD" 1)
	(setvar "DIMTDEC" 1)
	(setvar "DIMTXSTY" basestyle)
	(setvar "DIMTFAC" 1.0000)
	(setvar "DIMTFILL" 0)
	(setvar "DIMTFILLCLR" 0)
	(setvar "DIMTIH" 1)
	(setvar "DIMTIX" 0)
	(setvar "DIMTM" 0.0000)
	(setvar "DIMTMOVE" 0)
	(setvar "DIMTOFL" 0)
	(setvar "DIMTOH" 1)
	(setvar "DIMTOL" 0)
	(setvar "DIMTOLJ" 1)
	(setvar "DIMTP" 0.0000)
	(setvar "DIMTSZ" 0.0000)
	(setvar "DIMTVP" 0.0000)
	(setvar "DIMTXT" height)
	(setvar "DIMTXTDIRECTION" 0)
	(setvar "DIMTZIN" 0)
	(setvar "DIMUPT" 0)
	(setvar "DIMZIN" 0)

	(command "dimstyle" "s" basestyle)
	(while (= (getvar "cmdnames") "DIMSTYLE")
	   (command "y")
	)
    (SetDimAnnotative basestyle)


	(setq currentLayer (getvar "clayer"))
	(if (not (wcmatch currentLayer "*ANNO*"))
		(alert "Be sure to set layer to annotation layer!")
	)
)
(defun setDimBreak (dimStyleName newVal / aa qq)
	(setq ds
		(vla-item 
			(vla-get-dimstyles
				(vla-get-activedocument (vlax-get-acad-object))
			)
			dimStyleName
		)
	)
	(vlax-invoke-method ds 'GetXData "ACAD_DSTYLE_DIMBREAK" 'aa 'qq)
	(if aa
		(vlax-safearray-put-element qq 2 newVal)
		(progn
																;http://docs.autodesk.com/ACD/2013/ENU/index.html?url=files/GUID-E0D40331-096B-4A52-A0D7-10204829C4A6.htm,topicNumber=d30e638652
			(setq aa (vlax-make-safearray 2 '(0 . 2)))
			(vlax-safearray-put-element aa 0 1001)
			(vlax-safearray-put-element aa 1 1070)
			(vlax-safearray-put-element aa 2 1040)
			(setq qq (vlax-make-safearray 12 '(0 . 2)))
			(vlax-safearray-put-element qq 0 "ACAD_DSTYLE_DIMBREAK")
			(vlax-safearray-put-element qq 1 391)
			(vlax-safearray-put-element qq 2 newVal)
		)
	)
	(vlax-invoke-method ds 'SetXData aa qq)
)



;;; These functions will set an existing DIMSTYLE or TEXTSTYLE ANNOTATIVE
;;;
;;; For Dimstyles use the following
;;; (SetDimAnnotative "Style Name")
;;;
;;; For Text Styles use the following
;;; (SetTxtAnnotative "Style Name")
;;;
;;; Original Code by: Harrie Zeha
;;; Autodesk discussion post thread:
;;; http://discussion.autodesk.com/thread.jspa?messageID=5730957


(defun SetDimAnnotative (Name / *doc* *dims* app xd1 xd2 rt1 rt2)
  (vl-load-com)
  (setq	*dims* (vla-get-dimstyles
		 (vla-get-activedocument (vlax-get-acad-object))
	       )
  )
  (vlax-for itm	*dims*
    (setq *dimstl* (cons (vla-get-name itm) *dimstl*))
  )
  (if (member Name *dimstl*)
    (progn
      (setq obj	(vla-item *dims* Name)
	    app	"AcadAnnotative"
      )
      (regapp app)
      (setq xd1 (vlax-make-safearray vlax-vbInteger '(0 . 5)))
      (vlax-safearray-fill
	xd1
	(list 1001 1000 1002 1070 1070 1002)
      )
      (setq xd2 (vlax-make-safearray vlax-vbVariant '(0 . 5)))
      (vlax-safearray-fill
	xd2
	(list "AcadAnnotative"
	      "AnnotativeData"
	      "{"
	      (vlax-make-variant 1 vlax-vbInteger)
	      (vlax-make-variant 1 vlax-vbInteger)
	      "}"
	)
      )
      (vla-setxdata obj xd1 xd2)
      (vla-getxdata obj app 'rt1 'rt2)
      (mapcar
	(function (lambda
		    (x y)
		     (cons x y)
		  )
	)
	(vlax-safearray->list rt1)
	(mapcar 'vlax-variant-value (vlax-safearray->list rt2))
      )
    )
  )
)

(defun SetTxtAnnotative (Name / *doc* *text* app xd1 xd2 rt1 rt2)
  (vl-load-com)
  (setq	*text* (vla-get-textstyles
		 (vla-get-activedocument (vlax-get-acad-object))
	       )
  )
  (vlax-for itm	*text*
    (setq *textstl* (cons (vla-get-name itm) *textstl*))
  )
  (if (member Name *textstl*)
    (progn
      (setq obj	(vla-item *text* Name)
	    app	"AcadAnnotative"
      )
      (regapp app)
      (setq xd1 (vlax-make-safearray vlax-vbInteger '(0 . 5)))
      (vlax-safearray-fill
	xd1
	(list 1001 1000 1002 1070 1070 1002)
      )
      (setq xd2 (vlax-make-safearray vlax-vbVariant '(0 . 5)))
      (vlax-safearray-fill
	xd2
	(list "AcadAnnotative"
	      "AnnotativeData"
	      "{"
	      (vlax-make-variant 1 vlax-vbInteger)
	      (vlax-make-variant 1 vlax-vbInteger)
	      "}"
	)
      )
      (vla-setxdata obj xd1 xd2)
      (vla-getxdata obj app 'rt1 'rt2)
      (mapcar
	(function (lambda
		    (x y)
		     (cons x y)
		  )
	)
	(vlax-safearray->list rt1)
	(mapcar 'vlax-variant-value (vlax-safearray->list rt2))
      )
    )
  )
)

