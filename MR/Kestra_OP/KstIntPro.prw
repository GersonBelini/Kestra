#INCLUDE "TOTVS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ KSTIntPro ºAutor ³Gerson Belini       º Data ³  05/10/2018 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Gerar as baixas de produtos pela quantidade real e apontar º±±
±±º          ³ a produção.                                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Kestra                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function KSTIntPro()
	Local _cNumOp   := ""
	Local _cQuery   := ""
	Local _aOrdens  := {}
	Local _aCabEmp  := {}
	Local _aIteEmp  := {}
	Local _aIteAux  := {}
	Local _lLoteOk  := .T.
	Local _lEmpOk   := .F.
	Local _aLogErr  := {}
	Local _aOpBlq   := {}
	Local _cBuffers := ""

	Private _aOpProc     := {}
	Private _aMovimentos := {}
	Private _dDataMov    := stod("")

	Private lMsErroAuto := .F.

	if !ExistDir("\KESTRALOG")
		MakeDir("\KESTRALOG")
	endif
	if !ExistDir( "\KESTRALOG\PROCESSO" )
		MakeDir("\KESTRALOG\PROCESSO")
	endif
	_cHora := Substr(TIME(),1,2)+"_"+Substr(Time(),4,2)
	_cArq := "\KESTRALOG\PROCESSO\KSTIntPro_Log_"+dtos(dDataBase)+"_"+_cHora+"_.log"

	if MsgYesNo("Deseja escolher as ordens para processamento ? ","ESCOLHER ORDENS DE PRODUÇÃO")
		kstSelOp(_aOpProc)
		if Len(_aOpProc) == 0
			Return(.T.)
		endif
	else
		Return(.T.)
	endif

	// Verificar se os apontamentos estão de acordo com a quantidade de OP
	
	_cQuery := ""
	_cQuery += " SELECT ZZ6_FILIAL,ZZ6_OP,ZZ6_PRODUT,ZZ6_LOTECT,SUM(ZZ6_QTDPRO) ZZ6_QUANT "
	_cQuery += " FROM ZZ6010 "
	_cQuery += " WHERE D_E_L_E_T_ = ' ' "
	_cQuery += " AND ZZ6_DTAPON LIKE ' %' "
	if Len(_aOpProc) > 0
		_cQuery += " AND ZZ6_FILIAL+ZZ6_OP IN("
		For _nCount := 1 to Len(_aOpProc)
			_cQuery += iif(_nCount == 1,"'",",'")+_aOpProc[_nCount][3]+"'"
		Next
		_cQuery += " )"
	endif
	_cQuery += " GROUP BY ZZ6_FILIAL,ZZ6_OP,ZZ6_PRODUT,ZZ6_LOTECT "
	_cQuery += " ORDER BY ZZ6_FILIAL,ZZ6_OP,ZZ6_PRODUT,ZZ6_LOTECT "
	_cQuery := ChangeQuery(_cQuery)
	dbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), "TRB", .F., .T.)
	aEval(ZZ6->(dbStruct()), {|x| If(x[2] != "C" .And. FieldPos(x[1]) > 0, TcSetField("TRB",x[1],x[2],x[3],x[4]),Nil)})

	DbGoTop()
	While !Eof()
		_lEmpOk := .F.
		DbSelectArea("SC2")
		DbSetOrder(1)
		if !DbSeek(TRB->ZZ6_FILIAL+TRB->ZZ6_OP)
			MsgInfo("OP não encontrada. Filial "+AllTrim(TRB->ZZ6_FILIAL)+" OP "+Alltrim(TRB->ZZ6_OP))
			AADD(_aLogErr,{"OP não encontrada. Filial "+AllTrim(TRB->ZZ6_FILIAL)+" OP "+Alltrim(TRB->ZZ6_OP)})
			_lLoteOk := .F.
		endif
		
