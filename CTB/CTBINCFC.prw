#INCLUDE "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³CTBINCFC º Autor ³ J.DONIZETE R.SILVA º Data ³  14/02/08    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Programa para carga de clientes e fornecedores no plano de º±±
±±º          ³ contas.                                                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Chamado pelos pontos de entrada M020INC/M030INC/Outros.    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºData      ³ Alterações                                                 º±±
±±º          ³                                                             ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

// implementado na Katoen Natie em 01/03/2011 por Ricardo Bataglia   /somente a conta

User Function CTBINCFC(_cCad)

// Parâmetros
//	_cCad
//		C = Clientes
//		F = Fornecedores

// Declaração das Variáveis.
Local _xAreaCF 	:= Iif(_cCad=="C",SA1->(GetArea()),SA2->(GetArea()))
Local _xAreaCTD		:= {}
Local _xAreaSM0		:= {}
Local _xAreaSX2 	:= {}  

Local _cNome		:= Iif(_cCad=="C",SA1->A1_NOME,SA2->A2_NOME)
Local _cCod			:= Iif(_cCad=="C",_cCad+SA1->A1_COD+SA1->A1_LOJA,_cCad+SA2->A2_COD+SA2->A2_LOJA)
Local _cEst			:= Iif(_cCad=="C",SA1->A1_EST,SA2->A2_EST)
Local _cConta		:= ""
Local _cCtaSint		:= ""

Local _aCad		  	:= {}
Local _lCria		:= .t. // Esta variável define se será criado ou não conta analítica. A alteração da mesma

Local _cAlias		:= Iif(_cCad=="C","SA1","SA2")
Local _cModoSA1SA2 	:= ""
Local _cModoCTD 	:= ""
Local _cTipo		:= SubStr(Iif(_cCad=="C",SA1->A1_COD,SA2->A2_COD),1,1)
Local _cFilial		:= ""
Local _cEmpAnt		:= cEmpAnt // Guardar a empresa atual
Local _cFilAnt		:= cFilAnt // Guardar a filial atual
Local _lCriaEmp		:= .f.
Local _lSA1SA2C		:= .f.
Local _lProc		:= .t.

Private lMsErroAuto   := .F.
Private lMsHelpAuto   := .T.

// Não processa se não houver parâmetros.
If !_cCad $ "C,F"
	Return(.f.)
EndIf

