#Include 'Protheus.ch'

User Function impTmk()

	If SUA->UA_OPER == '2'
		u_TMKR3A()
	ElseIf SUA->UA_OPER == '1'
		u_TMKR03()
	Else
		msgAlert("Layout nao encontrado!")
	EndIf

Return

