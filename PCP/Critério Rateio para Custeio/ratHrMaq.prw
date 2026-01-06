#Include 'Protheus.ch'
#Include 'Topconn.ch'

/*/{Protheus.doc} ratHrMaq

Faz o rateio por Horas Maquinas Trabalhadas. Opção 02.
	
@author André Oquendo
@since 13/04/2015

@param dProdDe		, Data		, Data da apuração de
@param dProdAte	, Data		, Data da apuração até

/*/

User Function ratHrMaq(dProdDe,dProdAte)
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
				nQtdPerc := round((CTQ->CTQ_ZZQTDE*100)/nTotRat,2)
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

Retorna o total de horas maquinas trabalhadas no centro de custo.
	
@author André Oquendo
@since 13/04/2015

@param cCC			, String	, Centro de custo
@param dProdDe		, Data		, Data da apuração de
@param dProdAte	, Data		, Data da apuração até

@return Numerico Somatoria do tempo gasto
/*/

Static Function buscaSD3(cCC,dProdDe,dProdAte)   
	Local cQuery			:= ""
	Local nRet				:= 0
	
	cQuery := " SELECT " + CRLF		
	cQuery += "	SUM(D3_QUANT) as TOTAL									" + CRLF
	cQuery += " FROM " + RetSqlName("SD3") + " SD3 						" + CRLF	
	cQuery += " WHERE 														" + CRLF
	cQuery += "	   	SD3.D_E_L_E_T_ 	= 	' ' 							" + CRLF		
	cQuery += "	   	AND D3_EMISSAO >= 	'"+dToS(dProdDe)+"'					" + CRLF
	cQuery += "	   	AND D3_EMISSAO <= 	'"+dToS(dProdAte)+"'				" + CRLF	
	cQuery += "	   	AND D3_COD 	= 	'MOD"+cCC+"'			 			" + CRLF		
	
	TcQuery cQuery New Alias "QRYRAUX"
	QRYRAUX->(DbGoTop())
	
	If QRYRAUX->(!Eof())
		nRet := QRYRAUX->TOTAL
	EndIf
	
	QRYRAUX->(DbCloseArea())

Return nRet

/*/{Protheus.doc} buscaRat

Busca os rateios do tipo 02 - horas maquinas trabalhadas
	
@author André Oquendo
@since 13/04/2015

/*/

Static Function buscaRat()   
	Local cQuery			:= ""
	
	cQuery := " SELECT " + CRLF		
	cQuery += "	CTQ_RATEIO 										" + CRLF
	cQuery += " FROM " + RetSqlName("CTQ") + " CTQ 						" + CRLF
	cQuery += " WHERE 														" + CRLF
	cQuery += "	   	CTQ.D_E_L_E_T_ 	= 	' ' 							" + CRLF
	cQuery += "	   	AND CTQ_ZZCRAT 	= 	'02'					 		" + CRLF
	cQuery += " GROUP BY CTQ_RATEIO" + CRLF
	
	TcQuery cQuery New Alias "QRYRATEIO"
	QRYRATEIO->(DbGoTop())

Return