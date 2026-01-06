#include "totvs.ch"
#include "topconn.ch"

/*
Autor: 	Guilherme Ricci
Data:	19/01/2017
Uso:	Criado para permitir que o pedido tenha sua liberação de estoque (reserva) estornada, sem que o item seja retornado ao financeiro para reliberação.
		Solicitado por Daniel Rizzo.
		Utiliza o ponto de entrada MTA455NL para alimentar a variavel __lBotaoOK.
*/

User Function NovaLibe()

	Local cQuery	:= ""
	Local cProduto	:= SC9->C9_PRODUTO
	Local cPedido	:= SC9->C9_PEDIDO
	Local cItem		:= SC9->C9_ITEM
	Local cLote		:= SC9->C9_LOTECTL
	Local cQuant	:= cValToChar(SC9->C9_QTDLIB)
	Local nIndice	:= SC9->(IndexOrd())

	Public __lBotaoOK := .F.

	A455LibAlt(Alias(), Recno(), 0) // Funcao padrao
	
	If GetMV("MV_OPLBEST") == 2 .and. __lBotaoOK

		cQuery := " SELECT C9.R_E_C_N_O_ X" + CRLF
		cQuery += " FROM " + RetSqlName("SC9") + " C9" + CRLF
		cQuery += " WHERE C9_FILIAL = '" + xFilial("SC9") + "'" + CRLF
		cQuery += " AND C9_PRODUTO = '" + cProduto + "'" + CRLF
		cQuery += " AND C9_PEDIDO = '" + cPedido + "'" + CRLF
		cQuery += " AND C9_ITEM = '" + cItem + "'" + CRLF
		cQuery += " AND C9_LOTECTL = ' '" + CRLF
		cQuery += " AND C9_QTDLIB = " + cQuant  + CRLF
		cQuery += " AND C9_DATALIB = '" + DtoS(dDatabase) + "'" + CRLF
		cQuery += " AND C9.D_E_L_E_T_=' '"
		
		If Select("QSC9") > 0
			QSC9->(dbCloseArea())
		Endif
		
		tcQuery cQuery New Alias "QSC9"
		
		While QSC9->(!eof())
			SC9->(dbGoTo(QSC9->X))
			If SC9->C9_BLCRED == "01"
				Reclock("SC9",.F.)
					SC9->C9_BLCRED := ""
				SC9->(MsUnlock())
			Endif
			QSC9->(dbSkip())
		EndDo
	Endif

	SC9->(dbSetOrder(nIndice))
Return