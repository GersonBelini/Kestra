#INCLUDE "TOTVS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³KSTOPAUTO ºAutor  ³Gerson Belini       º Data ³  22/01/2018 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Geração de Ordem de Produção e Empenho de produtos de formaº±±
±±º          ³ Automática.                                                º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Kestra                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function KSTOpAuto()
	Local _cNumOp   := ""
	Local _cQuery   := ""
	Local _aOrdens  := {}
	Local _aCabEmp  := {}
	Local _aIteEmp  := {}
	Local _aIteAux  := {}
	Local _lLoteOk  := .T.
	Local _aLogErr  := {}
	Local _aOpBlq   := {}
	Local _cBuffers := ""

	Private _aOpProc  := {}

	Private lMsErroAuto := .F.

	if !ExistDir("\KESTRALOG")
		MakeDir("\KESTRALOG")
	endif
	if !ExistDir( "\KESTRALOG\PROCESSO" )
		MakeDir("\KESTRALOG\PROCESSO")
	endif
	_cHora := Substr(TIME(),1,2)+"_"+Substr(Time(),4,2)
	_cArq := "\KESTRALOG\PROCESSO\KSTOpAuto_Log_"+dtos(dDataBase)+"_"+_cHora+"_.log"

	//SendMessage('gbelini@atinet.com.br','Cabeçalho de teste','Corpo da Mensagem de Teste',.F.)

	//Return(.F.)

	if MsgYesNo("Deseja escolher corridas para processamento ? ","ESCOLHER CORRIDAS")
		kstSelOp(_aOpProc)
		if Len(_aOpProc) == 0
			Return(.T.)
		endif
	else
		Return(.T.)
	endif

	// Verificar se saldo por lote para os produtos
	_cQuery := ""
	_cQuery += " SELECT ZZ4_FILIAL,ZZ4_COD,ZZ4_LOCAL,ZZ4_LOTECT,SUM(ZZ4_QUANT) ZZ4_QUANT "
	_cQuery += " FROM ZZ4010 "
	_cQuery += " WHERE D_E_L_E_T_ = ' ' "
	_cQuery += " AND ZZ4_OP LIKE ' %' "
	_cQuery += " AND ZZ4_LOTECT NOT LIKE ' %' "
	if Len(_aOpProc) > 0
		_cQuery += " AND ZZ4_FILIAL+ZZ4_CORRID IN("
		For _nCount := 1 to Len(_aOpProc)
			_cQuery += iif(_nCount == 1,"'",",'")+_aOpProc[_nCount][3]+"'"
		Next
		_cQuery += " )"
	endif
	_cQuery += " GROUP BY ZZ4_FILIAL,ZZ4_LOCAL,ZZ4_COD,ZZ4_LOTECT "
	_cQuery += " ORDER BY ZZ4_FILIAL,ZZ4_LOCAL,ZZ4_COD,ZZ4_LOTECT "
	_cQuery := ChangeQuery(_cQuery)
	dbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), "TRB", .F., .T.)
	aEval(ZZ4->(dbStruct()), {|x| If(x[2] != "C" .And. FieldPos(x[1]) > 0, TcSetField("TRB",x[1],x[2],x[3],x[4]),Nil)})

	DbGoTop()
	While !Eof()
		DbSelectArea("SB8")
		DbSetOrder(3)
		if !DbSeek(TRB->ZZ4_FILIAL+TRB->ZZ4_COD+TRB->ZZ4_LOCAL+TRB->ZZ4_LOTECT)
			MsgInfo("Lote não encontrado. Filial "+AllTrim(TRB->ZZ4_FILIAL)+" Produto "+Alltrim(TRB->ZZ4_COD)+" Local "+AllTrim(TRB->ZZ4_LOCAL)+" Lote "+AllTrim(TRB->ZZ4_LOTECT))
			AADD(_aLogErr,{"Lote não encontrado. Filial "+AllTrim(TRB->ZZ4_FILIAL)+" Produto "+Alltrim(TRB->ZZ4_COD)+" Local "+AllTrim(TRB->ZZ4_LOCAL)+" Lote "+AllTrim(TRB->ZZ4_LOTECT)})
			_lLoteOk := .F.
			//			DbSelectArea("TRB")
			//			DbCloseArea()
			//			Return(NIL)
		elseif TRB->ZZ4_QUANT > SB8->B8_SALDO-SB8->B8_EMPENHO-SB8->B8_QACLASS
			MsgInfo("Saldo insuficiente. Filial "+AllTrim(TRB->ZZ4_FILIAL)+" Produto "+Alltrim(TRB->ZZ4_COD)+" Local "+AllTrim(TRB->ZZ4_LOCAL)+" Lote "+AllTrim(TRB->ZZ4_LOTECT))
			AADD(_aLogErr,{"Saldo insuficiente. Filial "+AllTrim(TRB->ZZ4_FILIAL)+" Produto "+Alltrim(TRB->ZZ4_COD)+" Local "+AllTrim(TRB->ZZ4_LOCAL)+" Lote "+AllTrim(TRB->ZZ4_LOTECT)})
			_lLoteOk := .F.
			//			DbSelectArea("TRB")
			//			DbCloseArea()
			//			Return(NIL)
		endif

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
	if !_lLoteOk
		Return()
	endif

	// Verificar na tabela ZZ4, quais são as ordens que devem ser criadas
	_cQuery := ""
	_cQuery += " SELECT "
	_cQuery += " ZZ4_FILIAL, "
	_cQuery += " ZZ4_PRODUT, "
	_cQuery += " ZZ4_CORRID, "
	_cQuery += " ZZ4_SEQOP,  "
	_cQuery += " ZZ4_LOCPRO, "
	_cQuery += " ZZ4_QTDPR   "
	_cQuery += " FROM "+RetSqlName("ZZ4")+" ZZ4"
	_cQuery += " WHERE ZZ4.D_E_L_E_T_ = ' '"
	_cQuery += " AND ZZ4_OP LIKE ' %'"
	if Len(_aOpProc) > 0
		_cQuery += " AND ZZ4_FILIAL+ZZ4_CORRID IN("
		For _nCount := 1 to Len(_aOpProc)
			_cQuery += iif(_nCount == 1,"'",",'")+_aOpProc[_nCount][3]+"'"
		Next
		_cQuery += " )"
	endif
	_cQuery += " GROUP BY ZZ4_FILIAL,ZZ4_PRODUT,ZZ4_CORRID,ZZ4_SEQOP,ZZ4_LOCPRO,ZZ4_QTDPR "
	_cQuery := ChangeQuery(_cQuery)
	dbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), "TRB", .F., .T.)
	aEval(ZZ4->(dbStruct()), {|x| If(x[2] != "C" .And. FieldPos(x[1]) > 0, TcSetField("TRB",x[1],x[2],x[3],x[4]),Nil)})

	DbGoTop()
	While !Eof()
		_cNumOp := ""
		// =====> Alteração Gerson Belini <=====
		// =====> 19/08/2019 <=====
		// Complementar empenhos de Op´s já abertas
		// Verificar se já existe OP para a corrida
		DbSelectArea("SC2")
		DbOrderNickName("CORRIDA")
		if DbSeek(TRB->ZZ4_FILIAL+TRB->ZZ4_CORRID,.T.)
			While TRB->ZZ4_FILIAL+TRB->ZZ4_CORRID == SC2->C2_FILIAL+SC2->C2_ZZNCORR+C2_ZZREQUA
				if SC2->C2_PRODUTO == TRB->ZZ4_PRODUT
					_cNumOp := SC2->(C2_NUM+C2_ITEM+C2_SEQUEN)
				endif
				DbSelectArea("SC2")
				DbSkip()
			End
		endif
		if Empty(_cNumOp)
			DbSelectArea("TRB")
			_cNumOp := GeraOp(TRB->ZZ4_FILIAL,TRB->ZZ4_PRODUT,TRB->ZZ4_CORRID,TRB->ZZ4_LOCPRO,TRB->ZZ4_QTDPR,TRB->ZZ4_SEQOP,_aOrdens)
		endif
		if !Empty(_cNumOp)
			aadd(_aOrdens,{TRB->ZZ4_FILIAL,TRB->ZZ4_PRODUT,TRB->ZZ4_CORRID,_cNumOp})
		endif
		DbSelectArea("TRB")
		DbSkip()

	End

	DbSelectArea("TRB")
	DbCloseArea()
	if !Empty(_aOrdens)

		// Verificar na tabela ZZ4, quais são as ordens que devem ser criadas
		DbSelectArea("ZZ4")
		_cQuery := ""
		/*
		aEval(DbStruct(),{|e| _cQuery += ","+AllTrim(e[1])})
		// Obtem os registros a serem processados
		_cQuery := "SELECT " +SubStr(_cQuery,2)
		_cQuery +=         ",ZZ4.R_E_C_N_O_ ZZ4RECNO "

		//		_cQuery := ""
		//		_cQuery += " SELECT * "
		_cQuery += " FROM "+RetSqlName("ZZ4")+" ZZ4"
		_cQuery += " WHERE ZZ4.D_E_L_E_T_ = ' '"
		_cQuery += " AND ZZ4_OP LIKE ' %'"
		_cQuery += " ORDER BY ZZ4_FILIAL,ZZ4_PRODUT,ZZ4_CORRID,ZZ4_COD,ZZ4_LOCAL "
		*/

		_cQuery += " SELECT ZZ4_FILIAL,ZZ4_CORRID,ZZ4_PRODUT,ZZ4_COD,ZZ4_LOCAL,ZZ4_LOTECT,SUM(ZZ4_QUANT) ZZ4_QUANT "
		_cQuery += " FROM "+RetSqlName("ZZ4")+" ZZ4"
		_cQuery += " WHERE ZZ4.D_E_L_E_T_ = ' '"
		_cQuery += " AND ZZ4_OP LIKE ' %'"
		_cQuery += " GROUP BY ZZ4_FILIAL,ZZ4_CORRID,ZZ4_PRODUT,ZZ4_COD,ZZ4_LOCAL,ZZ4_LOTECT "
		_cQuery += " ORDER BY ZZ4_FILIAL,ZZ4_CORRID,ZZ4_PRODUT,ZZ4_COD,ZZ4_LOCAL,ZZ4_LOTECT "

		_cQuery := ChangeQuery(_cQuery)
		dbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), "TRB", .F., .T.)
		aEval(ZZ4->(dbStruct()), {|x| If(x[2] != "C" .And. FieldPos(x[1]) > 0, TcSetField("TRB",x[1],x[2],x[3],x[4]),Nil)})

		DbGoTop()
		_cChave := TRB->(ZZ4_FILIAL+ZZ4_CORRID+ZZ4_PRODUT+ZZ4_COD+ZZ4_LOCAL+ZZ4_LOTECT)
		_aCabEmp := {}
		_aIteEmp := {}
		_aIteAux := {}

		While !Eof()
			_aIteAux := {}
			_nPosAscan :=  ascan(_aOrdens,{ |x| AllTrim(x[1]) == AllTrim(TRB->ZZ4_FILIAL) .and. AllTrim(x[2]) == AllTrim(TRB->ZZ4_PRODUT) .and. AllTrim(x[3]) == AllTrim(TRB->ZZ4_CORRID)  })
			if _nPosAscan > 0
				_cChave := TRB->(ZZ4_FILIAL+ZZ4_CORRID+ZZ4_PRODUT+ZZ4_COD+ZZ4_LOCAL+ZZ4_LOTECT)
				_cOp := _aOrdens[_nPosAscan][4]

				// Verificar se existe local criado para o empenho do produto
				DbSelectArea("SB2")
				DbSetOrder(1)
				if !DbSeek(xFilial("SB2")+TRB->ZZ4_COD+TRB->ZZ4_LOCAL)
					// Se não existir criar o local
					lMsErroAuto := .F.

					aItens:={ {"B2_COD",TRB->ZZ4_COD,NIL},;
					{"B2_LOCAL",TRB->ZZ4_LOCAL,NIL} }

					nOpc := 3

					MSExecAuto({|x,y| mata225(x,y)},aItens,nOpc)

					If lMsErroAuto
						//ConOut(OemToAnsi("****ERRO*****"))
						//ConOut(OemToAnsi("Erro na inclusao!!"))
						Mostraerro()
					Else
						//ConOut(OemToAnsi("****Ok*****"))
						//ConOut(OemToAnsi("Incluido com sucesso!"))
					Endif
				endif

				_aIteAux:={   {"D4_COD"   ,TRB->ZZ4_COD     ,Nil},; //COM O TAMANHO EXATO DO CAMPO
				{"D4_LOCAL"   ,TRB->ZZ4_LOCAL   ,Nil},;
				{"D4_OP"      ,_cOp             ,Nil},;
				{"D4_DATA"    ,dDatabase        ,Nil},;
				{"D4_QTDEORI" ,TRB->ZZ4_QUANT   ,Nil},;
				{"D4_QUANT"   ,TRB->ZZ4_QUANT   ,Nil},;
				{"D4_TRT"     ,"   "            ,Nil},;
				{"D4_QTSEGUM" ,0                ,Nil},;
				{"D4_LOTECTL" ,TRB->ZZ4_LOTECT  ,Nil} ;
				}
				/*
				aadd(_aIteAux,{"D4_COD"    ,TRB->ZZ4_COD    ,Nil})
				aadd(_aIteAux,{"D4_LOCAL"  ,TRB->ZZ4_LOCAL  ,Nil})
				aadd(_aIteAux,{"D4_OP"     ,_cOp            ,Nil})
				//aadd(_aIteAux,{"D4_DATA"   ,dDataBase       ,Nil})
				aadd(_aIteAux,{"D4_QTDORI" ,TRB->ZZ4_QUANT  ,Nil})
				aadd(_aIteAux,{"D4_QUANT"  ,TRB->ZZ4_QUANT  ,Nil})
				aadd(_aIteAux,{"D4_LOTECTL",TRB->ZZ4_LOTECT ,Nil})
				*/

				lMsErroAuto := .F.
				MSExecAuto({|x,y,z| mata380(x,y,z)},_aIteAux,3)
				If !lMsErroAuto
					DbSelectArea("ZZ4")
					/*
					DbGoTo(TRB->ZZ4RECNO)
					*/
					DbsetOrder(8)
					DbSeek(_cChave)
					While !Eof() .and. _cChave == ZZ4->(ZZ4_FILIAL+ZZ4_CORRID+ZZ4_PRODUT+ZZ4_COD+ZZ4_LOCAL+ZZ4_LOTECT)
						RecLock("ZZ4",.F.)
						ZZ4->ZZ4_OP := _cOp
						MsUnLock("ZZ4")
						DbSkip()
					End
					DbSelectArea("TRB")
					ConOut("Sucesso! ")
					// Necessário diminuir o empenho Kestra da tabela SB8
					DbSelectArea("SB8")
					DbSetOrder(3)
					if !Empty(TRB->ZZ4_LOTECT) .and. DbSeek(TRB->ZZ4_FILIAL+TRB->ZZ4_COD+TRB->ZZ4_LOCAL+TRB->ZZ4_LOTECT)
						RecLock("SB8",.F.)
						SB8->B8_ZKEMPEN -= TRB->ZZ4_QUANT
						MsUnLock()
					endif

				Else
					ConOut("Erro!")
					MostraErro()
				EndIf

				ConOut("Fim  : "+Time())

			Endif
			DbSelectArea("TRB")
			DbSkip()

		End

		DbSelectArea("TRB")
		DbCloseArea()

	endif

