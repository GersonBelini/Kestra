#include "totvs.ch"
#include "topconn.ch"

// Autor : Guilherme Ricci
// Funcao: Zerar empenhos de ordens que foram encerradas e por qualquer motivo ficaram com seus empenhos em aberto

User Function ZeraEmpG()

Private oDlg

Define msDialog oDlg from 200,1 to 390,390 Title OemToAnsi("Arquivo TXT ECF ") Pixel
@ 02,10 TO 080,190 Pixel
@ 10,018 Say " Este programa ira zerar os empenhos das ordens que ja foram     " of oDlg Pixel
@ 18,018 Say " encerradas e não tiveram seus empenhos encerrados por qualquer " of oDlg Pixel
@ 26,018 Say " motivo.                              " of oDlg Pixel

Define sButton From 80,98 Type 1 of oDlg Enable Pixel Action {|| Processa({||Roda()}), oDlg:End() }
Define sButton From 80,128 Type 2 of oDlg Enable Pixel Action oDlg:End()
//Define sButton From 80,158 Type 5 of oDlg Enable Pixel Action Pergunte(_cPerg,.T.)

Activate Dialog oDlg Centered

Return

Static Function Roda()

Local aVetor 	:= {}
Local cQuery 	:= ""
Local nRegs		:= 0

Private lMsErroAuto := .F.
Private lMSHelpAuto := .T.

cQuery := "SELECT D4.R_E_C_N_O_ X " + CRLF
cQuery += " FROM SD4010 D4" + CRLF
cQuery += " INNER JOIN SC2010 C2 ON C2.D_E_L_E_T_=' ' AND C2_NUM+C2_ITEM+C2_SEQUEN = D4_OP" + CRLF
cQuery += " WHERE D4.D_E_L_E_T_=' '" + CRLF
cQuery += " AND D4_QUANT > 0" + CRLF
cQuery += " AND C2_DATRF <> ' '"

tcQuery cQuery New Alias "TEMPOP"

COUNT TO nRegs
TEMPOP->(dbGoTop())

ProcRegua(nRegs)
IncProc()

dbSelectArea("SD4")
//BEGIN TRANSACTION

While TEMPOP->(!eof())
	IncProc()
	SD4->(dbGoTo(TEMPOP->X))
	
	aVetor:={{"D4_COD"     	,SD4->D4_COD,NIL},;
	          {"D4_OP"     	,SD4->D4_OP,NIL},;
	          {"D4_TRT"     ,SD4->D4_TRT,NIL},;
	          {"D4_LOCAL"   ,SD4->D4_LOCAL,NIL},;
	          {"D4_QTDEORI"	,SD4->D4_QTDEORI,NIL},;
	          {"D4_QUANT"   ,SD4->D4_QUANT,NIL},;
	          {"ZERAEMP"    ,"S",NIL}} //Zera empenho do processo de assistencia
	          
	MSExecAuto({|x,y| MATA380(x,y)},aVetor,4) 
	
	TEMPOP->(dbSkip())
EndDo

MsgInfo("Processo concluído.")

//END TRANSACTION

Return