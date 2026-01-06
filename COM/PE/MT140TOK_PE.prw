#Include 'Protheus.ch'

/*/{Protheus.doc} MT140TOK

Ponto de entrada na validação de todos os itens da NF de entrada.
Usado para gerar o lote dos produtos.
	
@author André Oquendo
@since 07/05/2015

@return Caracter Numero do lote.
/*/

User Function MT140TOK_PE()

	
	If ExistBlock("grvLoteE")
		ExecBlock("grvLoteE",.F.,.F.)
	EndIf

Return .T.

