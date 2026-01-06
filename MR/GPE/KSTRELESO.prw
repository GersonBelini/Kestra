#include 'protheus.ch'
#include 'parmtype.ch'

// #########################################################################################
// Projeto: Parex - Nivel de Servico
// Modulo :
// Fonte  : PxNivelServ
// ----------+-------------------+-----------------------------------------------------------
// Data      | Autor             | Descricao
// ----------+-------------------+-----------------------------------------------------------
// 02/01/17  | Gerson Belini     | Geração de consultas para análise de Nível de Serviço
// ----------+-------------------+-----------------------------------------------------------
// Comentario| 1) Analise de documentos de saída, sem data de canhoto
//           | 2) Povoar dados na tabela PX_NIVEL_SERVICO
//           | 3) Dados Analíticos por período
//Nolver Inf.| 4) Resultados por período

user function PXNivelSer()


// #########################################################################################
// Função : PxNSOtif
// Modulo :
// Fonte  : PxNivelServ
// ----------+-------------------+-----------------------------------------------------------
// Data      | Autor             | Descricao
// ----------+-------------------+-----------------------------------------------------------
// 02/01/17  | Gerson Belini     | Gerar uma planilha excel com o otif
// ----------+-------------------+-----------------------------------------------------------

static Function PxNSOtif()

	Local _cQuery  := ""
	Local _cSemana := ""
	Local _nRet    := 0

	_cQuery := ""
	_cQuery += " SELECT Z.* "
	_cQuery += " ,ISNULL((SELECT C91_PROTUL FROM C91010 WHERE D_E_L_E_T_ = ' ' AND C91_FILIAL = RA_FILIAL AND C91_ATIVO = '1' AND ID1200 = C91_ID AND C91_PERAPU = PERIODO),' ') PROT1200 "
	_cQuery += " ,ISNULL((SELECT SUM(T2R_VALOR) FROM T2M010 A,T2R010 B  WHERE A.D_E_L_E_T_ = ' ' AND T2M_CPFTRB = RA_CIC AND T2M_PERAPU = PERIODO AND T2M_ATIVO = '1' AND B.D_E_L_E_T_ = ' ' AND T2R_FILIAL = T2M_FILIAL AND T2R_ID = T2M_ID AND T2R_VERSAO = T2M_VERSAO AND T2R_TPVLR = '000001'),0) BS1200RET "
	_cQuery += " ,ISNULL((SELECT SUM(T2R_VALOR) FROM T2M010 A,T2R010 B  WHERE A.D_E_L_E_T_ = ' ' AND T2M_CPFTRB = RA_CIC AND T2M_PERAPU = PERIODO AND T2M_ATIVO = '1' AND B.D_E_L_E_T_ = ' ' AND T2R_FILIAL = T2M_FILIAL AND T2R_ID = T2M_ID AND T2R_VERSAO = T2M_VERSAO AND T2R_TPVLR = '000006'),0) DESC1200RET "
	_cQuery += " FROM( "
	_cQuery += " SELECT Y.* 
	_cQuery += " ,ISNULL((SELECT T3P_PROTUL FROM T3P010 WHERE D_E_L_E_T_ = ' ' AND T3P_FILIAL = RA_FILIAL AND T3P_BENEFI = IDTRAB AND T3P_PERAPU = PERIODO AND ID1210 = T3P_ID AND T3P_ATIVO = '1'),' ') PROT1210
	_cQuery += " ,ISNULL((SELECT SUM(T2J_VLDESC)
	_cQuery += " FROM T2G010 A,T2J010 B
	_cQuery += " WHERE A.D_E_L_E_T_ = ' '
	_cQuery += " AND T2G_CPFTRA = RA_CIC
	_cQuery += " AND T2G_ATIVO = '1'
	_cQuery += " AND T2G_PERAPU = PERIODO
	_cQuery += " AND B.D_E_L_E_T_ = ' '
	_cQuery += " AND T2J_FILIAL = T2G_FILIAL
	_cQuery += " AND T2J_ID = T2G_ID
	_cQuery += " AND T2J_VERSAO = T2G_VERSAO),0) DESC1210RET
	_cQuery += " ,ISNULL((SELECT C91_ID FROM C91010 WHERE D_E_L_E_T_ = ' ' AND C91_FILIAL = RA_FILIAL AND C91_TRABAL = IDTRAB AND C91_PERAPU = PERIODO  AND C91_ATIVO = '1'),' ') ID1200
	_cQuery += " FROM(
	_cQuery += " SELECT W.* 
	_cQuery += " ,ISNULL((SELECT T3P_ID FROM T3P010 WHERE D_E_L_E_T_ = ' ' AND T3P_FILIAL = RA_FILIAL AND T3P_BENEFI = IDTRAB AND T3P_PERAPU = PERIODO AND T3P_ATIVO = '1'),' ') ID1210
	_cQuery += " FROM(
	_cQuery += " SELECT T.*  
	_cQuery += " ,ISNULL((SELECT C9V_ID FROM C9V010 C WHERE C.D_E_L_E_T_= ' ' AND C9V_FILIAL = RA_FILIAL AND C9V_CPF = RA_CIC AND RA_CODUNIC = C9V_MATRIC AND C9V_ATIVO = '1'),
	_cQuery += " ISNULL((SELECT C9V_ID FROM C9V010 C WHERE C.D_E_L_E_T_= ' ' AND C9V_FILIAL = RA_FILIAL AND C9V_CPF = RA_CIC AND RA_CODUNIC = C9V_MATRIC AND C9V_ATIVO = '2' AND C9V_IDTRAN <> ' '),
	_cQuery += " ISNULL((SELECT C9V_ID FROM C9V010 C WHERE C.D_E_L_E_T_= ' ' AND C9V_FILIAL = RA_FILIAL AND C9V_CPF = RA_CIC AND C9V_NOMEVE = 'S2300'AND C9V_ATIVO = '1' ),' '))) IDTRAB
	_cQuery += " FROM(
	_cQuery += " SELECT X.* 
	_cQuery += " ,ISNULL((SELECT SUM(RD_VALOR) FROM SRD010 D, SRV010 V WHERE D.D_E_L_E_T_= ' ' AND V.D_E_L_E_T_ = ' ' AND RD_PD = RV_COD AND RD_FILIAL = RA_FILIAL AND RD_MAT = RA_MAT AND RD_PERIODO = PERIODO AND RD_ROTEIR IN ('ADI','FOL','AUT','CAR') AND RV_CODFOL IN ('0013','0014','0221')),0) BINSS
	_cQuery += " ,ISNULL((SELECT SUM(RD_VALOR) FROM SRD010 D, SRV010 V WHERE D.D_E_L_E_T_= ' ' AND V.D_E_L_E_T_ = ' ' AND RD_PD = RV_COD AND RD_FILIAL = RA_FILIAL AND RD_MAT = RA_MAT AND RD_PERIODO = PERIODO AND RD_ROTEIR IN ('ADI','FOL','AUT','CAR') AND RV_CODFOL IN ('0019','0020')),0) BINSS13
	_cQuery += " ,ISNULL((SELECT SUM(RD_VALOR) FROM SRD010 D, SRV010 V WHERE D.D_E_L_E_T_= ' ' AND V.D_E_L_E_T_ = ' ' AND RD_PD = RV_COD AND RD_FILIAL = RA_FILIAL AND RD_MAT = RA_MAT AND RD_PERIODO = PERIODO AND RD_ROTEIR IN ('ADI','FOL','AUT','CAR') AND RV_CODFOL IN ('0064','0065','0070')),0) INSSDESC
	_cQuery += " ,ISNULL((SELECT SUM(RD_VALOR) FROM SRD010 D, SRV010 V WHERE D.D_E_L_E_T_= ' ' AND V.D_E_L_E_T_ = ' ' AND RD_PD = RV_COD AND RD_FILIAL = RA_FILIAL AND RD_MAT = RA_MAT AND RD_PERIODO = PERIODO AND RD_ROTEIR IN ('ADI','FOL','AUT','CAR') AND RV_CODFOL IN ('0148')),0) INSSEMP
	_cQuery += " ,ISNULL((SELECT SUM(RD_VALOR) FROM SRD010 D, SRV010 V WHERE D.D_E_L_E_T_= ' ' AND V.D_E_L_E_T_ = ' ' AND RD_PD = RV_COD AND RD_FILIAL = RA_FILIAL AND RD_MAT = RA_MAT AND RD_PERIODO = PERIODO AND RD_ROTEIR IN ('ADI','FOL','AUT','CAR') AND RV_CODFOL IN ('0149')),0) INSSTERC
	_cQuery += " ,ISNULL((SELECT SUM(RD_VALOR) FROM SRD010 D, SRV010 V WHERE D.D_E_L_E_T_= ' ' AND V.D_E_L_E_T_ = ' ' AND RD_PD = RV_COD AND RD_FILIAL = RA_FILIAL AND RD_MAT = RA_MAT AND RD_PERIODO = PERIODO AND RD_ROTEIR IN ('ADI','FOL','AUT','CAR') AND RV_CODFOL IN ('0150')),0) INSSACID
	_cQuery += " ,ISNULL((SELECT SUM(RD_VALOR) FROM SRD010 D, SRV010 V WHERE D.D_E_L_E_T_= ' ' AND V.D_E_L_E_T_ = ' ' AND RD_PD = RV_COD AND RD_FILIAL = RA_FILIAL AND RD_MAT = RA_MAT AND SUBSTRING(RD_DATPGT,1,6) = PERIODO AND RD_ROTEIR IN ('ADI','PLR','FOL','AUT','CAR') AND RV_DIRF IN ('D ','L ','Q1')),0) 
	_cQuery += " +ISNULL((SELECT SUM(RR_VALOR) FROM SRR010 D, SRV010 V WHERE D.D_E_L_E_T_= ' ' AND V.D_E_L_E_T_ = ' ' AND RR_PD = RV_COD AND RR_FILIAL = RA_FILIAL AND RR_MAT = RA_MAT AND RV_CODFOL = '0067' AND RR_PERIODO > PERIODO AND SUBSTRING(RR_DATAPAG,1,6) = PERIODO),0) IRRFDESC
	_cQuery += " FROM(
	_cQuery += " SELECT DISTINCT RA_FILIAL,RA_MAT,RA_NOME,RA_CIC,RA_CATFUNC,RA_CATEFD,RA_SITFOLH,RA_CODUNIC,RA_ADMISSA,RA_DEMISSA,RA_RESCRAI,RD_PERIODO PERIODO
	_cQuery += " FROM SRA010 A, SRD010 B
	_cQuery += " WHERE A.D_E_L_E_T_ = ' '
	_cQuery += " AND B.D_E_L_E_T_ = ' '
	_cQuery += " AND RA_FILIAL = RD_FILIAL
	_cQuery += " AND RA_MAT = RD_MAT
	_cQuery += " AND RD_ROTEIR  IN ('FOL','AUT','PLR','CAR') 
	_cQuery += " AND RD_PERIODO = '201811'
	_cQuery += " )X
	_cQuery += " )T
	_cQuery += " )W
	_cQuery += " )Y
	_cQuery += " )Z
	_cQuery += " ORDER BY RA_FILIAL,RA_MAT

	_cQuery += " SELECT "
	_cQuery += " C5_FILIAL, "
	_cQuery += " C5_NUM, "
	_cQuery += " DATA_NS, "
	_cQuery += " C5_ENTREGA, "
	_cQuery += " QTDVEN, "
	_cQuery += " QTDENT, "
	_cQuery += " ENTREGA F2_DTCANHO, "
	_cQuery += " NVL(DATA_CARGA,'        ') DAK_DATA, "
	_cQuery += " C5_CLIENT, "
	_cQuery += " C5_LOJAENT, "
	_cQuery += " A1_NREDUZ, "
	_cQuery += " NVL((SELECT ACY_DESCRI "
	_cQuery += " FROM ACY010 ACY "
	_cQuery += " WHERE ACY.D_E_L_E_T_ = ' ' "
	_cQuery += " AND ACY.ACY_GRPVEN = SA1.A1_GRUPCLI),' ') KEY_ACCOUNT, "
	_cQuery += " A1_CLASSE, "
	_cQuery += ' ZZ02.ZZ0_DESCRI "SEG_ATUAL", '
	_cQuery += ' ZZ012.ZZ0_DESCRI "SEG_NOVO", '
	_cQuery += " A1_MUNE, "
	_cQuery += " A1_ESTE, "
	_cQuery += " ITENS, "
	_cQuery += " ITENS_ENT, "
	_cQuery += " C5_TPFRETE, "
	_cQuery += " CASE  "
	_cQuery += " WHEN QTDVEN = QTDENT THEN 'TOTAL' "
	_cQuery += " ELSE 'PARCIAL' "
	_cQuery += ' END "Parcial_Total", '
	_cQuery += " CASE  "
	_cQuery += " WHEN DATA_NS >= ENTREGA THEN 'On Time' "
	_cQuery += " ELSE 'Atraso' "
	_cQuery += ' END "Status_On_Time", '
	_cQuery += " CASE  "
	_cQuery += " WHEN C5_ENTREGA >= ENTREGA THEN 'On Time' "
	_cQuery += " ELSE 'Atraso' "
	_cQuery += ' END "Status_On_Time_CRC" '
	_cQuery += " FROM "
	_cQuery += " PX_NIVEL_SERVICO PXNS, "
	_cQuery += " SA1010 SA1, "
	_cQuery += " ZZ0010 ZZ02, "
	_cQuery += " ZZ0010 ZZ012, "
	_cQuery += " SC5010 SC5 "
