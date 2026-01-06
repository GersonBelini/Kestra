#Include 'Protheus.ch'

User Function RETCOM3()

	If GdFieldPos("C6_COMIS3") > 0
		For nG := 1 to len(aCols)
			aCols[nG][GdFieldPos("C6_COMIS3")] := M->C5_COMIS3
		Next
		oGetDad:oBrowse:Refresh(.T.)
	EndIf
	
Return M->C5_COMIS3


