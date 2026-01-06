#Include 'Protheus.ch'
#Include 'TopConn.ch'

/*/{Protheus.doc} intEstru

Faz a integração da tabela SG1 com a estrutura do produto
	
@author André Oquendo
@since 03/06/2015

/*/

User Function intEstru()
	Local nRegs		:= 0
	Private lJob		:= .F.
	
	If lJob
		conOut("******************INICIO DA INTEGRAÇÃO - ESTRUTURA PRODUTOS******************")	
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
	
	QRYESTRU->(DbCloseArea())
	
	If lJob
		conOut("******************FIM DA INTEGRAÇÃO - ESTRUTURA PRODUTOS******************")
	Else
		msgAlert("Fim da Integração!")
	EndIf	

Return

/*/{Protheus.doc} grvDados

Grava os dados na tabela de estruturas usando execauto
	
@author André Oquendo
@since 03/06/2015

/*/

Static Function grvDados()
	Local aTemp		:= {}
	Local aCabec		:= {}
	Local aItens		:= {}
	Local aAux			:= {}
	Local cIdInteg	:= ""
	Local cErro		:= ""
	Local nTipo		:= 0
	
	QRYESTRU->(DbGoTop())
	While QRYESTRU->(!Eof())
		ZG1->(dbGoto(QRYESTRU->RECNO))	
				
		cIdInteg 	:= ZG1->ZG1_IDINT
		nTipo		:= val(ZG1->ZG1_TPOPER)
		aTemp		:= {}
		aCabec		:= {}
		aItens		:= {}		
		
		aCabec := { 	{"G1_COD"  , ZG1->ZG1_PRODUT			, NIL},; 	
     		        	{"G1_QUANT", ZG1->ZG1_QTDBASE 		   	, NIL},;					
						{"NIVALT"  , "S"      					, NIL}} // A variavel NIVALT eh utilizada pra recalcular ou nao a estrutura
						
		While QRYESTRU->(!Eof()) .AND. cIdInteg == ZG1->ZG1_IDINT
			IncProc("Integrando IP -> " + Alltrim(cIdInteg))			
			aadd(aTemp,QRYESTRU->RECNO)
			ZG1->(dbGoto(QRYESTRU->RECNO))
			
			aAux := {}
			AADD(aAux,{"G1_COD"		,ZG1->ZG1_PRODUT		 		,NIL})
			AADD(aAux,{"G1_TRT"		,ZG1->ZG1_TRT			 		,NIL})
			AADD(aAux,{"G1_COMP"	,ZG1->ZG1_COMP		 		,NIL})
			AADD(aAux,{"G1_QUANT"	,ZG1->ZG1_QUANT		 		,NIL})
			AADD(aAux,{"G1_PERDA"	,ZG1->ZG1_PERDA		 		,NIL})
			AADD(aAux,{"G1_INI"		,ZG1->ZG1_INI			 		,NIL})
			AADD(aAux,{"G1_FIM"		,ZG1->ZG1_FIM			 		,NIL})
			AADD(aAux,{"G1_OBSERV"	,ZG1->ZG1_OBSERV		 		,NIL})
			AADD(aAux,{"G1_FIXVAR"	,ZG1->ZG1_FIXVAR		 		,NIL})
			AADD(aAux,{"G1_GROPC"	,ZG1->ZG1_GROPC		 		,NIL})
			AADD(aAux,{"G1_OPC"		,ZG1->ZG1_OPC			 		,NIL})
			AADD(aAux,{"G1_ZZFORM"	,ZG1->ZG1_ZZFORM		 		,NIL})
				
			AADD(aItens,aAux)	
											
			QRYESTRU->(DbSkip())
			If  QRYESTRU->(!Eof())
				ZG1->(dbGoto(QRYESTRU->RECNO))
			EndIf
		EndDo	
		Begin Transaction	
							
			lMsErroAuto		:=	.F.		
			
			dbSelectArea("SG1")
			DbSetOrder(1)//G1_FILIAL+G1_COD+G1_COMP+G1_TRT
			If dbSeek(xFilial("SG1")+aCabec[1][2])									
				MSExecAuto({|x,y,z| mata200(x,y,z)},aCabec,NIL,5)
				If !lMsErroAuto					
						MSExecAuto({|x,y,z| mata200(x,y,z)},aCabec,aItens,3)						
				EndIf
			Else
				MSExecAuto({|x,y,z| mata200(x,y,z)},aCabec,aItens,3)				
			EndIf
		    
			If lMsErroAuto
				cErro 	:= MostraErro(SuperGetMV("ZZ_LOGERRO"),"LogEstrut" + cValToChar(aTemp[1]) + ".txt")
				For nT := 1 to len(aTemp)
					ZG1->(dbGoto(aTemp[nT]))
					RecLock("ZG1",.F.)
						ZG1->ZG1_STATUS 	:= '2'
						ZG1->ZG1_DTINT 	:= dDataBase
						ZG1->ZG1_HRINT	:= time()	
						ZG1->ZG1_ERRO		:= cErro				
					MsUnLock()
				Next
			Else
				For nT := 1 to len(aTemp)
					ZG1->(dbGoto(aTemp[nT]))
					RecLock("ZG1",.F.)
						ZG1->ZG1_STATUS 	:= '3'
						ZG1->ZG1_DTINT 	:= dDataBase
						ZG1->ZG1_HRINT	:= time()	
						ZG1->ZG1_ERRO		:= ""						
					MsUnLock()
				Next						
			EndIf
		End Transaction			
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
	cQuery += " FROM " + RetSqlName("ZG1") + " ZG1 											" + CRLF
	cQuery += " WHERE 																			" + CRLF
	cQuery += "	   	ZG1.D_E_L_E_T_ 	= 	' ' 												" + CRLF		
	cQuery += "	   	AND ZG1_STATUS = 	'1'														" + CRLF	
	cQuery += "	   	ORDER BY ZG1_IDINT														" + CRLF
	
	TcQuery cQuery New Alias "QRYESTRU"
	Count to nRet
	QRYESTRU->(DbGoTop())
	
Return nRet