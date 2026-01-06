#include "protheus.ch"
#include "colors.ch"
#Include "Font.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³MSRCOMGF	ºAutor  ³Hermes Vieira Jr    º Data ³  27/10/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Imprime relatorio de Pedido de Compra de acordo com os     º±±
±±º          ³ parametros informados.   					              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MP8                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MSRCOMGF(lAuto,cPedNum)

	Local lReg				:= .F. 	// Verifica a existência de Registros
	Local nLastKey			:= 0
	Local titulo   			:= "Pedido de Compra"
	Local cMens 			:= "Não há registros para os parametros informados !!"
	Local nCount			:= 0
	Local cPerg				:= "ALRCOM2"
	Local nOpcao            := 0
	Local nOpcUM            := 0
	Local cQryDesc          := ""
	Local cQryUM	        := ""
	Private nItens			:= 0
	Private cFilPc 	   		:= ""
	Private cNPc 	   		:= ""
	Private cEmail 	   		:= ""
	Private cEmissao		:= ""
	Private nQtdPag			:= 0
	Private oFont1 			:= TFont():New("Arial",09,14,		,.T.,,,,,.F.) //Parametros TFonte ("Tipo Fonte", ,Tamanho Fonte , , ,Italico (.T./.F.))
	Private oFont2  		:= TFont():New("Arial",07,08,		,.F.,,,,,.F.) // Normal
	Private oFont3  		:= TFont():New("Arial",09,10,.T.	,.T.,,,,,.F.) // Negrito
	Private oFont4  		:= TFont():New("Arial",09,14,.T.	,.T.,,,,,.T.) // Negrito - Sublinhado
	Private oFont5  		:= TFont():New("Arial",09,10,   	,.F.,,,,,.F.) // Negrito
	Private oPrint

	// Instânciação do Objeto OPrint
	oPrint := TMSPrinter():New()

	&& Faz a chamada do grupo de perguntas, caso a chamada seja feita a partir do menu
	If !lAuto
		ValidPerg(cPerg)
		If !(Pergunte(cPerg,.T.))
			Return
		Endif
		nOpcao := mv_par11
	Else
		nOpcao := Aviso(FunDesc(),"Imprimir descrição do",{"Produto","Complemento","Pedido"})
	Endif

	If nOpcao == 1
		cQryDesc := "B1_DESC"
	ElseIf nOpcao == 2
		cQryDesc := "B5_CEME"
	ElseIf nOpcao == 3
		cQryDesc := "C7_DESCRI"
	Else
		Aviso(FunDesc(),"Escolha a descrição para impressão.",{"OK"})
		Return
	EndIf

	cQryUM := " C7_UM,C7_QUANT, "

	If lastKey() == 27 .or. nLastKey == 27 .or. nLastKey == 286
		return
	Endif

	&& Query que retorna os dados do pedido de compra e os dados dos itens.
	cQuery := "SELECT "
	cQuery += 	 "C7_FILIAL,C7_EMISSAO,C7_NUM,C7_DATPRF,C7_ITEM,C7_PRODUTO,C7_IPI,C7_PRECO,C7_TOTAL, C7_ZZOBS, "
	cQuery += 	 "C7_VALIPI,C7_VALFRE,C7_SEGURO,C7_VALICM,C7_DESPESA,C7_VLDESC,C7_TPFRETE,C7_CC,C7_OBS,C7_CONAPRO,C7_USER,C7_IPI, "
	cQuery += 	 "C7_MSG,C7_DESC1,C7_DESC2,C7_DESC3,C7_COND,C7_VALFRE, C7_TES, C7_ZZDESTC, C7_PICM, "
	cQuery += 	 "A2_COD, A2_LOJA, A2_HPAGE, A2_NOME,A2_END,A2_CEP,A2_DDD,A2_TEL,A2_FAX,A2_EMAIL,A2_CGC,A2_INSCR,A2_MUN, A2_EST,A2_CONTATO, A2_BAIRRO, "
	cQuery +=    "E4_DESCRI, "
	cQuery +=    "CTT_DESC01, "
	cQuery +=    cQryDesc+" AS C7_DESCRI, "
	cQuery +=    cQryUM

	cQuery += " A4_NOME, C7_ZZTRANS "

	cQuery += "FROM "
	cQuery +=    RetSqlName("SC7") + " AS SC7 "
	cQuery += "INNER JOIN "
	cQuery +=    RetSqlName("SA2") + " AS SA2 ON A2_FILIAL = '" + xFilial("SA2") + "' AND C7_FORNECE = A2_COD AND C7_LOJA = A2_LOJA AND SA2.D_E_L_E_T_ = ' ' "

	If Type("SC7->C7_ZZTRANS") <> "U"
		cQuery += "LEFT JOIN "
		cQuery +=    RetSqlName("SA4") + " AS SA4 ON A4_FILIAL = '" + xFilial("SA4") + "' AND C7_ZZTRANS = A4_COD AND SA4.D_E_L_E_T_ = ' ' "
	Endif

	cQuery += "LEFT JOIN "
	cQuery +=    RetSqlName("SE4") + " AS SE4 ON E4_FILIAL = '" + xFilial("SE4") + "' AND C7_COND = E4_CODIGO AND SE4.D_E_L_E_T_ = ' ' "
	cQuery += "LEFT JOIN "
	cQuery +=    RetSqlName("CTT") + " AS CTT ON CTT_FILIAL = '" + xFilial("CTT") + "' AND C7_CC = CTT_CUSTO AND CTT.D_E_L_E_T_ = ' ' "
	cQuery += "LEFT JOIN "
	cQuery +=    RetSqlName("SB1") + " AS SB1 ON B1_FILIAL = '" + xFilial("SB1") + "' AND C7_PRODUTO = B1_COD AND SB1.D_E_L_E_T_ = ' ' "
	cQuery += "LEFT JOIN "
	cQuery +=    RetSqlName("SB5") + " AS SB5 ON B5_FILIAL = '" + xFilial("SB5") + "' AND C7_PRODUTO = B5_COD AND SB5.D_E_L_E_T_ = ' ' "
	cQuery += "WHERE "
	cQuery +=    "C7_FILIAL = '" + xFilial("SC7") + "' "
	If !lAuto
		cQuery +=    "AND C7_NUM BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "' "
		If !Empty(mv_par03) .AND. !Empty(mv_par04)
			cQuery +=    "AND C7_EMISSAO BETWEEN '" + DtoS(mv_par03) + "' AND '" + DtoS(mv_par04) + "' "
		EndIf
		cQuery +=    "AND C7_PRODUTO BETWEEN '" + mv_par05 + "' AND '" + mv_par06 + "' "
		cQuery +=    "AND C7_FORNECE BETWEEN '" + mv_par07 + "' AND '" + mv_par09 + "' "
		cQuery +=    "AND C7_LOJA 	 BETWEEN '" + mv_par08 + "' AND '" + mv_par10 + "' "
	Else
		cQuery +=    "AND C7_NUM = '" + cPedNum + "' "
	Endif
	cQuery +=    "AND SC7.D_E_L_E_T_ = ' ' "
	cQuery += "ORDER BY C7_FILIAL,C7_NUM, C7_ITEM "

	TCQUERY cQuery NEW ALIAS "CALIAS"

	TCSETFIELD("cAlias","C7_EMISSAO","D",08,00)
	TCSETFIELD("cAlias","C7_DATPRF","D",08,00)

	Count to nCount

	cAlias->(dbgotop())

	While cAlias->(!Eof())

		cFilPc := cAlias->C7_FILIAL
		cNPc   := cAlias->C7_NUM
		//TCSETFIELD("cAlias","C7_EMISSAO","D")
		cEmissao := cAlias->C7_EMISSAO
		lReg := .T.

		// Query que retorna a Quantidade Total de itens do Pedido de Compra
		cQuery := "SELECT COUNT(C7_ITEM) AS Total "
		cQuery += " FROM " + RetSqlName("SC7")
		cQuery += " WHERE C7_NUM = '" + cAlias->C7_NUM + "' AND D_E_L_E_T_ = ' '"

		dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), "cCount", .T., .T. )

		// Atribui a Quantidade Total de itens na Variavel nCount
		nItens := cCount->Total

		// Controla a Quantidade de Paginas no Relatorio
		nQtdPag := STR((cCount->Total / 30)+ 1)
		nQtdPag := LEFT(nQtdPag, AT(".",nQtdPag)-1)

		cCount->(dbCloseArea())

		//Inicia uma Nova Pagina para Impressao
		oPrint:StartPage()

		//Define o modo de Impressao como Retrato
		oPrint:SetPortrait()  //SetLandscape -> Para definir como modo Paisagem

		IMPCAB(cNPc, cEMISSAO,cFilPc)	//Funcao para impressao do Cabecalho
		IMPCLI()	//Funcao para impressao dos dados do Cliente
		IMPPRO(cNPc,nCount,nQtdPag,cFilPc)	//Funcao para impressao dos Detalhes do Produto

		//cAlias->(dbSkip())

	End

	cAlias->(dbCloseArea())

	If lReg = .F.
		MsgSTOP(cMens)
	Else
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ MsDialog oDlg: exibi as opcoes para tratativa do relatorio.      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		Define MsDialog oDlg Title "Pedido de Compra" From 0, 0 To 090, 500 Pixel
		Define Font oBold Name "Arial" Size 0, -13 Bold
		@ 000, 000 Bitmap oBmp ResName "LOGIN" Of oDlg Size 30, 120 NoBorder When .F. Pixel
		@ 003, 040 Say Titulo Font oBold Pixel
		@ 014, 030 To 016, 400 Label '' Of oDlg  Pixel
		@ 020, 040 Button "Configurar" 	Size 40, 13 Pixel Of oDlg Action oPrint:Setup()
		@ 020, 082 Button "Imprimir"   	Size 40, 13 Pixel Of oDlg Action oPrint:Print()
		@ 020, 124 Button "Visualizar" 	Size 40, 13 Pixel Of oDlg Action oPrint:Preview()
		//@ 020, 166 Button "Env. Email" 	Size 40, 13 Pixel Of oDlg Action U_MSRCOMHT(.T.,mv_par01)
		@ 020, 208 Button "Sair"       	Size 40, 13 Pixel Of oDlg Action oDlg:End()
		Activate MsDialog oDlg Centered
	Endif

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ"±±
±±ºPrograma  ³ IMPCAB   º Autor ³Hermes Vieira Jr.	   º Data ³  27/10/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Impressao do cabecalho do relatorio.	  						º±±
±±º          ³ Informacao: Cabecalho - Dados da Empresa;					º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MP8                                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function IMPCAB(cNPc, cEMISSAO,cFilPc)

	Local nTopo			:= 0000  // Controle de Linhas
	Local nInicio		:= 0000  // Indica a posição da primeira coluna
	Local cEmail 		:= AllTrim(GetMV("MV_RELFROM")) //AllTrim(GetMV("ZZ_SCEMAIL"))
	Local cLogo			:= AllTrim(GetMV("ZZ_LOGOEMP")) //Imagem dentro do SYSTEM

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Retorna o tamanho Horizontal e Vertical da pagina.                                          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	nVertSize := oPrint:nVertSize()
	nHorzSize := oPrint:nHorzSize()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Impressao do cabeçalho do Relatorio.															³
	//³Obs.: O Logo pode ser colocado na pasta System do Protheus, no caso só referencia o nome.    ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	// oPrint:SayBitmap(Coluna, Linha, Caminho, Largura, Altura)
	oPrint:SayBitmap(nTopo + 0050, nInicio + 0040,cLogo, 410, 185)

	dbSelectArea("SM0")
	SM0->(dbseek(cEmPant + cFilant))

	// oPrint:Say(Coluna, Linha, Texto, Fonte, Num de Caracteres, , ,Alinhamento - 0=Left, 1=Right e 2=Center)
	oPrint:Say(nTopo + 0050, nInicio + 2360,RTrim(SM0->M0_NOMECOM)												   		,oFont1,100,,,1)
	oPrint:Say(nTopo + 0100, nInicio + 2360, AllTrim(SM0->M0_ENDENT) + " " + AllTrim(SM0->M0_CIDENT) + "/" + AllTrim(SM0->M0_ESTENT) + " " + LEFT(AllTrim(SM0->M0_CEPENT),5) + "-" + RIGHT(AllTrim(SM0->M0_CEPENT),3)		,oFont5,100,,,1)
	oPrint:Say(nTopo + 0150, nInicio + 2360, "E-mail: " + Alltrim(cEmail)								   			,oFont3,100,,,1)//							   			,oFont3,100,,,1)
	oPrint:Say(nTopo + 0200, nInicio + 2360, "Fone: " + AllTrim(SM0->M0_TEL)	   		,oFont5,100,,,1)
	oPrint:Say(nTopo + 0250, nInicio + 2360, "CNPJ: " + AllTrim(Transform(SM0->M0_CGC, "@R 99.999.999/9999-99")) + " - IE: " +  AllTrim(Transform(SM0->M0_INSC, "@R 999.999.999.999"))	,oFont5,100,,,1)

	// oPrint:Line(Coluna, Linha, Coluna, Linha)
	oPrint:Line(nTopo + 0310, nInicio + 0040,nTopo + 0310, nInicio + 2360)
	oPrint:Line(nTopo + 0313, nInicio + 0040,nTopo + 0313, nInicio + 2360)
	oPrint:Line(nTopo + 0410, nInicio + 0040,nTopo + 0410, nInicio + 2360)
	oPrint:Line(nTopo + 0413, nInicio + 0040,nTopo + 0413, nInicio + 2360)

	oPrint:Say(nTopo + 0335	, nInicio + 0040, "Pedido de Compra N° " + cNPc		,oFont1,100,,,0)
	oPrint:Say(nTopo + 0335	, nInicio + 2360,"Data: " + DTOC(cEMISSAO)			,oFont1,100,,,1)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ"±±