//	_cQuery += " WHERE DATA_NS BETWEEN '20170101' AND '20170831' "
//	_cQuery += " WHERE FATURAMENTO BETWEEN '20170101' AND '20171231' "
//	_cQuery += " WHERE FATURAMENTO BETWEEN '20170601' AND '20180131' "
//	_cQuery += " WHERE FATURAMENTO BETWEEN '20180101' AND '20180331' "
//	_cQuery += " WHERE FATURAMENTO BETWEEN '20180501' AND '20180731' "
//	_cQuery += " WHERE FATURAMENTO BETWEEN '20181201' AND '20191231' "
	_cQuery += " WHERE FATURAMENTO BETWEEN '"+dtos(MV_PAR01)+"' AND '"+dtos(MV_PAR02)+"'"
	_cQuery += " AND SA1.D_E_L_E_T_ = ' ' "
	_cQuery += " AND ZZ02.D_E_L_E_T_ = ' ' "
	_cQuery += " AND ZZ012.D_E_L_E_T_ = ' ' "
	_cQuery += " AND SC5.D_E_L_E_T_ = ' ' "
	_cQuery += " AND FILIAL = C5_FILIAL "
	_cQuery += " AND PEDIDO = C5_NUM "
	_cQuery += " AND C5_CLIENT = A1_COD "
	_cQuery += " AND C5_LOJAENT = A1_LOJA "
	_cQuery += " AND A1_SATIV8 = ZZ02.ZZ0_CHAVE "
	_cQuery += " AND A1_SATIV2 = ZZ012.ZZ0_CHAVE "
	_cQuery += " AND ZZ02.ZZ0_TABELA = '02' "
	_cQuery += " AND ZZ012.ZZ0_TABELA = '12' "

	_cQuery := ChangeQuery(_cQuery)
	dbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), "TRBNS", .F., .T.)
	aEval(SC5->(dbStruct()), {|x| If(x[2] != "C" .And. FieldPos(x[1]) > 0, TcSetField("TRBNS",x[1],x[2],x[3],x[4]),Nil)})
	aEval(SF2->(dbStruct()), {|x| If(x[2] != "C" .And. FieldPos(x[1]) > 0, TcSetField("TRBNS",x[1],x[2],x[3],x[4]),Nil)})
	aEval(DAK->(dbStruct()), {|x| If(x[2] != "C" .And. FieldPos(x[1]) > 0, TcSetField("TRBNS",x[1],x[2],x[3],x[4]),Nil)})
	aEval(SA1->(dbStruct()), {|x| If(x[2] != "C" .And. FieldPos(x[1]) > 0, TcSetField("TRBNS",x[1],x[2],x[3],x[4]),Nil)})
	TcSetField("TRBNS","DATA_NS","D")

	/*
	COUNT TO _nCtRule2

	oProcess:SetRegua2(_nCtRule2)
	*/

	DbSelectArea("TRBNS")

	DbGoTop()

	PxTabExcel("TRBNS","OTIF")
	DbSelectArea("TRBNS")
	DbCloseArea()