//		elseif TRB->ZZ6_QUANT != SC2->C2_QUANT // Se houver divergências validar item a item
//			MsgInfo("Divergência de quantidade entre consumo e ordem "+AllTrim(TRB->ZZ6_FILIAL)+" Produto "+Alltrim(TRB->ZZ6_OP))
//			AADD(_aLogErr,{"Divergência de quantidade entre consumo e ordem. Filial "+AllTrim(TRB->ZZ6_FILIAL)+" Produto "+Alltrim(TRB->ZZ6_COD)})
//			_lLoteOk := .F.
// Verificar o consumo com o empenho
		DbSelectArea("SD4")
		DbSetOrder(2)  // D4_FILIAL+D4_OP+D4_COD+D4_LOCAL
		DbSeek(xFilial("SD4")+TRB->ZZ6_OP+TRB->ZZ6_PRODUT)
		While !Eof() .and. xFilial("SD4")+AllTrim(TRB->ZZ6_OP)+AllTrim(TRB->ZZ6_PRODUT) == SD4->D4_FILIAL+AllTrim(SD4->D4_OP)+AllTrim(SD4->D4_COD)
			if TRB->ZZ6_QUANT == SD4->D4_QUANT // Se houver divergências validar item a item
				_lEmpOk := .T.
			endif
			DbSelectArea("SD4")
			DbSkip()
			if Eof() .and. !_lEmpOk 
				MsgInfo("Divergência de quantidade entre consumo e ordem "+AllTrim(TRB->ZZ6_FILIAL)+" Produto "+Alltrim(TRB->ZZ6_OP))
				AADD(_aLogErr,{"Divergência de quantidade entre consumo e ordem. Filial "+AllTrim(TRB->ZZ6_FILIAL)+" Produto "+Alltrim(TRB->ZZ6_PRODUT)})
			endif
			
		End
		DbSelectArea("TRB")
		DbSkip()
	End

	if Len(_aLogErr) > 0
		_nHandle := fCreate(_cArq,0)
		For _nCount := 1 to Len(_aLogErr)
			_cBuffers := _aLogErr[_nCount][1]+chr(13)+chr(10)
			FWrite(_nHandle,_cBuffers)
		Next _nCount
		fClose(_nHandle)
	Endif

	DbSelectArea("TRB")
	DbCloseArea()
	if !_lLoteOk .or. !_lEmpOk
		Return()
	endif


	// Verificar na tabela ZZ6, os movimentos que serão consumidos
	_cQuery := ""
	_cQuery += " SELECT ZZ6_FILIAL,ZZ6_OP,ZZ6_PRODUT,ZZ6_DATAIN,ZZ6_LOTECT,ZZ6_LOCAL,SUM(ZZ6_QTDPRO) ZZ6_QTDPRO "
	_cQuery += " FROM ZZ6010 "
	_cQuery += " WHERE D_E_L_E_T_ = ' ' "
	_cQuery += " AND ZZ6_DTAPON LIKE ' %' "
	if Len(_aOpProc) > 0
		_cQuery += " AND ZZ6_FILIAL+ZZ6_OP IN("
		For _nCount := 1 to Len(_aOpProc)
			_cQuery += iif(_nCount == 1,"'",",'")+_aOpProc[_nCount][3]+"'"
		Next
		_cQuery += " )"
	endif
	_cQuery += " GROUP BY ZZ6_FILIAL,ZZ6_OP,ZZ6_PRODUT,ZZ6_DATAIN,ZZ6_LOCAL,ZZ6_LOTECT "
	_cQuery += " ORDER BY ZZ6_FILIAL,ZZ6_OP "
	_cQuery := ChangeQuery(_cQuery)
	dbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), "TRB", .F., .T.)
	aEval(ZZ6->(dbStruct()), {|x| If(x[2] != "C" .And. FieldPos(x[1]) > 0, TcSetField("TRB",x[1],x[2],x[3],x[4]),Nil)})

	_aMovimentos := {}
	_dDataMov    := stod("")
	DbGoTop()
	While !Eof()
		_cOP      := TRB->ZZ6_OP
		_dDataMov := TRB->ZZ6_DATAIN
		aadd(_aMovimentos,{TRB->ZZ6_FILIAL,TRB->ZZ6_OP,TRB->ZZ6_PRODUT,TRB->ZZ6_DATAIN,TRB->ZZ6_QTDPRO,TRB->ZZ6_LOTECT,TRB->ZZ6_LOCAL})
		DbSelectArea("TRB")
		DbSkip()
		// O movimento é tratado por data então a cada mudança de OP, Data ou final de arquivo gerar os movimentos
		if _dDataMov != TRB->ZZ6_DATAIN .or. AllTrim(_cOp) != AllTrim(TRB->ZZ6_OP) .or. Eof()
			GeraBaixa(_aMovimentos,_dDataMov)
			_aMovimentos := {}
		endif

	End

	DbSelectArea("TRB")
	DbCloseArea()

	// Gerar o consumo de tempos

	// Verificar na tabela ZZ6, os movimentos que serão consumidos
	_cQuery := ""
	_cQuery += " SELECT * "
	_cQuery += " FROM ZZ6010 "
	_cQuery += " WHERE D_E_L_E_T_ = ' ' "
	_cQuery += " AND ZZ6_DTAPON LIKE ' %' "
	if Len(_aOpProc) > 0
		_cQuery += " AND ZZ6_FILIAL+ZZ6_OP IN("
		For _nCount := 1 to Len(_aOpProc)
			_cQuery += iif(_nCount == 1,"'",",'")+_aOpProc[_nCount][3]+"'"
		Next
		_cQuery += " )"
	endif
	_cQuery += " GROUP BY ZZ6_FILIAL,ZZ6_OP,ZZ6_PRODUT,ZZ6_DATAIN,ZZ6_LOCAL,ZZ6_LOTECT "
	_cQuery += " ORDER BY ZZ6_FILIAL,ZZ6_OP "
	_cQuery := ChangeQuery(_cQuery)
	dbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), "TRB", .F., .T.)
	aEval(ZZ6->(dbStruct()), {|x| If(x[2] != "C" .And. FieldPos(x[1]) > 0, TcSetField("TRB",x[1],x[2],x[3],x[4]),Nil)})

	_aMovimentos := {}
	_dDataMov    := stod("")
	DbGoTop()
	While !Eof()
		_cOP      := TRB->ZZ6_OP
		_dDataMov := TRB->ZZ6_DATAIN
		aadd(_aMovimentos,{TRB->ZZ6_FILIAL,TRB->ZZ6_OP,TRB->ZZ6_PRODUT,TRB->ZZ6_DATAIN,TRB->ZZ6_QTDPRO,TRB->ZZ6_LOTECT,TRB->ZZ6_LOCAL})
		DbSelectArea("TRB")
		DbSkip()
		// O movimento é tratado por data então a cada mudança de OP, Data ou final de arquivo gerar os movimentos
		if _dDataMov != TRB->ZZ6_DATAIN .or. AllTrim(_cOp) != AllTrim(TRB->ZZ6_OP) .or. Eof()
			GeraBaixa(_aMovimentos,_dDataMov)
			_aMovimentos := {}
		endif

	End

	DbSelectArea("TRB")
	DbCloseArea()

