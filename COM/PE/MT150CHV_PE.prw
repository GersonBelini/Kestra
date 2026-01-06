#Include 'Protheus.ch'
/*/{Protheus.doc} MT150CHV

Ponto de entrada que permite alterar a chave de exclusão quando selecionada a opção de exclusão por produto.
	
@author Diego de Angeloo
@since 29/03/2015

@return Caracter Nova chave a ser utilizada durante a exclusão.
/*/
user function MT150CHV()
	local cChave	:= ""
	local lWf		:= IsInCallStack("U_WFLOW04") 
	
	if lWf
		dbSelectArea("SC8")
		SC8->(dbSetOrder(1))
		SC8->(dbSeek(xFilial("SC8")+cNumCot + cFornec + cLoja + cItem))
		cChave:= "SC8->C8_NUM+SC8->C8_FORNECE+SC8->C8_LOJA+SC8->C8_ITEM"
	endIf
return cChave

