#Include "protheus.ch"
#Include "parmtype.ch"
#Include "tbiconn.ch"

User Function FIN050EXC()

    LOCAL aArray := {}
    Local _aArea    := GetArea()
    Local _cQuery   := ""
    Local _cArq     := ""
    Local _aCampos   := {}
    Local _aFields  := {}
    Local nOpca     := 0
    Local _lRetCar  := .F.
    Local _aCargas  := {}
    Local cAliasSE2 := GetNextAlias()
    Local aStruct	:= SE5->(DBSTRUCT()) //Estrutra do contas a pagar.
    Local aColumns	:= {}
    Local aPesq		:= {}
    Local nCampo    := 0
    Local oDlgLS	As Object
    Local aRotOld	:= aClone(aRotina)

    PRIVATE lMsErroAuto := .F.

    // Criando identificador no diretorio para a batch verificar que os arquivos estão sendo criados

    //-------------------
    //Criação do objeto
    //-------------------
    oTempTable := FWTemporaryTable():New( cAliasSE5 )
    //--------------------------
    //Monta os campos da tabela
    //--------------------------

//	aEval(SE5->(dbStruct()), {|x| aadd{_aFields,x[1],x[2],x[3],x[4]})
    //_aFieldsSE5 := {}
    //aEval(SE5->(dbStruct()), {|x| aadd{_aFieldsSE5,x[1],GetSx3Cache( AllTrim(x[1]) , "X3_TIPO" ),GetSx3Cache( AllTrim(x[1]) , "X3_TAMANHO" ),GetSx3Cache( AllTrim(x[1]) , "X3_DECIMAL" )}})


    aadd(_aFields,{'E5_FILIAL' ,'C',TamSx3('E5_FILIAL')[1]   ,0})
    aadd(_aFields,{'E5_PREFIXO','C',TamSx3('E5_PREFIXO')[1]  ,0})
    aadd(_aFields,{'E5_NUMERO' , 'C',TamSx3('E5_NUMERO')[1]  ,0})
    aadd(_aFields,{'E5_PARCELA', 'C',TamSx3('E5_PARCELA')[1] ,0})
    aadd(_aFields,{'E5_TIPO'   , 'C',TamSx3('E5_TIPO')[1]    ,0})
    aadd(_aFields,{'E5_FORNECE', 'C',TamSx3('E5_FORNECE')[1] ,0})
    aadd(_aFields,{'E5_LOJA'   , 'C',TamSx3('E5_LOJA')[1]    ,0})

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


            aArray      := {}
            lMsErroAuto := .F.

            aArray := {{"E2_PREFIXO" ,SE2->E2_PREFIXO , NIL },;// CAMPO POSICIONADO
                       {"E2_NUM"     ,SE2->E2_NUM     , NIL }}

            MsExecAuto( { |x,y,z| FINA050(x,y,z)},aArray,, 5) // 3 - Inclusao, 4 - Alteração, 5 - Exclusão

            If lMsErroAuto
                MostraErro()
            Else
                Alert("Título excluído com sucesso!")
            Endif

        Endif
        DbSelectArea(_cAliasSE5)
        dbSkip()
    Enddo

    //---------------------------------
    //Exclui a tabela
    //---------------------------------
    oTempTable:Delete()




Return
