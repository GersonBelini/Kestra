#include "tbiconn.ch"
#include 'PROTHEUS.ch'
#include 'parmtype.ch'
#include "fwmvcdef.ch"
#DEFINE CRLF CHR(13) + CHR(10)
#DEFINE TAB Chr(09)

User Function KSTVEN01()
	Local aArea 	:= getArea()
	Private aPergs	:= {}
	Private cPerg 	:= ""
	Private oReport

	oReport := KSTSB1Def()
	oReport:printDialog()

	RestArea(aArea)
	Return()

	*************************************************************************************************************************************************************
Static Function KSTSB1Def()
	Local oSection1
	Local ctitulo := "Relatório de vendas por produto"
	Local cDesc := "Este relatorio irá imprimir as vendas por produtos"

	oReport:= TReport():New("KSTB1DEF",OemToAnsi(ctitulo),cPerg,{|oReport| PxZ09PRep(oReport)}, cDesc)
	oReport:SetLandscape()
	oReport:SetTotalInLine(.F.)
	oReport:ShowHeader()

	oSection1 := TRSection():New(oReport,"Consulta",{"cTMP"},{"FILIAL","EMISSAO","SERIE","EMISSAO","NOTA_FISCAL","SERIE","PRODUTO","DESCRICAO","TOTAL","ICMS","IPI","IMP5","IMP6"},,)
	oSection1:SetTotalInLine(.F.)

	TRCell():New(oSection1, "F2_FILIAL" 	, "cTMP", "FILIAL"			,PesqPict("SF2","F2_FILIAL")	,TamSX3("F2_FILIAL")    [1]	,,,"LEFT",,"CENTER" )
	TRCell():New(oSection1, "F2_EMISSAO"	, "cTMP", "EMISSAO"			,PesqPict("SF2","F2_EMISSAO")	,TamSX3("F2_EMISSAO")   [1]	,,,"LEFT",,"CENTER" )
	TRCell():New(oSection1, "F2_DOC"	    , "cTMP", "NOTA_FISCAL"		,PesqPict("SF2","F2_DOC")   	,TamSX3("F2_DOC")       [1]	,,,"LEFT",,"CENTER" )
	TRCell():New(oSection1, "F2_SERIE"	    , "cTMP", "SERIE"		    ,PesqPict("SF2","F2_SERIE")   	,TamSX3("F2_SERIE")     [1]	,,,"LEFT",,"CENTER" )
	TRCell():New(oSection1, "D2_COD"	    , "cTMP", "PRODUTO"			,PesqPict("SD2","D2_COD")   	,TamSX3("D2_COD")       [1]	,,,"LEFT",,"CENTER" )
	TRCell():New(oSection1, "B1_DESC"		, "cTMP", "DESC_PRODUTO"	,PesqPict("SB1","B1_DESC")		,TamSX3("B1_DESC")	    [1]	,,,"LEFT",,"CENTER" )
	TRCell():New(oSection1, "D2_TOTAL"	    , "cTMP", "TOTAL"			,PesqPict("SD2","D2_TOTAL")   	,TamSX3("D2_TOTAL")     [1]	,,,"LEFT",,"CENTER" )
	TRCell():New(oSection1, "D2_VALICM"	    , "cTMP", "ICMS"			,PesqPict("SD2","D2_VALICM")   	,TamSX3("D2_VALICM")    [1]	,,,"LEFT",,"CENTER" )
	TRCell():New(oSection1, "D2_VALIPI"	    , "cTMP", "IPI"				,PesqPict("SD2","D2_VALIPI")   	,TamSX3("D2_VALIPI")    [1]	,,,"LEFT",,"CENTER" )
	TRCell():New(oSection1, "D2_VALIMP5"    , "cTMP", "VALIMP5"			,PesqPict("SD2","D2_VALIMP5")  	,TamSX3("D2_VALIMP5")   [1]	,,,"LEFT",,"CENTER" )
	TRCell():New(oSection1, "D2_VALIMP6"	, "cTMP", "VALIMP6"			,PesqPict("SD2","D2_VALIMP6")  	,TamSX3("D2_VALIMP6")   [1]	,,,"LEFT",,"CENTER" )
	

	oBreak    := TRBreak():New(oSection1,oSection1:Cell("Z09_FILIAL"),,.F.)

	Return(oReport)
	*************************************************************************************************************************************************************
