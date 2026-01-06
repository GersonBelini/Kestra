#Include 'Protheus.ch'

User Function MT110TOK()
	Local lRet	:= .T.
	
	For nR := 1 to len(aCols)
		If !aCols[nR,Len(aHeader)+1]
			If empty(aCols[nR,GdFieldPos("C1_CC")])
				dbSelectArea("SC1")
				dbSetOrder(1)//C1_FILIAL+C1_NUM+C1_ITEM
				If dbSeek(xFilial("SC1")+CA110NUM+aCols[nR,GdFieldPos("C1_ITEM")])
					If empty(SC1->C1_PEDIDO)
						lRet := .F.
						msgAlert("Campo do Centro de Custo não preenchido, reveja os itens!","CAMPO OBRIGATÓRIO")
						Exit
					EndIf
				Else
					lRet := .F.
					msgAlert("Campo do Centro de Custo não preenchido, reveja os itens!","CAMPO OBRIGATÓRIO")
					Exit
				EndIf
			EndIf
		EndIf 
	Next

Return lRet

