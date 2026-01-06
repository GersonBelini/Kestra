#include "protheus.ch"
#include "colors.ch"
#Include "Font.ch"
#Include "TopConn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma   MSRCOTGF	    บAutor  ณHermes Vieira Jr    บ Data ณ  27/10/06 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Imprime relatorio de Cota็ใo de acordo com os              บฑฑ
ฑฑบ          ณ parametros informados.   					              บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP8                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function MSRCOTGF(lAuto,cNum)

Local lReg				:= .F. 	// Verifica a exist๊ncia de Registros
Local nLastKey			:= 0
Local titulo   			:= "Cota็ใo"
Local cMens 			:= "Nใo hแ registros para os parametros informados !!"
Local nCount			:= 0  
Local cPerg				:= "PERCOT" 
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
Private cDescr			:= ""  

Default lAuto := .F.
Default cNum  := ""

// Instโncia็ใo do Objeto OPrint
oPrint := TMSPrinter():New()   
oPrint:SetPaperSize(9) 	  	 	// Define como Tamanho A4	

&& Faz a chamada do grupo de perguntas, caso a chamada seja feita a partir do menu
ValidPerg(cPerg)

If lAuto
	mv_par01 := cNum
	mv_par02 := cNum
	mv_par03 := Ctod("01/01/1990")
	mv_par04 := Ctod("31/12/2060")
	mv_par05 := Replicate(" ",Len(SB1->B1_COD))
	mv_par06 := Replicate("Z",Len(SB1->B1_COD))
	mv_par07 := Replicate(" ",Len(SA2->A2_COD))
	mv_par08 := Replicate("Z",Len(SA2->A2_COD))
	mv_par09 := Replicate(" ",Len(SA2->A2_LOJA))
	mv_par10 := Replicate("Z",Len(SA2->A2_LOJA))
Else
	If !(Pergunte(cPerg,.T.))
		Return
	Endif
Endif

	
If lastKey() == 27 .or. nLastKey == 27 .or. nLastKey == 286
	return
Endif
     
   	&& Query que retorna os dados da cotacao de compra e os dados dos itens.
		cQuery := "SELECT "
		cQuery += "  	C8_EMISSAO,C8_NUM,C8_DATPRF,C8_ITEM,C8_PRODUTO,C8_UM,C8_QUANT,C8_ALIIPI,C8_PRECO, "
		cQuery += "  	C8_TOTAL,C8_VALIPI,C8_VALFRE,C8_SEGURO,C8_VALICM,C8_DESPESA,C8_VLDESC,C8_TPFRETE,C8_TES, "
		cQuery += "  	C8_OBS,C8_MSG,C8_DESC1,C8_DESC2,C8_DESC3,C8_COND,C8_VALFRE,C8_VALIDA, "
		cQuery += "  	C8_FORNECE, C8_LOJA, C8_NUMSC, C8_ITEMSC, "
		cQuery += "  	A2_COD, A2_HPAGE, A2_NOME,A2_END,A2_CEP,A2_DDD,A2_TEL,A2_FAX,A2_EMAIL,A2_CGC,A2_INSCR, "
		cQuery += "  	A2_MUN, A2_EST, A2_CONTATO, A2_BAIRRO, "	
		cQuery += "  	E4_DESCRI "
		//cQuery += "  	A4_NOME " 
		cQuery += "FROM " + RetSQLName("SC8") + " AS SC8 " 
		cQuery += "INNER JOIN " + RetSQLName("SA2") + " AS SA2 ON A2_FILIAL = '" + xFilial("SA2") + "' AND C8_FORNECE = A2_COD AND C8_LOJA = A2_LOJA AND SA2.D_E_L_E_T_ = ' ' " 
		//cQuery += "LEFT JOIN " + RetSQLName("SA4") + " AS SA4 ON A4_FILIAL = '" + xFilial("SA4") + "' AND C8_ZZTRANS = A4_COD AND SA4.D_E_L_E_T_ = ' ' " 
		cQuery += "LEFT JOIN " + RetSQLName("SE4") + " AS SE4 ON E4_FILIAL = '" + xFilial("SE4") + "' AND C8_COND = E4_CODIGO AND SE4.D_E_L_E_T_ = ' ' " 
		cQuery += "WHERE C8_FILIAL = '" + xFilial("SC8") + "' AND C8_NUM BETWEEN '" + mv_Par01 + "' AND '" + mv_Par02 + "' "
		
		If !Empty(mv_par03) .AND. !Empty(mv_par04) 
			cQuery += " AND C8_EMISSAO BETWEEN '" + DTOS(mv_Par03) + "' AND '" + DTOS(mv_Par04) + "' " 
		EndIf 
		
		If !Empty(mv_par05) .AND. !Empty(mv_par06) 
			cQuery += " AND C8_PRODUTO BETWEEN '" + mv_Par05 + "' AND '" + mv_Par06 + "' " 
		EndIf   
		
		If !Empty(mv_par07) .AND. !Empty(mv_par08) .AND. !Empty(mv_par09) .AND. !Empty(mv_par10) 
			cQuery += " AND C8_FORNECE BETWEEN '" + mv_Par07 + "' AND '" + mv_Par08 + "' " 
			cQuery += " AND C8_LOJA BETWEEN '" + mv_Par09 + "' AND '" + mv_Par10 + "'  " 
		EndIf  
		
		cQuery += " AND SC8.D_E_L_E_T_ = ' ' "
		
		cQuery += " ORDER BY C8_NUM, C8_FORNECE, C8_LOJA "
		
		MemoWrite("MSRCOTGF.sql",cQuery)
			
		TCQUERY cQuery NEW ALIAS "cAlias"
	
		TCSETFIELD("cAlias","C8_EMISSAO","D",08,00)
		TCSETFIELD("cAlias","C8_DATPRF","D",08,00)  
		TCSETFIELD("cAlias","C8_VALIDA","D",08,00)  
	
		Count to nCount      
	
		cAlias->(dbgotop()) 
		
	While cAlias->(!Eof())
		     
		cNPc 		:= cAlias->C8_NUM
		cFornece 	:= cAlias->C8_FORNECE
		cLoja 		:= cAlias->C8_LOJA
		TCSETFIELD("cAlias","C8_EMISSAO","D")
		cEmissao := cAlias->C8_EMISSAO
		lReg := .T.                                                    
		
		// Query que retorna a Quantidade Total de itens do Pedido de Compra		
		cQuery := "SELECT COUNT(C8_ITEM) AS Total "
		cQuery += " FROM " + RetSqlName("SC8")
		cQuery += " WHERE C8_NUM = '" + cAlias->C8_NUM + "' AND C8_FORNECE = '" + cFornece + "' AND C8_LOJA = '" + cLoja + "' AND D_E_L_E_T_ = ' '"
		
		dbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), "cCount", .T., .T. )
		
		// Atribui a Quantidade Total de itens na Variavel nCount
		nCount := cCount->Total 
		
		// Controla a Quantidade de Paginas no Relatorio
		nQtdPag := STR((cCount->Total / 30)+ 1) 
		nQtdPag := LEFT(nQtdPag, AT(".",nQtdPag)-1)
		
		cCount->(dbCloseArea())
		
		//Inicia uma Nova Pagina para Impressao
		oPrint:StartPage()
		
		//Define o modo de Impressao como Retrato
		oPrint:SetPortrait()  //SetLandscape -> Para definir como modo Paisagem
		
		IMPCAB(cNPc, cEMISSAO)	//Funcao para impressao do Cabecalho
	    IMPCLI()	//Funcao para impressao dos dados do Cliente
	   	IMPPRO(cNPc,cFornece,cLoja,nCount,nQtdPag)	//Funcao para impressao dos Detalhes do Produto  
				
	End
	
	cAlias->(dbCloseArea())