±±ºPrograma  ³ IMPCLI   º Autor ³Hermes Vieira Jr.	   º Data ³  27/10/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Impressao dos Dados do Cliente.								º±±
±±º          ³ Informacoes: Nome, E-mail, Endereco, Cidade, CEP, Tel, FAX,	º±±
±±º			 ³				Contato e Bairro.								º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MP8                                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function IMPCLI()
	Local nTopo		:= 0000  // Controle de Linhas
	Local nInicio		:= 0000  // Indica a posicao da primeira coluna

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Impressão da Estrutura dos Dados do Cliente.                                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	// Texto a Esquerda
	oPrint:Say(nTopo + 0430	, nInicio + 0040, "Fornecedor" 	,oFont3,100,,,0)
	oPrint:Say(nTopo + 0480	, nInicio + 0040, "E-mail"		,oFont3,100,,,0)
	oPrint:Say(nTopo + 0530	, nInicio + 0040, "Endereço"	,oFont3,100,,,0)
	oPrint:Say(nTopo + 0580	, nInicio + 0040, "Cidade"	  	,oFont3,100,,,0)
	oPrint:Say(nTopo + 0630	, nInicio + 0040, "TEL"  		,oFont3,100,,,0)
	If LEN(ALLTRIM(cAlias->A2_CGC)) > 11
		oPrint:Say(nTopo + 0680	, nInicio + 0040, "CNPJ"  		,oFont3,100,,,0)
	Else
		oPrint:Say(nTopo + 0680	, nInicio + 0040, "CPF"  		,oFont3,100,,,0)
	EndIF
	//oPrint:Say(nTopo + 0730	, nInicio + 0040, "Site"  		,oFont3,100,,,0)

	//Texto Centralizado
	oPrint:Say(nTopo + 0480	,Mm2Pix(oPrint, oPrint:nHorzSize()) / 2,"Contato" 			,oFont3,100,,,0)
	oPrint:Say(nTopo + 0530	,Mm2Pix(oPrint, oPrint:nHorzSize()) / 2,"Bairro" 			,oFont3,100,,,0)
	oPrint:Say(nTopo + 0580	,Mm2Pix(oPrint, oPrint:nHorzSize()) / 2,"CEP" 				,oFont3,100,,,0)
	//oPrint:Say(nTopo + 0630	,Mm2Pix(oPrint, oPrint:nHorzSize()) / 2,"FAX"				,oFont3,100,,,0)
	oPrint:Say(nTopo + 0630	,Mm2Pix(oPrint, oPrint:nHorzSize()) / 2,"IE"				,oFont3,100,,,0)

	// Texto a Esquerda
	oPrint:Say(nTopo + 0430	, nInicio + 0240, ": " + cAlias->A2_COD + " - " + cAlias->A2_NOME		,oFont5,100,,,0)
	oPrint:Say(nTopo + 0480	, nInicio + 0240, ": " + cAlias->A2_EMAIL		,oFont5,100,,,0)
	oPrint:Say(nTopo + 0530	, nInicio + 0240, ": " + cAlias->A2_END			,oFont5,100,,,0)
	oPrint:Say(nTopo + 0580	, nInicio + 0240, ": " + AllTrim(cAlias->A2_MUN)+"/"+cAlias->A2_EST	   		,oFont5,100,,,0)
	oPrint:Say(nTopo + 0630	, nInicio + 0240, ": (" + cAlias->A2_DDD + ") " + LEFT(cAlias->A2_TEL,4) + "-" + SUBSTR(cAlias->A2_TEL,5,8)	 	,oFont5,100,,,0)
	If LEN(ALLTRIM(cAlias->A2_CGC)) > 11
		oPrint:Say(nTopo + 0680	, nInicio + 0240, ": " + AllTrim(Transform(cAlias->A2_CGC,"@R 99.999.999/9999-99")) ,oFont5,100,,,0)
	Else
		oPrint:Say(nTopo + 0680	, nInicio + 0240, ": " + AllTrim(Transform(cAlias->A2_CGC,"@R 999.999.999-99")) ,oFont5,100,,,0)
	EndIf
	//oPrint:Say(nTopo + 0730	, nInicio + 0240, ": " + cAlias->A2_HPAGE ,oFont5,100,,,0)

	//Texto Centralizado
	oPrint:Say(nTopo + 0480	,Mm2Pix(oPrint, oPrint:nHorzSize()) / 2 + 0150,": " + cAlias->A2_CONTATO										,oFont5,100,,,0)
	oPrint:Say(nTopo + 0530	,Mm2Pix(oPrint, oPrint:nHorzSize()) / 2 + 0150,": " + cAlias->A2_BAIRRO										,oFont5,100,,,0)
	oPrint:Say(nTopo + 0580	,Mm2Pix(oPrint, oPrint:nHorzSize()) / 2 + 0150,": " + LEFT(cAlias->A2_CEP,5) + "-" + RIGHT(cAlias->A2_CEP,3)	,oFont5,100,,,0)
	//oPrint:Say(nTopo + 0630	,Mm2Pix(oPrint, oPrint:nHorzSize()) / 2 + 0150,": (" + cAlias->A2_DDD + ") " + LEFT(cAlias->A2_FAX,4) + "-" + SUBSTR(cAlias->A2_FAX,5,8)	,oFont5,100,,,0)
	If LEN(ALLTRIM(cAlias->A2_INSCR)) > 6
		oPrint:Say(nTopo + 0630	,Mm2Pix(oPrint, oPrint:nHorzSize()) / 2 + 0150, ": " + AllTrim(Transform(cAlias->A2_INSCR,"@R 999.999.999.999")) ,oFont5,100,,,0)
	Else
		oPrint:Say(nTopo + 0630	,Mm2Pix(oPrint, oPrint:nHorzSize()) / 2 + 0150, ": " + AllTrim(cAlias->A2_INSCR) ,oFont5,100,,,0)
	EndiF
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ"±±
±±ºPrograma  ³ IMPPRO   º Autor ³Hermes Vieira Jr.	   º Data ³  27/10/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Impressao dos Dados de Detalhes dos Produtos.		  		º±±
±±º		     ³ Parametros: cNPc - Numero do Pedido de Compra Corrente.		º±±
±±º          ³ 			   nCount - Quantidade Total de Itens. 		  		º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MP8                                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function IMPPRO(cNPc, nCount, nQtdPag,cFilPc)
	Local nTopo		 := 0800  // Controle de Linhas
	Local nInicio	 := 0000  // Indica a posição da primeira coluna
	Local nTotal	 := 0000  // Controle do Valor Total do Pedido
	Local nVTIpi	 := 0000  // Controle do Valor Total do Pedido com IPI
	Local nVIPI			:= 0000
	Local nVICM			:= 0000
	Local nPag		 := 1
	Local nCont		 := 0
	Local nContP	 := 0
	Local nTotal2	 := 0
	Local nDespesa   := 0
	Local nFrete     := 0
	Local nTamDes	 := 0
	Local nTamStr	:=0
	Local cDescri		:= ""
	Local nDesc		:= 0000

	Private nTpag		 := 0
	Private cObs		:= ""

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Box, Linhas Verticais e Dados do Cabecalho de Pedido.                                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	// Box
	oPrint:Box(nTopo, nInicio + 0040, nTopo + 0050, nInicio + 2360)

	//Linhas Verticais
	oPrint:Line(nTopo,nInicio + 0180,nTopo + 0050,nInicio + 0180)//Produto
	oPrint:Line(nTopo,nInicio + 0480,nTopo + 0050,nInicio + 0480)//Descri
	oPrint:Line(nTopo,nInicio + 1080,nTopo + 0050,nInicio + 1080)//UM
	oPrint:Line(nTopo,nInicio + 1180,nTopo + 0050,nInicio + 1180)//Qtd
	oPrint:Line(nTopo,nInicio + 1320,nTopo + 0050,nInicio + 1320)//Prc Unit
	oPrint:Line(nTopo,nInicio + 1590,nTopo + 0050,nInicio + 1590)//Prc Total
	oPrint:Line(nTopo,nInicio + 1870,nTopo + 0050,nInicio + 1870)//IPI
	oPrint:Line(nTopo,nInicio + 1960,nTopo + 0050,nInicio + 1960)//ICMS
	oPrint:Line(nTopo,nInicio + 2080,nTopo + 0050,nInicio + 2080)//Dt Entreg

	// Texto
	oPrint:Say(nTopo + 0007,nInicio + 0060,"Item"				   		,oFont3,100,,,0)
	oPrint:Say(nTopo + 0007,nInicio + 0200,"Produto"					,oFont3,100,,,0)
	oPrint:Say(nTopo + 0007,nInicio + 0500,"Descrição do Produto"		,oFont3,100,,,0)
	oPrint:Say(nTopo + 0007,nInicio + 1100,"UM"							,oFont3,100,,,0)
	oPrint:Say(nTopo + 0007,nInicio + 1200,"Qtd."						,oFont3,100,,,0)
	oPrint:Say(nTopo + 0007,nInicio + 1340,"Prc Unit."					,oFont3,100,,,0)
	oPrint:Say(nTopo + 0007,nInicio + 1610,"Prc Total"					,oFont3,100,,,0)
	oPrint:Say(nTopo + 0007,nInicio + 1890,"IPI"	  					,oFont3,100,,,0)
	oPrint:Say(nTopo + 0007,nInicio + 1980,"ICMS"	  					,oFont3,100,,,0)
	oPrint:Say(nTopo + 0007,nInicio + 2100,"Data Entrega"				,oFont3,100,,,0)

	While cAlias->(!Eof()) .AND. cAlias->C7_FILIAL == cFilPc .and. cAlias->C7_NUM == cNPc

		//Demais unidades de medida

		cUM		:= cAlias->C7_UM
		nQuant	:= cAlias->C7_QUANT
		nPreco	:= cAlias->C7_PRECO
		dbSelectArea("SA5")
		dbSetOrder(1)//A5_FILIAL+A5_FORNECE+A5_LOJA+A5_PRODUTO
		If dbSeek(xFilial("SA5")+cAlias->A2_COD+cAlias->A2_LOJA+cAlias->C7_PRODUTO)
			If !empty(SA5->A5_UNID) .AND. !empty(SA5->A5_ZZFATOR) .AND. !empty(SA5->A5_ZZTPCON)
				cUM		:= SA5->A5_UNID
				If SA5->A5_ZZTPCON == "M"
					nQuant	:= cAlias->C7_QUANT * SA5->A5_ZZFATOR
					nPreco	:= cAlias->C7_TOTAL / nQuant
				ElseIf SA5->A5_ZZTPCON == "D"
					nQuant	:= cAlias->C7_QUANT / SA5->A5_ZZFATOR
					nPreco	:= cAlias->C7_TOTAL / nQuant
				EndIf
			EndIf
		EndIf

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Testa se o limite da pagina para a impressao dos produtos.                                   ³
		//³ Caso ultrapasse o limite gera uma Nova Pagina                              					 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		cDescri := ""
		If (nTopo + 0130) >= 2000

			//	oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0150, nInicio + 2360,"Página: " + STR(nPag) + " / " + AllTrim(nQtdPag)		,oFont3,100,,,1)
			oPrint:Line(nTopo + 0040,nInicio + 0040,nTopo + 0040,nInicio + 2360)
			oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0180, nInicio + 2360,"Página: " + str(nPag) + " / " + AllTrim(nQtdPag)   ,oFont3,100,,,1)

			oPrint:EndPage()

			//Inicia uma Nova Pagina para Impressao
			oPrint:StartPage()

			//Define o modo de Impressão como Retrato
			oPrint:SetPortrait()   //SetLandscape -> Para definir como modo Paisagem

			//Funcao para impressao do Cabecalho
			IMPCAB(cNPc, cEMISSAO, cFilPc)

			// Incrementa o contador de Paginas
			nPag := nPag + 1

			nTopo := 0450

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Box, Linhas Verticais e Dados do Cabecalho de Pedido.                                        ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			// Box
			oPrint:Box(nTopo, nInicio + 0040, nTopo + 0050, nInicio + 2360)

			//Linhas Verticais
			oPrint:Line(nTopo,nInicio + 0180,nTopo + 0050,nInicio + 0180)//Produto
			oPrint:Line(nTopo,nInicio + 0480,nTopo + 0050,nInicio + 0480)//Descri
			oPrint:Line(nTopo,nInicio + 1080,nTopo + 0050,nInicio + 1080)//UM
			oPrint:Line(nTopo,nInicio + 1180,nTopo + 0050,nInicio + 1180)//Qtd
			oPrint:Line(nTopo,nInicio + 1320,nTopo + 0050,nInicio + 1320)//Prc Unit
			oPrint:Line(nTopo,nInicio + 1590,nTopo + 0050,nInicio + 1590)//Prc Total
			oPrint:Line(nTopo,nInicio + 1870,nTopo + 0050,nInicio + 1870)//IPI
			oPrint:Line(nTopo,nInicio + 1960,nTopo + 0050,nInicio + 1960)//ICMS
			oPrint:Line(nTopo,nInicio + 2080,nTopo + 0050,nInicio + 2080)//Dt Entreg

			// Texto
			oPrint:Say(nTopo + 0007,nInicio + 0060,"Item"				   		,oFont3,100,,,0)
			oPrint:Say(nTopo + 0007,nInicio + 0200,"Produto"					,oFont3,100,,,0)
			oPrint:Say(nTopo + 0007,nInicio + 0500,"Descrição do Produto"		,oFont3,100,,,0)
			oPrint:Say(nTopo + 0007,nInicio + 1100,"UM"							,oFont3,100,,,0)
			oPrint:Say(nTopo + 0007,nInicio + 1200,"Qtd."						,oFont3,100,,,0)
			oPrint:Say(nTopo + 0007,nInicio + 1340,"Prc Unit."					,oFont3,100,,,0)
			oPrint:Say(nTopo + 0007,nInicio + 1610,"Prc Total"					,oFont3,100,,,0)
			oPrint:Say(nTopo + 0007,nInicio + 1890,"IPI"	  					,oFont3,100,,,0)
			oPrint:Say(nTopo + 0007,nInicio + 1980,"ICMS"	  					,oFont3,100,,,0)
			oPrint:Say(nTopo + 0007,nInicio + 2100,"Data Entrega"				,oFont3,100,,,0)

		EndIF

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Box, Linhas Verticais, Linhas Horizontais e Dados do Pedido.                                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		If !empty(cAlias->C7_ZZOBS)
			If empty(cObs)
				cObs := cAlias->C7_ZZOBS
			Else
				cObs += " - " + cAlias->C7_ZZOBS
			EndIf
		EndIf

		cDescri := ALLTRIM(cAlias->C7_DESCRI) +" - "+ ALLTRIM(cAlias->C7_OBS)

		nTamDes := LEN(cDescri) / 32

		If nTamDes > 1

			//Linhas Verticais - Divisao Colunas
			oPrint:Line(nTopo + 0030,nInicio + 0040,nTopo + 0090,nInicio + 0040)
			oPrint:Line(nTopo + 0030,nInicio + 2360,nTopo + 0090,nInicio + 2360) //2358

			//Linhas Verticais
			oPrint:Line(nTopo + 0030,nInicio + 0180,nTopo + 0090,nInicio + 0180)//Produto
			oPrint:Line(nTopo + 0030,nInicio + 0480,nTopo + 0090,nInicio + 0480)//Descri
			oPrint:Line(nTopo + 0030,nInicio + 1080,nTopo + 0090,nInicio + 1080)//UM
			oPrint:Line(nTopo + 0030,nInicio + 1180,nTopo + 0090,nInicio + 1180)//Qtd
			oPrint:Line(nTopo + 0030,nInicio + 1320,nTopo + 0090,nInicio + 1320)//Prc Unit
			oPrint:Line(nTopo + 0030,nInicio + 1590,nTopo + 0090,nInicio + 1590)//Prc Total
			oPrint:Line(nTopo + 0030,nInicio + 1870,nTopo + 0090,nInicio + 1870)//IPI
			oPrint:Line(nTopo + 0030,nInicio + 1960,nTopo + 0090,nInicio + 1960)//ICMS
			oPrint:Line(nTopo + 0030,nInicio + 2080,nTopo + 0090,nInicio + 2080)//Dt Entreg

			TCSETFIELD("cAlias","C7_DATPRF","D")

			// Impressao dos Campos dos Detalhes dos Produtos

			oPrint:Say(nTopo + 0057, nInicio + 0060, Ltrim(cAlias->C7_ITEM)		,oFont2,100,,,0)
			oPrint:Say(nTopo + 0057, nInicio + 0200, Ltrim(cAlias->C7_PRODUTO)		,oFont2,100,,,0)
			oPrint:Say(nTopo + 0057, nInicio + 0500, substr(cDescri,1,32)		,oFont2,100,,,0)
			oPrint:Say(nTopo + 0057, nInicio + 1100, LTrim(cUM)			,oFont2,100,,,0)
			oPrint:Say(nTopo + 0057, nInicio + 1300, Alltrim(STR(nQuant))  								,oFont2,100,,,1)
			oPrint:Say(nTopo + 0057, nInicio + 1570, Alltrim(Transform(nPreco,PesqPict('SC7', 'C7_PRECO')))		,oFont2,100,,,1)
			oPrint:Say(nTopo + 0057, nInicio + 1850, Alltrim(Transform(cAlias->C7_TOTAL,PesqPict('SC7', 'C7_TOTAL')))		,oFont2,100,,,1)
			oPrint:Say(nTopo + 0057, nInicio + 1940, Alltrim(STR(cAlias->C7_IPI,4,1))								,oFont2,100,,,1)
			oPrint:Say(nTopo + 0057, nInicio + 2060, Alltrim(STR(cAlias->C7_PICM,4,1))								,oFont2,100,,,1)
			oPrint:Say(nTopo + 0057, nInicio + 2100, DTOC(cAlias->C7_DATPRF)		,oFont2,100,,,0)

			nTamStr := 33

			For nCtDesc := 2 to Int(nTamDes) + 1

				nTopo := nTopo + 0050

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Testa se o limite da pagina para a impressao dos produtos.                                   ³
				//³ Caso ultrapasse o limite gera uma Nova Pagina                              					 ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If (nTopo + 0130) >= 2000

					//	oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0150, nInicio + 2360,"Página: " + STR(nPag) + " / " + AllTrim(nQtdPag)		,oFont3,100,,,1)
					oPrint:Line(nTopo + 0040,nInicio + 0040,nTopo + 0040,nInicio + 2360)
					oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0180, nInicio + 2360,"Página: " + str(nPag) + " / " + AllTrim(nQtdPag)   ,oFont3,100,,,1)

					oPrint:EndPage()

					//Inicia uma Nova Pagina para Impressao
					oPrint:StartPage()

					//Define o modo de Impressão como Retrato
					oPrint:SetPortrait()   //SetLandscape -> Para definir como modo Paisagem

					//Funcao para impressao do Cabecalho
					IMPCAB(cNPc, cEMISSAO)

					// Incrementa o contador de Paginas
					nPag := nPag + 1

					nTopo := 0450

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Box, Linhas Verticais e Dados do Cabecalho de Pedido.                                        ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					// Box
					oPrint:Box(nTopo, nInicio + 0040, nTopo + 0050, nInicio + 2360)

					//Linhas Verticais
					oPrint:Line(nTopo,nInicio + 0180,nTopo + 0050,nInicio + 0180)//Produto
					oPrint:Line(nTopo,nInicio + 0480,nTopo + 0050,nInicio + 0480)//Descri
					oPrint:Line(nTopo,nInicio + 1080,nTopo + 0050,nInicio + 1080)//UM
					oPrint:Line(nTopo,nInicio + 1180,nTopo + 0050,nInicio + 1180)//Qtd
					oPrint:Line(nTopo,nInicio + 1320,nTopo + 0050,nInicio + 1320)//Prc Unit
					oPrint:Line(nTopo,nInicio + 1590,nTopo + 0050,nInicio + 1590)//Prc Total
					oPrint:Line(nTopo,nInicio + 1870,nTopo + 0050,nInicio + 1870)//IPI
					oPrint:Line(nTopo,nInicio + 1960,nTopo + 0050,nInicio + 1960)//ICMS
					oPrint:Line(nTopo,nInicio + 2080,nTopo + 0050,nInicio + 2080)//Dt Entreg

					// Texto
					oPrint:Say(nTopo + 0007,nInicio + 0060,"Item"				   		,oFont3,100,,,0)
					oPrint:Say(nTopo + 0007,nInicio + 0200,"Produto"					,oFont3,100,,,0)
					oPrint:Say(nTopo + 0007,nInicio + 0500,"Descrição do Produto"		,oFont3,100,,,0)
					oPrint:Say(nTopo + 0007,nInicio + 1100,"UM"							,oFont3,100,,,0)
					oPrint:Say(nTopo + 0007,nInicio + 1200,"Qtd."						,oFont3,100,,,0)
					oPrint:Say(nTopo + 0007,nInicio + 1340,"Prc Unit."					,oFont3,100,,,0)
					oPrint:Say(nTopo + 0007,nInicio + 1610,"Prc Total"					,oFont3,100,,,0)
					oPrint:Say(nTopo + 0007,nInicio + 1890,"IPI"	  					,oFont3,100,,,0)
					oPrint:Say(nTopo + 0007,nInicio + 1980,"ICMS"	  					,oFont3,100,,,0)
					oPrint:Say(nTopo + 0007,nInicio + 2100,"Data Entrega"				,oFont3,100,,,0)

				EndIF

				//Linhas Verticais - Divisao Colunas
				oPrint:Line(nTopo + 0030,nInicio + 0040,nTopo + 0090,nInicio + 0040)
				oPrint:Line(nTopo + 0030,nInicio + 2360,nTopo + 0090,nInicio + 2360) //2358

				//Linhas Verticais
				oPrint:Line(nTopo + 0030,nInicio + 0180,nTopo + 0090,nInicio + 0180)//Produto
				oPrint:Line(nTopo + 0030,nInicio + 0480,nTopo + 0090,nInicio + 0480)//Descri
				oPrint:Line(nTopo + 0030,nInicio + 1080,nTopo + 0090,nInicio + 1080)//UM
				oPrint:Line(nTopo + 0030,nInicio + 1180,nTopo + 0090,nInicio + 1180)//Qtd
				oPrint:Line(nTopo + 0030,nInicio + 1320,nTopo + 0090,nInicio + 1320)//Prc Unit
				oPrint:Line(nTopo + 0030,nInicio + 1590,nTopo + 0090,nInicio + 1590)//Prc Total
				oPrint:Line(nTopo + 0030,nInicio + 1870,nTopo + 0090,nInicio + 1870)//IPI
				oPrint:Line(nTopo + 0030,nInicio + 1960,nTopo + 0090,nInicio + 1960)//ICMS
				oPrint:Line(nTopo + 0030,nInicio + 2080,nTopo + 0090,nInicio + 2080)//Dt Entreg

				oPrint:Say(nTopo + 0057, nInicio + 0500, Substr(Ltrim(cDescri),nTamStr,32)		,oFont2,100,,,0)

				nTamStr := nTamStr + 33
			Next nCtDesc

		Else

			//Linhas Verticais - Divisao Colunas
			oPrint:Line(nTopo + 0030,nInicio + 0040,nTopo + 0090,nInicio + 0040)
			oPrint:Line(nTopo + 0030,nInicio + 2360,nTopo + 0090,nInicio + 2360) //2358

			//Linhas Verticais
			oPrint:Line(nTopo + 0030,nInicio + 0180,nTopo + 0090,nInicio + 0180)//Produto
			oPrint:Line(nTopo + 0030,nInicio + 0480,nTopo + 0090,nInicio + 0480)//Descri
			oPrint:Line(nTopo + 0030,nInicio + 1080,nTopo + 0090,nInicio + 1080)//UM
			oPrint:Line(nTopo + 0030,nInicio + 1180,nTopo + 0090,nInicio + 1180)//Qtd
			oPrint:Line(nTopo + 0030,nInicio + 1320,nTopo + 0090,nInicio + 1320)//Prc Unit
			oPrint:Line(nTopo + 0030,nInicio + 1590,nTopo + 0090,nInicio + 1590)//Prc Total
			oPrint:Line(nTopo + 0030,nInicio + 1870,nTopo + 0090,nInicio + 1870)//IPI
			oPrint:Line(nTopo + 0030,nInicio + 1960,nTopo + 0090,nInicio + 1960)//ICMS
			oPrint:Line(nTopo + 0030,nInicio + 2080,nTopo + 0090,nInicio + 2080)//Dt Entreg

			TCSETFIELD("cAlias","C7_DATPRF","D")

			// Impressao dos Campos dos Detalhes dos Produtos

			oPrint:Say(nTopo + 0057, nInicio + 0060, Ltrim(cAlias->C7_ITEM)		,oFont2,100,,,0)
			oPrint:Say(nTopo + 0057, nInicio + 0200, Ltrim(cAlias->C7_PRODUTO)		,oFont2,100,,,0)
			oPrint:Say(nTopo + 0057, nInicio + 0500, Ltrim(cDescri)		,oFont2,100,,,0)
			oPrint:Say(nTopo + 0057, nInicio + 1100, LTrim(cUM)			,oFont2,100,,,0)
			oPrint:Say(nTopo + 0057, nInicio + 1300, Alltrim(STR(nQuant))  								,oFont2,100,,,1)
			oPrint:Say(nTopo + 0057, nInicio + 1570, Alltrim(Transform(nPreco,PesqPict('SC7', 'C7_PRECO')))		,oFont2,100,,,1)
			oPrint:Say(nTopo + 0057, nInicio + 1850, Alltrim(Transform(cAlias->C7_TOTAL,PesqPict('SC7', 'C7_TOTAL')))		,oFont2,100,,,1)
			oPrint:Say(nTopo + 0057, nInicio + 1940, Alltrim(STR(cAlias->C7_IPI,4,1))								,oFont2,100,,,1)
			oPrint:Say(nTopo + 0057, nInicio + 2060, Alltrim(STR(cAlias->C7_PICM,4,1))								,oFont2,100,,,1)
			oPrint:Say(nTopo + 0057, nInicio + 2100, DTOC(cAlias->C7_DATPRF)		,oFont2,100,,,0)

		endif
		// Calculo do Valor Total do Pedido de Compra
		nTotal += cAlias->C7_TOTAL
		nFrete += cAlias->C7_VALFRE
		nDespesa += cAlias->C7_DESPESA
		nVIPI += cAlias->C7_VALIPI
		nVICM += cAlias->C7_VALICM
		nDesc += cAlias->C7_VLDESC

		//Calcula o Valor Total do Pedido de Compra com IPI
		//nVTIpi += (((cAlias->C6_VALOR * cAlias->B1_IPI)/100) + cAlias->C6_VALOR)

		nTopo := nTopo + 0050

		//Incrementa Contador da Quantidade de Itens no Pedido de Compra
		++nCont

		//Se o arquivo chegou ao fim, imprime rodape.

		DbSelectArea("CALIAS")
		cAlias->(dbskip())

