#Include "RWMAKE.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณALTPAR    บAutor  ณ RICARDO BATAGLIA   บ Data ณ  13/03/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Este programa serve para alterar alguns parโmetros,        บฑฑ
ฑฑบ          ณ barrando desta forma a operacinalidade por parte do        บฑฑ
ฑฑบ          ณ usuแrio. M๓dulos tratados: entrada de NF/Faturamento,      บฑฑ
ฑฑบ          ณ Financeiro (movimentos e reconcilia็ใo), Livros Fiscais    บฑฑ
ฑฑบ          ณ (escritura็ใo).                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Fun็ใo carregada atrav้s do menu. Programa desenhado para  บฑฑ
ฑฑบUso       ณ Protheus 8.                                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
                                                                                                                                  
// IMPLANTADO NA KESTRA POR RICARDO BATAGLIA EM 07/2015                                                                

User Function ALTPAR()
// Defini็ใo das variแveis do programa.     
Local  _cUsu		:= GetMv("ZJ_PCCTB")   // Usuario(s) com permissao para alteracao dos parametros. | Paulo Prado 05/01/09 | 
Public _mvDatafis 	:= GetMv("MV_DATAFIS")
Public _mvDatafin 	:= GetMv("MV_DATAFIN")
Public _mvDatarec 	:= GetMv("MV_DATAREC")
Public _mvDblqmov 	:= GetMv("MV_DBLQMOV")                                          


// Verifica se o usuแrio ้ o Administrador do sistema ou usuแrios autorizados.
If !Alltrim(SubStr(cUsuario,7,15)) $ _cUsu
	Alert("Somente o Administrador ou usuแrios autorizados podem executar esta rotina.")
	Return
EndIf

// Solicita ao usuแrio nome do arquivo.
@ 150,  1 TO 400, 435 DIALOG oMyDlg TITLE OemToAnsi("Bloqueio de Parโmetros")
@   2, 10 TO 110, 210
@  10, 18 Say " Data limite p/opera็๕es fiscais ?"
@  10,115 Get _mvDatafis Size 50,50
@  20, 18 Say " Data limite p/opera็๕es financeiras ?"
@  20,115 Get _mvDatafin Size 50,50
@  30, 18 Say " Data limite p/reconcilia็ใo banc. ?"
@  30,115 Get _mvDatarec Size 50,50
@  40, 18 Say " Data limite p/bloqeio do estoque?"
@  40,115 Get _mvDblqmov Size 50,50
@  50, 18 Say " ฺltimo fech.estoque: " + Transform(GETMV("MV_ULMES"),"@D")
@  60, 18 Say " ฺltimo cแlc.deprec.: " + Transform(GETMV("MV_ULTDEPR"),"@D")
@  70, 18 Say ""
@  80, 18 Say ""
@  90, 18 Say ""
@  100, 18 Say ""
@ 110,150 BMPBUTTON TYPE 01 ACTION (RunProc(), Close(oMyDlg))
@ 110,180 BMPBUTTON TYPE 02 ACTION Close(oMyDlg)
Activate Dialog oMyDlg Centered

Return

Static Function RunProc()
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณRUNPROC   บAutor  ณ                    บ Data ณ  02/11/04   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Fun็ใo para alterar os parโmetros.                         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ fun็ใo ALTPAR.                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

// Faz valida็๕es e Altera os parโmetros. 
If !Empty(_mvDatafis)
	PutMv("MV_DATAFIS",_mvDatafis)
EndIf

If !Empty(_mvDatafin)
	PutMv("MV_DATAFIN",_mvDatafin)
EndIf

If !Empty(_mvDatarec)
	PutMv("MV_DATAREC",_mvDatarec)
EndIf

If !Empty(_mvDblqmov)
	PutMv("MV_DBLQMOV",_mvDblqmov)
EndIf


Return