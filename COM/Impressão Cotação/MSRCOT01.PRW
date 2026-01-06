#Include "Protheus.ch"   

User Function MSRCOT01() 	
Local cOpt
Local lAuto := .F.
Local cNum  := ""

If Type("PARAMIXB") == "A"
	If Type("PARAMIXB[1]") == "C"
		cNum := PARAMIXB[1]
	Endif
Endif

lAuto := !Empty(cNum)

If MsgYesNo("Deseja Enviar Relatório via E-Mail?","Envia E-Mail")
	cOpt := "mail"
else
	cOpt := "grafico"
Endif

If cOpt == "mail"
	U_MSRCOTHT(lAuto,cNum)
Else
	U_MSRCOTGF(lAuto,cNum)
EndIf     

Return