#INCLUDE "Protheus.ch"
#INCLUDE "Totvs.ch"

/*
Nome       			: KSTEIC01
Descrição  			: Preencher informacoes do titulo a pagar na inclusao via despesas do desembaraco e prestacao de contas
Ponto	   			: Executado do ponto de entrada EICFI400_RDM
Nota       			: -
Ambiente   			: IMPORTACAO
Cliente				: KESTRA
Autor      			: Andre Borin - TOTVS IP
Data Criação 		: 14/07/2015
Param. Pers 		: -
Campos Pers.		: -

Nº Revisão			: -
Data Revisão		: -
Revisor				: -                 
Nota				: 
*/

User Function KSTEIC01

Local cDespesa 	:= ""
Local cTipoTit	:= "  "
Local cNaturez	:= "          "
Local cFornece	:= "      "
Local cLojaFor	:= "  "
Local nAuxParc	:= 0

Public cZZParc

	dbSelectArea("SYB")
	SYB->(dbSetOrder(1))
	If SYB->(dbSeek(xFilial("SYB") + M->WD_DESPESA ))
		cDespesa 	:= Alltrim(SYB->YB_DESCR)
		cTipoTit	:= SYB->YB_ZZTIPOT
		cNaturez	:= SYB->YB_ZZNATUR
		cFornece	:= SYB->YB_ZZFORN
		cLojaFor	:= SYB->YB_ZZLOJAF
	EndIf
	
	If M->WD_GERFIN == "1" && Via Inclusao Manual da Despesa

		If !Empty(cTipoTit)
			M->E2_TIPO		:= cTipoTit
		EndIf
		If !Empty(cNaturez)
			M->E2_NATUREZ	:= cNaturez
		EndIf
		If !Empty(cFornece)
			M->E2_FORNECE 	:= cFornece
			M->E2_LOJA    	:= cLojaFor
			M->E2_NOMFOR	:= Posicione("SA2",1,xFilial("SA2") + cFornece + cLojaFor,"A2_NREDUZ")
		EndIf
	 	M->E2_HIST	  	:= "P: " + Alltrim(SW6->W6_HAWB) + " - " + cDespesa
	
	ElseIf M->WD_GERFIN == "2" && Via Prestacao de Contas

		If !Empty(cZZParc)
			cZZParc := cZZParc
		Else
			cZZParc := "00"
		EndIf
		
		nAuxParc := Val(cZZParc) + 1
		cZZParc  := StrZero(nAuxParc,2)
		
		M->E2_PARCELA := cZZParc
		M->E2_NATUREZ := cNaturez
	EndIf
		 
	M->E2_ZZHAWB := Alltrim(SW6->W6_HAWB)
	
	If FA050Natur() .AND. FinVldNat(.F.,M->E2_NATUREZ,2)
		M->E2_NATUREZ := M->E2_NATUREZ
	Else
		M->E2_NATUREZ := "          "
	EndIf
Return