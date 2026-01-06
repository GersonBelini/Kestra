#Include "Protheus.ch"

/*
 * Função:			MT120GOK
 * Autor:			Waldir Baldin
 * Data:			26/04/2013
 * Descrição:		PE disparado após a execução da função de gravação A120GRAVA e antes da contabilização do PC / AE.
 *					Serve para Inclusão, Alteração como Exclusão.
 */
User Function MT120GOK()
	Local cPedido		:= PARAMIXB[01]		&& Número do Pedido de Compra
	Local lInclui		:= PARAMIXB[02]		&& Inclusão
	Local lAltera		:= PARAMIXB[03]		&& Alteração
	Local lExclusao		:= PARAMIXB[04]		&& Exclusão
	Local cMsgTxt		:= ""

	If lExclusao .And. !IsBlind()
		cMsgTxt := "O Pedido de Compra foi excluído do sistema Protheus, porém, o Fornecedor"	+ CRLF
		cMsgTxt += "pode ter recebido o e-mail do workflow e já ter providenciado a Produção"	+ CRLF
		cMsgTxt += "ou Faturamento relativo a este Pedido de Compra, portanto, é de nossa"		+ CRLF
		cMsgTxt += "total responsabilidade, tomar as devidas providências MANUAIS para evitar"	+ CRLF
		cMsgTxt += "problemas futuros."															+ CRLF
		Aviso("Atenção", cMsgTxt, {"OK"}, 3, FunDesc())
	ElseIf !lExclusao .And. !IsBlind()
		U_WFPC()						// Envio workflow de pedido de compra pelo quando a cotação de compra nacional
	ElseIf lInclui .Or. lAltera
		U_WFLOW03(1)					// Envio workflow de pedido de compra quando é feita pelo processo normal.
	EndIf
Return
