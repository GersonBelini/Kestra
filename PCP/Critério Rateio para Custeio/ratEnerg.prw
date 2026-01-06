#Include 'Protheus.ch'
#Include 'Topconn.ch'

/*/{Protheus.doc} ratEnerg

Faz o rateio por Horas Maquinas Trabalhadas. Opção 02.
	
@author André Oquendo
@since 14/04/2015

@param dProdDe		, Data		, Data da apuração de
@param dProdAte	, Data		, Data da apuração até

/*/

User Function ratEnerg(dProdDe,dProdAte)
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
			nQtdRat 	:= buscaSD3(CTQ->CTQ_CCCPAR,dProdDe,dProdAte)
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

/*/{Protheus.doc} buscaSD3

Retorna o total de energia eletrica gasta no centro de custo.
	
@author André Oquendo
@since 14/04/2015

@param cCC			, String	, Centro de custo
@param dProdDe		, Data		, Data da apuração de
@param dProdAte	, Data		, Data da apuração até

@return Numerico Somatoria da quantidade gasta
/*/

Static Function buscaSD3(cCC,dProdDe,dProdAte)   
	Local cQuery			:= ""
	Local cQry2			:= ""
	Local nRet				:= 0
	
	cQuery := " SELECT " + CRLF		
	cQuery += "	D3_QUANT, D3_COD, D3_OP, D3_NUMSEQ						" + CRLF
	cQuery += " FROM " + RetSqlName("SD3") + " SD3 						" + CRLF	
	cQuery += " WHERE 														" + CRLF
	cQuery += "	   	SD3.D_E_L_E_T_ 	= 	' ' 							" + CRLF		
	cQuery += "	   	AND D3_EMISSAO >= 	'"+dProdDe+"'					" + CRLF
	cQuery += "	   	AND D3_EMISSAO <= 	'"+dProdAte+"'				" + CRLF	
	cQuery += "	   	AND D3_COD 	= 	'MOD"+cCC+"'			 			" + CRLF		
	
	TcQuery cQuery New Alias "QRYRATEIO"
	QRYRATEIO->(DbGoTop())
	
	While QRYRATEIO->(!Eof())
		cQry2 := " SELECT " + CRLF		
		cQry2 += " H6_RECURSO												" + CRLF
		cQry2 += " FROM " + RetSqlName("SH6") + " SH6						" + CRLF	
		cQry2 += " WHERE 														" + CRLF
		cQry2 += "	   	SH6.D_E_L_E_T_ = 	' ' 								" + CRLF		
		cQry2 += "	   	AND H6_PROD = '"+QRYRATEIO->D3_COD+"'				" + CRLF
		cQry2 += "	   	AND H6_OP = '"+QRYRATEIO->D3_OP+"'					" + CRLF	
		cQry2 += "	   	AND H6_IDENT = '"+QRYRATEIO->D3_NUMSEQ+"'			" + CRLF
		TcQuery cQuery New Alias "QRYAUX"
		QRYAUX->(DbGoTop())
		If QRYAUX->(!Eof())
			dbSelectArea("SH1")
			dbSetOrder(1)//H1_FILIAL+H1_CCUSTO
			If dbSeek(xFilial("SH1")+QRYAUX->H6_RECURSO)
				nRet += QRYRATEIO->D3_QUANT * SH1->H1_HKHR  	
			EndIF
		EndIf		
		QRYAUX->(DbCloseArea())
		QRYRATEIO->(DbSkip())
	EndDo
	
	QRYRATEIO->(DbCloseArea())

Return nRet

/*/{Protheus.doc} buscaRat

Busca os rateios do tipo 05 - energia eletrica.
	
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
	cQuery += "	   	AND CTQ_ZZCRAT 	= 	'05'					 		" + CRLF
	cQuery += " GROUP BY CTQ_RATEIO" + CRLF
	
	TcQuery cQuery New Alias "QRYRATEIO"
	QRYRATEIO->(DbGoTop())

Return