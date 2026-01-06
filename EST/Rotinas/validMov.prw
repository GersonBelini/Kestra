#Include 'Protheus.ch'
#Include 'TopConn.ch'

User Function validMov(cCodUsr,cLocal)
	Local lRet := .f.
	Local cQuery	:= ""
	
	cQuery += " SELECT " + CRLF
	cQuery += " 	* " + CRLF
	cQuery += " FROM "+RetSqlName("SZ9")+" SZ9 " + CRLF
	cQuery += " WHERE SZ9.D_E_L_E_T_ = ' ' " + CRLF 
	cQuery += " AND Z9_CODUSR = '"+cCodUsr+"' " + CRLF
	cQuery += " AND (Z9_LOCAL = 'ZZ' " + CRLF
	cQuery += " OR Z9_LOCAL = '"+cLocal+"') " + CRLF
	
	TcQuery cQuery New Alias "QRYAUX"
	QRYAUX->(DbGoTop())
	
	If QRYAUX->(!Eof())
		lRet := .T.
	Else
		msgAlert("Movimentação não permitida nesse armazem!","ATENCAO")
	EndIf
	
	QRYAUX->(DbCloseArea())

Return lRet

