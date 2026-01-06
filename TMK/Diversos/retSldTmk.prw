#Include 'Protheus.ch'

User Function retSldTmk(lGat)
	Local nRet		:= ""	
	Default lGat	:= .F.
	
	If lGat
		dbSelectArea("SB2")
		dbSetOrder(1)
		dbSeek(xFilial("SB2") + M->UB_PRODUTO +"04")
	Else
		dbSelectArea("SB2")
		dbSetOrder(1)
		dbSeek(xFilial("SB2") + SUB->UB_PRODUTO +"04")
	EndIf	
	nRet := saldoSB2(,.T.)

Return nRet

