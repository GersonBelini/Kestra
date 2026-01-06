#include "protheus.ch"
#include "rwmake.ch"  
#include "totvs.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MT103IPC  ºAutor - TOTVS IP     º Data ³ 28/02/2013         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±³Descricao ³ Ponto de Entrada na amarracao do pedido de compra na       ³±±
±±³          ³ nota fiscal de entrada                                     ³±±
±±³          ³ Finalidade: atualizar campos na tabela SD1                 ³±±
±±º			 ³						  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MT103IPC()

Local aArea    := GetArea()
Local aAreaSC7 := SC7->(GetArea())
Local aAreaSD1 := SD1->(GetArea())
Local _cItem   := PARAMIXB[1]
Local cDescr   := SC7->C7_DESCRI
//Local cObs	   := SC7->C7_OBS
Local nPosDesc := GDFieldPos("D1_ZZDESPR")
//Local nPosObs  := GDFieldPos("D1_ZZOBS")

If nPosDesc > 0 
	aCols[ _cItem , nPosDesc ] := cDescr
Endif

//If nPosObs > 0
//	aCols[ _cItem , nPosObs  ] := cObs
//Endif
  
RestArea(aAreaSD1)
RestArea(aAreaSC7)
RestArea(aArea)  

Return