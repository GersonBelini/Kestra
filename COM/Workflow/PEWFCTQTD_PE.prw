#Include 'Protheus.ch'

User Function PEWFCTQTD()
	Local aArea    		:= GetArea()
	Local aAreaSC8 		:= SC8->(GetArea())
	Local nRet	       	:= TMPSC8->C8_QUANT
	dbSelectArea("SA5")
	dbSetOrder(1)//A5_FILIAL+A5_FORNECE+A5_LOJA+A5_PRODUTO
	If dbSeek(xFilial("SA5")+TMPSC8->C8_FORNECE+TMPSC8->C8_LOJA+TMPSC8->C8_PRODUTO)    
		If !empty(SA5->A5_UNID) .AND. !empty(SA5->A5_ZZFATOR) .AND. !empty(SA5->A5_ZZTPCON)			
			If SA5->A5_ZZTPCON == "M"
				nRet	:= nRet * SA5->A5_ZZFATOR				
			ElseIf SA5->A5_ZZTPCON == "D"
				nRet	:= nRet / SA5->A5_ZZFATOR				
			EndIf				
		EndIf	
	EndIf	  
	RestArea(aAreaSC8)
	RestArea(aArea)         
Return nRet