If lReg = .F.
	MsgSTOP(cMens)
Else
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ MsDialog oDlg: exibi as opcoes para tratativa do relatorio.      ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	Define MsDialog oDlg Title "Cota็ใo" From 0, 0 To 090, 500 Pixel
	Define Font oBold Name "Arial" Size 0, -13 Bold
	@ 000, 000 Bitmap oBmp ResName "LOGIN" Of oDlg Size 30, 120 NoBorder When .f. Pixel
	@ 003, 040 Say Titulo Font oBold Pixel
	@ 014, 030 To 016, 400 Label '' Of oDlg  Pixel
	@ 020, 040 Button "Configurar" 	Size 40, 13 Pixel Of oDlg Action oPrint:Setup()
	@ 020, 082 Button "Imprimir"   	Size 40, 13 Pixel Of oDlg Action oPrint:Print()
	@ 020, 124 Button "Visualizar" 	Size 40, 13 Pixel Of oDlg Action oPrint:Preview()
	//@ 020, 166 Button "Env. Email" 	Size 40, 13 Pixel Of oDlg Action U_MSRCOTHT(.T.,mv_par01)
	@ 020, 208 Button "Sair"       	Size 40, 13 Pixel Of oDlg Action oDlg:End()
	Activate MsDialog oDlg Centered
Endif                                                  

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออออหออออออัอออออออออออออ"ฑฑ
ฑฑบPrograma  ณ IMPCAB   บ Autor ณHermes Vieira Jr.	   บ Data ณ  27/10/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Impressao do cabecalho do relatorio.	  						บฑฑ
ฑฑบ          ณ Informacao: Cabecalho - Dados da Empresa;					บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP8                                                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function IMPCAB(cNPc, cEMISSAO)

Local nTopo			:= 0000  // Controle de Linhas
Local nInicio		:= 0000  // Indica a posi็ใo da primeira coluna
Local cEmail 		:= RetEmailUsr(__cuserid)//AllTrim(GetMV("MV_RELFROM")) //AllTrim(GetMV("ZZ_SCEMAIL"))
Local cLogo			:= AllTrim(GetMV("ZZ_LOGOEMP")) //AllTrim(GetMV("ZZ_LOGO"))

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณRetorna o tamanho Horizontal e Vertical da pagina.                                          ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
nVertSize := oPrint:nVertSize()
nHorzSize := oPrint:nHorzSize()  

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณImpressao do cabe็alho do Relatorio.															ณ
//ณObs.: O Logo pode ser colocado na pasta System do Protheus, no caso s๓ referencia o nome.    ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

// oPrint:SayBitmap(Coluna, Linha, Caminho, Largura, Altura)
oPrint:SayBitmap(nTopo + 0050, nInicio + 0040,cLogo, 700, 220)

dbSelectArea("SM0")
SM0->(dbseek(cEmPant + cFilant))


// oPrint:Say(Coluna, Linha, Texto, Fonte, Num de Caracteres, , ,Alinhamento - 0=Left, 1=Right e 2=Center)
oPrint:Say(nTopo + 0050, nInicio + 2360,RTrim(SM0->M0_NOMECOM)												   		,oFont1,100,,,1)
oPrint:Say(nTopo + 0100, nInicio + 2360, AllTrim(SM0->M0_ENDENT) + " " + AllTrim(SM0->M0_CIDENT) + "/" + AllTrim(SM0->M0_ESTENT) + " " + LEFT(AllTrim(SM0->M0_CEPENT),5) + "-" + RIGHT(AllTrim(SM0->M0_CEPENT),3)		,oFont5,100,,,1)
oPrint:Say(nTopo + 0150, nInicio + 2360, "E-mail: " + Alltrim(cEmail)								   			,oFont3,100,,,1)
oPrint:Say(nTopo + 0200, nInicio + 2360, "Fone: " + AllTrim(SM0->M0_TEL) + " FAX: " + AllTrim(SM0->M0_FAX)	   		,oFont5,100,,,1)
oPrint:Say(nTopo + 0250, nInicio + 2360, "CNPJ: " + AllTrim(Transform(SM0->M0_CGC, "@R 99.999.999/9999-99")) + " - IE: " +  AllTrim(Transform(SM0->M0_INSC, "@R 999.999.999.999"))	,oFont5,100,,,1)

// oPrint:Line(Coluna, Linha, Coluna, Linha)
oPrint:Line(nTopo + 0310, nInicio + 0040,nTopo + 0310, nInicio + 2360)
oPrint:Line(nTopo + 0313, nInicio + 0040,nTopo + 0313, nInicio + 2360)
oPrint:Line(nTopo + 0410, nInicio + 0040,nTopo + 0410, nInicio + 2360)
oPrint:Line(nTopo + 0413, nInicio + 0040,nTopo + 0413, nInicio + 2360)

	oPrint:Say(nTopo + 0335	, nInicio + 0040, "Cota็ใo Nฐ " + cNPc		,oFont1,100,,,0)
	oPrint:Say(nTopo + 0335	, nInicio + 2360,"Data: " + DTOC(cEMISSAO)			,oFont1,100,,,1)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออออหออออออัอออออออออออออ"ฑฑ
