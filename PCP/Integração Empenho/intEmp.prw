#Include 'Protheus.ch'
#Include 'TopConn.ch'

/*/{Protheus.doc} intEstru

Faz a integração da tabela SG1 com a estrutura do produto
	
@author André Oquendo
@since 03/06/2015

/*/

User Function intEmp()
	Local nRegs		:= 0
	Private lJob		:= .F.
	
	If lJob
		conOut("******************INICIO DA INTEGRAÇÃO - EMPENHO******************")	
	EndIf

	//Busca os dados a serem exportados
	nRegs := buscaDados()
	
	If nRegs > 0
		If lJob
			conOut("***Inicio do processamento!")
			grvDados()
			conOut("***Fim do processamento!")
		Else
			ProcRegua(nRegs)	      
			Processa({||grvDados()},"Processando...")
		EndIf
		 
				
	Else
		If lJob
			conOut("***Nenhum registro encontrado!")
		Else
			msgAlert("Nenhum registro encontrado!")
		EndIf	
	EndIf
	
	QRYEMP->(DbCloseArea())
	
	If lJob
		conOut("******************FIM DA INTEGRAÇÃO - EMPENHO******************")
	Else
		msgAlert("Fim da Integração!")
	EndIf
Return


/*/{Protheus.doc} grvDados

Grava os dados na tabela de empenho usando execauto
	
@author André Oquendo
@since 03/06/2015

/*/

Static Function grvDados()	
	Local aItens		:= {}	
	Local cIdInteg	:= ""
	Local cErro		:= ""
	Local nTipo		:= 0
	Local cSeqTRT		:= ""
	Local cOP			:= ""	
	Local nRecno		:= ""
	
	QRYEMP->(DbGoTop())
	While QRYEMP->(!Eof())
		ZD4->(dbGoto(QRYEMP->RECNO))
		cIdInteg 	:= ZD4->ZD4_IDINT
		nTipo		:= val(ZD4->ZD4_TPOPER)		
		aItens		:= {}
		IncProc("Integrando IP -> " + Alltrim(cIdInteg))		
		cOP := retOP(ZD4->ZD4_OPKSTA)
		If cOP == "ERRO"
			RecLock("ZD4",.F.)
				ZD4->ZD4_STATUS 	:= '2'
				ZD4->ZD4_DTINT 	:= dDataBase
				ZD4->ZD4_HRINT	:= time()	
				ZD4->ZD4_ERRO		:= "OP Kestra "+ZD4->ZD4_OPKSTA+" não encontrada!"				
			MsUnLock()
			QRYEMP->(DbSkip())
			Loop
		EndIf		
		If nTipo == 3
			cSeqTRT := retProxSeq(cOP,ZD4->ZD4_COD) 
		Else
			nRecno := retD4Atu(cOP,ZD4->ZD4_COD,ZD4->ZD4_LOTECTL)
			If nRecno == 0
				RecLock("ZD4",.F.)
					ZD4->ZD4_STATUS 	:= '2'
					ZD4->ZD4_DTINT 	:= dDataBase
					ZD4->ZD4_HRINT	:= time()	
					ZD4->ZD4_ERRO		:= "Empenho para OP: "+cOP+", Produto: "+ZD4->ZD4_COD+" e Lote: "+ZD4->ZD4_LOTECTL+" não encontrado!"				
				MsUnLock()
				QRYEMP->(DbSkip())
				Loop
			EndIf	
			SD4->(dbGoto(nRecno))
			cSeqTRT := SD4->D4_TRT			
		EndIf		
		Begin Transaction	
				
		aadd(aItens, {"D4_COD"		, ZD4->ZD4_COD			, nil})
		aadd(aItens, {"D4_LOCAL"		, ZD4->ZD4_LOCAL			, nil})
		aadd(aItens, {"D4_OP"		, ZD4->ZD4_OP				, nil})
		aadd(aItens, {"D4_DATA"		, ZD4->ZD4_DATA			, nil})
		aadd(aItens, {"D4_QTDEORI"	, ZD4->ZD4_QTDEOR			, nil})
		aadd(aItens, {"D4_QUANT"		, ZD4->ZD4_QTDEOR			, nil})
		aadd(aItens, {"D4_TRT"		, cSeqTRT					, nil})
		aadd(aItens, {"D4_LOTECTL"	, ZD4->ZD4_LOTECT			, nil})
		aadd(aItens, {"D4_DTVALID"	, ZD4->ZD4_DTVALI			, nil})
		
		MSExecAuto({|x, y| mata380(x, y)}, aItens, nTipo)

		If lMsErroAuto
			cErro 	:= MostraErro(SuperGetMV("ZZ_LOGERRO"),"LogEMP" + cValToChar(aTemp[1]) + ".txt")		
			RecLock("ZC2",.F.)
				ZD4->ZD4_STATUS 	:= '2'
				ZD4->ZD4_DTINT 	:= dDataBase
				ZD4->ZD4_HRINT	:= time()	
				ZD4->ZD4_ERRO		:= cErro				
			MsUnLock()
		Else
			RecLock("ZC2",.F.)
				ZD4->ZD4_STATUS 	:= '3'
				ZD4->ZD4_DTINT 	:= dDataBase
				ZD4->ZD4_HRINT	:= time()	
				ZD4->ZD4_ERRO		:= ""						
			MsUnLock()			
		EndIf		
		
		End Transaction
		QRYEMP->(DbSkip())
	EndDo		
