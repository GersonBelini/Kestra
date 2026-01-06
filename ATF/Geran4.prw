#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºClasse    ³Geran4    ºAutor  ³Totvs IP            º Data ³  01/01/01   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºProjeto   ³       - Mztele -                                           º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Protheus 10                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function Geran4()

dbselectarea("SN3")
dbsetorder(1)
dbgotop()

While xFilial("SN3") == SN3->N3_FILIAL .and. !EOF()
	
	dbselectarea("SN1")
	dbsetorder(1)
	dbseek(xFilial("SN1")+SN3->N3_CBASE+SN3->N3_ITEM)

	If !found()
		msgStop("NAO ENCONTRADO NO SN1")
	Else
		
		If (reclock("SN4",.T.))			
			SN4->N4_FILIAL:=xFilial()
			SN4->N4_CBASE:=SN3->N3_CBASE
			SN4->N4_ITEM:=SN3->N3_ITEM
			SN4->N4_TIPO:=SN3->N3_TIPO
			SN4->N4_OCORR:="05"
			SN4->N4_TIPOCNT:="1"
			SN4->N4_CONTA:=SN3->N3_CCONTAB
			SN4->N4_DATA:=SN3->N3_AQUISIC
			SN4->N4_QUANTD:=SN1->N1_QUANTD
			SN4->N4_VLROC1:=SN3->N3_VORIG1
			SN4->N4_VLROC2:=SN3->N3_VORIG2
			SN4->N4_VLROC3:=SN3->N3_VORIG3
			SN4->N4_VLROC4:=SN3->N3_VORIG4
			SN4->N4_VLROC5:=SN3->N3_VORIG5
			SN4->N4_SERIE:=SN1->N1_NSERIE
			SN4->N4_NOTA:=SN1->N1_NFISCAL
			SN4->N4_SEQ:="001"
			msUnlock()
		EndIf
		
		If (SN3->N3_VRDACM1 >0 .and. reclock("SN4",.T.))			
			SN4->N4_FILIAL:=xFilial()
			SN4->N4_CBASE:=SN3->N3_CBASE
			SN4->N4_ITEM:=SN3->N3_ITEM
			SN4->N4_TIPO:=SN3->N3_TIPO
			SN4->N4_OCORR:="06"
			SN4->N4_TIPOCNT:="4"
			SN4->N4_CONTA:=SN3->N3_CCDEPR
			SN4->N4_DATA:=SN3->N3_AQUISIC
			SN4->N4_VLROC1:=SN3->N3_VRDACM1
			SN4->N4_VLROC2:=SN3->N3_VRDACM2
			SN4->N4_VLROC3:=SN3->N3_VRDACM3
			SN4->N4_VLROC4:=SN3->N3_VRDACM4
			SN4->N4_VLROC5:=SN3->N3_VRDACM5
			SN4->N4_TXMEDIA:=SN3->N3_VRDACM1/SN3->N3_VRDACM3
			SN4->N4_TXDEPR:=SN3->N3_TXDEPR1
			SN4->N4_SEQ:="001"
			msUnlock()
		EndIf
	EndIf
	
	dbSelectArea("SN3")
	dbSkip()
	
EndDo

msgStop("FIM")

Return