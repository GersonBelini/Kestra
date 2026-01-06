#Include 'Protheus.ch'

User Function MTA105LIN()
	Local lRet 		:= .T.
	dbSelectArea("SZA")
	dbSetOrder(1)
	If !dbSeek(xFilial("SZA")+retCodUsr()+aCols[n][gdFieldPos("CP_CC"))
		lRet := .F.
		msgAlert("Centro de Custo não permitido!","ERRO")
	EndIf

Return lRet

