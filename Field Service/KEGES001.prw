#include "Totvs.ch"

User Function KEGES001()

Local cNumSeri :=""
Local cCliente := M->AA3_CODCLI
Local cLoja    := M->AA3_LOJA
Local cProduto := M->AA3_CODPRO  
Local aAreaAA3 := AA3->(GetArea())

AA3->(dbSetOrder(1))
if AA3->(dbSeek(xFilial("AA3")+cCliente+cLoja+cProduto))  // Procura se ja existe numero de serie para o cliente + produto
	While AA3->(!Eof()) .and. AA3->AA3_FILIAL+AA3->AA3_CODCLI+AA3->AA3_LOJA+AA3->AA3_CODPRO == xFilial("AA3")+cCliente+cLoja+cProduto
		cNumSeri := AA3->AA3_NUMSER
		AA3->(dbSkip())
	EndDo
	cNumSeri := soma1(cNumSeri)
else
	cNumSeri := "00000000000000000001"  // Caso nao exista numero de serie para o cliente + produto, gera um novo numero
endif

RestArea(aAreaAA3)

Return(cNumSeri)  