//		If nCont >= nItens
		If cAlias->(Eof()) .or. cAlias->C7_FILIAL != cFilPc .or. cAlias->C7_NUM != cNPc

			nTotal2 := nTotal + nFrete + nDespesa + nVIPI - nDesc //+ nVICM

			oPrint:Box(nTopo + 0060, nInicio + 0480, nTopo + 0110, nInicio + 1300)
			oPrint:Line(nTopo + 0060, nInicio + 0970,nTopo + 0110,nInicio + 0970)

			oPrint:Say(nTopo + 0067, nInicio + 0500, "Frete"		,oFont3,100,,,0)
			oPrint:Say(nTopo + 0067, nInicio + 1280, " " + Alltrim(Transform(nFrete,PesqPict('SC7', 'C7_TOTAL')))	,oFont3,100,,,1)

			oPrint:Box(nTopo + 0110, nInicio + 0480, nTopo + 0160, nInicio + 1300)
			oPrint:Line(nTopo + 0110, nInicio + 0970,nTopo + 0160,nInicio + 0970)

			oPrint:Say(nTopo + 0117, nInicio + 0500, "Outras Despesas"		,oFont3,100,,,0)
			oPrint:Say(nTopo + 0117, nInicio + 1280, " " + Alltrim(Transform(nDespesa,PesqPict('SC7', 'C7_TOTAL')))	,oFont3,100,,,1)

			oPrint:Box(nTopo + 0160, nInicio + 0480, nTopo + 0210, nInicio + 1300)
			oPrint:Line(nTopo + 0160, nInicio + 0970,nTopo + 0210,nInicio + 0970)

			oPrint:Say(nTopo + 0167, nInicio + 0500, "Descontos"		,oFont3,100,,,0)
			oPrint:Say(nTopo + 0167, nInicio + 1280, " " + Alltrim(Transform(nDesc,PesqPict('SC7', 'C7_TOTAL')))	,oFont3,100,,,1)

			//Valor IPI
			oPrint:Box(nTopo + 0060, nInicio + 1320, nTopo + 0110, nInicio + 1920)
			oPrint:Line(nTopo + 0060, nInicio + 1620,nTopo + 0110,nInicio + 1620)

			oPrint:Say(nTopo + 0067, nInicio + 1340, "Valor IPI"		,oFont3,100,,,0)
			oPrint:Say(nTopo + 0067, nInicio + 1900, " " + Alltrim(Transform(nVIPI,PesqPict('SC7', 'C7_TOTAL')))	,oFont3,100,,,1)

			//Valor ICMS
			oPrint:Box(nTopo + 0110, nInicio + 1320, nTopo + 0160, nInicio + 1920)
			oPrint:Line(nTopo + 0110, nInicio + 1620,nTopo + 0160,nInicio + 1620)

			oPrint:Say(nTopo + 0117, nInicio + 1340, "Valor ICMS"		,oFont3,100,,,0)
			oPrint:Say(nTopo + 0117, nInicio + 1900, " " + Alltrim(Transform(nVICM,PesqPict('SC7', 'C7_TOTAL')))	,oFont3,100,,,1)

			//Box e Dados - Valor Total
			oPrint:Box(nTopo + 0160, nInicio + 1320, nTopo + 0210, nInicio + 1920)
			oPrint:Line(nTopo + 0160, nInicio + 1620,nTopo + 0210,nInicio + 1620)

			oPrint:Say(nTopo + 0167, nInicio + 1340, "Valor Total Ped."		,oFont3,100,,,0)
			oPrint:Say(nTopo + 0167, nInicio + 1900, " " + Alltrim(Transform(nTotal,PesqPict('SC7', 'C7_TOTAL')))	,oFont3,100,,,1)

			oPrint:Box(nTopo + 0210, nInicio + 1320, nTopo + 0260, nInicio + 1920)
			oPrint:Line(nTopo + 0210, nInicio + 1620,nTopo + 0260,nInicio + 1620)

			oPrint:Say(nTopo + 0217, nInicio + 1340, "Valor Total"		,oFont3,100,,,0)
			oPrint:Say(nTopo + 0217, nInicio + 1900, " " + Alltrim(Transform(nTotal2,PesqPict('SC7', 'C7_TOTAL')))	,oFont3,100,,,1)

			//LInhas Horizontais  -  FIM PEDIDO
			oPrint:Line(nTopo + 0040,nInicio + 0040,nTopo + 0040,nInicio + 2360) //2358

			//Imprime o Numero de Paginas
			//	oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0150, nInicio + 2360,"Página: " + str(nPag) + " / " + AllTrim(nQtdPag)  ,oFont3,100,,,1)

			// Funcao de Impressao do Rodape. Parametro: Numero da linha atual
			IMPROD(NPag, nTotal, nTopo)
		EndIf

	End

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ"±±
±±ºPrograma  ³ IMPROD	º Autor ³ Hermes Vieira Jr.	   º Data ³  27/10/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao para impressao do Rodape.								º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MP8                                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function IMPROD(nPag, nTotal, nTopo)

	Local nInicio    := 0000  // Indica a posicao da primeira coluna
	Local cDescontos := ""

	If cAlias->C7_DESC1 > 0
		cDescontos += AllTrim(TRANSFORM(cAlias->C7_DESC1,PesqPict('SC7', 'C7_DESC1')))
	EndIf

	If cAlias->C7_DESC2 > 0
		If !Empty(cDescontos)
			cDescontos += " + "
		Endif
		cDescontos += AllTrim(TRANSFORM(cAlias->C7_DESC2,PesqPict('SC7', 'C7_DESC2')))
	EndIf

	If cAlias->C7_DESC3 > 0
		If !Empty(cDescontos)
			cDescontos += " + "
		Endif
		cDescontos += AllTrim(TRANSFORM(cAlias->C7_DESC3,PesqPict('SC7', 'C7_DESC3')))
	EndIf

	IMPROBS()

	oPrint:Box(Mm2Pix(oPrint, oPrint:nVertSize()) - 1070, nInicio + 0040, Mm2Pix(oPrint, oPrint:nVertSize()) - 0940, nInicio + 2360)
	oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 1060, nInicio + 0060,"Observações:",oFont3,100,,,0)
	oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 1020, nInicio + 0080,substr(cObs,1,250),oFont2,100,,,0)
	oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0980, nInicio + 0080,substr(cObs,251,250),oFont2,100,,,0)

	// Box Condicoes Gerais
	oPrint:Box(Mm2Pix(oPrint, oPrint:nVertSize()) - 0920, nInicio + 0040, Mm2Pix(oPrint, oPrint:nVertSize()) - 0680, nInicio + 2360)

	// Titulo Centralizado
	oPrint:Say (Mm2Pix(oPrint, oPrint:nVertSize()) - 0900, Mm2Pix(oPrint, oPrint:nHorzSize()) / 2,"Informações Gerais"		,oFont1,100,,,2)

	oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0800, nInicio + 0060,"Forma de Pagamento"  						  		,oFont3,100,,,0)
	oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0800, nInicio + 0450,": " + cAlias->C7_COND + " - " + cAlias->E4_DESCRI	,oFont5,100,,,0)

	oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0800, Mm2Pix(oPrint, oPrint:nHorzSize()) / 2 - 200,"Tipo Frete"  								,oFont3,100,,,0)
	If AllTrim(cAlias->C7_TPFRETE) = "C"
		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0800, Mm2Pix(oPrint, oPrint:nHorzSize()) / 2 + 0100,": CIF"	,oFont5,100,,,0)
	Else
		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0800, Mm2Pix(oPrint, oPrint:nHorzSize()) / 2 + 0100,": FOB"	,oFont5,100,,,0)
	EndIf

	cDestC := ""

	If cAlias->C7_ZZDESTC == "C"
		cDestC := "CONSUMO"
	ElseIf cAlias->C7_ZZDESTC == "I"
		cDestC := "INDUSTRIALIZAÇÃO"
	ElseIf cAlias->C7_ZZDESTC == "S"
		cDestC := "SERVIÇO"
	ElseIf cAlias->C7_ZZDESTC == "M"
		cDestC := "IMOBILIZADO"
	ElseIf cAlias->C7_ZZDESTC == "R"
		cDestC := "REVENDA"
	EndIF

	oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0750, nInicio + 0060,"Material destinado a"    ,oFont3,100,,,0)
	oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0750, nInicio + 0450,": " + cDestC,oFont5,100,,,0)

	If Type("SC7->C7_ZZTRANS") <> "U"
		//oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0390, Mm2Pix(oPrint, oPrint:nHorzSize()) / 2,"Validade" 				 			   		,oFont3,100,,,0)
		//oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0390, Mm2Pix(oPrint, oPrint:nHorzSize()) / 2 + 0200,": " + DtoC(cAlias->C7_ZZVALID)				,oFont5,100,,,0)

		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0750, Mm2Pix(oPrint, oPrint:nHorzSize()) / 2 - 200,"Transportadora" 				 				   	   					,oFont3,100,,,0)
		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0750, Mm2Pix(oPrint, oPrint:nHorzSize()) / 2 + 0100,": (" + cAlias->C7_ZZTRANS + " )" + cAlias->A4_NOME					,oFont5,100,,,0)
	Endif

	//Imprime o Numero de Paginas
	oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0180, nInicio + 2360,"Página: " + str(nPag) + " / " + AllTrim(nQtdPag)   ,oFont3,100,,,1)

	oPrint:EndPage()

