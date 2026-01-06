User Function TK271COR(cPasta)

Local aArea  := GetArea()
Local aCores := {}
Local cOpcao	:= ""

	If cPasta == '2' //Televendas      
	
		aCores := { {'(!EMPTY(SUA->UA_CODCANC))'																					, "BR_PRETO"	},;
					{'(VAL(SUA->UA_OPER) == 1 .AND. Empty(Posicione("SC5",1,xFilial("SC5")+SUA->UA_NUMSC5,"C5_LIBEROK")) .AND. Empty(Posicione("SC5",1,xFilial("SC5")+SUA->UA_NUMSC5,"C5_NOTA")) .AND. Empty(Posicione("SC5",1,xFilial("SC5")+SUA->UA_NUMSC5,"C5_BLQ")))'		, "BR_VERDE"   	},;
					{'(VAL(SUA->UA_OPER) == 1 .AND. !Empty(Posicione("SC5",1,xFilial("SC5")+SUA->UA_NUMSC5,"C5_NOTA")))' 															, "BR_VERMELHO"	},;
		            {'(VAL(SUA->UA_OPER) == 2)'																						, "BR_AZUL"		},;
		            {'(VAL(SUA->UA_OPER) == 1 .AND. !Empty(Posicione("SC5",1,xFilial("SC5")+SUA->UA_NUMSC5,"C5_LIBEROK")) .AND. Empty(Posicione("SC5",1,xFilial("SC5")+SUA->UA_NUMSC5,"C5_NOTA")) .AND. Empty(Posicione("SC5",1,xFilial("SC5")+SUA->UA_NUMSC5,"C5_BLQ")))'		, "BR_AMARELO"	},;
		            {'(VAL(SUA->UA_OPER) == 3)' 																  					, "BR_MARRON"	},;
		            {'(VAL(SUA->UA_OPER) == 1 .AND. Posicione("SC5",1,xFilial("SC5")+SUA->UA_NUMSC5,"C5_BLQ")=="1")' 																, "BR_LARANJA"	}}
	EndIf

	&& CORES:
	&& VERDE = Pedido em Carteira
	&& VERMELHO = NF Emitida
	&& AZUL = Orçamento
	&& AMARELO = Pedido Liberado / NF Parcial
	&& MARROM = Atendimento 
	&& LARANJA = Bloqueado por Regra
	&& PRETO = Cancelado

RestArea(aArea)

Return(aCores)