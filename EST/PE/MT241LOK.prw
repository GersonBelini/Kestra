#Include 'Protheus.ch'

User Function MT241LOK()
	Local lRet := .T.
	If lRet
		lRet := u_validMov(RetCodUsr(),aCols[N,GdFieldPos("D3_LOCAL")])
	EndIf
Return lRet

