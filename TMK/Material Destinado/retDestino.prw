#Include 'Protheus.ch'
#Include 'TopConn.ch'

User Function retDestino(cDoc,cSerie)
	Local cRet		:= ""
	Local cQuery	:= ""
	
	cQuery := "SELECT C5_ZZAPLIC "+CRLF
	cQuery += "FROM " +CRLF
	cQuery +=		RetSqlName("SC5") + " SC5 "+CRLF
	cQuery += "INNER JOIN "+RetSqlName("SD2")+" SD2 ON C5_FILIAL = D2_FILIAL AND D2_PEDIDO = C5_NUM "+CRLF
	cQuery += "	AND D2_DOC = '"+cDoc+"'  AND D2_SERIE = '"+cSerie+"' AND SD2.D_E_L_E_T_ = ' ' "+CRLF	
	cQuery += "WHERE "+CRLF
	cQuery += "	SC5.D_E_L_E_T_ = ' ' "+CRLF
	cQuery += " AND	C5_FILIAL = '" + xFilial("SC5") + "' "+CRLF	
		
	TCQUERY cQuery NEW ALIAS "retDest"
	
	retDest->(dbgotop()) 
	If retDest->(!Eof())
		                        
		aTemp		:= RetSX3Box(GetSX3Cache("C5_ZZAPLIC","X3_CBOX"),,,1)
		aCombo		:= {}	
		For nG := 1 to len(aTemp)
			aadd(aCombo,{aTemp[nG][2],aTemp[nG][3]})
		Next
		
		nPos		:= AScan(aCombo, {|aX| aX[1] == retDest->C5_ZZAPLIC})
		If nPos > 0
			cRet := "MATERIAL DESTINA-SE A: "+ aCombo[nPos][2]	
		EndIf					
	EndIf
	retDest->(dbCloseArea())

Return cRet