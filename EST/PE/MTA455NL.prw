#INCLUDE "totvs.ch"

/*
Autor: 	Guilherme Ricci
Data:	19/01/2017
Uso:	Criado para permitir que o pedido tenha sua liberação de estoque (reserva) estornada, sem que o item seja retornado ao financeiro para reliberação.
		Solicitado por Daniel Rizzo.
		Variavel __lBotaoOK é criada no fonte NOVALIB.
		Este ponto de entrada somente é executado quando o usuário confirma a tela da nova liberação.
*/

User Function MTA455NL

	If Type("__lBotaoOK") == "L"
		__lBotaoOK := .T.
	Endif

Return