ฑฑบPrograma  ณ IMPCLI   บ Autor ณHermes Vieira Jr.	   บ Data ณ  27/10/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Impressao dos Dados do Cliente.								บฑฑ
ฑฑบ          ณ Informacoes: Nome, E-mail, Endereco, Cidade, CEP, Tel, FAX,	บฑฑ
ฑฑบ			 ณ				Contato e Bairro.								บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP8                                                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function IMPCLI()
Local nTopo			:= 0000  // Controle de Linhas
Local nInicio		:= 0000  // Indica a posicao da primeira coluna

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Impressใo da Estrutura dos Dados do Cliente.                                                 ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

// Texto a Esquerda
oPrint:Say(nTopo + 0430	, nInicio + 0040, "Fornecedor" 	,oFont3,100,,,0)
oPrint:Say(nTopo + 0480	, nInicio + 0040, "E-mail"		,oFont3,100,,,0)
oPrint:Say(nTopo + 0530	, nInicio + 0040, "Endere็o"	,oFont3,100,,,0)
oPrint:Say(nTopo + 0580	, nInicio + 0040, "Cidade"	  	,oFont3,100,,,0)
oPrint:Say(nTopo + 0630	, nInicio + 0040, "TEL"  		,oFont3,100,,,0)
If LEN(ALLTRIM(cAlias->A2_CGC)) > 11
	oPrint:Say(nTopo + 0680	, nInicio + 0040, "CNPJ"  		,oFont3,100,,,0)
Else
	oPrint:Say(nTopo + 0680	, nInicio + 0040, "CPF"  		,oFont3,100,,,0)
EndIF
oPrint:Say(nTopo + 0730	, nInicio + 0040, "Site"  		,oFont3,100,,,0)

//Texto Centralizado
oPrint:Say(nTopo + 0480	,Mm2Pix(oPrint, oPrint:nHorzSize()) / 2,"Contato" 			,oFont3,100,,,0)
oPrint:Say(nTopo + 0530	,Mm2Pix(oPrint, oPrint:nHorzSize()) / 2,"Bairro" 			,oFont3,100,,,0)
oPrint:Say(nTopo + 0580	,Mm2Pix(oPrint, oPrint:nHorzSize()) / 2,"CEP" 				,oFont3,100,,,0)
oPrint:Say(nTopo + 0630	,Mm2Pix(oPrint, oPrint:nHorzSize()) / 2,"FAX"				,oFont3,100,,,0)
oPrint:Say(nTopo + 0680	,Mm2Pix(oPrint, oPrint:nHorzSize()) / 2,"IE"				,oFont3,100,,,0)

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
	oPrint:Say(nTopo + 0730	, nInicio + 0240, ": " + cAlias->A2_HPAGE ,oFont5,100,,,0)
	
	//Texto Centralizado
	oPrint:Say(nTopo + 0480	,Mm2Pix(oPrint, oPrint:nHorzSize()) / 2 + 0150,": " + cAlias->A2_CONTATO										,oFont5,100,,,0)
	oPrint:Say(nTopo + 0530	,Mm2Pix(oPrint, oPrint:nHorzSize()) / 2 + 0150,": " + cAlias->A2_BAIRRO										,oFont5,100,,,0)
	oPrint:Say(nTopo + 0580	,Mm2Pix(oPrint, oPrint:nHorzSize()) / 2 + 0150,": " + LEFT(cAlias->A2_CEP,5) + "-" + RIGHT(cAlias->A2_CEP,3)	,oFont5,100,,,0)
	oPrint:Say(nTopo + 0630	,Mm2Pix(oPrint, oPrint:nHorzSize()) / 2 + 0150,": (" + cAlias->A2_DDD + ") " + LEFT(cAlias->A2_FAX,4) + "-" + SUBSTR(cAlias->A2_FAX,5,8)	,oFont5,100,,,0)
	If LEN(ALLTRIM(cAlias->A2_INSCR)) > 6
		oPrint:Say(nTopo + 0680	,Mm2Pix(oPrint, oPrint:nHorzSize()) / 2 + 0150, ": " + AllTrim(Transform(cAlias->A2_INSCR,"@R 999.999.999.999")) ,oFont5,100,,,0)
    Else
 		oPrint:Say(nTopo + 0680	,Mm2Pix(oPrint, oPrint:nHorzSize()) / 2 + 0150, ": " + AllTrim(cAlias->A2_INSCR) ,oFont5,100,,,0)   
    EndiF
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออออหออออออัอออออออออออออ"ฑฑ
ฑฑบPrograma  ณ IMPPRO   บ Autor ณHermes Vieira Jr.	   บ Data ณ  27/10/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Impressao dos Dados de Detalhes dos Produtos.		  		บฑฑ
ฑฑบ		     ณ Parametros: cNPc - Numero do Pedido de Compra Corrente.		บฑฑ 
ฑฑบ          ณ 			   nCount - Quantidade Total de Itens. 		  		บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP8                                                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function IMPPRO(cNPc,cFornece,cLoja, nCount, nQtdPag)
Local nTopo		 := 0800  // Controle de Linhas
Local nInicio	 := 0000  // Indica a posi็ใo da primeira coluna
Local nTotal	 := 0000  // Controle do Valor Total do Pedido 
Local nVTIpi	 := 0000  // Controle do Valor Total do Pedido com IPI
Local nPag		 := 1
Local nCont		 := 1 
Local nContP	 := 0 
Local nTotal2	 := 0
Local nDespesa   := 0
Local nFrete     := 0   
Local nTamDes	 := 0
Local nTamStr	:=0       

Private nTpag		 := 0   


//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Box, Linhas Verticais e Dados do Cabecalho de Pedido.                                        ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
// Box
oPrint:Box(nTopo, nInicio + 0040, nTopo + 0050, nInicio + 2360)

