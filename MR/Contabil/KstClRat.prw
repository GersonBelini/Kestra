#Include 'TOTVS.CH'


/*/{Protheus.doc} ratEnerg

Ajustar a tabela de rateios adicionando um novo centro de custos 
Inserir o Centro de Custo 680902 em todos os Códigos de rateios (do Código 200026 ao Código 200778)
	
@author Gerson Belini
@since 19/04/2021

/*/

User Function KstClRat()

    Local cAliasCTQ := GetNextAlias()
    Local aStruct	:= CTQ->(DBSTRUCT()) //Tabela de rateios.
    Local aColumns	:= {}
    Local aPesq		:= {}
    Local nCampo    := 0
    Local oDlgLS	As Object
    Local aRotOld	:= aClone(aRotina)


    // Criando identificador no diretorio para a batch verificar que os arquivos estão sendo criados

    //-------------------
    //Criação do objeto
    //-------------------
    //oTempTable := FWTemporaryTable():New( cAliasCTQ )
    //--------------------------
    //Monta os campos da tabela
    //--------------------------

//	aEval(SE5->(dbStruct()), {|x| aadd{_aFields,x[1],x[2],x[3],x[4]})
    _aFieldsCTQ := {}
    aEval(CTQ->(dbStruct()), {|x| aadd{_aFieldsCTQ,x[1],GetSx3Cache( AllTrim(x[1]) , "X3_TIPO" ),GetSx3Cache( AllTrim(x[1]) , "X3_TAMANHO" ),GetSx3Cache( AllTrim(x[1]) , "X3_DECIMAL" )}})

	Return

/*
    aadd(_aFields,{'E5_FILIAL' ,'C',TamSx3('E5_FILIAL')[1]   ,0})
    aadd(_aFields,{'E5_PREFIXO','C',TamSx3('E5_PREFIXO')[1]  ,0})
    aadd(_aFields,{'E5_NUMERO' , 'C',TamSx3('E5_NUMERO')[1]  ,0})
    aadd(_aFields,{'E5_PARCELA', 'C',TamSx3('E5_PARCELA')[1] ,0})
    aadd(_aFields,{'E5_TIPO'   , 'C',TamSx3('E5_TIPO')[1]    ,0})
    aadd(_aFields,{'E5_FORNECE', 'C',TamSx3('E5_FORNECE')[1] ,0})
    aadd(_aFields,{'E5_LOJA'   , 'C',TamSx3('E5_LOJA')[1]    ,0})
*/
    oTemptable:SetFields( _aFields )
    //oTempTable:AddIndex("01", {'DAK_COD'} )

    //------------------
    //Criação da tabela
    //------------------
    oTempTable:Create()

    _cMarca := Space(2)
    _cQuery := ""
    _cQuery += " SELECT E5_FILIAL, E5_PREFIXO, E5_NUMERO, E5_PARCELA, E5_TIPO, E5_FORNECE, E5_LOJA "
    _cQuery += " FROM "+RetSqlName("SE5")+" SE5 "
    _cQuery += " WHERE SE5.D_E_L_E_T_ = ' ' "
    _cQuery += " AND E5_DATA = '20201013'"
    _cQuery += " AND E5_SITUACA = ' '"
    _cQuery := ChangeQuery(_cQuery)

    Processa({||SqlToTrb(_cQuery, _aFields, _cAliasSE5)})	// Cria arquivo temporario

    dbSelectArea(_cAliasSE5)
    dbGoTop()
    While !Eof()
        DbSelectArea("SE2")
        DbsetOrder(1)
        // E2_FILIAL, E2_PREFIXO, E2_NUM, E2_PARCELA, E2_TIPO, E2_FORNECE, E2_LOJA, R_E_C_N_O_, D_E_L_E_T_
        if DbSeek((_cAliasSE5)->E5_FILIAL+E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_FORNECE+E5_LOJA)

	Local nSequen := 0

	DbSelectArea("CTQ")
	DbSetOrder(1)
	DbSeek(xFilial("CTQ")+"200026")

	While !Eof() .and. CTQ->CTQ_FILIAL == xFilial("CTQ") .and. CTQ->CTQ_RATEIO >= '200026' .and. CTQ->CTQ_RATEIO <= '200778'
		nTotRat 	:= 0
		_cRatAtu    := CTQ->CTQ_RATEIO
		_cSeqAtu    := CTQ->CTQ_RATEIO
		
		//Vejo o total de horas
		dbSelectArea("CTQ")
		dbSetOrder(1)//CTQ_FILIAL+CTQ_RATEIO+CTQ_SEQUEN
		dbSeek(xFilial("CTQ")+QRYRATEIO->CTQ_RATEIO)
		While CTQ->(!Eof()) .AND. CTQ->CTQ_RATEIO == QRYRATEIO->CTQ_RATEIO
			nQtdRat 	:= buscaSD3(CTQ->CTQ_CCCPAR,dProdDe,dProdAte)
			nTotRat 	+= nQtdRat
			nContRat++
			RecLock("CTQ",.F.)
				CTQ->CTQ_ZZQTDE  := nQtdRat		
			MsUnLock()
			CTQ->(DbSkip())			
		EndDo
		
		QRYRATEIO->(DbSkip())			
	EndDo			
	QRYRATEIO->(DbCloseArea())
Return

