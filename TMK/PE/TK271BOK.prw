#include 'protheus.ch'
#include 'parmtype.ch'

User Function TK271BOK()
	Local lRet		:= .T.
	Begin Transaction
	For nH := 1 to len(aCols)
		//Se deletado
		If aCols[nH][len(aCols[nH])]
			If empty(aCols[nH][GdFieldPos("UB_ZZCODMT")])
				lRet := .F.
				msgAlert("Existem linhas apagadas sem motivo!")
				disarmTransaction()	
				Exit
			Else
				RecLock("SZ8",.T.)
					SZ8->Z8_FILIAL 	:= xFilial("SZ8")
					SZ8->Z8_NUM 	:= SUA->UA_NUM
					SZ8->Z8_CLIENTE := SUA->UA_CLIENTE
					SZ8->Z8_LOJA 	:= SUA->UA_LOJA
					SZ8->Z8_ITEM 	:= aCols[nH][GdFieldPos("UB_ITEM")]
					SZ8->Z8_PRODUTO	:= aCols[nH][GdFieldPos("UB_PRODUTO")]
					SZ8->Z8_QUANT 	:= aCols[nH][GdFieldPos("UB_QUANT")]
					SZ8->Z8_VRUNIT	:= aCols[nH][GdFieldPos("UB_VRUNIT")]
					SZ8->Z8_VLRITEM	:= aCols[nH][GdFieldPos("UB_VLRITEM")]
					SZ8->Z8_ZZCODMT	:= aCols[nH][GdFieldPos("UB_ZZCODMT")]
					SZ8->Z8_ZZDESMT	:= aCols[nH][GdFieldPos("UB_ZZDESMT")]
					SZ8->Z8_USUARIO	:= retCodUsr()
					SZ8->Z8_DATA	:= dDataBase
					SZ8->Z8_HORA	:= time()
					SZ8->Z8_ORIGEM	:= Iif(SUA->UA_OPER=="1","FATURAMENTO","ORCAMENTO")
				MsUnlock()
				
			EndIf				
		Else
			If empty(aCols[nH][GdFieldPos("UB_NUMPCOM")])
				aCols[nH][GdFieldPos("UB_NUMPCOM")] := M->UA_ZZPEDCL				
			EndIf 
			If M->UA_OPER == "1"
				If empty(aCols[nH][GdFieldPos("UB_NUMPCOM")]) .OR. empty(aCols[nH][GdFieldPos("UB_ITEMPC")])
					If !msgYesNo("Item "+alltrim(cValtoChar(nH))+" não está com o pedido/item do cliente informado corretamente, deseja continuar?","ATENÇÃO")
						lRet := .F.					
						disarmTransaction()	
						Exit
					EndIf
				EndIf
			EndIf
		EndIf			
	Next	
	End Transaction
		
	If lRet .AND. M->UA_OPER == "1"
		dbSelectArea("SA1")		
		dbSetOrder(1)
		dbSeek(xFilial("SA1")+M->UA_CLIENTE+M->UA_LOJA)
		If SA1->A1_MSBLQL == "1"
			msgAlert("Cliente Bloqueado, não é possivel gerar pedido!","ATENÇÃO")
			lRet := .F.
		EndIf
	EndIf

Return lRet