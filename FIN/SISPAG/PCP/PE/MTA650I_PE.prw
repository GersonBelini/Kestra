#Include 'Protheus.ch'

/*/{Protheus.doc} MTA650I

PE após a gravação da OP.
1 - Usado para gerar o numero da corrida.
	
@author André Oquendo
@since 24/04/2015

/*/


User Function MTA650I()

	If empty(SC2->C2_SEQPAI)
		If ExistBlock("retCorri")
			ExecBlock("retCorri",.F.,.F.)
		EndIf
	Else
		If ExistBlock("copCorri")
			ExecBlock("copCorri",.F.,.F.)
		EndIf
	EndIf

Return

