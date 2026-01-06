#Include 'Protheus.ch'
#include "topconn.ch"

User Function retOPAberta(cProduto)
	Local nRet 		:= 0
	Local cQuery 	:= ""
	
	cQuery += "SELECT SUM(C2_QUANT - C2_QUJE) AS TOTAL " + CRLF
	cQuery += " FROM "+RetSqlName("SC2")+" " + CRLF
	cQuery += " WHERE D_E_L_E_T_=' ' " + CRLF
	cQuery += " AND C2_DATRF = ' ' " + CRLF
	cQuery += " AND C2_QUANT - C2_QUJE > 0 " + CRLF
	cQuery += " AND C2_PRODUTO = '"+cProduto+"' "
	
	TCQUERY cQuery NEW ALIAS "TEMPOP"
	
	TEMPOP->(dbGoTop())
	
	If TEMPOP->(!Eof())		
		nRet := TEMPOP->TOTAL
	EndIf
	TEMPOP->(dbCloseArea())

Return nRet

