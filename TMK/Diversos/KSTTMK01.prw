#include "Protheus.ch"
#include "Totvs.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³KSTTMK01 ºAutor  ³Borin - TOTVS IP     º Data ³ 08/06/2015  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Funcao para validacao de campos nos itens do orcamento do   º±±
±±º          ³Televendas, modulo Call Center.						      º±±
±±º			 ³															  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso     ³Generico                                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º                    Manutencoes desde sua criacao                      º±±
±±ÌÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºData    ³Autor               ³Descricao                                º±±
±±ÌÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º08/06/15³ Borin - TOTVS IP   ³Funcao para validar o campo UB_QUANT	  º±±
±±º        ³                    ³referente a quantidade multipla que deve º±±
±±º        ³                    ³acompanhar a quantidade na embalagem.    º±±
±±º        ³                    ³				                          º±±
±±ÈÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function KSTTMK01

Local lRet 		:= .T.
Local nPosProd	:= GDFieldPos("UB_PRODUTO")
Local nPosQtd	:= GDFieldPos("UB_QUANT")
Local nPosQDeE	:= GDFieldPos("UB_ZZQDEEM")
Local nPosQNaE	:= GDFieldPos("UB_ZZQNAEM")
Local nQtdDeEm	:= 0
Local cTitulo	:= "ATENÇÃO!!!"
Local cMsg		:= ""

	dbSelectArea("SB1")
	SB1->(dbSetOrder(1))
	If SB1->(dbSeek(xFilial("SB1") + aCols[n,nPosProd] ))
	
		If !Empty(SB1->B1_SEGUM) .and. SB1->B1_TIPCONV == "D" .and. SB1->B1_CONV <> 0

			nQtdDeEm := aCols[n,nPosQtd] / SB1->B1_CONV
			
			If Int(nQtdDeEm) <> nQtdDeEm
				cMsg := "Quantidade informada (" + cValToChar(aCols[n,nPosQtd])
				cMsg += ") não é múltipla da quantidade NA embalagem (" + cValToChar(aCols[n,nPosQNaE]) + ").Verifique!"
				MsgInfo(cMsg,cTitulo)
				&& lRet := .F.
			Else
				aCols[n,nPosQDeE] := nQtdDeEm
				lRet := .T.
		    EndIf
		    
		ElseIf Empty(SB1->B1_SEGUM)
			cMsg := "Produto " + Alltrim(aCols[n,nPosProd]) + " não tem embalagem/2ª U.M. definida."
			MsgInfo(cMsg,cTitulo)
	    EndIf
    EndIf
Return(lRet)