#INCLUDE 'TOTVS.CH'
#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE "TBICONN.CH"
 
User Function MyMATA200(PARAMIXB3)
 
Local PARAMIXB1 := {}
Local PARAMIXB2 := {}
Local aGets     := {}
Local lOK       := .T.
Local cString   := ''
 
Private lMsErroAuto := .F.
 
 



								//-------------------
								//Criação do objeto
								//-------------------
								oTempTable := FWTemporaryTable():New( cAliasSRA )
								//--------------------------
								//Monta os campos da tabela
								//--------------------------

								_aFields := {}
								aadd(_aFields,{'RA_FILIAL'  , 'C',TamSx3('RA_FILIAL')[1]   ,0})
								aadd(_aFields,{'RA_MAT'     , 'C',TamSx3('RA_MAT')[1]  ,0})
								aadd(_aFields,{'RA_CIC'     , 'C',TamSx3('RA_CIC')[1]  ,0})
								aadd(_aFields,{'RA_SITFOLH' , 'C',TamSx3('RA_SITFOLH')[1]  ,0})

								oTemptable:SetFields( _aFields )

								//------------------
								//Criação da tabela
								//------------------
								oTempTable:Create()

								_cQuery := ""

/*
(
G1_FILIAL,
G1_COD,
G1_COMP,
G1_TRT,
G1_QUANT,
G1_PERDA,
G1_INI,
G1_FIM,
G1_OBSERV,
G1_FIXVAR,
G1_GROPC,
G1_OPC,
G1_REVINI,
G1_REVFIM,
G1_NIV,
G1_NIVINV,
G1_POTENCI,
G1_TIPVEC,
G1_VECTOR,
G1_OK,
G1_VLCOMPE,
G1_USAALT,
G1_LOCCONS,
G1_FANTASM,
G1_LISTA
)
*/
								_cQuery += " SELECT RA_FILIAL,RA_MAT,RA_CIC,RA_SITFOLH "
								_cQuery += " FROM ZZZ_SG1010 "
								_cQuery += " WHERE G1_OK != '2'
								_cQuery += " AND RA_CIC = '"+_oObj[_nCount]:evtMonit:ideVinculo:cpfTrab+"'"
								_cQuery := ChangeQuery(_cQuery)

								Processa({||SqlToTrb(_cQuery, _aFields, cAliasSRA)})	// Cria arquivo temporario

								dbSelectArea(cAliasSRA)
								dbGoTop()
								_cEmpresa     := ""
								_cFilial      := ""
								_cMatricula   := ""
								_cCPFFunc     := ""

								While !Eof()
									if (cAliasSRA)->RA_SITFOLH != 'D'
										_cEmpresa     := ""
										_cFilial      := (cAliasSRA)->RA_FILIAL
										_cMatricula   := (cAliasSRA)->RA_MAT
										_cCPFFunc     := (cAliasSRA)->RA_CIC
										Exit
									endif

									Alert("Filial: "+(cAliasSRA)->RA_FILIAL)
									DbSelectArea(cAliasSRA)
									dbSkip()
								Enddo

								//---------------------------------
								//Exclui a tabela
								//---------------------------------
								oTempTable:Delete()





