#INCLUDE "PROTHEUS.CH"

User Function zBUSDBC(CCTA,CCUS) 

Local cRegra 	:= ""
Local cRet 		:= ""
Local cClvl 	:= ""
Local cConta 	:= ALLTRIM(CCTA)
Local CCTA 		:= ALLTRIM(CCTA)
Local CCUS 		:= ALLTRIM(CCUS)

Local aAreaCTT 	:= CTT->(GetArea())
Local aAreaCT1 	:= CT1->(GetArea())

IF CCTA $ "PCFYZ"

	DO CASE
		CASE CCTA == "P"
	    	cConta := SB1->B1_CONTA
		CASE CCTA == "C"
			cConta := SA1->A1_CONTA
		CASE CCTA == "F"
			
			cConta := SA2->A2_CONTA
		CASE CCTA == "Z"
			      
		If CCUS <> ""		
			CTT->(DbSelectArea("CTT"))
			CTT->(DbSetOrder(1))   
			If CTT->(DbSeek(xFilial("CTT") + CCUS))
				cRegra := ALLTRIM(CTT->CTT_CRGNV1)
			Endif
		
			Do Case
				Case cRegra=="A" 
					cConta := SB1->B1_ZZCTAD
				Case cRegra=="C" 
					cConta := SB1->B1_ZZCTADC	
				Case cRegra=="D" 
					cConta := SB1->B1_ZZCTAC	
				Case cRegra=="I" 
					cConta := SB1->B1_ZZCTACI	
			EndCase				
		
		EndIf
	
	EndCase
	
EndIf

	If cConta <> ""
	
		CT1->(DbSelectArea("CT1"))
		CT1->(DbSetOrder(1))
		If CT1->(DbSeek(xFilial("CT1")+cConta))
			cClvl := ALLTRIM(CT1->CT1_GRUPO)
		EndIf		
	
	Endif

	RestArea(aAreaCTT)
	RestArea(aAreaCT1)								

Return (cClvl)

