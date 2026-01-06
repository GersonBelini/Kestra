#Include "Protheus.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fLPGrim   ºAutor  ³microsiga           º Data ³  05/10/13   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina responsavel pelo retorno da Conta Contabil de acordo º±±
±±º          ³com a classificação do Centro de Custo                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Especifico kestra                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function CTBFOL(nOpcao)

Local cRet := ""

CTT->(dbSetOrder(1))
If CTT->(dbSeek(xFilial("CTT") + SRZ->RZ_CC))
	
	If nOpcao == 1					&& Débito
		If ALLTRIM(CTT->CTT_CRGNV1) == "A"
			Return SRV->RV_ZZCDADM
		ElseIf ALLTRIM(CTT->CTT_CRGNV1) == "C"
			Return SRV->RV_ZZCDCML
		ElseIf ALLTRIM(CTT->CTT_CRGNV1) == "D"
			Return SRV->RV_ZZCDPDI
		ElseIf ALLTRIM(CTT->CTT_CRGNV1) == "I"
			Return SRV->RV_ZZCDPIN
		Endif
		
	ElseIf nOpcao == 2				&& Crédito
		If ALLTRIM(CTT->CTT_CRGNV1) == "A"
			Return SRV->RV_ZZCCADM
		ElseIf ALLTRIM(CTT->CTT_CRGNV1) == "C"
			Return SRV->RV_ZZCCCML
		ElseIf ALLTRIM(CTT->CTT_CRGNV1) == "D"
			Return SRV->RV_ZZCCPDI
		ElseIf ALLTRIM(CTT->CTT_CRGNV1) == "I"
			Return SRV->RV_ZZCCPIN
		Endif
	Endif
Endif

Return cRet