Return


/*/{Protheus.doc} buscaDados

Busca os dados a serem integrados
	
@author André Oquendo
@since 03/06/2015

@return Numerico Numero de linhas da integração
/*/

Static Function buscaDados()
	Local cQuery		:= ""
	Local nRet			:= 0
	
	cQuery := " SELECT 																			" + CRLF		
	cQuery += " R_E_C_N_O_ AS RECNO																" + CRLF	
	cQuery += " FROM " + RetSqlName("ZD4") + " ZD4 											" + CRLF
	cQuery += " WHERE 																			" + CRLF
	cQuery += "	   	ZD4.D_E_L_E_T_ 	= 	' ' 												" + CRLF		
	cQuery += "	   	AND ZD4_STATUS = 	'1'														" + CRLF
	cQuery += "	   	ORDER BY ZD4_IDINT														" + CRLF
	
	TcQuery cQuery New Alias "QRYEMP"
	Count to nRet
	QRYEMP->(DbGoTop())
	
Return nRet


Static Function retOP(cOPKestra)
	Local cRet		:= ""
	Local cQuery	:= ""

	cQuery := " SELECT 																			" + CRLF		
	cQuery += " C2_NUM,C2_ITEM,C2_SEQUEN														" + CRLF	
	cQuery += " FROM " + RetSqlName("SC2") + " SC2 											" + CRLF
	cQuery += " WHERE 																			" + CRLF
	cQuery += "	   	SC2.D_E_L_E_T_ 	= 	' ' 												" + CRLF		
	cQuery += "	   	AND C2_ZZNCORR = '"+substr(cOPKestra,1,8)+"'							" + CRLF
	cQuery += "	   	AND C2_ZZREQUA = '"+substr(cOPKestra,9,2)+"'							" + CRLF				
				
	TcQuery cQuery New Alias "QRYTMP"
	Count to nRet
	QRYTMP->(DbGoTop()) 
	If QRYEOP->(Eof())
		cRet := "ERRO"
	Else	
		cRet := QRYEOP->C2_NUM+QRYEOP->C2_ITEM+QRYEOP->C2_SEQUEN
	EndIf				
Return cRet


Static Function retProxSeq(cCodPro, cOrdPro)

	Local cQuery 		:= ""
	Local cRet			:= ""
	
	cQuery := "SELECT MAX(D4_TRT) D4_TRT "
	cQuery += "FROM " + retSqlName("SD4") + " D4 "
	cQuery += "WHERE "
	cQuery +=		"D4_FILIAL 		= '" + xFilial("SD4") + "' AND "
	cQuery +=		"D4_COD 		= '" + cCodPro	 + "' AND "
	cQuery +=		"D4_OP			= '" + cOrdPro 	 + "' AND "
	cQuery +=		"D4.D_E_L_E_T_  = ' ' "
			
	TCQuery cQuery NEW Alias "TSEQ"	
	
	If TSEQ->(!eof())
		cUltSeq := TSEQ->D4_TRT		
	EndIf
	
	If empty(allTrim(cUltSeq))
		cUltSeq := "001"
	Else
		cUltSeq := soma1(cUltSeq)	
	EndIf
	
	TSEQ->(dbCloseArea())     
	
Return cRet	

Static Function retD4Atu(cOP,cProduto,cLote)
	Local nRet			:= 0
	Local cQuery 		:= ""
	
	cQuery := "SELECT R_E_C_N_O_ AS RECNO	 "
	cQuery += "FROM " + retSqlName("SD4") + " D4 "
	cQuery += "WHERE "
	cQuery +=		"D4_FILIAL 		= '" + xFilial("SD4") + "' AND "
	cQuery +=		"D4_COD 		= '" + cProduto	 + "' AND "
	cQuery +=		"D4_OP			= '" + cOP 	 + "' AND "
	cQuery +=		"D4_LOTECTL	= '" + cLote 	 + "' AND "
	cQuery +=		"D4.D_E_L_E_T_  = ' ' "
			
	TCQuery cQuery NEW Alias "TSEQ"	
	
	If TSEQ->(!eof())
		nRet := TSEQ->RECNO		
	Else
		nRet := 0
	EndIf
		
	TSEQ->(dbCloseArea()) 
Return nRet