//Linhas Verticais
oPrint:Line(nTopo,nInicio + 0180,nTopo + 0050,nInicio + 0180)
oPrint:Line(nTopo,nInicio + 0480,nTopo + 0050,nInicio + 0480)
oPrint:Line(nTopo,nInicio + 1080,nTopo + 0050,nInicio + 1080) 
oPrint:Line(nTopo,nInicio + 1180,nTopo + 0050,nInicio + 1180)
oPrint:Line(nTopo,nInicio + 1320,nTopo + 0050,nInicio + 1320)
oPrint:Line(nTopo,nInicio + 1620,nTopo + 0050,nInicio + 1620)
oPrint:Line(nTopo,nInicio + 1920,nTopo + 0050,nInicio + 1920)
oPrint:Line(nTopo,nInicio + 2050,nTopo + 0050,nInicio + 2050)

// Texto    
oPrint:Say(nTopo + 0007,nInicio + 0060,"Item"				   		,oFont3,100,,,0)
oPrint:Say(nTopo + 0007,nInicio + 0200,"Produto"					,oFont3,100,,,0)
oPrint:Say(nTopo + 0007,nInicio + 0500,"Descri็ใo do Produto"		,oFont3,100,,,0)
oPrint:Say(nTopo + 0007,nInicio + 1100,"UM"							,oFont3,100,,,0)
oPrint:Say(nTopo + 0007,nInicio + 1200,"Qtd."						,oFont3,100,,,0)
oPrint:Say(nTopo + 0007,nInicio + 1340,"Prc Unit."					,oFont3,100,,,0)
oPrint:Say(nTopo + 0007,nInicio + 1640,"Prc Total"					,oFont3,100,,,0)
oPrint:Say(nTopo + 0007,nInicio + 1940,"IPI"	  					,oFont3,100,,,0)
oPrint:Say(nTopo + 0007,nInicio + 2070,"Data Entrega"				,oFont3,100,,,0)
	
	While cAlias->(!Eof()) .AND. cAlias->C8_NUM == cNPc .AND. cAlias->C8_FORNECE == cFornece .AND. cAlias->C8_LOJA == cLoja
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Testa se o limite da pagina para a impressao dos produtos.                                   ณ 
		//ณ Caso ultrapasse o limite gera uma Nova Pagina                              					 ณ 			                                                                                                      
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		If (nTopo + 0130) >= 2550
			
			oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0150, nInicio + 2360,"Pแgina: " + STR(nPag) + " / " + AllTrim(nQtdPag)		,oFont3,100,,,1)
			
		   	IMPROD(NPag, nTotal, nTopo)
			
			//Inicia uma Nova Pagina para Impressao
			oPrint:StartPage()
			
			//Define o modo de Impressใo como Retrato
			oPrint:SetPortrait()   //SetLandscape -> Para definir como modo Paisagem
			
			//Funcao para impressao do Cabecalho
			IMPCAB(cNPc, cEMISSAO)
			
			// Incrementa o contador de Paginas
			nPag := nPag + 1
								
			nTopo := 0450
			
			//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
			//ณ Box, Linhas Verticais e Dados do Cabecalho de Pedido.                                        ณ
			//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
			// Box
			oPrint:Box(nTopo, nInicio + 0040, nTopo + 0050, nInicio + 2360)
				
			//Linhas Verticais
			oPrint:Line(nTopo,nInicio + 0180,nTopo + 0050,nInicio + 0180)
			oPrint:Line(nTopo,nInicio + 0480,nTopo + 0050,nInicio + 0480)
			oPrint:Line(nTopo,nInicio + 1080,nTopo + 0050,nInicio + 1080) 
			oPrint:Line(nTopo,nInicio + 1180,nTopo + 0050,nInicio + 1180)
			oPrint:Line(nTopo,nInicio + 1320,nTopo + 0050,nInicio + 1320)
			oPrint:Line(nTopo,nInicio + 1620,nTopo + 0050,nInicio + 1620)
			oPrint:Line(nTopo,nInicio + 1920,nTopo + 0050,nInicio + 1920)
			oPrint:Line(nTopo,nInicio + 2050,nTopo + 0050,nInicio + 2050)
			
			// Texto    
			oPrint:Say(nTopo + 0007,nInicio + 0060,"Item"				   		,oFont3,100,,,0)
			oPrint:Say(nTopo + 0007,nInicio + 0200,"Produto"					,oFont3,100,,,0)
			oPrint:Say(nTopo + 0007,nInicio + 0500,"Descri็ใo do Produto"		,oFont3,100,,,0)
			oPrint:Say(nTopo + 0007,nInicio + 1100,"UM"							,oFont3,100,,,0)
			oPrint:Say(nTopo + 0007,nInicio + 1200,"Qtd."						,oFont3,100,,,0)
			oPrint:Say(nTopo + 0007,nInicio + 1340,"Prc Unit."					,oFont3,100,,,0)
			oPrint:Say(nTopo + 0007,nInicio + 1640,"Prc Total"					,oFont3,100,,,0)
			oPrint:Say(nTopo + 0007,nInicio + 1940,"IPI"	  					,oFont3,100,,,0)
			oPrint:Say(nTopo + 0007,nInicio + 2070,"Data Entrega"			   	,oFont3,100,,,0)
			
		EndIF
		
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณ Box, Linhas Verticais, Linhas Horizontais e Dados do Pedido.                                  ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		cDescr := POSICIONE("SC1",1,XFILIAL("SC1")+cAlias->C8_NUMSC+cAlias->C8_ITEMSC,"C1_DESCRI")
		nTamDes := LEN(Alltrim(cDescr)) / 30
		
		If nTamDes > 2
		
				//Linhas Verticais - Divisao Colunas
			   	oPrint:Line(nTopo + 0030,nInicio + 0040,nTopo + 0090,nInicio + 0040)
			    oPrint:Line(nTopo + 0030,nInicio + 2358,nTopo + 0090,nInicio + 2358)
				
				oPrint:Line(nTopo + 0030,nInicio + 0180,nTopo + 0090,nInicio + 0180)
				oPrint:Line(nTopo + 0030,nInicio + 0480,nTopo + 0090,nInicio + 0480)
				oPrint:Line(nTopo + 0030,nInicio + 1080,nTopo + 0090,nInicio + 1080) 
				oPrint:Line(nTopo + 0030,nInicio + 1180,nTopo + 0090,nInicio + 1180)
				oPrint:Line(nTopo + 0030,nInicio + 1320,nTopo + 0090,nInicio + 1320)
				oPrint:Line(nTopo + 0030,nInicio + 1620,nTopo + 0090,nInicio + 1620)
				oPrint:Line(nTopo + 0030,nInicio + 1920,nTopo + 0090,nInicio + 1920)
			   	oPrint:Line(nTopo + 0030,nInicio + 2050,nTopo + 0090,nInicio + 2050)
				
				TCSETFIELD("cAlias","C8_DATPRF","D")
				
				// Impressao dos Campos dos Detalhes dos Produtos   
				oPrint:Say(nTopo + 0057, nInicio + 0060, Ltrim(cAlias->C8_ITEM)		,oFont2,100,,,0)
				oPrint:Say(nTopo + 0057, nInicio + 0200, Ltrim(cAlias->C8_PRODUTO)		,oFont2,100,,,0)
				oPrint:Say(nTopo + 0057, nInicio + 0500, SubStr(Ltrim(cDescr),1,30)	,oFont2,100,,,0)
				oPrint:Say(nTopo + 0057, nInicio + 1100, LTrim(cAlias->C8_UM)			,oFont2,100,,,0)
				oPrint:Say(nTopo + 0057, nInicio + 1300, Alltrim(STR(cAlias->C8_QUANT))  								,oFont2,100,,,1)
				oPrint:Say(nTopo + 0057, nInicio + 1600, Alltrim(Transform(cAlias->C8_PRECO, PesqPict('SC8', 'C8_PRECO')))		,oFont2,100,,,1)
				oPrint:Say(nTopo + 0057, nInicio + 1900, Alltrim(Transform(cAlias->C8_TOTAL, PesqPict('SC8', 'C8_TOTAL')))		,oFont2,100,,,1)
				
				dbSelectArea("SF4")
				dbSetOrder(1)
				dbSeek(xFilial("SF4") + cAlias->C8_TES)
					If SF4->F4_IPI == "S"
						oPrint:Say(nTopo + 0057, nInicio + 2030, Alltrim(STR(cAlias->C8_ALIIPI,4,1))								,oFont2,100,,,1)
				    Else
						oPrint:Say(nTopo + 0057, nInicio + 2030, "0.0"								,oFont2,100,,,1)    
				    EndIf
				SF4->(dbCloseArea())  
				
				oPrint:Say(nTopo + 0057, nInicio + 2070, DTOC(cAlias->C8_DATPRF)		,oFont2,100,,,0)
				
				nTamStr := 31
				
			For nCon := 2 to Int(nTamDes) + 1  
			
				nTopo := nTopo + 0050     
				
				//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
				//ณ Testa se o limite da pagina para a impressao dos produtos.                                   ณ 
				//ณ Caso ultrapasse o limite gera uma Nova Pagina                              					 ณ 			                                                                                                      
				//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
				If (nTopo + 0130) >= 2550
					
					oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0150, nInicio + 2360,"Pแgina: " + STR(nPag) + " / " + AllTrim(nQtdPag)		,oFont3,100,,,1)
					
				   	IMPROD(NPag, nTotal, nTopo)
					
					//Inicia uma Nova Pagina para Impressao
					oPrint:StartPage()
					
					//Define o modo de Impressใo como Retrato
					oPrint:SetPortrait()   //SetLandscape -> Para definir como modo Paisagem
					
					//Funcao para impressao do Cabecalho
					IMPCAB(cNPc, cEMISSAO)
					
					// Incrementa o contador de Paginas
					nPag := nPag + 1
										
					nTopo := 0450
					
					//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
					//ณ Box, Linhas Verticais e Dados do Cabecalho de Pedido.                                        ณ
					//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
					// Box
					oPrint:Box(nTopo, nInicio + 0040, nTopo + 0050, nInicio + 2360)
						
					//Linhas Verticais
					oPrint:Line(nTopo,nInicio + 0180,nTopo + 0050,nInicio + 0180)
					oPrint:Line(nTopo,nInicio + 0480,nTopo + 0050,nInicio + 0480)
					oPrint:Line(nTopo,nInicio + 1080,nTopo + 0050,nInicio + 1080) 
					oPrint:Line(nTopo,nInicio + 1180,nTopo + 0050,nInicio + 1180)
					oPrint:Line(nTopo,nInicio + 1320,nTopo + 0050,nInicio + 1320)
					oPrint:Line(nTopo,nInicio + 1620,nTopo + 0050,nInicio + 1620)
					oPrint:Line(nTopo,nInicio + 1920,nTopo + 0050,nInicio + 1920)
					oPrint:Line(nTopo,nInicio + 2050,nTopo + 0050,nInicio + 2050)
					
					// Texto    
					oPrint:Say(nTopo + 0007,nInicio + 0060,"Item"				   		,oFont3,100,,,0)
					oPrint:Say(nTopo + 0007,nInicio + 0200,"Produto"					,oFont3,100,,,0)
					oPrint:Say(nTopo + 0007,nInicio + 0500,"Descri็ใo do Produto"		,oFont3,100,,,0)
					oPrint:Say(nTopo + 0007,nInicio + 1100,"UM"							,oFont3,100,,,0)
					oPrint:Say(nTopo + 0007,nInicio + 1200,"Qtd."						,oFont3,100,,,0)
					oPrint:Say(nTopo + 0007,nInicio + 1340,"Prc Unit."					,oFont3,100,,,0)
					oPrint:Say(nTopo + 0007,nInicio + 1640,"Prc Total"					,oFont3,100,,,0)
					oPrint:Say(nTopo + 0007,nInicio + 1940,"IPI"	  					,oFont3,100,,,0)
					oPrint:Say(nTopo + 0007,nInicio + 2070,"Data Entrega"			   	,oFont3,100,,,0)
					
				EndIf
		
				
				//Linhas Verticais - Divisao Colunas
			   	oPrint:Line(nTopo + 0030,nInicio + 0040,nTopo + 0090,nInicio + 0040)
			    oPrint:Line(nTopo + 0030,nInicio + 2358,nTopo + 0090,nInicio + 2358)
				
				oPrint:Line(nTopo + 0030,nInicio + 0180,nTopo + 0090,nInicio + 0180)
				oPrint:Line(nTopo + 0030,nInicio + 0480,nTopo + 0090,nInicio + 0480)
				oPrint:Line(nTopo + 0030,nInicio + 1080,nTopo + 0090,nInicio + 1080) 
				oPrint:Line(nTopo + 0030,nInicio + 1180,nTopo + 0090,nInicio + 1180)
				oPrint:Line(nTopo + 0030,nInicio + 1320,nTopo + 0090,nInicio + 1320)
				oPrint:Line(nTopo + 0030,nInicio + 1620,nTopo + 0090,nInicio + 1620)
				oPrint:Line(nTopo + 0030,nInicio + 1920,nTopo + 0090,nInicio + 1920)
			   	oPrint:Line(nTopo + 0030,nInicio + 2050,nTopo + 0090,nInicio + 2050)
			   	
			   	oPrint:Say(nTopo + 0057, nInicio + 0500, Substr(Ltrim(cDescr),nTamStr,30)		,oFont2,100,,,0)
			    
			 	nTamStr := nTamStr + 30	
			Next
	
		Else
		
		//Linhas Verticais - Divisao Colunas
	   	oPrint:Line(nTopo + 0030,nInicio + 0040,nTopo + 0090,nInicio + 0040)
	    oPrint:Line(nTopo + 0030,nInicio + 2358,nTopo + 0090,nInicio + 2358)
		
		oPrint:Line(nTopo + 0030,nInicio + 0180,nTopo + 0090,nInicio + 0180)
		oPrint:Line(nTopo + 0030,nInicio + 0480,nTopo + 0090,nInicio + 0480)
		oPrint:Line(nTopo + 0030,nInicio + 1080,nTopo + 0090,nInicio + 1080) 
		oPrint:Line(nTopo + 0030,nInicio + 1180,nTopo + 0090,nInicio + 1180)
		oPrint:Line(nTopo + 0030,nInicio + 1320,nTopo + 0090,nInicio + 1320)
		oPrint:Line(nTopo + 0030,nInicio + 1620,nTopo + 0090,nInicio + 1620)
		oPrint:Line(nTopo + 0030,nInicio + 1920,nTopo + 0090,nInicio + 1920)
	   	oPrint:Line(nTopo + 0030,nInicio + 2050,nTopo + 0090,nInicio + 2050)
		
		TCSETFIELD("cAlias","C8_DATPRF","D")
		
		// Impressao dos Campos dos Detalhes dos Produtos   
		oPrint:Say(nTopo + 0057, nInicio + 0060, Ltrim(cAlias->C8_ITEM)		,oFont2,100,,,0)
		oPrint:Say(nTopo + 0057, nInicio + 0200, Ltrim(cAlias->C8_PRODUTO)		,oFont2,100,,,0)
		oPrint:Say(nTopo + 0057, nInicio + 0500, Ltrim(cDescr)		 			,oFont2,100,,,0)
		oPrint:Say(nTopo + 0057, nInicio + 1100, LTrim(cAlias->C8_UM)			,oFont2,100,,,0)
		oPrint:Say(nTopo + 0057, nInicio + 1300, Alltrim(STR(cAlias->C8_QUANT))  								,oFont2,100,,,1)
		oPrint:Say(nTopo + 0057, nInicio + 1600, Alltrim(Transform(cAlias->C8_PRECO, PesqPict('SC8', 'C8_PRECO')))		,oFont2,100,,,1)
		oPrint:Say(nTopo + 0057, nInicio + 1900, Alltrim(Transform(cAlias->C8_TOTAL,PesqPict('SC8', 'C8_TOTAL')))		,oFont2,100,,,1)
		dbSelectArea("SF4")
		dbSetOrder(1)
		dbSeek(xFilial("SF4") + cAlias->C8_TES)
			If SF4->F4_IPI == "S"
				oPrint:Say(nTopo + 0057, nInicio + 2030, Alltrim(STR(cAlias->C8_IPI,4,1))								,oFont2,100,,,1)
		    Else
				oPrint:Say(nTopo + 0057, nInicio + 2030, "0.0"								,oFont2,100,,,1)    
		    EndIf
		SF4->(dbCloseArea())
		oPrint:Say(nTopo + 0057, nInicio + 2070, DTOC(cAlias->C8_DATPRF)		,oFont2,100,,,0)
		
		endif
		// Calculo do Valor Total do Pedido de Compra
		nTotal += cAlias->C8_TOTAL 
		nFrete += cAlias->C8_VALFRE 
		nDespesa += cAlias->C8_DESPESA
		
		//Calcula o Valor Total do Pedido de Compra com IPI
		//nVTIpi += (((cAlias->C6_VALOR * cAlias->B1_IPI)/100) + cAlias->C6_VALOR)
		
		nTopo := nTopo + 0050 
		
		//Incrementa Contador da Quantidade de Itens no Pedido de Compra
		nCont ++
		      
		//Se o arquivo chegou ao fim, imprime rodape.
		If nCont > nCount   
		
			nTotal2 := nTotal + nFrete + nDespesa
		
			oPrint:Box(nTopo + 0060, nInicio + 0480, nTopo + 0110, nInicio + 1300)
			oPrint:Line(nTopo + 0060, nInicio + 0970,nTopo + 0110,nInicio + 0970) 
			
			oPrint:Say(nTopo + 0067, nInicio + 0500, "Frete"		,oFont3,100,,,0)
			oPrint:Say(nTopo + 0067, nInicio + 1280, " " + Alltrim(Transform(nFrete, PesqPict('SC8', 'C8_VALFRE')))	,oFont3,100,,,1)
		    
			oPrint:Box(nTopo + 0110, nInicio + 0480, nTopo + 0160, nInicio + 1300)
			oPrint:Line(nTopo + 0110, nInicio + 0970,nTopo + 0160,nInicio + 0970) 
			
			oPrint:Say(nTopo + 0117, nInicio + 0500, "Outras Despesas"		,oFont3,100,,,0)
			oPrint:Say(nTopo + 0117, nInicio + 1280, " " + Alltrim(Transform(nDespesa, PesqPict('SC8', 'C8_DESPESA')))	,oFont3,100,,,1)
		
			
			//Box e Dados - Valor Total
			oPrint:Box(nTopo + 0060, nInicio + 1320, nTopo + 0110, nInicio + 1920)
			oPrint:Line(nTopo + 0060, nInicio + 1620,nTopo + 0110,nInicio + 1620) 
			
			oPrint:Say(nTopo + 0067, nInicio + 1340, "Valor Total Ped."		,oFont3,100,,,0)
			oPrint:Say(nTopo + 0067, nInicio + 1900, " " + Alltrim(Transform(nTotal, PesqPict('SC8', 'C8_TOTAL')))	,oFont3,100,,,1)
			    
			oPrint:Box(nTopo + 0110, nInicio + 1320, nTopo + 0160, nInicio + 1920)
			oPrint:Line(nTopo + 0110, nInicio + 1620,nTopo + 0160,nInicio + 1620) 
			
			oPrint:Say(nTopo + 0117, nInicio + 1340, "Valor Total"		,oFont3,100,,,0)
			oPrint:Say(nTopo + 0117, nInicio + 1900, " " + Alltrim(Transform(nTotal2, PesqPict('SC8', 'C8_TOTAL')))	,oFont3,100,,,1)
			
			
			/* IMPRIME TOTAL COM IPI
			
			oPrint:Box(nTopo + 0120, nInicio + 1600, nTopo + 0170, nInicio + 2200)
			oPrint:Line(nTopo + 0120, nInicio + 1900,nTopo + 0170,nInicio + 1900) 
			
			oPrint:Say(nTopo + 0127, nInicio + 1615, "Valor Total c/ IPI"		,oFont3,100,,,0)
			oPrint:Say(nTopo + 0127, nInicio + 2190, " " + Alltrim(Transform(nVTIpi,"@E 9,999,999.99"))	,oFont3,100,,,1)
			*/
			
			//LInhas Horizontais  -  FIM PEDIDO
			oPrint:Line(nTopo + 0040,nInicio + 0040,nTopo + 0040,nInicio + 2358)
			
			// Funcao de Impressao do Rodape. Parametro: Numero da linha atual
		   	IMPROD(NPag, nTotal, nTopo)
		EndIf   
				
		cAlias->(dbskip())		
	End
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออออหออออออัอออออออออออออ"ฑฑ
ฑฑบPrograma  ณ IMPROD	บ Autor ณ Hermes Vieira Jr.	   บ Data ณ  27/10/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcao para impressao do Rodape.								บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP8                                                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function IMPROD(nPag, nTotal, nTopo)

