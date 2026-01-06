#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºClasse    ³MT681INC  ºAutor  ³Guilherme Ricci     º Data ³  19/06/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Eh executado apos a gravacao dos dados na rotina de inclusaoº±±
±±º          ³do apontamento de producao PCP Mod2.                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Protheus 10                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MT681INC()
Local aCCCif := {}

Private cModCif := ""


aCCCif := u_GetCCCif( AprModRec( SH6->H6_RECURSO ) )

For i := 1 To Len(aCCCif)
	cModCif := aCCCif[i]
	If A680GeraD3("MOD",SH6->H6_IDENT)
		A240Atu()
		lCriaHeader := .T.
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Corrige identificacao errada da RE. ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SD3")
		dbGoto(nRegD3)
		RecLock("SD3",.F.)
		Replace D3_CF With "RE1"
	EndIf
Next

If A680UltOper(.F.) .and. SH6->H6_QTDPROD > 0
	fAjCorrida() // Ajusta empenho da ordem de producao PAI com o lote gerado nesta ordem de producao
Endif

Return

Static Function fAjCorrida()

Local cCorrida 	:= SH6->H6_LOTECTL
Local cProd		:= SH6->H6_PRODUTO
Local cQuery	:= ""
Local aVetor	:= {}
Local cProdOP	:= ""
Local cLocal	:= ""
Local cOP		:= ""
Local dDataEmp	:= dDatabase
Local nQuant	:= 0
Local nQuantOri	:= 0
Local nQtdTot	:= 0
Local aAreaAtu	:= GetArea()
Local aAreaSD4	:= SD4->(GetArea())
Local aAreaSB2	:= SB2->(GetArea())

Private lMsErroAuto := .F.

Posicione("SB1",1,xFilial("SB1") + SH6->H6_PRODUTO,"")

If SB1->B1_LOCALIZ == "S" .AND. SB1->B1_TIPO == "PI"
	MsgAlert("O produto PI apontado controla endereço e atualizará nenhum empenho. Favor empenhar manualmente, caso seja necessário.")
	Return
Endif

If Select("WORK") > 0
	WORK->( dbCloseArea() )
Endif

cQuery := "SELECT D4.R_E_C_N_O_ RSD4, C2_PRODUTO, D4.*"
cQuery += " FROM "+ RetSqlName("SC2") +" C2"
cQuery += " INNER JOIN "+ RetSqlName("SD4") +" D4 ON D4_FILIAL = C2_FILIAL AND D4_OP = C2_NUM+C2_ITEM+C2_SEQUEN AND D4.D_E_L_E_T_=' '"
cQuery += " WHERE C2.D_E_L_E_T_=' '"
cQuery += " AND C2_FILIAL = '"+ xFilial("SC2") +"'"
cQuery += " AND C2_ZZNCORR+C2_ZZREQUA = '"+cCorrida+"'"
cQuery += " AND D4_COD = '"+ cProd +"'"
cQuery += " AND D4_LOTECTL IN ('','"+ cCorrida +"') "
//cQuery += " AND D4_QUANT > 0"
cQuery += " ORDER BY D4_LOTECTL DESC"

tcQuery cQuery New Alias "WORK"

// Query deve ter no maximo 2 registros, sendo o primeiro com o lote produzido e o segundo com o lote em branco.

//BEGIN TRANSACTION

