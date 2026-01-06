#include "Totvs.ch"
#include "Protheus.ch"
#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TMKVFIM  ºAutor  ³Borin - TOTVS IP     º Data ³ 14/04/2015  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de Entrada na rotina de atendimento Call Center, 	  º±±
±±º          ³executado no final da rotina, onde ja estao gravados os     º±±
±±º			 ³registros do atendimento e pedido de venda.				  º±±
±±º			 ³															  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso     ³Generico                                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º                    Manutencoes desde sua criacao                      º±±
±±ÌÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºData    ³Autor               ³Descricao                                º±±
±±ÌÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º14/04/15³ Borin - TOTVS IP   ³Ponto de Entrada para gravacao dos camposº±±
±±º        ³                    ³de mensagem para nota fiscal e obra.     º±±
±±º        ³                    ³				                          º±±
±±ÈÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function TMKVFIM

Local aArea		:= GetArea()
Local aAreaSUA	:= SUA->(GetArea())
Local aAreaSUB	:= SUB->(GetArea())
Local aAreaSC5	:= SC5->(GetArea())
Local aAreaSC6	:= SC6->(GetArea())
Local cMenNota	:= ""


	If SUA->UA_OPER == "1"
		
		dbSelectArea("SC5")
		SC5->(RecLock("SC5",.F.))
			SC5->C5_REDESP	:= SUA->UA_ZZREDES && Redespacho
			SC5->C5_ZZTPFRE	:= SUA->UA_ZZTPFRE && Frete Redespacho
			SC5->C5_VOLUME1	:= SUA->UA_ZZVOLU1 && Volume 1
			SC5->C5_VOLUME2	:= SUA->UA_ZZVOLU2 && Volume 2
			SC5->C5_VOLUME3	:= SUA->UA_ZZVOLU3 && Volume 3
			SC5->C5_VOLUME4	:= SUA->UA_ZZVOLU4 && Volume 4
			SC5->C5_ESPECI1	:= SUA->UA_ZZESPE1 && Especie 1
			SC5->C5_ESPECI2	:= SUA->UA_ZZESPE2 && Especie 2
			SC5->C5_ESPECI3	:= SUA->UA_ZZESPE3 && Especie 3
			SC5->C5_ESPECI4	:= SUA->UA_ZZESPE4 && Especie 4
			SC5->C5_MENNOTA := SUA->UA_ZZMENNF && Mensagens para Nota Fiscal
			SC5->C5_ZZCALLC := SUA->UA_NUM     && Numero do atendimento do Call Center
			SC5->C5_ZZOBS 	:= SUA->UA_ZZOBSEX
			//SC5->C5_ZZCRIT 	:= SUA->UA_ZZCRIT
			SC5->C5_ZZAPLIC	:= SUA->UA_ZZAPLIC
			SC5->C5_ZZOPER	:= SUA->UA_OPERADO
			SC5->C5_ZZOBS2 	:= SUA->UA_ZZOBSE2
			SC5->C5_NATUREZ	:= SUA->UA_ZZNATUR
	    SC5->(MsUnLock())
	    
	    dbSelectArea("SUB")
	    SUB->(dbSetOrder(1))
	    If SUB->(dbSeek(xFilial("SUB") + SUA->UA_NUM ))
	        While SUB->(!EOF()) .AND. (xFilial("SUB") + SUA->UA_NUM) == (SUB->UB_FILIAL + SUB->UB_NUM)
	        	
	        	dbSelectArea("SC6")
	        	SC6->(dbSetOrder(1))
	        	If SC6->(dbSeek(xFilial("SC6") + SUA->UA_NUMSC5 + SUB->UB_ITEM + SUB->UB_PRODUTO ))	        		
	        		SC6->(RecLock("SC6",.F.))
	        			SC6->C6_ZZKS 		:= SUB->UB_ZZKS
	        			SC6->C6_ZZSTATU 	:= SUB->UB_ZZSTATU
	        			SC6->C6_ZZVDESC 	:= SUB->UB_ZZVDESC
	        			SC6->C6_ZZPDESC 	:= SUB->UB_ZZPDESC
	        		SC6->(MsUnLock())
	    		EndIf
	    		SUB->(dbSkip())
	        EndDo
	    EndIf
    EndIf

RestArea(aAreaSC6)
RestArea(aAreaSC5)
RestArea(aAreaSUB)
RestArea(aAreaSUA)
RestArea(aArea)

Return