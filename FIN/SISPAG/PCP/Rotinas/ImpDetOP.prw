#Include 'Protheus.ch'
#include "topconn.ch"

#DEFINE ATUALIZA_SX1	.F. 

User Function ImpDetOP()

Local oReport 
Private cPergunta := "IMPDETOP"

If FindFunction("TRepInUse") .And. TRepInUse()
	
	CriaSX1()
	Pergunte(cPergunta,.F.)
	
	oReport:= ReportDef()
	oReport:PrintDialog()
	
Else
	MsgAlert("Relatório não disponível em R3.", "Atenção")
EndIf

Return

//Define layout do relatório
Static Function ReportDef()

Local cTitulo 	:= "Imp. Detalhe OP - Ult Custo - Kestra"
Local cHelp	:= "Personalizado Kestra. Relatório que lista todas as requisições contra as Ordens de Produção, no formato do relatório MATR860 - Detalhamento de OPs, "+;
				"porém utilizando custos do último fechamento"
Local oReport
Local oSection1
Local oSection1_1
Local oBreakOP

oReport := TReport():New("IMPDETOP", cTitulo, cPergunta,{|oReport|ReportPrint(oReport)}, cHelp)
oReport:SetTotalInLine(.F.)
oReport:ShowHeader()
oReport:SetLandscape()

oReport:nFontBody := 8
	
//Primeira seção - Cabecalho OP
oSection1 := TRSection():New(oReport,"Dados OP",{"SC2","SB1"})

TRCell():New(oSection1, "D3_OP"		, "WORK", "OP")
TRCell():New(oSection1, "C2_ZZTPOPK", "WORK", "Tipo OP")
TRCell():New(oSection1, "C2_PRODUTO", "WORK", "Prod. Fabricado")
TRCell():New(oSection1, "B1_DESC_C2", "WORK", "Descrição", "@!", 60)
TRCell():New(oSection1, "C2_QUANT"	, "WORK", "Qtd OP")
TRCell():New(oSection1, "B1_UM_C2"	, "WORK", "UM")
TRCell():New(oSection1, "C2_QUJE"	, "WORK", "Qtd Produzida")
TRCell():New(oSection1, "C2_DATRF"	, "WORK", "Dt Encerr.")

//Segunda secao - Itens consumidos
oSection1_1 := TRSection():New(oSection1,"Requisições OP",{"SD3","SB1"})    

TRCell():New(oSection1_1, "D3_CF"		, "WORK", "Tipo RE/DE")   
TRCell():New(oSection1_1, "D3_COD"		, "WORK", "Produto")   
TRCell():New(oSection1_1, "B1_DESC_D3"	, "WORK", "Descrição", "@!", 40)   
TRCell():New(oSection1_1, "D3_QUANT"	, "WORK", "Quant")   
TRCell():New(oSection1_1, "B1_UM_D3"	, "WORK", "UM")   
TRCell():New(oSection1_1, "D3_EMISSAO"	, "WORK", "Dt Emis.",, 12)   
TRCell():New(oSection1_1, "D3_LOCAL"	, "WORK", "Local")   
TRCell():New(oSection1_1, "CUNIT"		, "WORK", "Custo unit.", PesqPict("SB9", "B9_CM1"), TamSx3("D3_CUSTO1")[1])   
TRCell():New(oSection1_1, "CTOTAL"		, "WORK", "Custo total", PesqPict("SD3", "D3_CUSTO1"), TamSx3("D3_CUSTO1")[1])   
TRCell():New(oSection1_1, "DATACUSTO"	, "WORK", "Dt. Custo",,12)   

// Quebra por OP
oBreakOP := TRBreak():New(oSection1, {|| oSection1:Cell("D3_OP"):uPrint }, "Total Custo OP :", .F.)                   
TRFunction():New(oSection1_1:Cell("CTOTAL"), "TOTCUST", "SUM", oBreakOP,,,, .F., .F.)

Return oReport

//Busca e imprime os dados do relatório
Static Function ReportPrint(oReport)

Local oSection1 	:= oReport:Section(1)
Local oSection1_1 	:=oReport:Section(1):Section(1)
Local cQuery		:= ""
Local nRegs			:= 0
Local nCUnit		:= 0 // Custo unitario
Local aRet			:= {}
Local dDtCusto		:= StoD("")
Local cOp			:= ""