If WORK->(!eof() )
	cProdOP		:= WORK->C2_PRODUTO
	cLocal		:= WORK->D4_LOCAL
	cOP			:= WORK->D4_OP
	dDataEmp	:= StoD(WORK->D4_DATA)
	nQuant		:= Iif(Empty(WORK->D4_LOTECTL), SH6->H6_QTDPROD, WORK->D4_QUANT + SH6->H6_QTDPROD)
	nQuantOri	:= WORK->D4_QTDEORI
	lUnico		:= Empty(WORK->D4_LOTECTL)
	            
	While WORK->(!eof())
		// Verifica quantidade total inicial do empenho
		nQtdTot += WORK->D4_QUANT
		
		// Apaga empenhos ja existentes, sistema desposiciona no execauto.
		SD4->( dbGoTo( WORK->RSD4 ) )
		
		If Empty(WORK->D4_LOTECTL)
	   
			aVetor:={   {"D4_COD"     ,Padr( cProd, TamSx3("D4_COD")[1]),Nil},; 
			            {"D4_LOCAL"   ,SD4->D4_LOCAL   ,Nil},;
			            {"D4_OP"      ,SD4->D4_OP		,Nil},;
			            {"D4_DATA"    ,SD4->D4_DATA,Nil}}
			            
			MSExecAuto({|x,y,z| mata380(x,y,z)},aVetor,5,)
			If lMsErroAuto
				MsgStop("Erro na exclusão dos empenhos. Favor consultar os detalhes e estornar o apontamento realizado.")
				MostraErro()
				//DisarmTransaction()
				Exit
			Endif
			If lUnico
				aVetor:={   {"D4_COD"     , Padr( cProd, TamSx3("D4_COD")[1]),Nil},; 
				            {"D4_LOCAL"   , cLocal   ,Nil},;
				            {"D4_OP"      , cOP		 ,Nil},;
				            {"D4_DATA"    , dDataEmp ,Nil},;
				            {"D4_QTDEORI" , nQuant, Nil},;
				            {"D4_QUANT"   , nQuant, Nil},;
				            {"D4_LOTECTL" , cCorrida			,Nil}}
				
				MSExecAuto({|x,y,z| mata380(x,y,z)},aVetor,3,)
				
				If lMsErroAuto
					MsgStop("Erro na inclusão do empenho com lote. Favor consultar os detalhes e estornar o apontamento realizado.")
					MostraErro()
					DisarmTransaction()
				Endif
			Endif
			WORK->(dbSkip())
		Else
			aVetor:={   {"D4_COD"     ,Padr( cProd, TamSx3("D4_COD")[1]),Nil},; 
			            {"D4_LOCAL"   ,SD4->D4_LOCAL   ,Nil},;
			            {"D4_OP"      ,SD4->D4_OP		,Nil},;
			            {"D4_DATA"    ,SD4->D4_DATA,Nil},;
   			            {"D4_QTDEORI" ,WORK->D4_QTDEORI + SH6->H6_QTDPROD, Nil},;
			            {"D4_QUANT"   ,nQuant, Nil},;
			            {"D4_TRT"	  ,SD4->D4_TRT, Nil},;
			            {"D4_LOTECTL" ,cCorrida	,Nil}}
			            
			MSExecAuto({|x,y,z| mata380(x,y,z)},aVetor,4,)
			If lMsErroAuto
				MsgStop("Erro na alteração dos empenhos. Favor consultar os detalhes e estornar o apontamento realizado.")
				MostraErro()
				//DisarmTransaction()
				Exit
			Endif
		Endif
		
		WORK->(dbSkip())
	EndDo
	WORK->(dbGoTop())

	// Se a quantidade apontada for menor que o empenho existente, deverá adicionar o restante do empenho sem lote.
	If nQuant < nQtdTot .and. !lMsErroAuto
		aVetor:={   {"D4_COD"     , Padr( cProd, TamSx3("D4_COD")[1]),Nil},; 
		            {"D4_LOCAL"   , cLocal				,Nil},;
		            {"D4_OP"      , cOP					,Nil},;
		            {"D4_DATA"    , dDataEmp			,Nil},;
		            {"D4_QTDEORI" , nQtdTot - nQuant	,Nil},;
		            {"D4_QUANT"   , nQtdTot - nQuant	,Nil}}
//		            {"D4_LOTECTL" , ""					,Nil}}
		MSExecAuto({|x,y,z| mata380(x,y,z)},aVetor,3,)
		
		If lMsErroAuto                                  
			MsgStop("Erro na inclusão do empenho sem lote. Favor consultar os detalhes e estornar o apontamento realizado.")
			MostraErro()
			//DisarmTransaction()
		Endif
	Endif
	
	//Se a quantidade total bater com a quantidade com lote e existir um empenho sem lote, este deve ser apagado.
	/*
	WORK->( dbSkip() )

	If WORK->( !eof() ) .and. nQtdTot-nQuant <= 0 .and. !lMsErroAuto
		SD4->( dbGoTo( WORK->RSD4 ) )

		aVetor:={   {"D4_COD"     ,Padr( cProd, TamSx3("D4_COD")[1]),Nil},; 
		            {"D4_LOCAL"   ,SD4->D4_LOCAL   ,Nil},;
		            {"D4_OP"      ,SD4->D4_OP		,Nil},;
		            {"D4_DATA"    ,SD4->D4_DATA,Nil}}
		            
		MSExecAuto({|x,y,z| mata380(x,y,z)},aVetor,5,)
		
		If lMsErroAuto
			MsgStop("Erro na exclusão do empenho sem lote. Favor consultar os detalhes e estornar o apontamento realizado.")
			MostraErro()
			DisarmTransaction()
		Endif
	Endif
	*/
	If !lMsErroAuto
		MsgInfo("Empenho da OP "+ Alltrim(cOP) + " do produto " + Alltrim(cProd) + " foi atualizada.")
	Endif
Endif

WORK->( dbCloseArea() )
//END TRANSACTION

RestArea(aAreaSD4)
RestArea(aAreaSB2)
RestArea(aAreaAtu)

Return