// Processa somente se o módulo for SIGACTB e a opção for de Inclusão.
If Upper(Alltrim(GetMv("MV_MCONTAB"))) == "CTB"
	
	// Verifica o compartilhamento de arquivos.
	dbSelectArea("SX2")
	_xAreaSX2 := GetArea()
	dbSetOrder(1)
	If dbSeek(_cAlias)
		_cModoSA1SA2 := SX2->X2_MODO
	Else
		MsgStop("Alias "+_cAlias+" não encontrado no SX2.","CTBIMPFC")
		RestArea(_xAreaSX2)
		DbSelectArea(_cAlias)
		RestArea(_xAreaCF)
		Return(.f.)
	EndIf
	If dbSeek("CTD")
		_cModoCTD := SX2->X2_MODO
	Else
		MsgStop("Alias CTD não encontrado no SX2.","CTBIMPFC")
		RestArea(_xAreaSX2)
		DbSelectArea(_cAlias)
		RestArea(_xAreaCF)
		Return(.f.)
	EndIf
	
	If _cModoSA1SA2=="E" .And. _cModoCTD=="C"
		MsgStop("Conflito de compartilhamento: "+_cAlias+"=Exclusivo e CTD=Compartilhado.","CTBIMPFC")
		DbSelectArea(_cAlias)
		RestArea(_xAreaCF)
		Return(.f.)
	Endif
	
	//Restaura SX2.
	RestArea(_xAreaSX2)
	
	dbSelectArea(_cAlias)
	//_xAreaCF := GetArea()
	
	If (_cModoSA1SA2=="E" .And. _cModoCTD=="E") .Or. (_cModoSA1SA2=="C" .And. _cModoCTD=="C")
		_cFilial := Iif(_cCad=="C",SA1->A1_FILIAL,SA2->A2_FILIAL)
		cFilAnt	:= _cFilial
	ElseIf _cModoSA1SA2=="C" .And. _cModoCTD=="E"
		_lSA1SA2C := .t.
	EndIf

	If _lCria
		
		//_cConta := _cCad + _cCod
		
		dbSelectArea("SM0")
		_xAreaSM0 := GetArea()
		dbSetOrder(1)
		
		While !Eof() .And. _lProc
			
			If _lProc
				If (SM0->M0_CODIGO <> cEmpAnt)
					dbSkip()
					Loop
				EndIf
			EndIf
			
			If _lSA1SA2C
				cFilAnt	 := SM0->M0_CODFIL
				_cFilial := cFilAnt
			Else
				_lProc := .f.
			EndIf
			
			dbSelectArea("CTD")
			_xAreaCTD := GetArea()
			dbSetOrder(1)
			DbSeek(_cFilial + _cCod)
			// Se encontrar, atualiza a descrição do plano de contas.
			If Found()
				If CTD->CTD_DESC01 <> _cNome
					If RecLock("CTD",.f.) // Atualiza a razão social
						CTD->CTD_DESC01 := _cNome
						msunlock()
					EndIf
				EndIf
				// Caso não encontre a conta no plano de contas, criar a mesma.
			Else
				// Alimenta matriz com os dados do registro a ser criado.
				aAdd( _aCad , { "CTD_FILIAL"  , _cFilial       , Nil } )
				aAdd( _aCad , { "CTD_ITEM  "  , _cCod          , Nil } )
				aAdd( _aCad , { "CTD_CLASSE"  , "2"            , Nil } )
				aAdd( _aCad , { "CTD_DESC01"  , _cNome         , Nil } )
				//aAdd( _aCad , { "CTD_BLOQ"  	, "2"            , Nil } )
				//aAdd( _aCad , { "CTD_CLOBRG"  , "2"            , Nil } )
				//aAdd( _aCad , { "CTD_ACCLVL"  , "1"            , Nil } )
				//aAdd( _aCad , { "CTD_NORMAL"  , _cCad          , Nil } )
				//aAdd( _aCad , { "CTD_RES"     , _cCod          , Nil } )
				//aAdd( _aCad , { "CTD_CTASUP"  , _cConta        , Nil } ) // O próprio sistema cria a cta.superior
				//aAdd( _aCad , { "CTD_ACITEM"  , "2"            , Nil } )
				//aAdd( _aCad , { "CTD_ACCUST"  , "2"            , Nil } )
				//aAdd( _aCad , { "CTD_CCOBRG"  , "2"            , Nil } )
				//aAdd( _aCad , { "CTD_ITOBRG"  , "2"            , Nil } )
				//aAdd( _aCad , { "CTD_CTAVM "  , ""             , Nil } )
				aAdd( _aCad , { "CTD_CRGNV1"  , IIf(Left(_cCod,1)=="C","CLI","FOR"), Nil } )
				//aAdd( _aCad , { "CTD_BOOK  "  , "001/002/003/004/005"           , Nil } )
				
				// Inclui a conta contábil através de rotina automática.
				lMsErroAuto := .F.
				MSExecAuto({|x,y| CTBA040(x,y)},_aCad,3)
				If lMsErroAuto
					MostraErro()
					Alert("Não foi possível incluir registro.")
				Endif
				
			Endif
			
			dbSelectArea("SM0")
			dbSkip()
			
		EndDo
		
		// Restaura dados da empresa anterior.
		cEmpAnt := _cEmpAnt
		cFilAnt	:= _cFilAnt
		
		// Restaura áreas de trabalho.
		RestArea(_xAreaSM0)
		RestArea(_xAreaCTD)
		
	EndIf
	
	// Restaura áreas de trabalho.
	RestArea(_xAreaCF)

Endif

Return(.t.)
/*/
//ALTERADO PARA CRIAÇÃO DO ITEM CONTABIL E NÃO DA CONTA CONTABIL
	
	// Atualiza a conta no cadastro do Cliente.
	If _cCad=="1"
		If Empty(SA1->A1_CONTA)
			If Reclock(_cAlias, .F.)
				REPLACE SA1->A1_CONTA	with _cConta
				MsUnlock()
			EndIf
		Endif
	Else
		If Empty(SA2->A2_CONTA)
			If Reclock(_cAlias, .F.)
				REPLACE SA2->A2_CONTA	with _cConta
				MsUnlock()
			EndIf
		EndIf
	Endif
Endif

Return(.t.)
/*/