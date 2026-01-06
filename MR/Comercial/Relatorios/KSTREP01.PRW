#include "tbiconn.ch"
#include 'PROTHEUS.ch'
#include 'parmtype.ch'
#include "fwmvcdef.ch"
#DEFINE CRLF CHR(13) + CHR(10)
#DEFINE TAB Chr(09)

User Function KSTREP01()
	Local aArea 	:= getArea()
	Private aPergs	:= {}
	Private cPerg 	:= ""
	Private oReport

	oReport := PxZ09IDef()
	oReport:printDialog()

	RestArea(aArea)
	Return()

	*************************************************************************************************************************************************************
Static Function PxZ09IDef()
	Local oSection1
	Local ctitulo := "Relatório de consulta da Tabela Master"
	Local cDesc := "Este relatorio irá imprimir a relação de itens das tabela Master"

	oReport:= TReport():New("PX09IDEF",OemToAnsi(ctitulo),cPerg,{|oReport| PxZ09PRep(oReport)}, cDesc)
	oReport:SetLandscape()
	oReport:SetTotalInLine(.F.)
	oReport:ShowHeader()

	oSection1 := TRSection():New(oReport,"Consulta",{"cTMP"},{"FILIAL","DOCUMENTO","SERIE","EMISSAO","COD_CLIENTE","NOME_CLIENTE","LOJA","VALOR"},,)
	oSection1:SetTotalInLine(.F.)

	TRCell():New(oSection1, "Z09_FILIAL"	, "cTMP", "FILIAL"			,PesqPict("Z09","Z09_FILIAL")	,TamSX3("Z09_FILIAL")[1]	,,,"LEFT",,"CENTER" )
	TRCell():New(oSection1, "Z09_CODTAB"	, "cTMP", "TABELA"			,PesqPict("Z09","Z09_CODTAB")	,TamSX3("Z09_CODTAB")[1]	,,,"LEFT",,"CENTER" )
	TRCell():New(oSection1, "Z09_PRODUT"	, "cTMP", "COD_PRODUTO"		,PesqPict("Z09","Z09_PRODUT")	,TamSX3("Z09_PRODUT")[1]	,,,"LEFT",,"CENTER" )
	TRCell():New(oSection1, "B1_DESC"		, "cTMP", "DESC_PRODUTO"	,PesqPict("SB1","B1_DESC")		,TamSX3("B1_DESC")	 [1]	,,,"LEFT",,"CENTER" )
	TRCell():New(oSection1, "Z09_PRCREF"	, "cTMP", "PREÇO"			,PesqPict("Z09","Z09_PRCREF")	,TamSX3("Z09_PRCREF")[1]	,,,"RIGHT",,"CENTER" )
	TRCell():New(oSection1, "Z09_INIVIG"	, "cTMP", "INI_VIGENCIA"	,PesqPict("Z09","Z09_INIVIG")	,TamSX3("Z09_INIVIG")[1]	,,,"CENTER",,"CENTER" )
	TRCell():New(oSection1, "Z09_FIMVIG"	, "cTMP", "FIM_VIGENCIA"	,PesqPict("Z09","Z09_FIMVIG")	,TamSX3("Z09_FIMVIG")[1]	,,,"CENTER",,"CENTER" )

	oBreak    := TRBreak():New(oSection1,oSection1:Cell("Z09_FILIAL"),,.F.)

	Return(oReport)
	*************************************************************************************************************************************************************
Static Function PxZ09PRep(oReport)
	Local oSection1 := oReport:Section(1)
	oSection1:Init()
	oSection1:SetHeaderSection(.T.)

	cQuery := ""
	cQuery += " SELECT Z09_FILIAL,Z09_CODTAB,Z09_PRODUT,B1_DESC,Z09_PRCREF,Z09_INIVIG,Z09_FIMVIG "
	cQuery += " FROM " + RetSqlName("Z09") + " Z09, "+ RetSqlName("SB1") + " SB1 "
	cQuery += " WHERE Z09.D_E_L_E_T_ = ' ' "
	cQuery += " AND SB1.D_E_L_E_T_ = ' ' "
	cQuery += " AND SB1.B1_FILIAL = '05' "
	cQuery += " AND Z09.Z09_PRODUT = SB1.B1_COD "
	cQuery += " ORDER BY Z09_FILIAL,Z09_CODTAB,Z09_PRODUT "
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

		oSection1:Cell("Z09_FILIAL"):SetValue(cTMP->Z09_FILIAL)
		//		oSection1:Cell("Z09_FILIAL"):SetAlign("CENTER")
		oSection1:Cell("Z09_CODTAB"):SetValue(cTMP->Z09_CODTAB)
		//		oSection1:Cell("NOTA_FISCAL"):SetAlign("LEFT")
		oSection1:Cell("Z09_PRODUT"):SetValue(cTMP->Z09_PRODUT)
		//		oSection1:Cell("SERIE"):SetAlign("LEFT")
		oSection1:Cell("B1_DESC"):SetValue(cTMP->B1_DESC)
		//		oSection1:Cell("EMISSAO_NF"):SetAlign("CENTER")
		oSection1:Cell("Z09_PRCREF"):SetValue(cTMP->Z09_PRCREF)
		//		oSection1:Cell("COD_CLIENTE"):SetAlign("LEFT")
		oSection1:Cell("Z09_INIVIG"):SetValue(cTMP->Z09_INIVIG)
		//		oSection1:Cell("NOME_CLIENTE"):SetAlign("LEFT")
		oSection1:Cell("Z09_FIMVIG"):SetValue(cTMP->Z09_FIMVIG)
		//		oSection1:Cell("LOJA"):SetAlign("LEFT")

		oSection1:PrintLine()
		dbSelectArea("cTMP")
		cTMP->(dbSkip())
	EndDo
	cTMP->(dbCloseArea())
	oSection1:Finish()
Return

