#Include 'Protheus.ch'

User Function MT107GRV()

	RecLock("SCP",.F.)
		SCP->CP_USRAPRO := CUSERNAME
		SCP->CP_HORAPRO := time()
		SCP->CP_DATAPRO	:= dDataBase	
	MsUnLock()

Return