Return(NIL)

Static Function GeraOp(_cFilial,_cProduto,_cCorrida,_cLocal,_nQuantidade,_cSeqOp,_aOrdRef)

	Local _aMata650      := {}       //-Array com os campos
	Local _nOpc          := 3
	Local _cObs          := "GERADO INTEGRACAO KESTRA X PROTHEUS"
	Local _cNumOp        := ""
	Local _nPosAscan   := 0

	Private lMsErroAuto  := .F.
	Default _aOrdRef     := {}

	if !Empty(_aOrdRef)
		_nPosAscan :=  ascan(_aOrdRef,{ |x| AllTrim(x[3]) == AllTrim(_cCorrida) })
	endif

	//                {'C2_NUM'     ,_cNumOp      ,NIL},;
	if _nPosAscan == 0
		_aMata650  := {  {'C2_FILIAL' ,_cFilial     ,NIL},;
		{'C2_PRODUTO' ,_cProduto    ,NIL},;
		{'C2_LOCAL '  ,_cLocal      ,NIL},;
		{'C2_ITEM'    ,"01"         ,NIL},;
		{'C2_SEQUEN'  ,StrZero(Val(_cSeqOp),3),NIL},;
		{'C2_QUANT'   ,_nQuantidade ,NIL},;
		{'C2_DATPRI'  ,dDataBase    ,NIL},;
		{'C2_DATPRF'  ,dDataBase    ,NIL},;
		{'C2_ZZNCORR' ,_cCorrida    ,NIL},;
		{'C2_OBS'     ,_cObs        ,NIL};
		}
	else
		_cNumOrd := Substr(_aOrdRef[_nPosAscan][4],1,6)
		_aMata650  := {  {'C2_FILIAL' ,_cFilial     ,NIL},;
		{'C2_NUM    ' ,_cNumOrd     ,NIL},;
		{'C2_PRODUTO' ,_cProduto    ,NIL},;
		{'C2_LOCAL '  ,_cLocal      ,NIL},;
		{'C2_ITEM'    ,"01"         ,NIL},;
		{'C2_SEQUEN'  ,StrZero(Val(_cSeqOp),3),NIL},;
		{'C2_QUANT'   ,_nQuantidade ,NIL},;
		{'C2_DATPRI'  ,dDataBase    ,NIL},;
		{'C2_DATPRF'  ,dDataBase    ,NIL},;
		{'C2_ZZNCORR' ,_cCorrida    ,NIL},;
		{'C2_OBS'     ,_cObs        ,NIL};
		}
	endif

	ConOut("Inicio  : "+Time())

	lMsErroAuto := .F.

	msExecAuto({|x,Y| Mata650(x,Y)},_aMata650,_nOpc)
	If !lMsErroAuto
		_cNumOp := SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN
		ConOut("Sucesso! ")
	Else
		ConOut("Erro!")
		MostraErro()
	EndIf

	ConOut("Fim  : "+Time())

