#Include 'Protheus.ch'
#Include 'Topconn.ch'

/*/{Protheus.doc} ratHrHom

Faz o rateio por Horas Homem Trabalhadas. Opção 01.
	
@author André Oquendo
@since 10/04/2015

@param dProdDe		, Data		, Data da apuração de
@param dProdAte	, Data		, Data da apuração até

/*/

User Function ratHrHom(dProdDe,dProdAte)
	Local nQtdRat		:= 0
	Local nTotRat		:= 0
	
	Local nTotPerc	:= 100
	Local nQtdPerc	:= 0
	Local nContRat	:= 0
	

	buscaRat()
	While QRYRATEIO->(!Eof())
		IncProc("Calculando. Aguarde...")
		nTotRat 	:= 0
		nContRat	:= 0
		nTotPerc	:= 100
		
		//Vejo o total de horas
		dbSelectArea("CTQ")
		dbSetOrder(1)//CTQ_FILIAL+CTQ_RATEIO+CTQ_SEQUEN
		dbSeek(xFilial("CTQ")+QRYRATEIO->CTQ_RATEIO)
		While CTQ->(!Eof()) .AND. CTQ->CTQ_RATEIO == QRYRATEIO->CTQ_RATEIO
			nQtdRat 	:= buscaSH6(CTQ->CTQ_CCCPAR,dProdDe,dProdAte)
			nTotRat 	+= nQtdRat
			nContRat++
			RecLock("CTQ",.F.)
				CTQ->CTQ_ZZQTDE  := nQtdRat		
			MsUnLock()
			CTQ->(DbSkip())			
		EndDo
		
		//Acho o rateio
		dbSelectArea("CTQ")
		dbSetOrder(1)//CTQ_FILIAL+CTQ_RATEIO+CTQ_SEQUEN
		dbSeek(xFilial("CTQ")+QRYRATEIO->CTQ_RATEIO)		
		While CTQ->(!Eof()) .AND. CTQ->CTQ_RATEIO == QRYRATEIO->CTQ_RATEIO
			If nContRat == 1
				nQtdPerc := nTotPerc
			Else
				nQtdPerc := ROUND((CTQ->CTQ_ZZQTDE*100)/nTotRat,2)
				nTotPerc -= nQtdPerc
				nContRat--
			EndIf
			
			
			RecLock("CTQ",.F.)
				CTQ->CTQ_PERCEN  := nQtdPerc		
			MsUnLock()
			CTQ->(DbSkip())			
		EndDo
		
		QRYRATEIO->(DbSkip())			
	EndDo			
	QRYRATEIO->(DbCloseArea())
Return

/*/{Protheus.doc} buscaSH6

Retorna o total de tempo gasto no centro de custo
	
@author André Oquendo
@since 10/04/2015

@param cCC			, String	, Centro de custo
@param dProdDe		, Data		, Data da apuração de
@param dProdAte	, Data		, Data da apuração até

@return Numerico Somatoria do tempo gasto
/*/

Static Function buscaSH6(cCC,dProdDe,dProdAte)   
	Local cQuery			:= ""
	Local nRet				:= 0
	
	cQuery := " SELECT " + CRLF		
	cQuery += "	SUM(H6_TEMPO) as TOTAL									" + CRLF
	cQuery += " FROM " + RetSqlName("SH6") + " SH6 						" + CRLF
	cQuery += " INNER JOIN " + RetSqlName("SRA") + " SRA ON				" + CRLF
	cQuery += " RA_MAT = H6_ZZMAT AND SRA.D_E_L_E_T_ = ' '				" + CRLF
	cQuery += " WHERE 														" + CRLF
	cQuery += "	   	SH6.D_E_L_E_T_ 	= 	' ' 							" + CRLF		
	cQuery += "	   	AND H6_DATAINI >= 	'"+dProdDe+"'					" + CRLF
	cQuery += "	   	AND H6_DATAFIN <= 	'"+dProdAte+"'				" + CRLF	
	cQuery += "	   	AND RA_CC 	= 	'"+cCC+"'					 			" + CRLF	
	
	TcQuery cQuery New Alias "QRYRATEIO"
	QRYRATEIO->(DbGoTop())
	
	If QRYRATEIO->(!Eof())
		nRet := QRYRATEIO->TOTAL
	EndIf
	
	QRYRATEIO->(DbCloseArea())

Return nRet

/*/{Protheus.doc} buscaRat

Busca os rateios do tipo 01 - horas homem trabalhadas
	
@author André Oquendo
@since 10/04/2015

/*/

Static Function buscaRat()   
	Local cQuery			:= ""
	
	cQuery := " SELECT " + CRLF		
	cQuery += "	CTQ_RATEIO 										" + CRLF
	cQuery += " FROM " + RetSqlName("CTQ") + " CTQ 						" + CRLF
	cQuery += " WHERE 														" + CRLF
	cQuery += "	   	CTQ.D_E_L_E_T_ 	= 	' ' 							" + CRLF
	cQuery += "	   	AND CTQ_ZZCRAT 	= 	'01'					 		" + CRLF
	cQuery += " GROUP BY CTQ_RATEIO" + CRLF
	
	TcQuery cQuery New Alias "QRYRATEIO"
	QRYRATEIO->(DbGoTop())

Return