Return(NIL)

Static Function PxTabExcel(_cAlias,_cNome)
	Local _aCabExcel   :={}
	Local _aItensExcel :={}
	Local _nCount      := 0
	// AADD(aCabExcel, {"TITULO DO CAMPO", "TIPO", NTAMANHO, NDECIMAIS})
	DbSelectArea(_cAlias)
	_aStruct := DBStruct()
	/*
	If !ApOleClient("MSExcel")
	MsgAlert("Microsoft Excel não instalado!")
	Endif
	*/
	_aCabExcel := _aStruct
	/*
	AADD(aCabExcel, {"A1_FILIAL" ,"C", 02, 0})
	AADD(aCabExcel, {"A1_COD" ,"C", 06, 0})
	AADD(aCabExcel, {"A1_LOJA" ,"C", 02, 0})
	AADD(aCabExcel, {"A1_NOME" ,"C", 40, 0})
	AADD(aCabExcel, {"A1_MCOMPRA" ,"N", 18, 2})
	*/
	MsgRun("Favor Aguardar.....", "Selecionando os Registros",{|| GProcItens(_aCabExcel, @_aItensExcel, _cAlias)})
	//	MsgRun("Favor Aguardar.....", "Exportando os Registros para o Excel",{||DlgToExcel({{"NIVEL_SERVICO"," NIVEL DE SERVICO ",_aCabExcel,_aItensExcel}})})
	For _nCount := 1 to Len(_aCabExcel)
		DbSelectArea("SX3")
		SX3->(dbSetOrder(2))
		if SX3->(MsSeek(AllTrim(_aCabExcel[_nCount][1])))
			_aCabExcel[_nCount][1] := AllTrim(SX3->X3_TITULO)
		EndIf
	Next _nCount
	DbSelectArea(_cAlias)

	GDToExcel(_aCabExcel,_aItensExcel,"ITENS",_cNome)