Local nInicio		:= 0000  // Indica a posicao da primeira coluna

If nTopo <= (Mm2Pix(oPrint, oPrint:nVertSize()) - 0540)
	
	// Box Condicoes Gerais
	oPrint:Box(Mm2Pix(oPrint, oPrint:nVertSize()) - 0540, nInicio + 0040, Mm2Pix(oPrint, oPrint:nVertSize()) - 0240, nInicio + 2360)
	
	// Titulo Centralizado
	oPrint:Say (Mm2Pix(oPrint, oPrint:nVertSize()) - 0520, Mm2Pix(oPrint, oPrint:nHorzSize()) / 2,"Informa็๕es Gerais"		,oFont1,100,,,2)
		
	oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0440, nInicio + 0060,"Forma de Pagamento"  						  		,oFont3,100,,,0)
	oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0440, nInicio + 0450,": " + cAlias->C8_COND + " - " + cAlias->E4_DESCRI	,oFont5,100,,,0)
    
    oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0440, Mm2Pix(oPrint, oPrint:nHorzSize()) / 2,"Tipo Frete"  								,oFont3,100,,,0)
   	If AllTrim(cAlias->C8_TPFRETE) = "C"  							
		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0440, Mm2Pix(oPrint, oPrint:nHorzSize()) / 2 + 0200,": CIF"	,oFont5,100,,,0)
	Else
		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0440, Mm2Pix(oPrint, oPrint:nHorzSize()) / 2 + 0200,": FOB"	,oFont5,100,,,0)
	EndIf
	
	oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0390, nInicio + 0060,"Descontos %" 				 				   	   		,oFont3,100,,,0)
	oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0390, nInicio + 0450,": " + AllTrim(TRANSFORM(cAlias->C8_DESC1, PesqPict('SC8', 'C8_DESC1'))) + " + " + AllTrim(TRANSFORM(cAlias->C8_DESC2, PesqPict('SC8', 'C8_DESC2'))) + " + " + AllTrim(TRANSFORM(cAlias->C8_DESC3, PesqPict('SC8', 'C8_DESC3')))	,oFont5,100,,,0)
 	
 	oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0390, Mm2Pix(oPrint, oPrint:nHorzSize()) / 2,"Validade" 				 			   		,oFont3,100,,,0)
 	oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0390, Mm2Pix(oPrint, oPrint:nHorzSize()) / 2 + 0200,": " + DtoC(cAlias->C8_VALIDA)				,oFont5,100,,,0)	
   
	//oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0340, nInicio + 0060,"Transportadora" 				 				   	   					,oFont3,100,,,0)
	//oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0340, nInicio + 0450,": (" + cAlias->C8_ZZTRANS + " )" + cAlias->A4_NOME					,oFont5,100,,,0)
 	
 	//Imprime o Numero de Paginas
	oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0200, nInicio + 2360,"Pแgina: " + str(nPag) + " / " + AllTrim(nQtdPag)   ,oFont3,100,,,1)
		
	oPrint:EndPage()
		
 	
