#Include 'Protheus.ch'
#Include 'Topconn.ch'

/*/{Protheus.doc} ratFunci

Faz o rateio por Funcionarios. Opção 03.
	
@author André Oquendo
@since 14/04/2015

@param dDemiDe		, Data		, Data da demissão de
@param dDemiAte	, Data		, Data da demissão até

/*/

User Function ratFunci(dDemiDe,dDemiAte)
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
			nQtdRat 	:= buscaFun(CTQ->CTQ_CCCPAR,dDemiDe,dDemiAte)
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

/*/{Protheus.doc} buscaFun

Retorna o total de funcionarios por centro de custo.
	
@author André Oquendo
@since 14/04/2015

@param cCC			, String	, Centro de custo
@param dDemiDe		, Data		, Data da demissão de
@param dDemiAte	, Data		, Data da demissão até

@return Numerico Somatoria dos funcionarios
/*/

Static Function buscaFun(cCC,dDemiDe,dDemiAte)   
	Local cQuery			:= ""
	Local nRet				:= 0
	
	cQuery := " SELECT " + CRLF		
	cQuery += "	COUNT(RA_MAT) as TOTAL									" + CRLF
	cQuery += " FROM " + RetSqlName("SRA") + " SRA						" + CRLF	
	cQuery += " WHERE 														" + CRLF
	cQuery += "	   	SRA.D_E_L_E_T_ 	= 	' ' 							" + CRLF
	cQuery += "	   	AND RA_DEMISSA = 	' '									" + CRLF		
	cQuery += "	   	OR (RA_DEMISSA >= 	'"+dDemiDe+"'					" + CRLF
	cQuery += "	   	AND RA_DEMISSA <= 	'"+dDemiAte+"')				" + CRLF	
	cQuery += "	   	AND RA_CC 	= 	'"+cCC+"'					 			" + CRLF	
	
	TcQuery cQuery New Alias "QRYRATEIO"
	QRYRATEIO->(DbGoTop())
	
	If QRYRATEIO->(!Eof())
		nRet := QRYRATEIO->TOTAL
	EndIf
	
	QRYRATEIO->(DbCloseArea())

Return nRet

/*/{Protheus.doc} buscaRat

Busca os rateios do tipo 03 - Numero de Funcionarios
	
@author André Oquendo
@since 14/04/2015

/*/

Static Function buscaRat()   
	Local cQuery			:= ""
	
	cQuery := " SELECT " + CRLF		
	cQuery += "	CTQ_RATEIO 										" + CRLF
	cQuery += " FROM " + RetSqlName("CTQ") + " CTQ 						" + CRLF
	cQuery += " WHERE 														" + CRLF
	cQuery += "	   	CTQ.D_E_L_E_T_ 	= 	' ' 							" + CRLF
	cQuery += "	   	AND CTQ_ZZCRAT 	= 	'03'					 		" + CRLF
	cQuery += " GROUP BY CTQ_RATEIO" + CRLF
	
	TcQuery cQuery New Alias "QRYRATEIO"
	QRYRATEIO->(DbGoTop())

Return