Static Function KSTVENPRep(oReport)
	Local oSection1 := oReport:Section(1)
	oSection1:Init()
	oSection1:SetHeaderSection(.T.)

	cQuery := ""
	cQuery += " SELECT F2_FILIAL FILIAL,F2_EMISSAO EMISSAO,F2_DOC NOTA_FISCAL,F2_SERIE SERIE,D2_COD PRODUTO,B1_DESC DESCRICAO,D2_TOTAL TOTAL,D2_VALICM ICMS,D2_VALIPI IPI,D2_VALIMP5,D2_VALIMP6 "
	cQuery += " FROM " + RetSqlName("SF2") + " SF2, "+ RetSqlName("SD2") + " SD2 ", "+ RetSqlName("SF4") + " SF4 ", "+ RetSqlName("SB1") + " SB1 "
	cQuery += " WHERE SF2.D_E_L_E_T_ = ' ' "
	cQuery += " AND SD2.D_E_L_E_T_ = ' ' "
	cQuery += " WHERE SF4.D_E_L_E_T_ = ' ' "
	cQuery += " AND SB1.D_E_L_E_T_ = ' ' "	
	cQuery += " SF2.F2_FILIAL = SD2.D2_FILIAL "
	cQuery += " SF2.F2_DOC = SD2.D2_DOC "
	cQuery += " SF2.F2_SERIE = SD2.D2_SERIE "
	cQuery += " SD2.D2_TES = SF4.F4_CODIGO "
	cQuery += " SD2.D2_COD = SB1.B1_COD "
		//TCQuery cQuery new Alias 'cTMP'
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), "cTMP", .F., .T.)
	aEval(Z09->(dbStruct()), {|x| If(x[2] != "C" .And. FieldPos(x[1]) > 0, TcSetField("cTMP",x[1],x[2],x[3],x[4]),Nil)})
	aEval(SB1->(dbStruct()), {|x| If(x[2] != "C" .And. FieldPos(x[1]) > 0, TcSetField("cTMP",x[1],x[2],x[3],x[4]),Nil)})

	dbSelectArea('cTMP')
	dbGoTop()
	oReport:SetMeter(cTMP->(RecCount()))
	While cTMP->(!Eof())
		If oReport:Cancel()
			Exit
		EndIf
		oReport:IncMeter()

		oSection1:Cell("F2_FILIAL"):SetValue(cTMP->F2_FILIAL)
		//		oSection1:Cell("Z09_FILIAL"):SetAlign("CENTER")
		oSection1:Cell("F2_EMISSAO"):SetValue(cTMP->F2_EMISSAO)
		//		oSection1:Cell("NOTA_FISCAL"):SetAlign("LEFT")
		oSection1:Cell("F2_DOC"):SetValue(cTMP->F2_DOC)
		//		oSection1:Cell("SERIE"):SetAlign("LEFT")
		oSection1:Cell("F2_SERIE"):SetValue(cTMP->F2_SERIE)
		//		oSection1:Cell("EMISSAO_NF"):SetAlign("CENTER")
		oSection1:Cell("D2_COD"):SetValue(cTMP->D2_COD)
		//		oSection1:Cell("COD_CLIENTE"):SetAlign("LEFT")
		oSection1:Cell("B1_DESC"):SetValue(cTMP->B1_DESC)
		//		oSection1:Cell("NOME_CLIENTE"):SetAlign("LEFT")
		oSection1:Cell("D2_TOTAL"):SetValue(cTMP->D2_TOTAL)
		//		oSection1:Cell("LOJA"):SetAlign("LEFT")
		oSection1:Cell("D2_ICMS"):SetValue(cTMP->D2_ICMS)
		//		oSection1:Cell("LOJA"):SetAlign("LEFT")
		oSection1:Cell("D2_IPI"):SetValue(cTMP->D2_IPI)
		//		oSection1:Cell("LOJA"):SetAlign("LEFT")
		oSection1:Cell("D2_VALIMP5"):SetValue(cTMP->D2_VALIMP5)
		//		oSection1:Cell("LOJA"):SetAlign("LEFT")
		oSection1:Cell("D2_VALIMP6"):SetValue(cTMP->D2_VALIMP6)
		//		oSection1:Cell("LOJA"):SetAlign("LEFT")

		oSection1:PrintLine()
		dbSelectArea("cTMP")
		cTMP->(dbSkip())
	EndDo
	cTMP->(dbCloseArea())
	oSection1:Finish()
Return