Else
	
	//Encerra a Pagina Atual
	oPrint:EndPage()
	
	//Inicia uma Nova Pagina para Impressao
	oPrint:StartPage()
	
	//Define o modo de Impressใo como Retrato
	oPrint:SetPortrait()  //SetLandscape -> Para definir como modo Paisagem
	
	//Funcao para impressao do Cabecalho
	IMPCAB(cNPc, cEMISSAO)
	nTopo := 0420
	
	NPag += 1
	
	// Box Condicoes Gerais
	oPrint:Box(Mm2Pix(oPrint, oPrint:nVertSize()) - 0540, nInicio + 0040, Mm2Pix(oPrint, oPrint:nVertSize()) - 0240, nInicio + 2360)
	
	// Titulo Centralizado
	oPrint:Say (Mm2Pix(oPrint, oPrint:nVertSize()) - 0520, Mm2Pix(oPrint, oPrint:nHorzSize()) / 2,"Informa็๕es Gerais"		,oFont1,100,,,2)
		
	oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0440, nInicio + 0060,"Forma de Pagamento"  						  		,oFont3,100,,,0)
	oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0440, nInicio + 0450,": " + cAlias->C8_COND + " - " + cAlias->E4_DESCRI	,oFont5,100,,,0)
    
    oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0440, Mm2Pix(oPrint, oPrint:nHorzSize()) / 2,"Tipo Frete"  								,oFont3,100,,,0)
   	If AllTrim(cAlias->C8_TPFRETE) = "C"  							
		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0440, Mm2Pix(oPrint, oPrint:nHorzSize()) / 2 + 0200,": CIF"	,oFont5,100,,,0)
	Else
		oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0440, Mm2Pix(oPrint, oPrint:nHorzSize()) / 2 + 0200,": FOB"	,oFont5,100,,,0)
	EndIf
	
	oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0390, nInicio + 0060,"Descontos %" 				 				   	   		,oFont3,100,,,0)
	oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0390, nInicio + 0450,": " + AllTrim(TRANSFORM(cAlias->C8_DESC1,"@E 9,999,999.99")) + " + " + AllTrim(TRANSFORM(cAlias->C8_DESC2,"@E 9,999,999.99")) + " + " + AllTrim(TRANSFORM(cAlias->C8_DESC3,"@E 9,999,999.99"))	,oFont5,100,,,0)
 	
 	oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0390, Mm2Pix(oPrint, oPrint:nHorzSize()) / 2,"Validade" 				 			   		,oFont3,100,,,0)
 	oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0390, Mm2Pix(oPrint, oPrint:nHorzSize()) / 2 + 0200,": " + DtoC(cAlias->C8_VALIDA)				,oFont5,100,,,0)	
   
	//oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0340, nInicio + 0060,"Transportadora" 				 				   	   					,oFont3,100,,,0)
	//oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0340, nInicio + 0450,": (" + cAlias->C8_ZZTRANS + " )" + cAlias->A4_NOME					,oFont5,100,,,0)
 	