If Select("WORK") > 0
	WORK->(dbCloseArea())
Endif

cQuery := "SELECT D3_OP, C2_ZZTPOPK, C2_PRODUTO, B1C2.B1_DESC B1_DESC_C2, C2_QUANT, B1C2.B1_UM B1_UM_C2, C2_QUJE, C2_DATRF, "
cQuery += " D3.*, B1D3.B1_DESC B1_DESC_D3, B1D3.B1_UM B1_UM_D3"
cQuery += " FROM "+ RetSqlName("SD3") +" D3"
cQuery += " INNER JOIN "+ RetSqlName("SB1") +" B1D3 ON B1D3.D_E_L_E_T_=' ' AND B1D3.B1_COD = D3_COD AND B1D3.B1_FILIAL = '"+ xFilial("SB1")+"'"
cQuery += " INNER JOIN "+ RetSqlName("SC2") +" C2 ON C2.D_E_L_E_T_=' ' AND D3_OP = C2_NUM+C2_ITEM+C2_SEQUEN AND C2_FILIAL = '"+ xFilial("SC2")+"'""
cQuery += " INNER JOIN "+ RetSqlName("SB1") +" B1C2 ON B1C2.D_E_L_E_T_=' ' AND B1C2.B1_COD = C2_PRODUTO AND B1C2.B1_FILIAL = '"+ xFilial("SB1")+"'""
cQuery += " WHERE D3.D_E_L_E_T_=' '"
cQuery += " AND D3_FILIAL = '"+xFilial("SD3")+"'"
cQuery += " AND D3_ESTORNO <> 'S'"
cQuery += " AND D3_OP >= '"+ MV_PAR01 +"'"
cQuery += " AND D3_OP <= '"+ MV_PAR02 +"'"
cQuery += " AND C2_ZZTPOPK >= '"+ MV_PAR03 +"'"
cQuery += " AND C2_ZZTPOPK <= '"+ MV_PAR04 +"'"
cQuery += " AND D3_OP <> ' '"
cQuery += " AND D3_CF <> 'PR0'"

tcQuery cQuery New Alias "WORK"
Count To nRegs

WORK->(dbGoTOP())

If WORK->(!eof())
	oReport:SetMeter(nRegs)
	
	While WORK->(!eof())
		oSection1:Init()
		
		cOP := WORK->D3_OP

		oSection1:Cell("D3_OP"):SetValue(WORK->D3_OP)
		oSection1:Cell("C2_ZZTPOPK"):SetValue(WORK->C2_ZZTPOPK)
		oSection1:Cell("C2_PRODUTO"):SetValue(WORK->C2_PRODUTO)
		oSection1:Cell("B1_DESC_C2"):SetValue(WORK->B1_DESC_C2)
		oSection1:Cell("C2_QUANT"):SetValue(WORK->C2_QUANT)
		oSection1:Cell("B1_UM_C2"):SetValue(WORK->B1_UM_C2)
		oSection1:Cell("C2_QUJE"):SetValue(WORK->C2_QUJE)
		oSection1:Cell("C2_DATRF"):SetValue(DtoC(StoD(WORK->C2_DATRF)))
		
		oSection1:Printline()
		
		While WORK->(!eof()) .and. cOP == WORK->D3_OP
			oSection1_1:Init()
		
			oSection1_1:Cell("D3_CF"):SetValue(WORK->D3_CF)
			oSection1_1:Cell("D3_COD"):SetValue(WORK->D3_COD)
			oSection1_1:Cell("B1_DESC_D3"):SetValue(WORK->B1_DESC_D3)
			oSection1_1:Cell("D3_QUANT"):SetValue(WORK->D3_QUANT)
			oSection1_1:Cell("B1_UM_D3"):SetValue(WORK->B1_UM_D3)
			oSection1_1:Cell("D3_EMISSAO"):SetValue(DtoC(StoD(WORK->D3_EMISSAO)))
			oSection1_1:Cell("D3_LOCAL"):SetValue(WORK->D3_LOCAL)
			
			aRet := BuscaCusto(WORK->D3_COD, WORK->D3_LOCAL, WORK->D3_EMISSAO)
			nCUnit 		:= aRet[1]
			dDtCusto 	:= aRet[2]
			
			oSection1_1:Cell("CUNIT"):SetValue(nCUnit)
			oSection1_1:Cell("CTOTAL"):SetValue(nCUnit * WORK->D3_QUANT)
			oSection1_1:Cell("DATACUSTO"):SetValue(DtoC(dDtCusto))
		
			oSection1_1:PrintLine()
			oReport:SkipLine()
			oReport:IncMeter()
			
			WORK->(dbSkip())
		EndDo
		
		oSection1_1:Finish()
		oSection1:Finish()
		
		oReport:SkipLine()
		oReport:SkipLine()
		oReport:SkipLine()

	EndDo
	
	oSection1:Finish()
	
