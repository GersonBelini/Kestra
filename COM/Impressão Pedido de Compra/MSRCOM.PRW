#Include "Protheus.ch"   

User Function MSRCOM() 	

Local cOpt
Local lAuto		:= .F.
Local cPedNum	:= ""

&& Verifica se a chamada foi feita atraves da rotina padrao mata121
If Type("PARAMIXB") != "U"
	If ValType(PARAMIXB) = "A"
		If Len(PARAMIXB) >= 2
			If ValType(PARAMIXB[2]) = "N"
				If PARAMIXB[2] > 0
					lAuto	:= .T.
					dbSelectArea("SC7")
					SC7->(dbGoTo(PARAMIXB[2]))
					cPedNum	:= SC7->C7_NUM
				Endif
			Endif
		Endif
	Endif
Endif
	
//If MsgYesNo("Deseja Enviar Relatório via E-Mail?","Envia E-Mail")
//	U_MSRCOMHT(lAuto,cPedNum)
//else
	U_MSRCOMGF(lAuto,cPedNum)
//Endif

Return