/*    
	// Box para a Mensagem da Nota
	oPrint:Box(Mm2Pix(oPrint, oPrint:nVertSize()) - 0270, nInicio + 0040, Mm2Pix(oPrint, oPrint:nVertSize()) - 0170, nInicio + 2360)
	oPrint:Say (Mm2Pix(oPrint, oPrint:nVertSize()) - 0260, nInicio + 0060,"Mensagem" 			   		,oFont3,100,,,0) 
	oPrint:Say (Mm2Pix(oPrint, oPrint:nVertSize()) - 0260, nInicio + 0250,": " + Transform(cAlias->C7_MSG,'@!S150')  		,oFont5,100,,,0) 
 */	
	//Imprime o Numero de Paginas
	oPrint:Say(Mm2Pix(oPrint, oPrint:nVertSize()) - 0200, nInicio + 2360,"Pแgina: " + str(nPag) + " / " + AllTrim(nQtdPag)   ,oFont3,100,,,1)
		
	oPrint:EndPage()
		
EndIf
	
Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออออหออออออัอออออออออออออ"ฑฑ
ฑฑบPrograma  ณ Mm2Pix   บ Autor ณWaldir Baldin		   บ Data ณ  27/10/06   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Retorna a Largura da Pagina em Pixel.						บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP8                                                          บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function Mm2Pix(oPrint, nMm)
/*Retirado metodo oPrint:nLogPixelX(), pois estava ocorrendo casos em clientes 
em que a linha impressa que utliza a funcao MM2PIX saia desconfigurada*/
//Local nValor := (nMm * oPrint:nLogPixelX()) / 25.4
Local nValor := (nMm * 300) / 25.4
Return nValor  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณValidPerg บAutor  ณHermes Vieira Jr.   บ Data ณ  15/01/07   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Valida se existe um grupo de perguntas caso contrario o    บฑฑ
ฑฑบ          ณ o grupo de perguntas e criado.                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MP8 - DB2                                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
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
aAdd(aRegs, {cPerg, "01", "Cota็ใo de "        			,"" ,"" ,"mv_ch1", "C", 06, 0, 0, "G", "", "mv_par01", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "ZSC8"})
aAdd(aRegs, {cPerg, "02", "Cota็ใo at้ "        		,"" ,"" ,"mv_ch2", "C", 06, 0, 0, "G", "", "mv_par02", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "ZSC8"})
aAdd(aRegs, {cPerg, "03", "Data de "        			,"" ,"" ,"mv_ch3", "D", 08, 0, 0, "G", "", "mv_par03", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""})
aAdd(aRegs, {cPerg, "04", "Data at้ "        			,"" ,"" ,"mv_ch4", "D", 08, 0, 0, "G", "", "mv_par04", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""})
aAdd(aRegs, {cPerg, "05", "Produto de "     			,"" ,"" ,"mv_ch5", "C", 30, 0, 0, "G", "", "mv_par05", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SB1"})
aAdd(aRegs, {cPerg, "06", "Produto at้ "     			,"" ,"" ,"mv_ch6", "C", 30, 0, 0, "G", "", "mv_par06", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SB1"})
aAdd(aRegs, {cPerg, "07", "Fornecedor de "     			,"" ,"" ,"mv_ch7", "C", 06, 0, 0, "G", "", "mv_par07", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SA2"})
aAdd(aRegs, {cPerg, "08", "Fornecedor at้ "     		,"" ,"" ,"mv_ch8", "C", 06, 0, 0, "G", "", "mv_par08", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SA2"})
aAdd(aRegs, {cPerg, "09", "Loja de "     				,"" ,"" ,"mv_ch9", "C", 02, 0, 0, "G", "", "mv_par09", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""})
aAdd(aRegs, {cPerg, "10", "Loja at้ "     				,"" ,"" ,"mv_ch10", "C", 02, 0, 0, "G", "", "mv_par10", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""})

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


//Retorna o Email do Usuแrio Logado ou informado
Static Function RetEmailUsr(cCodUser)
Local aDadUser	:= {}
Local cEmail	:= ""

Default cCodUser := RetCodUsr()

PswOrder(1)
If PswSeek(cCodUser, .T.)
	aDadUser:= PswRet(1)
	cEmail	:= Alltrim(aDadUser[1, 14])	// E-mail do Usuario
	If Empty(cEmail)
		cEmail := Alltrim(GetMV("MV_RELFROM"))
	EndIf		
EndIf
	
Return (cEmail)