Endif

WORK->(dbCloseArea())

Return


Static Function CriaSX1()

If ATUALIZA_SX1

	DbSelectArea("SX1")
	DbSetOrder(1)
	
	If DbSeek(cPergunta)
		
		While !SX1->(Eof()) .And. AllTrim(SX1->X1_GRUPO) == cPergunta
			
			If RecLock("SX1", .F.)
				SX1->(DbDelete())
				SX1->(MsUnlock())
			Endif
			
			SX1->(DbSkip())
		
		Enddo	
			
	Endif
	
	SX1->(DbCloseArea())

	// Grupo de Pergunta -> Tamanho 10
	PutSX1(cPergunta, "01", "OP de", "OP de", "OP de", "MV_PAR01", "C", TamSx3("D3_OP")[1], 0, 0, "G",, "SC2",,, "MV_PAR01",,,,,,,,,,,,,,,,,{"Informe a OP inicial"}, {"Informe a OP inicial"}, {"Informe a OP inicial"})
	PutSX1(cPergunta, "02", "OP até", "OP até", "OP até", "MV_PAR02", "C", TamSx3("D3_OP")[1], 0, 0, "G",, "SC2",,, "MV_PAR02",,,,,,,,,,,,,,,,,{"Informe OP final"}, {"Informe a OP final"}, {"Informe a OP final"})
	PutSX1(cPergunta, "03", "Tipo OP de", "Tipo OP de", "Tipo OP de", "MV_PAR03", "C", TamSx3("C2_ZZTPOPK")[1], 0, 0, "G",, "ZX",,, "MV_PAR03",,,,,,,,,,,,,,,,,{"Informe o Tipo OP inicial"}, {"Informe o Tipo OP inicial"}, {"Informe o Tipo OP inicial"})
	PutSX1(cPergunta, "04", "Tipo OP até", "Tipo OP até", "Tipo OP até", "MV_PAR04", "C", TamSx3("C2_ZZTPOPK")[1], 0, 0, "G",, "ZX",,, "MV_PAR04",,,,,,,,,,,,,,,,,{"Informe o Tipo OP final"}, {"Informe o Tipo OP final"}, {"Informe o Tipo OP final"})

Endif

Return Nil

//////////////////////////////////////////////////////////////////////////////////////////
Static Function BuscaCusto( cCod, cLocal, cData )

Local aCusto 	:= {}
Local aRet		:= Array(2)
Local dData		:= StoD(cData)
Local dDataCust	:= StoD("")
Local dDtFech	:= GetMV("MV_ULMES")

If Left(cCod,3) == "MOD"
	aRet[1] := Round(WORK->D3_CUSTO1/WORK->D3_QUANT,4)
Else
	If dData > dDtFech
		dDataCust := dDtFech
	Else
		dDataCust := LastDay(dData,0)
	Endif
	
	SB9->( dbSetOrder(1) )
	If SB9->(dbSeek(xFilial("SB9") + cCod + cLocal + DtoS(dDataCust), .F. ))
		aRet[1] := SB9->B9_CM1
	Else // nao tem nenhum fechamento
		aRet[1] := Posicione("SB2",1, xFilial("SB2") + cCod + cLocal, "B2_CM1")
		dDataCust := dDataBase
	Endif
Endif

aRet[2] := dDataCust

If Left(WORK->D3_CF,1) == "D"
	aRet[1] *= -1
Endif

Return aRet
//////////////////////////////////////////////////////////////////////////////////////////