Return

Static Function IMPROBS()
	Local nInicio    := 0000  // Indica a posicao da primeira coluna

	oPrint:Box(Mm2Pix(oPrint, oPrint:nVertSize()) - 0660, nInicio + 0040, Mm2Pix(oPrint, oPrint:nVertSize()) - 0300, nInicio + 2360)
	//oPrint:Box(Mm2Pix(oPrint, oPrint:nVertSize()) - 1700, nInicio + 0040, Mm2Pix(oPrint, oPrint:nVertSize()) - 0300, nInicio + 2360)

	oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0660, nInicio + 0060,"Obs. da Empresa" 				 				   	   					,oFont3,100,,,0)
	oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0620, nInicio + 0080,"1   É obrigatório constar o número do nosso pedido no corpo da nota.",oFont2,100,,,0)
	oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0580, nInicio + 0080,"2   A nota será imediatamente devolvida se estiver em divergencia com o pedido.",oFont2,100,,,0)
	oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0540, nInicio + 0080,"3   Observar endereço e CNPJ do pedido para faturamento.",oFont2,100,,,0)
	oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0500, nInicio + 0080,"4   Optantes pelo SIMPLES destacar o valor em reais para obtenção de crédito ICMS.",oFont2,100,,,0)
	oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0460, nInicio + 0080,"5   HORÁRIO DE RECEBIMENTO DE MERCADORIA:",oFont2,100,,,0)
	oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0420, nInicio + 0080,"6           De 2ª a 5ª - 8:00 às 12:00 hs - 13:00 às 16:00 hs",oFont2,100,,,0)
	oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0380, nInicio + 0080,"7           6ª - 8:00 às 12:00 hs - 13:00 às 15:00 hs",oFont2,100,,,0)
	oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0340, nInicio + 0080,"8   E-mail para recebimento da NF Eletrônica: nfefornecedor@kestra.com.br",oFont2,100,,,0)

	dbSelectArea("SCR")
	dbSetOrder(1)//CR_FILIAL+CR_TIPO+CR_NUM+CR_NIVEL
	If dbSeek(xFilial("SCR")+"PC"+cNPc)
		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0660, nInicio + 1710,"Aprovadores:" 				 				   	   					,oFont3,100,,,0)
		While SCR->(!Eof()) .AND. alltrim(xFilial("SCR")+"PC"+cNPc) == alltrim(SCR->CR_FILIAL+"PC"+SCR->CR_NUM)
			cAprovador := alltrim(posicione("SAK",1,xFilial("SAK")+SCR->CR_APROV,"AK_NOME"))
			Do Case
				Case SCR->CR_STATUS == "01"
				cAprovador += " - Aguardando outros niveis!"
				Case SCR->CR_STATUS == "02"
				cAprovador += " - Aguardando liberação!"
				Case SCR->CR_STATUS == "03"
				cAprovador += " - Liberado!"
				Case SCR->CR_STATUS == "04"
				cAprovador += " - Bloqueado!"
				Case SCR->CR_STATUS == "05"
				cAprovador += " - Liberado!"
			EndCase

			oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0620, nInicio + 1710 ,cAprovador,oFont2,100,,,0)

			SCR->(dbSkip())
		EndDo
	EndIf

	oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0270, Mm2Pix(oPrint, oPrint:nHorzSize()) / 2,"O não cumprimento de quaisquer das especificações acimas acordadas, implicará na devoluçao dos materiais sem qualquer",oFont3,100,,,2)
	oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0230, Mm2Pix(oPrint, oPrint:nHorzSize()) / 2,"ônus para o comprador. Autorizamos-lhe o fornecimento acima, observada as condições de compra",oFont3,100,,,2)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ"±±
