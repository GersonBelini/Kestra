#Include 'Protheus.ch'

User Function RETCOM2()
	
	If GdFieldPos("C6_COMIS2") > 0
		For nG := 1 to len(aCols)
			aCols[nG][GdFieldPos("C6_COMIS2")] := M->C5_COMIS2
		Next
		oGetDad:oBrowse:Refresh(.T.)
	EndIf
	
Return M->C5_COMIS2

