#Include 'Protheus.ch'

User Function PEWFITPC()
	Local nRet		:= 0         
	Local xArea		:= GetArea()
	Local cTipo		:= PARAMIXB[1]
	Local oHtml		:= PARAMIXB[2]
	Local cUM		:= SC7->C7_UM
	Local nQuant	:= SC7->C7_QUANT
	Local nPrcUni	:= SC7->C7_PRECO
	Local cMoedaPC	:= ""

	If cTipo == "PC"
		nRet := SC7->C7_TOTAL
		
		dbSelectArea("SB1")
		dbSetOrder(1)
		dbSeek(xFilial("SB1")+SC7->C7_PRODUTO)    
		
		dbSelectArea("SA5")
		dbSetOrder(1)//A5_FILIAL+A5_FORNECE+A5_LOJA+A5_PRODUTO
		If dbSeek(xFilial("SA5")+SC7->C7_FORNECE+SC7->C7_LOJA+SC7->C7_PRODUTO)    
			If !empty(SA5->A5_UNID) .AND. !empty(SA5->A5_ZZFATOR) .AND. !empty(SA5->A5_ZZTPCON)		
				cUM := SA5->A5_UNID
				If SA5->A5_ZZTPCON == "M"
					nQuant	:= nQuant * SA5->A5_ZZFATOR								
				ElseIf SA5->A5_ZZTPCON == "D"
					nQuant	:= nQuant / SA5->A5_ZZFATOR				
				EndIf				
				nPrcUni := SC7->C7_TOTAL / nQuant 
			EndIf	
		EndIf	
		
		If SC7->C7_MOEDA == 1
			cMoedaPC := "R$"
		ElseIf SC7->C7_MOEDA == 2 .OR. SC7->C7_MOEDA == 6 
			cMoedaPC := "US$"
		ElseIf SC7->C7_MOEDA == 4 .OR. SC7->C7_MOEDA == 5 
			cMoedaPC := "EUR"
		ElseIf SC7->C7_MOEDA == 7 .OR. SC7->C7_MOEDA == 8
			cMoedaPC := "£"
		EndIf
	
		
		aAdd((oHtml:ValByName( "tb.item"))			, SC7->C7_ITEM)
		aAdd((oHtml:ValByName( "tb.descricao"))		, SC7->C7_DESCRI)
		aAdd((oHtml:ValByName( "tb.unid"))			, cUM)
		aAdd((oHtml:ValByName( "tb.quant"))			, nQuant)
		aAdd((oHtml:ValByName( "tb.moeda"))			, cMoedaPC)
		aAdd((oHtml:ValByName( "tb.preco"))			, nPrcUni)
		aAdd((oHtml:ValByName( "tb.total"))			, SC7->C7_TOTAL)
		aAdd((oHtml:ValByName( "tb.entrega"))		, SC7->C7_DATPRF)
		aAdd((oHtml:ValByName( "tb.ultprc"))		, SB1->B1_UPRC)
		aAdd((oHtml:ValByName( "tb.cc"))			, SC7->C7_CC)
		aAdd((oHtml:ValByName( "tb.observ"))		, iif(Empty(SC7->C7_OBS),CriaVar("C7_OBS",.f.),SC7->C7_OBS))
	EndIf		
        
	RestArea(xArea)
Return nRet