Return(NIL)

/*
ti@kestra.com.br

smtp.gmail.com

porta 587

senha: Kestra@10

*/

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³EaFilRepro³ Autor ³ Gerson Belini         ³ Data ³10/08/2007³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ ESPECIFICO Qualimat                                        ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ EaFilRepro                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Copia arquivos para pasta de entrada do pedidosea.         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function kstSelOp(_aOpProc)

	Local _aArea := GetArea()
	Local _cQuery := ""
	Local _cArq   := ""
	Local aCampos := {}
	Local nOpca   := 0

	_cMarca := Space(2)
	_cQuery := ""
	_cQuery += " SELECT ' ' ZZ6_OK,ZZ6_FILIAL,ZZ6_OP "
	_cQuery += " FROM "+RetSqlName("ZZ6")+" ZZ6 "
	_cQuery += " WHERE ZZ6.D_E_L_E_T_ = ' ' "
	_cQuery += " AND ZZ6_DTAPON LIKE ' %' "
	_cQuery += " GROUP BY ZZ6_FILIAL,ZZ6_OP "
	_cQuery += " ORDER BY ZZ6_FILIAL,ZZ6_OP "
	_cQuery := ChangeQuery(_cQuery)
	DbUseArea(.T., "TOPCONN", TCGENQRY(,,_cQuery), 'TRB', .F., .T.)

	_cArq := CriaTrab(NIL,.F.)
	Copy To &_cArq

	dbCloseArea()

	dbUseArea(.T.,,_cArq,"TRB",.T.)
	DbSelectArea("TRB")

	_aCampos := {}
	AADD(_aCampos,{"ZZ6_OK" ,""   ,"  "             ,"  "  })
	AADD(_aCampos,{"ZZ6_FILIAL"   ,"","FILIAL","@!"})
	AADD(_aCampos,{"ZZ6_OP"       ,"","CODIGO DA OP","@!"})

	_cMarca := GetMark(,"TRB","ZZ6_OK")
	lInverte := .T.
	nOpca   := 0

	PRIVATE oMark := 0
	Private oBrowse
	DEFINE MSDIALOG oDlg TITLE OemToAnsi(" Seleciona as ordens para processamento ") FROM 9,0 To 38,80 OF oMainWnd
	TRB->(Dbgotop())
	oMark:=MsSelect():New("TRB","ZZ6_OK",,_aCampos,,_cMarca,{02,1,203,300})
	oMark:oBrowse:lhasMark := .t.
	oMark:oBrowse:lCanAllmark := .t.
	/*
	Private nReg := TRB->(Recno())
	dbSelectArea("TRB")
	dbGoTop()
	TRB->(dbGoto(nReg))
	*/
	oMark:oBrowse:Refresh(.t.)
	oMark:oBrowse:bAllMark := {|| KstInverte(_cMarca,@oMark)}

	DEFINE SBUTTON FROM 205,085 TYPE 1 ACTION (nOpca := 1,oDlg:End()) ENABLE OF oDlg
	DEFINE SBUTTON FROM 205,120 TYPE 2 ACTION oDlg:End() ENABLE OF oDlg

	ACTIVATE MSDIALOG oDlg CENTERED
	If nOpca == 1
		KstMonta(_cMarca,oMark,_aOpProc)
	Endif

	dbSelectArea("TRB")
	dbCloseArea()
	//Close(oDlg)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Port001Inverte    ³Gerson Belini       º Data ³16/06/2011   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Inverte e grava a marcacao na markBrowse                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Portaria                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function KstInvert(cMarca,oMark)

	Private nReg := TRB->(Recno())
	dbSelectArea("TRB")
	dbGoTop()
	While !Eof()
		RecLock("TRB")
		IF TRB->ZZ6_OK == cMarca
			TRB->ZZ6_OK := "  "
		Else
			TRB->ZZ6_OK := cMarca
		Endif
		dbSkip()
	Enddo
	TRB->(dbGoto(nReg))
	oMark:oBrowse:Refresh(.t.)

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Port001Inverte    ³Gerson Belini       º Data ³16/06/2011   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Inverte e grava a marcacao na markBrowse                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Portaria                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function KstMonta(cMarca,oMark,_aOpProc)

	Private nReg := TRB->(Recno())
	dbSelectArea("TRB")
	dbGoTop()
	While !Eof()
		if TRB->ZZ6_OK == cMarca
			AADD(_aOpProc,{TRB->ZZ6_FILIAL,TRB->ZZ6_OP,TRB->ZZ6_FILIAL+TRB->ZZ6_OP})
		Endif
		dbSkip()
	Enddo