If PARAMIXB3==3
    PARAMIXB1 := {{"G1_COD","PA001",NIL},;
                {"G1_QUANT",1,NIL},;
                {"NIVALT","S",NIL}} // A variavel NIVALT eh utilizada pra recalcular ou nao a estrutura
    aGets := {}
    aadd(aGets,{"G1_COD","PA001",NIL})
    aadd(aGets,{"G1_COMP","PI001",NIL})
    aadd(aGets,{"G1_TRT",Space(3),NIL})
    aadd(aGets,{"G1_QUANT",1,NIL})
    aadd(aGets,{"G1_PERDA",0,NIL})
    aadd(aGets,{"G1_INI",CTOD("01/01/01"),NIL})
    aadd(aGets,{"G1_FIM",CTOD("31/12/49"),NIL})
    aadd(PARAMIXB2,aGets)
    aGets := {}
    aadd(aGets,{"G1_COD","PI001",NIL})
    aadd(aGets,{"G1_COMP","PI002",NIL})
    aadd(aGets,{"G1_TRT",Space(3),NIL})
    aadd(aGets,{"G1_QUANT",1,NIL})
    aadd(aGets,{"G1_PERDA",0,NIL})
    aadd(aGets,{"G1_INI",CTOD("01/01/01"),NIL})
    aadd(aGets,{"G1_FIM",CTOD("31/12/49"),NIL})
    aadd(PARAMIXB2,aGets)
    aGets := {}
    aadd(aGets,{"G1_COD","PI001",NIL})
    aadd(aGets,{"G1_COMP","MP002",NIL})
    aadd(aGets,{"G1_TRT",Space(3),NIL})
    aadd(aGets,{"G1_QUANT",1,NIL})
    aadd(aGets,{"G1_PERDA",0,NIL})
    aadd(aGets,{"G1_INI",CTOD("01/01/01"),NIL})
    aadd(aGets,{"G1_FIM",CTOD("31/12/49"),NIL})
    aadd(PARAMIXB2,aGets)
    aGets := {}
    aadd(aGets,{"G1_COD","PI002",NIL})
    aadd(aGets,{"G1_COMP","MP001",NIL})
    aadd(aGets,{"G1_TRT",Space(3),NIL})
    aadd(aGets,{"G1_QUANT",1,NIL})
    aadd(aGets,{"G1_PERDA",0,NIL})
    aadd(aGets,{"G1_INI",CTOD("01/01/01"),NIL})
    aadd(aGets,{"G1_FIM",CTOD("31/12/49"),NIL})
    aadd(PARAMIXB2,aGets)
    aGets := {}
    aadd(aGets,{"G1_COD","PA001",NIL})
    aadd(aGets,{"G1_COMP","PI003",NIL})
    aadd(aGets,{"G1_TRT",Space(3),NIL})
    aadd(aGets,{"G1_QUANT",1,NIL})
    aadd(aGets,{"G1_PERDA",0,NIL})
    aadd(aGets,{"G1_INI",CTOD("01/01/01"),NIL})
    aadd(aGets,{"G1_FIM",CTOD("31/12/49"),NIL})
    aadd(PARAMIXB2,aGets)
    aGets := {}
    aadd(aGets,{"G1_COD","PA001",NIL})
    aadd(aGets,{"G1_COMP","MP004",NIL})
    aadd(aGets,{"G1_TRT",Space(3),NIL})
    aadd(aGets,{"G1_QUANT",1,NIL})
    aadd(aGets,{"G1_PERDA",0,NIL})
    aadd(aGets,{"G1_INI",CTOD("01/01/01"),NIL})
    aadd(aGets,{"G1_FIM",CTOD("31/12/49"),NIL})
    aadd(PARAMIXB2,aGets)
    aGets := {}
    aadd(aGets,{"G1_COD","PI003",NIL})
    aadd(aGets,{"G1_COMP","MP003",NIL})
    aadd(aGets,{"G1_TRT",Space(3),NIL})
    aadd(aGets,{"G1_QUANT",1,NIL})
    aadd(aGets,{"G1_PERDA",0,NIL})
    aadd(aGets,{"G1_INI",CTOD("01/01/01"),NIL})
    aadd(aGets,{"G1_FIM",CTOD("31/12/49"),NIL})
    aadd(PARAMIXB2,aGets)
 
    If lOk
        ConOut("Teste de Inclusao")
        ConOut("Inicio: "+Time())
        MSExecAuto({|x,y,z| mata200(x,y,z)},PARAMIXB1,PARAMIXB2,PARAMIXB3)
        //Inclusao
        ConOut("Fim: "+Time())
    EndIf
EndIf
 
    If lMsErroAuto
        If IsBlind()
            If IsTelnet()
                VTDispFile(NomeAutoLog(),.t.)
            Else
                cString := MemoRead(NomeAutoLog())
                Aviso("Aviso de Erro:",cString)
            EndIf
        Else
            MostraErro()
        EndIf
    Else
        If lOk
            Aviso("Aviso","Operacao efetuada com sucesso",{"Ok"})
        Else
            Aviso("Aviso","Fazer os devidos cadastros",{"Ok"})
        EndIf
    Endif
 
Return