Return(_cNumOp)

/*
ti@kestra.com.br

smtp.gmail.com

porta 587

senha: Kestra@10

*/

//#include "rwmake.ch"
//#INCLUDE "DIRECTRY.CH"
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
	_cQuery += " SELECT ' ' ZZ4_OK,ZZ4_FILIAL,ZZ4_CORRID "
	_cQuery += " FROM "+RetSqlName("ZZ4")+" ZZ4 "
	_cQuery += " WHERE ZZ4.D_E_L_E_T_ = ' ' "
	_cQuery += " AND ZZ4_OP LIKE ' %' "
	_cQuery += " GROUP BY ZZ4_FILIAL,ZZ4_CORRID "
	_cQuery += " ORDER BY ZZ4_FILIAL,ZZ4_CORRID "
	_cQuery := ChangeQuery(_cQuery)
	DbUseArea(.T., "TOPCONN", TCGENQRY(,,_cQuery), 'TRB', .F., .T.)

	_cArq := CriaTrab(NIL,.F.)
	Copy To &_cArq

	dbCloseArea()

	dbUseArea(.T.,,_cArq,"TRB",.T.)
	DbSelectArea("TRB")

	_aCampos := {}
	AADD(_aCampos,{"ZZ4_OK" ,"","  "             ,"  "  })
	AADD(_aCampos,{"ZZ4_FILIAL"   ,"","FILIAL","@!"})
	AADD(_aCampos,{"ZZ4_CORRID"  ,"","CODIGO DA CORRIDA","@!"})

	_cMarca := GetMark(,"TRB","ZZ4_OK")
	lInverte := .T.
	nOpca   := 0

	PRIVATE oMark := 0
	Private oBrowse
	DEFINE MSDIALOG oDlg TITLE OemToAnsi(" Seleciona as ordens para processamento ") FROM 9,0 To 38,80 OF oMainWnd
	TRB->(Dbgotop())
	oMark:=MsSelect():New("TRB","ZZ4_OK",,_aCampos,,_cMarca,{02,1,203,300})
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
		IF TRB->ZZ4_OK == cMarca
			TRB->ZZ4_OK := "  "
		Else
			TRB->ZZ4_OK := cMarca
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
		if TRB->ZZ4_OK == cMarca
			AADD(_aOpProc,{TRB->ZZ4_FILIAL,TRB->ZZ4_CORRID,TRB->ZZ4_FILIAL+TRB->ZZ4_CORRID})
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

	oMessage:cTo      := "gerson.belini@parex-group.com,gbelini@atinet.com.br,thiago.vergilio@parex-group.com"
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