±±ºPrograma  ³ Mm2Pix   º Autor ³Waldir Baldin		   º Data ³  27/10/06   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Retorna a Largura da Pagina em Pixel.						º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MP8                                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Mm2Pix(oPrint, nMm)
	/*Retirado metodo oPrint:nLogPixelX(), pois estava ocorrendo casos em clientes
	em que a linha impressa que utliza a funcao MM2PIX saia desconfigurada*/
	//Local nValor := (nMm * oPrint:nLogPixelX()) / 25.4
	Local nValor := (nMm * 300) / 25.4
Return nValor

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ValidPerg ºAutor  ³Hermes Vieira Jr.   º Data ³  15/01/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Valida se existe um grupo de perguntas caso contrario o    º±±
±±º          ³ o grupo de perguntas e criado.                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ MP8 - DB2                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function ValidPerg(cPerg)

	Local _sAlias := Alias()
	Local aRegs := {}
	Local i,j

	dbSelectArea("SX1")
	dbSetOrder(1)
	//cPerg := PADR(cPerg,6)
	cPerg := PADR(cPerg,Len(SX1->X1_GRUPO))

	// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/	Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
	aAdd(aRegs, {cPerg, "01", "Pedido de "        			,"" ,"" ,"mv_ch1", "C", 06, 0, 0, "G", "", "mv_par01", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SC7"})
	aAdd(aRegs, {cPerg, "02", "Pedido até "        			,"" ,"" ,"mv_ch2", "C", 06, 0, 0, "G", "", "mv_par02", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SC7"})
	aAdd(aRegs, {cPerg, "03", "Data de "        			,"" ,"" ,"mv_ch3", "D", 08, 0, 0, "G", "", "mv_par03", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""})
	aAdd(aRegs, {cPerg, "04", "Data até "        			,"" ,"" ,"mv_ch4", "D", 08, 0, 0, "G", "", "mv_par04", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""})
	aAdd(aRegs, {cPerg, "05", "Produto de "     			,"" ,"" ,"mv_ch5", "C", 30, 0, 0, "G", "", "mv_par05", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SB1"})
	aAdd(aRegs, {cPerg, "06", "Produto até "     			,"" ,"" ,"mv_ch6", "C", 30, 0, 0, "G", "", "mv_par06", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SB1"})
	aAdd(aRegs, {cPerg, "07", "Fornecedor de "     			,"" ,"" ,"mv_ch7", "C", 06, 0, 0, "G", "", "mv_par07", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SA2"})
	aAdd(aRegs, {cPerg, "08", "Loja de "     				,"" ,"" ,"mv_ch8", "C", 02, 0, 0, "G", "", "mv_par08", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""})
	aAdd(aRegs, {cPerg, "09", "Fornecedor até "     		,"" ,"" ,"mv_ch9", "C", 06, 0, 0, "G", "", "mv_par09", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SA2"})
	aAdd(aRegs, {cPerg, "10", "Loja até "     				,"" ,"" ,"mv_chA", "C", 02, 0, 0, "G", "", "mv_par10", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""})
	aAdd(aRegs, {cPerg, "11", "Imprimir Descrição "         ,"" ,"" ,"mv_chB", "N", 01, 0, 0, "C", "", "mv_par11", "B1_DESC","B1_DESC","B1_DESC","","","B5_CEME","B5_CEME","B5_CEME","","","C7_DESCRI","C7_DESCRI","C7_DESCRI","","","","","","","","","","","","",""})

	For i:=1 to Len(aRegs)
		If !dbSeek(cPerg+aRegs[i,2])
			RecLock("SX1",.T.)
			For j:=1 to FCount()
				If j <= Len(aRegs[i])
					FieldPut(j,aRegs[i,j])
				Endif
			Next
			MsUnlock()
		Endif
	Next

	dbSelectArea(_sAlias)

Return .T.      