#INCLUDE "PROTHEUS.CH"

/*/{Protheus.doc} CT270GRD

Ponto de entrada para depois da gravação
	
@author André Oquendo
@since 09/04/2015

/*/

User function CT270GRD()
	
	Local aArea    		:= GetArea()
	Local aAreaCTQ 		:= CTQ->(GetArea())
	Local cRateio			:= CTQ->CTQ_RATEIO
	
	If type("_cCrit") != "U"		
		dbSelectArea("CTQ")
		dbSetOrder(1)//CTQ_FILIAL+CTQ_RATEIO+CTQ_SEQUEN
		dbSeek(xFilial("CTQ")+cRateio)
		
		While CTQ->(!Eof()) .AND. CTQ->CTQ_RATEIO == cRateio
			RecLock("CTQ",.F.)
				CTQ->CTQ_ZZCRAT	:= _cCrit
			MsUnlock()
			CTQ->(DbSkip())			
		EndDo
		
		_cCrit := NIL
	EndIF
	
	RestArea(aAreaCTQ)
	RestArea(aArea)

Return