Return

//-------------------------------------------------------------------------------------------------------------------------------------------------------------

Static Function GProcItens(aHeader, aCols, _cAlias)
	Local aItem
	Local nX
	DbSelectArea(_cAlias)
	DbGotop()
	While TRBNS->(!EOF())
		aItem := Array(Len(aHeader))
		For nX := 1 to Len(aHeader)
			IF aHeader[nX][2] == "C"
				//				aItem[nX] := CHR(160)+TRBNS->&(aHeader[nX][1])
				aItem[nX] := TRBNS->&(aHeader[nX][1])
			ELSE
				aItem[nX] := TRBNS->&(aHeader[nX][1])
			ENDIF
		Next nX
		AADD(aCols,aItem)
		aItem := {}
		TRBNS->(dbSkip())
	End
	/*
	aCols := aBrowse
	For _nCount := 1 to Len(aCols)
	For nX := 1 to Len(aHeader)
	IF aHeader[nX][2] == "C"
	aCols[_nCount][nX] := CHR(160)+aCols[_nCount][nX]
	ENDIF
	Next nX
	Next _nCount
	*/
Return

/*
Funcao: GDToExcel
Autor: Marinaldo de Jesus
Data: 01/06/2013
Descricao: Mostrar os Dados no Excel
Sintaxe: StaticCall(NDJLIB001,GDToExcel,aHeader,aCols,cWorkSheet,cTable,lTotalize,lPicture)
*/
Static Function GDToExcel(aHeader,aCols,cWorkSheet,cTable,lTotalize,lPicture)

	Local oFWMSExcel := FWMSExcel():New()

	Local oMsExcel

	Local aCells

	Local cType
	Local cColumn

	Local cFile
	Local cFileTMP

	Local cPicture

	Local lTotal

	Local nRow
	Local nRows
	Local nField
	Local nFields

	Local nAlign
	Local nFormat

	Local uCell

	DEFAULT cWorkSheet := "GETDADOS"
	DEFAULT cTable := cWorkSheet
	DEFAULT lTotalize := .T.
	DEFAULT lPicture := .F.

	BEGIN SEQUENCE

		oFWMSExcel:AddworkSheet(cWorkSheet)
		oFWMSExcel:AddTable(cWorkSheet,cTable)

		nFields := Len( aHeader )
		For nField := 1 To nFields
			cType := aHeader[nField][2]
			nAlign := IF(cType=="C",1,IF(cType=="N",3,2))
			nFormat := IF(cType=="D",4,IF(cType=="N",2,1))
			cColumn := aHeader[nField][1]
			lTotal := ( lTotalize .and. cType == "N" )
			oFWMSExcel:AddColumn(@cWorkSheet,@cTable,@cColumn,@nAlign,@nFormat,@lTotal)
		Next nField

		aCells := Array(nFields)

		nRows := Len( aCols )
		For nRow := 1 To nRows
			For nField := 1 To nFields
				uCell := aCols[nRow][nField]
				IF ( lPicture )
					cPicture := aHeader[nField][6]
					IF .NOT.( Empty(cPicture) )
						uCell := Transform(uCell,cPicture)
					EndIF
				EndIF
				cType := aHeader[nField][2] // Verificar data vazia e deixar sem formato, gera erro no XML
				if cType == "D" .and. uCell == stod("")
					aCells[nField] := ""
				else
					aCells[nField] := uCell
				endif
			Next nField
			oFWMSExcel:AddRow(@cWorkSheet,@cTable,aClone(aCells))
		Next nRow

		oFWMSExcel:Activate()

		cFile := ( CriaTrab( NIL, .F. ) + ".xml" )

		While File( cFile )
			cFile := ( CriaTrab( NIL, .F. ) + ".xml" )
		End While

		oFWMSExcel:GetXMLFile( cFile )
		oFWMSExcel:DeActivate()

		IF .NOT.( File( cFile ) )
			cFile := ""
			BREAK
		EndIF

		cFileTMP := ( GetTempPath() + cFile )
		//cFileTMP := ( AllTrim(_cDirSave) + cFile )
		IF .NOT.( __CopyFile( cFile , cFileTMP ) )
			fErase( cFile )
			cFile := ""
			BREAK
		EndIF

		fErase( cFile )

		cFile := cFileTMP

		IF .NOT.( File( cFile ) )
			cFile := ""
			BREAK
		EndIF

		IF .NOT.( ApOleClient("MsExcel") )
			BREAK
		EndIF

		oMsExcel := MsExcel():New()
		oMsExcel:WorkBooks:Open( cFile )
		oMsExcel:SetVisible( .T. )
		oMsExcel := oMsExcel:Destroy()

	END SEQUENCE

	oFWMSExcel := FreeObj( oFWMSExcel )

Return( cFile )

