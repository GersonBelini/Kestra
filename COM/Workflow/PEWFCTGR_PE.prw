#Include 'Protheus.ch'

User Function PEWFCTGR()	
	Local oProcess  := PARAMIXB[1]
	Local nItem		:= PARAMIXB[2]
	
	dbSelectArea("SA5")
	dbSetOrder(1)//A5_FILIAL+A5_FORNECE+A5_LOJA+A5_PRODUTO
	If dbSeek(xFilial("SA5")+SC8->C8_FORNECE+SC8->C8_LOJA+SC8->C8_PRODUTO)    
		If !empty(SA5->A5_UNID) .AND. !empty(SA5->A5_ZZFATOR) .AND. !empty(SA5->A5_ZZTPCON)
			nPrcTot := SC8->C8_PRECO
			If SA5->A5_ZZTPCON == "M"
				nQuant		:= SC8->C8_QUANT * SA5->A5_ZZFATOR
				nPrcTot		:= SC8->C8_PRECO * nQuant				
			ElseIf SA5->A5_ZZTPCON == "D"
				nQuant		:= SC8->C8_QUANT / SA5->A5_ZZFATOR
				nPrcTot		:= SC8->C8_PRECO * nQuant				
			EndIf	
			
			RecLock("SC8",.F.)
				SC8->C8_PRECO		:= nPrcTot / SC8->C8_QUANT
				SC8->C8_TOTAL		:= nPrcTot										
			    SC8->C8_BASEICM  	:= IIf(SC8->C8_PICM > 0, nPrcTot, 0)			    
			    SC8->C8_BASEIPI  	:= IIf(SC8->C8_ALIIPI > 0, nPrcTot, 0)
			    SC8->C8_VALICM  	:= IIf(SC8->C8_PICM > 0,SC8->C8_BASEICM * nPrcTot / 100, 0)			    
			    SC8->C8_VALIPI  	:= IIf(SC8->C8_ALIIPI > 0,SC8->C8_BASEIPI * SC8->C8_ALIIPI / 100, 0) 			    			   
			SC8->(MsUnLock())										
		EndIf	
	EndIf
	 
Return