Return Nil

//#include "rwmake.ch"
//#include "ap5mail.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³ Funcao    ³ SendMessage³ Autor ³Gerson Belini        ³ Data ³ 12/08/2002³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Descricao ³ Envio de mensagem generica do Protheus                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Parametro ³ Destinatarios,SubJect,Mensagem,TemAnexo,Anexo               ³±±
±±³           ³                                                             ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function SendMessage(_cDestinatarios,_cSubJect,_cMensagem,_lTemAnexo,_cAnexo,_cDestCC,_cDestBCC,_PFrom)

	// Ex.: U_SendMessage('gerson.belini@parex-group.com;gbelini@atinet.com.br','Cabeçalho de teste','Corpo da Mensagem de Teste',.F.)
	local oServer  := Nil
	local oMessage := Nil
	local nErr     := 0

	local cPopAddr  := "pop.gmail.com"      // Endereco do servidor POP3
	local cSMTPAddr := "smtp.gmail.com"     // Endereco do servidor SMTP
	local cPOPPort  := 995                    // Porta do servidor POP
	local cSMTPPort := 587                    // Porta do servidor SMTP
	local cUser     := "ti@kestra.com.br"     // Usuario que ira realizar a autenticacao
	local cPass     := "Kestra@10"             // Senha do usuario
	local nSMTPTime := 60                     // Timeout SMTP

	/*
	ti@kestra.com.br

	smtp.gmail.com

	porta 587

	senha: Kestra@10

	*/

	// Instancia um novo TMailManager
	oServer := tMailManager():New()
	// Usa SSL na conexao
	oServer:setUseSSL(.T.)
	//oServer:setUseSSL(.F.)
	//oServer:setUseTLS(.T.)
	// Inicializa
	oServer:init(cPopAddr, cSMTPAddr, cUser, cPass, cPOPPort, cSMTPPort)
	// Define o Timeout SMTP
	if oServer:SetSMTPTimeout(nSMTPTime) != 0
		conout("[ERROR]Falha ao definir timeout")
		return .F.
	endif
	// Conecta ao servidor
	nErr := oServer:smtpConnect()
	if nErr <> 0
		conOut("[ERROR]Falha ao conectar: " + oServer:getErrorString(nErr))
		oServer:smtpDisconnect()
		return .F.
	endif
	// Realiza autenticacao no servidor
	nErr := oServer:smtpAuth(cUser, cPass)
	if nErr <> 0
		conOut("[ERROR]Falha ao autenticar: " + oServer:getErrorString(nErr))
		oServer:smtpDisconnect()
		return .F.
	endif
	// Cria uma nova mensagem (TMailMessage)
	oMessage := tMailMessage():new()
	oMessage:clear()
	//oMessage:cFrom    := "br.microsiga@parex-group.com"
	oMessage:cFrom    := "notificacao.totvs@parexgroup.com.br"
	//oMessage:cFrom    := "teste.microsiga@parex-group.com"

	oMessage:cTo      := "gbelini@atinet.com.br"
	_cMensagem += chr(10)+chr(13)+chr(10)+chr(13)+_cDestinatarios

	oMessage:cSubject := _cSubJect
	oMessage:cBody    := _cMensagem
	if _lTemAnexo
		nErr := oMessage:AttachFile( _cAnexo )
		if nErr <> 0
			cMsg := "Could not attach file " + _cAnexo
			conout( cMsg )
			return
		endif
	endif
	// Envia a mensagem
	nErr := oMessage:send(oServer)
	if nErr <> 0
		conout("[ERROR]Falha ao enviar: " + oServer:getErrorString(nErr))
		oServer:smtpDisconnect()
		return .F.
	endif
	// Disconecta do Servidor
	oServer:smtpDisconnect()
	return .T.
