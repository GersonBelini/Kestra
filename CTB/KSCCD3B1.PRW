#INCLUDE "PROTHEUS.CH"

User Function KSCCD3B1(CCC) 
Local cRegra := ""
Local cConta := ""
Local aAreaCTT := CTT->(GetArea())
Local aAreaSB1 := SB1->(GetArea())
	If !EMPTY(CCC)
	    CTT->(DbSelectArea("CTT"))
        CTT->(DbSetOrder(1))   
        If CTT->(DbSeek(xFilial("CTT") + CCC))
			cRegra := ALLTRIM(CTT->CTT_CRGNV1)
		Endif
		
		SB1->(DbSelectArea("SB1"))
		SB1->(DbSetOrder(1))	
		If SB1->(DbSeek(xFilial("SB1") +  aCols[ n, nPosCod]))
			Do Case
				Case cRegra="A" 
					cConta := SB1->B1_ZZCTAD
				Case cRegra="C" 
					cConta := SB1->B1_ZZCTADC	
				Case cRegra="I" 
					cConta := SB1->B1_ZZCTAC	
				Case cRegra="D" 
					cConta := SB1->B1_ZZCTACI	
				OtherWise && outra regra ou vazio
					cConta :="REGRA CC INVALIDA"
			EndCase				
	    EndIf
										
	EndIf
		
		If ALLTRIM(cConta) == "" 
			cConta := "CONTA NAO CADASTRADA"
		EndIf
	
	RestArea(aAreaSB1)
	RestArea(aAreaCTT)

	
Return (cConta)

/*

Regra do LP de consumo:
IF(ALLT(CTT->CTT_CRGNV1)=="A",SB1->B1_ZZCTAD,
IF(ALLT(CTT->CTT_CRGNV1)=="C",SB1->B1_ZZCTADC,
IF(ALLT(CTT->CTT_CRGNV1)=="D",SB1->B1_ZZCTAC,
IF(ALLT(CTT->CTT_CRGNV1)=="I",SB1->B1_ZZCTACI,
"PROD."+SB1->B1_COD))))                                                 
*/

