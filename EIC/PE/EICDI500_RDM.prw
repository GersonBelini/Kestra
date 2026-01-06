#include "Protheus.ch"
#include "Totvs.ch"
#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³EICDI500  ºAutor  ³Borin - TOTVS IP     º Data ³ 04/11/2011 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±³Descricao ³ Ponto de Entrada na confirmação do Embarque/Desembaraço    ³±±
±±³          ³ de importação. Executao no botão OK da rotina.			  ³±±
±±³          ³ 															  ³±±
±±º																		  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso     ³Generico                                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º                    Manutencoes desde sua criacao                      º±±
±±ÌÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºData    ³Autor               ³Descricao                                º±±
±±ÌÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º04/11/11³ Borin - TOTVS IP   ³Parametro "FIM_GRAVA_CAPA" e	          º±±
±±º        ³                    ³ "POS_GRAVA_TUDO":						  º±±
±±º        ³                    ³Para gravacao das informacoes de numero  º±±
±±º        ³                    ³do processo de importacao e numero da    º±±
±±º        ³                    ³Invoice no titulo a pagar no modulo      º±±
±±º        ³                    ³SIGAFIN.		                          º±±
±±º        ³                    ³										  º±±
±±ÌÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º07/05/13³ Borin - TOTVS IP   ³Ajuste da GetArea:			              º±±
±±º        ³                    ³Foi necessario ajustar a Area para que	  º±±
±±º        ³                    ³nao gere problemas ao acessar o menu do  º±±
±±º        ³                    ³embarque/desembaraco.					  º±±
±±º        ³                    ³										  º±±
±±ÌÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºdd/mm/aa³analista    - TOTVS ³							              º±±
±±º        ³                    ³										  º±±
±±º        ³                    ³										  º±±
±±ÈÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function EICDI500()

Local aArea		:= GetArea()
Local aAreaSW6	:= GetArea()
Local aAreaSWB	:= GetArea()
Local aAreaSE2	:= GetArea()
Local cPrefixo	:= ""
Local cNumDup	:= ""
Local cParcela	:= ""
Local cTipoTit	:= ""
Local Fornece	:= ""
Local Loja		:= ""
Local cHawb		:= ""
Local cInvoice	:= ""

If Alltrim(ParamIXB) == "FIM_GRAVA_CAPA" .OR. Alltrim(ParamIXB) == "POS_GRAVA_TUDO"

	aAreaSW6 := SW6->(GetArea())
	aAreaSWB := SWB->(GetArea())
	aAreaSE2 := SE2->(GetArea())

	cHawb  := SW6->W6_HAWB

	dbSelectArea("SWB")
	SWB->(dbSetOrder(1))
	While SWB->(!EOF()) .AND. ( SW6->W6_FILIAL + SW6->W6_HAWB == SWB->WB_FILIAL + SWB->WB_HAWB )
		
        cPrefixo := SWB->WB_PREFIXO
        cNumDup	 := SWB->WB_NUMDUP
        cParcela := SWB->WB_PARCELA
        cTipoTit := SWB->WB_TIPOTIT
        cFornece := SWB->WB_FORN
        cLoja	 := SWB->WB_LOJA
        cInvoice := SWB->WB_INVOICE
        
		dbSelectArea("SE2")
		SE2->(dbSetOrder(1))
		If SE2->(dbSeek( xFilial("SE2") + cPrefixo + cNumDup + cParcela + cTipotit + cFornece + cLoja ))
			
			If Empty(SE2->E2_ZZHAWB) .OR. Empty(SE2->E2_ZZINV)
				SE2->(RecLock("SE2",.F.))
					SE2->E2_ZZHAWB  := cHawb
					SE2->E2_ZZINV	:= cInvoice
				SE2->(MsUnLock())
	  		EndIf
		EndIf
		SWB->(dbSkip())
	EndDo
Endif 

RestArea(aAreaSE2)
RestArea(aAreaSWB)
RestArea(aAreaSW6)
RestArea(aArea)

Return