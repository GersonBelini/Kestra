#Include 'Protheus.ch'
#Include 'TopConn.ch'

/*/{Protheus.doc} intOP

Faz a integração da tabela ZC2 com a estrutura OP
	
@author André Oquendo
@since 29/06/2015

/*/

User Function intOP()
	Local nRegs		:= 0
	Private lJob		:= .F.
	
	If lJob
		conOut("******************INICIO DA INTEGRAÇÃO - ORDEM DE PRODUÇÃO******************")	
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
	
	QRYEOP->(DbCloseArea())
	
	If lJob
		conOut("******************FIM DA INTEGRAÇÃO - ORDEM DE PRODUÇÃO******************")
	Else
		msgAlert("Fim da Integração!")
	EndIf	

Return

/*/{Protheus.doc} grvDados

Grava os dados na tabela de OP usando execauto
	
@author André Oquendo
@since 03/06/2015

/*/

Static Function grvDados()	
	Local aItens		:= {}	
	Local cIdInteg	:= ""
	Local cErro		:= ""
	Local nTipo		:= 0
	Local cQuery		:= ""
	
	QRYEOP->(DbGoTop())
	Begin Transaction
		While QRYEOP->(!Eof())			
			ZC2->(dbGoto(QRYEOP->RECNO))
			IncProc("Integrando IP -> " + Alltrim(ZC2->ZC2_IDINT))
					
			nTipo		:= val(ZC2->ZC2_TPOPER)
			aItens		:= {}		
			
			If nTipo == 5
				cQuery := " SELECT 																			" + CRLF		
				cQuery += " R_E_C_N_O_ AS RECNO																" + CRLF	
				cQuery += " FROM " + RetSqlName("SC2") + " SC2 											" + CRLF
				cQuery += " WHERE 																			" + CRLF
				cQuery += "	   	SC2.D_E_L_E_T_ 	= 	' ' 												" + CRLF		
				cQuery += "	   	AND C2_ZZNCORR = '"+ZC2->ZC2_ZZNCOR+"'								" + CRLF
				cQuery += "	   	AND C2_ZZREQUA = '"+ZC2->ZC2_ZZREQU+"'							" + CRLF				
				
				TcQuery cQuery New Alias "QRYTMP"
				Count to nRet
				QRYTMP->(DbGoTop()) 
				If QRYTMP->(Eof())
					RecLock("ZC2",.F.)
						ZC2->ZC2_STATUS 	:= '2'
						ZC2->ZC2_DTINT 	:= dDataBase
						ZC2->ZC2_HRINT	:= time()	
						ZC2->ZC2_ERRO		:= "Corrida "+ZC2->ZC2_ZZNCOR+" e requalificação "+ZC2->ZC2_ZZREQU+" nao encontrada!"				
					MsUnLock()
					QRYEOP->(DbSkip())
					Loop
				EndIf
				SC2->(dbGoto(QRYTMP->RECNO))
				
				aItens :=	{{'C2_PRODUTO' 	,SC2->C2_PRODUTO		,NIL},;
						  	{'C2_NUM'    		,SC2->C2_NUM			,NIL},;
						  	{'C2_ITEM'   		,SC2->C2_ITEM			,NIL},;
						  	{'C2_SEQUEN'   	,SC2->C2_SEQUEN		,NIL}}				
				
				QRYTMP->(DbCloseArea())
			Else								
				aItens :=	{{"C2_PRODUTO"	, ZC2->ZC2_PRODUT			,NIL},;
							{"C2_LOCAL"		, ZC2->ZC2_LOCAL			,NIL},;   
							{"C2_CC"			, ZC2->ZC2_CC				,NIL},;
							{"C2_QUANT"		, ZC2->ZC2_QUANT			,NIL},;
							{"C2_DATPRI"		, ZC2->ZC2_DATPRI			,NIL},;
							{"C2_DATPRF"		, ZC2->ZC2_DATPRF			,NIL},;
							{"C2_OBS"			, ZC2->ZC2_OBS			,NIL},;
							{"C2_EMISSAO"		, ZC2->ZC2_EMISSA			,NIL},;
							{"C2_ZZNCORR"		, ZC2->ZC2_ZZNCOR			,NIL},;
							{"C2_ZZREQUA"		, ZC2->ZC2_ZZREQU			,NIL},;
							{"C2_ZZNDIN"		, ZC2->ZC2_ZZNDIN			,NIL},;
							{"C2_ZZNEPR"		, ZC2->ZC2_ZZNEPR			,NIL},;
							{"C2_ZZASME"		, ZC2->ZC2_ZZASME			,NIL},;
							{"C2_ZZTPOPK"		, ZC2->ZC2_ZZTPOP			,NIL},;											
							{"C2_ZZLAYRE"		, ZC2->ZC2_ZZLAYR			,NIL},;
							{"C2_ZZEXTRU"		, ZC2->ZC2_ZZEXTR			,NIL},;
							{"C2_ZZFIEIR"		, ZC2->ZC2_ZZFIEI			,NIL},;
							{"C2_ZZCODK"		, ZC2->ZC2_ZZCODK			,NIL},;
							{"C2_ZZHOMIN"		, ZC2->ZC2_ZZHOMI			,NIL},;
							{"C2_ZZHOMAC"		, ZC2->ZC2_ZZHOMA			,NIL},;
							{"C2_ZZPRMIN"		, ZC2->ZC2_ZZPRMI			,NIL},;
							{"C2_ZZPRMAX"		, ZC2->ZC2_ZZPRMA			,NIL},;
							{"C2_ZZCARKE"		, ZC2->ZC2_ZZCARK			,NIL},;
							{"C2_ZZCARNO"		, ZC2->ZC2_ZZCARN			,NIL},;
							{"C2_ZZFG"			, ZC2->ZC2_ZZLAM			,NIL},;
							{"C2_ZZLAM"		, ZC2->ZC2_ZZLAM			,NIL},;
							{"C2_ZZNREV"		, ZC2->ZC2_ZZNREV			,NIL},;
							{"C2_ZZSILI"		, ZC2->ZC2_ZZSILI			,NIL},;
							{"AUTEXPLODE"		, "N"						,NIL}} //Explode a Estrutura S/N}  	
			EndIf
																	
			lMsErroAuto := .F.			
			MSExecAuto({|x,y| Mata650(x,y)},aItens,nTipo)		
			
			If lMsErroAuto
				cErro 	:= MostraErro(SuperGetMV("ZZ_LOGERRO"),"LogOP" + cValToChar(aTemp[1]) + ".txt")		
				RecLock("ZC2",.F.)
					ZC2->ZC2_STATUS 	:= '2'
					ZC2->ZC2_DTINT 	:= dDataBase
					ZC2->ZC2_HRINT	:= time()	
					ZC2->ZC2_ERRO		:= cErro				
				MsUnLock()
			Else
				RecLock("ZC2",.F.)
					ZC2->ZC2_STATUS 	:= '3'
					ZC2->ZC2_DTINT 	:= dDataBase
					ZC2->ZC2_HRINT	:= time()	
					ZC2->ZC2_ERRO		:= ""						
				MsUnLock()			
			EndIf															
			QRYEOP->(DbSkip())			
		EndDo	
	End Transaction		
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
	cQuery += " FROM " + RetSqlName("ZC2") + " ZC2 											" + CRLF
	cQuery += " WHERE 																			" + CRLF
	cQuery += "	   	ZC2.D_E_L_E_T_ 	= 	' ' 												" + CRLF		
	cQuery += "	   	AND ZC2_STATUS = 	'1'														" + CRLF
	cQuery += "	   	ORDER BY ZC2_IDINT														" + CRLF
	
	TcQuery cQuery New Alias "QRYEOP"
	Count to nRet
	QRYEOP->(DbGoTop())
	
Return nRet