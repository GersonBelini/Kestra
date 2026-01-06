#include "Protheus.ch"
#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³  BKPATF  ³ Autor ³ RICARDO BATAGLIA      ³ Data ³ 29/07/2015 ³±±
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

//IMPLANTADO NA KESTRA POR RICARDO BATAGLIA EM 07/2015

User Function BKPCFG()
Local cTabSN1		:= ""
Local lEnd			:= .F.
Local aOpcoes		:= IIf(AllTrim(cUserName)=='Administrador',{"Backup","Restore"},{"Backup"})

Private aParamBox	:= {}         

// Declaração de variáveis.
Public _cNomArq	:= ""
Public _cArqDest1	:= ""
Public _cData		:= "_" + DTOS(ddatabase)
Public _aEmpresa	:= {}
Public _cPathDest	:= "\BkpCFG\"
Public _lYesNo		:= .F.
Public _lExistArq	:= .F.  
Public _lOk			:= .F.
Public _cEmpFil	:= SM0->M0_CODIGO+"/"+SM0->M0_NOME

	aAdd(aParamBox,{3,"Opções",1,aOpcoes,50,"",.T.})
	If ParamBox(aParamBox,"Parametros",,,,.T.,,,,"BKPCFG",.T.,.T.)
		If MV_PAR01 == 1
			
			_lYesNo := MsgYesNo("Confirma backup do cfg "+_cEmpFil+"?","ATENÇÃO")
			If _lYesNo	== .F.
				Return
			EndIf
			
			// Executa o processo principal.
			Processa( {|| RunBkp() },"Aguarde. Gerando backup dos arquivos ..." )
		Else
			_lYesNo := MsgYesNo("Confirma restore do ativo da empresa "+_cEmpFil+"?","ATENÇÃO")
			If _lYesNo	== .F.
				Return
			EndIf
			
			cTabSN1 := cGetFile('Arquivo SN1 (sn1*.dbf) | sn1*.dbf','Selecione o arquivo SN1',0,'SERVIDOR\BKPAtivo\',.T.,GETF_NOCHANGEDIR,.T.)
			If !Empty(cTabSN1)
				Private oProcess := Nil

				oProcess := MsNewProcess():New( { |lEnd| RunRestore(@lEnd,cTabSN1) } , "Aguarde o processamento" , "" , .T.)
				oProcess:Activate()
			EndIf
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
ProcRegua(15)

// Processa o backup.
For i=1 to len(_aEmpresa)
	
	//.. Backup das tabelas do Ativo Fixo ..//
	Backup("CT1")
	If _lOk
		Backup("CT5")
		Backup("CTT")
		Backup("CTD")
		Backup("CTH")
		Backup("SF5")
		Backup("SF4")
		Backup("SED")
		Backup("SF7")
		Backup("SX5")
		Backup("ZJD")
		Backup("ZJE")
		Backup("CTQ")
		Backup("SNG")
		Backup("SEE")
		Backup("SEB")
		Backup("SA6")
		Backup("SFM")
		
        
        		
		MSGINFO("Backup concluido. Arquivos gravados na raiz do server em "+_cPathDest+".","INFORMAÇÃO")

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
	_lYesNo := MsgYesNo("Backup efetuado anteriormente. Sobrepor?","ATENÇÃO")
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
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ RunRestore³ Autor ³ Diogo Mesquita       ³ Data ³ 11/03/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Funcao responsavel por processar o restore dos arquivos.   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ RunRestore(< lPar01, cPar02 >)                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ lPar01: Controle de processamento;                         ³±±
±±³          ³ cPar02: Arquivo SN1 (DBF) selecionado.                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ lReturn                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ SIGAATF                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Analista ³ Data    ³ Motivo                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³         ³                                                  ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function RunRestore(lEnd,cArquivo)
Local lReturn 		:= .T.
Local aTabelas		:= {'SN1','SN2','SN3','SN4','SN5','SN6','SN7','SN8','SN9','SNA','SNB','SNC','SND','SNE','SNG'}
Local nI := nY		:= 0	
Local cAux			:= ""
Local cMsg			:= ""
Local lOK			:= .T.
Local cTabela		:= ""
Local cAlias		:= ""
Local aEstrutura	:= {}
Local nQtdReg		:= 0
Local nReg			:= 0
Local aAux			:= {}

   For nI := Len(cArquivo) to 1 Step -1
   	If SubStr(cArquivo,nI,1) == '\'
   		Exit
   	EndIf
   	cAux := Substr(cArquivo,nI,1) + cAux      
	Next nI
   cAux := SubStr(cAux,4,16)
	
	For nI := 1 to Len(aTabelas)
		If !File("\BKPAtivo\"+aTabelas[nI]+cAux)
			cMsg += aTabelas[nI] + " "
		Else
			aAdd(aAux,aTabelas[nI])
		EndIf
	Next nI
	
	If !Empty(cMsg)
		cMsg := "Arquivo da(s) tabela(s): " + cMsg + " não encontrado(s). Deseja realmente continuar ?"
		If !MsgYesNo(cMsg,"ATENÇÃO")   
      	lOK := .F.
      EndIf
	EndIf
	
	If lOK
		oProcess:SetRegua1(Len(aAux))
		For nI := 1 to Len(aAux)
			oProcess:IncRegua1("Lendo tabela " + aAux[nI] + "...")
			
			cTabela := RetSqlName(aAux[nI])
			DbUseArea(.T.,"TOPCONN",cTabela,"TMP",.F.,.F.)
			TMP->(DbSelectArea("TMP"))
			If TMP->(NetErr())
				MSGSTOP("Nao foi possível abrir a tabela " + cTabela + " em modo EXCLUSIVO. O processo será abortado.","ERRO")
				Return .F.
			Else
				MsAguarde({|lEnd| fLimpaTabela(cTabela)},"Aguarde o processamento","Excluindo registros atuais da tabela " + cTabela + "...",.T.)
			EndIf
		   TMP->(DbCloseArea())
		   
			DbUseArea(.T.,"DBFCDX","\BKPAtivo\"+aAux[nI]+cAux,"TMP",.F.,.F.)
			TMP->(DbSelectArea("TMP"))
			Count to nQtdReg
			TMP->(DbGoTop())
			oProcess:SetRegua2(nQtdReg)

			cAlias := aAux[nI]
			&(cAlias)->(DbSelectArea(cAlias))
			aEstrutura := &(cAlias)->(DbStruct())
			Do While TMP->(!Eof())
				oProcess:IncRegua2("Restaurando registro " + StrZero(++nReg,8) + " de " + StrZero(nQtdReg,8))

				&(cAlias)->(RecLock(cAlias,.T.))
				For nY := 1 to Len(aEstrutura)
					If TMP->(FieldPos(aEstrutura[nY,1])) > 0
						&(cAlias)->(FieldPut(&(cAlias)->(FieldPos(aEstrutura[nY,1])),TMP->(FieldGet(TMP->(FieldPos(aEstrutura[nY,1]))))))
					EndIf		
				Next nY
				&(cAlias)->(MsUnLock())

				TMP->(DbSkip())
			EndDo
			TMP->(DbCloseArea())
			nReg := 0
		Next nI
		
		MSGINFO("Processamento finalizado.","INFORMAÇÃO")
	Else
		MSGSTOP("Processamento abortado.", "ERRO")	
	EndIf
Return (lReturn)

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

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ pUpdSM2     ³ Autor ³ Diogo Mesquita     ³ Data ³ 12/04/10 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Funcao responsavel por atualizar o valor da moeda nos regi ³±±
±±³          ³ stros da tabela SM2 (Moedas do Sistema) de acordo com a ta ³±±
±±³          ³ xa definida em parametro.                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ pUpdSM2(< >)                                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
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
Static Procedure pUpdSM2()
Local aAreaSM2	:= SM2->(GetArea())
Local cMoeda 	:= GetMV("MV_ATFMOEDA")
Local cCampo	:= "M2_MOEDA"+AllTrim(cMoeda)
Local nTxUFIR	:= GetMV("GD_TXUFIR")
Local dDataIni := FirstDay(dDataBase)
Local dDataFim := LastDay(dDataBase)

	SM2->(DbSelectArea("SM2"))
	SM2->(DbSetOrder(1))
	Do While dDataIni <= dDataFim
		If !SM2->(DbSeek(dDataIni))
	   	RecLock("SM2",.T.)
			SM2->M2_DATA := dDataIni
			SM2->M2_MOEDA1 := 0
			SM2->M2_MOEDA2 := 0
			SM2->M2_MOEDA3 := 0
			SM2->M2_MOEDA4 := 0
			SM2->M2_MOEDA5 := 0
			SM2->M2_TXMOED2 := 0
			SM2->M2_TXMOED3 := 0
			SM2->M2_TXMOED4 := 0
			SM2->M2_TXMOED5 := 0
		Else
			RecLock("SM2")
		EndIf
	   
		SM2->&(cCampo) := nTxUFIR
		MsUnlock()
		
		dDataIni++
	EndDo
	
	RestArea(aAreaSM2)
Return Nil