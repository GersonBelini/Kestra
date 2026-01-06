#Include 'Protheus.ch'

User Function MT107QRY()
	Local cRet		:= ""
	
	If !(retCodUsr() $ getMV("MV_ZZLIBSOL"))
		cRet += " CP_LOCAL <> '13' "		
	EndIf	 
		
Return cRet