#include "totvs.ch"

User Function A650OPI()

// Ponto de entrada para eliminar problema de duplicidade de ordens intermediarias que foram geradas manualmente.
Local nPosComp  	:= aScan(aHeader, {|x| x[2] == "G1_COMP"})
Local nX			:= PARAMIXB // Variavel que guarda qual a linha do aCols que esta posicionada
Local cNum			:= SC2->C2_NUM
Local cItem			:= SC2->C2_ITEM
Local cSequen		:= SC2->C2_SEQUEN
Local aAreaAtu		:= GetArea()
Local aAreaSC2		:= SC2->(GetArea())
Local lRet			:= .T.

SC2->(dbSetOrder(1))
If SC2->( dbSeek( xFilial("SC2") + cNum + cItem + Strzero(Val(cSequen)+1,3,0) ) ) // Verifica se a proxima sequencia ja foi gerada manualmente
	lRet := .F.
Endif
  
RestArea(aAreaSC2)
RestArea(aAreaAtu)

Return lRet