Return

Static Function GeraBaixa(_aMovimentos,_dDataMov)
	Local _aCab1 := {}
	Local _aItem := {}
	Local _atotitem:={}
	Local cCodigoTM:="501"
	Private lMsHelpAuto := .t. // se .t. direciona as mensagens de help
	Private lMsErroAuto := .f. //necessario a criacao
	Private _acod:={"1","MP1"}
	_aAreaReq := GetArea()
	_aCab1 := {}
	_cOp := ""
	AADD(_aCab1,{"D3_TM"      ,cCodigoTM,NIL})
	AADD(_aCab1,{"D3_EMISSAO",_dDataMov,NIL})
	For _nCount := 1 to Len(_aMovimentos)
		_aItem := {}
		DbSelectArea("SB1")
		DbSetOrder(1)
		DbSeek(xFilial("SB1")+_aMovimentos[_nCount][3])
		AADD(_aItem,{"D3_COD"   ,_aMovimentos[_nCount][3],NIL})
		AADD(_aItem,{"D3_UM"    ,SB1->B1_UM,NIL})
		AADD(_aItem,{"D3_QUANT" ,_aMovimentos[_nCount][5],NIL})
		AADD(_aItem,{"D3_LOCAL" ,_aMovimentos[_nCount][7],NIL})
		AADD(_aItem,{"D3_OP"    ,_aMovimentos[_nCount][2],NIL})
		_cOp := _aMovimentos[_nCount][2]
		if !Empty(_aMovimentos[_nCount][6])
			AADD(_aItem,{"D3_LOTECTL",_aMovimentos[_nCount][6],NIL})
		endif
		if Localiza(SB1->B1_COD) // Se houver controle de localização é necessário identificar o local
			//Posicionar na localizacao com saldo para o Lote
			DbSelectArea("SBF")
			DbSetOrder(2) //BF_FILIAL+BF_PRODUTO+BF_LOCAL+BF_LOTECTL+BF_NUMLOTE+BF_PRIOR+BF_LOCALIZ+BF_NUMSERI 
			if DbSeek(xFilial("SBF")+SB1->B1_COD+_aMovimentos[_nCount][7]+_aMovimentos[_nCount][6])
				AADD(_aItem,{"D3_LOCALIZ",SBF->BF_LOCALIZ,NIL})
			endif 
		endif 
		AADD(_aItem,{"D3_OBSERVA","GERADO POR INTEGRACAO KESTRA",NIL})
		aadd(_atotitem,_aitem)
	Next
	Begin Transaction
		lMsHelpAuto := .t.
		lMsErroAuto := .f.
		MSExecAuto({|x,y,z| MATA241(x,y,z)},_aCab1,_atotitem,3)
		If lMsErroAuto
			Mostraerro()
			/*
			_cBuffers := "Problema na geração do consumo. "+SB1->B1_COD+CHR(13)+CHR(10)
			_cNomeFile := NomeAutoLog()
			// Gerar notificacao
			_cCampoMemo := MemoRead(_cNomeFile)
			NotProd(_cNomeFile,_cBuffers,SB1->B1_COD)
			fErase(AllTrim(_cNomeFile))
			*/
			//			Mostraerro()
			DisarmTransaction()
			break
		Else
			MsgInfo("Consumos carregados com sucesso!!!")
			DbSelectAre("ZZ6")
			DbSetOrder(1)
			DbSeek(xFilial("ZZ6")+_cOp)
			While !Eof() .and. ZZ6->ZZ6_FILIAL+AllTrim(ZZ6->ZZ6_OP) == xFilial("ZZ6")+AllTrim(_cOp)
				RecLock("ZZ6",.F.)
				ZZ6->ZZ6_DTAPON := Date()
				MsUnLock("ZZ6")
				DbSelectArea("ZZ6")
				Dbskip()
			End
		EndIf
	End Transaction
	RestArea(_aAreaReq)
Return



// 

//Tratar consumo de tempo

H6_FILIAL
H6_OP
H6_PRODUTO
H6_OPERAC
H6_RECURSO
H6_FERRAM
H6_DATAINI
H6_HORAINI
H6_DATAFIN
H6_HORAFIN
H6_QTDPROD
H6_QTDPERD
H6_PT
H6_DTAPONT
H6_DESDOBR
H6_IDENT
H6_TEMPO
H6_LOTECTL
H6_NUMLOTE
H6_DTVALID
H6_MOTIVO
H6_OBSERVA
H6_TIPO
H6_OPERADO
H6_PERDANT
H6_SEQ
H6_IDENTE
H6_IDEINV
H6_DTPROD
H6_PRDINV
H6_LOTINV
H6_VERIFI
H6_LAUDO
H6_CERQUA
H6_TAMLOT
H6_REVI
H6_QTDPRO2
H6_SEQCARG
H6_POTENCI
H6_TIPOTEM
H6_RATEIO
H6_LOCAL
H6_STATUS
H6_CBFLAG
H6_QTGANHO
H6_QTMAIOR
H6_PERIMP
D_E_L_E_T_
R_E_C_N_O_
H6_ZZMAT
