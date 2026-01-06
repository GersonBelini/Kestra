#include "Protheus.ch"
#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³  BKPCFG  ³ Autor ³ DONIZETE              ³ Data ³ 12/01/05 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Este programa gera backup dos arquivos do Ativo.           ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Chamada atraves do menu miscelanea.                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Alterado ³ Data    ³ Motivo                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Diogo M. ³ 05/03/10³ Adaptado rotina para fazer backup de todos os re ³±±
±±³          ³         ³ gistros das tabelas, independente se o mesmo est ³±±
±±³          ³         ³ a deletado ou nao; Implementado opcao restore.   ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function BKPCFG()
Local lEnd			:= .F.
Local aOpcoes		:= IIf(AllTrim(cUserName)=='Administrador',{"Backup"},{"Backup"})

Private aParamBox	:= {}         

// Declaração de variáveis.
Public _cNomArq		:= ""
Public _cArqDest1	:= ""
Public _cData		:= "_" + (DTOS(DDATABASE) + "_" + SUBSTR(TIME(),1,2) + "_" + SUBSTR(TIME(),4,2))
Public _aEmpresa	:= {}
Public _cPathDest	:= "\CPROVA\
Public _lYesNo		:= .F.
Public _lExistArq	:= .F.  
Public _lOk			:= .F.
Public _cEmpFil		:= SM0->M0_CODIGO+"/"+SM0->M0_NOME

	aAdd(aParamBox,{3,"Opções",1,aOpcoes,50,"",.T.})
	If ParamBox(aParamBox,"Parametros",,,,.T.,,,,"BKPCFG",.T.,.T.)
		If MV_PAR01 == 1
			_lYesNo := MsgBox("Confirma backup do CFGCTB da empresa "+_cEmpFil+"?","Backup","YESNO")
			If _lYesNo	== .F.
				Return
			EndIf
			
			// Executa o processo principal.
			Processa( {|| RunBkp() },"Aguarde. Gerando backup dos arquivos ..." )
		
		EndIf
   EndIf

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ FUNCAO PRINCIPAL                                                    ³
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
Static Function RunBkp()
// Inicializa empresas a serem processadas.
aadd(_aEmpresa,SM0->M0_CODIGO)

// Define o número de arquivos a serem processados.
ProcRegua(14)

// Processa o backup.
For i=1 to len(_aEmpresa)
	
	//.. Backup das tabelas do configuracao.//
	Backup("CT1")
	If _lOk
		Backup("CTD")
		Backup("CTH")
		Backup("CTA")
		Backup("CT5")
		Backup("SF4")
		Backup("SED")
		Backup("ZJD")
		Backup("ZJE")
		Backup("SF7")
		Backup("SFM")
		Backup("SF5")
		Backup("SX5")
		
				        		
		MsgBox("Backup concluido. Arquivos gravados na raiz do server em "+_cPathDest+".")

	EndIf
	
Next

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ FUNCAO DE BACKUP                                                    ³
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
Static Function Backup(_cTabela)
Local cQuery := ""
Local aAreaSX3 := {}
// Incrementa a régua.
IncProc("Processando tabela " + _cTabela)

// Verifica se o diretório de backup existe.
_cPathDest := Alltrim(_cPathDest)
If !File(Left(_cPathDest,Len(_cPathDest)-1))
	Alert("A Pasta [ " + _cPathDest + " ] não existe no servidor. Procure o administrador e peça para criá-la.")
	Return
EndIf

// Carrega o alias. Necessário para que o SIGA crie a tabela caso não exista.
dbSelectArea(_cTabela)

// Faz o backup.
_cNomArq	:=_cTabela-_aEmpresa[i]-"0"
_cArqDest1	:=_cPathDest+_cNomArq+_cData+".dbf"

// Verifica se já existe arquivo.
If File(_cArqDest1)
	_lExistArq := .T.
EndIf

_lYesNo := .T.
If _lExistArq .And. !_lOk
	_lYesNo := MsgBox("Backup efetuado anteriormente. Sobrepor?","Sobrescrever?","YESNO")
EndIf

If !_lYesNo 
	_lOk := .F.
Else
	_lOk := .T.
EndIf

If !_lExistArq .Or. _lOk
	/* Faz backup de todos os registros independente se o mesmo estiver deletado
	cQuery := " SELECT * FROM " + RetSqlName(_cTabela)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),_cNomArq,.T.,.F.)
   
   aAreaSX3 := SX3->(GetArea())
	SX3->(DbSelectArea("SX3"))
	SX3->(DbSetOrder(1))
	If SX3->(DbSeek(_cTabela))
		Do While SX3->(!Eof()) .AND. SX3->X3_ARQUIVO == _cTabela
	  		If SX3->X3_TIPO == "N"
	  			TcSetField(_cNomArq, SX3->X3_CAMPO, SX3->X3_TIPO, TamSx3(SX3->X3_CAMPO)[1], TamSx3(SX3->X3_CAMPO)[2])
   		EndIf
   		SX3->(DbSkip())
   	EndDo
   EndIf
   RestArea(aAreaSX3)
   
	DbSelectArea(_cNomArq)
	*/
	Use &_cNomArq Alias _cNomArq SHARED NEW VIA "TOPCONN"
	copy to &_cArqDest1 VIA "DBFCDXADS"
	DbCloseArea(_cNomArq)
Else
	Alert("Backup não efetuado!")
EndIf

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ fLimpaTabela³ Autor ³ Diogo Mesquita     ³ Data ³ 12/03/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Funcao responsavel por limpar a tabela em processamento.   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ fLimpaTabela(< cPar01 >)                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ cPar01: Tabela em processamento.                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nil                                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ SIGAATF                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Analista ³ Data    ³ Motivo                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³         ³                                                  ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function fLimpaTabela(cTabela)
	
	TMP->(DbSelectArea("TMP"))
	ZAP
	
Return Nil