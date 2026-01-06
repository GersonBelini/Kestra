#INCLUDE "protheus.ch"
#INCLUDE "colors.ch"
#INCLUDE "font.ch"
#INCLUDE "topconn.ch"    
#INCLUDE "rwmake.ch

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AIMAILM   ºAutor  ³Hermes Vieira Jr	 º Data ³  16/06/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Relatorio de Pedido de Venda / Orçamento / Despacho PV      º±±
±±           ³chamado via menu para envio via E-mail.                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³MP8 - TOP                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MSRCOMHT(lAuto,cPedNum)

Local cAssunto 	 := "Relatório de Pedido de Compras"
Local cMens 	 := "Não há registros para os parametros informados !!"
Local cEmail     := ""
Local cMailDig   := Space(255)
Local nLastKey	 := 0
Local nCount	 := 0
Local nTotal     := 0
Local nTotal2    := 0
Local nFrete     := 0
Local nDespesa   := 0
Local cEmailCab	 := RetEmailUsr()
Local cEmailFor	 := ""
Local cEmail	 := ""
Local oMailServer:= Nil
Local oMessage	 := Nil
Local nErr		 := 0
Local cPerg		 := "ALRCOM"
Local cLogoMail	 := AllTrim(GETMV("ZZ_LOGOEXT")) //Imagem em Caminho HTTP
Local oDL
Local oMail
Local cNPc
Local cHtml
Local cOpt
Local cQuery
Local cEMISSAO
Local cNomeFor
Local cCond
Local cTpFrete
Local cE4Desc
Local cValid
Local cDesc1
Local cDesc2
Local cDesc3
Local cTrans
Local cNTran

Default lAuto 	 := .F.
Default cPedNum  := ""

&& Faz a chamada do grupo de perguntas, caso a chamada seja feita a partir do menu
If !lAuto
	ValidPerg(cPerg)
	If !(Pergunte(cPerg,.T.))
		Return
	Endif
Endif

If lastKey() == 27 .or. nLastKey == 27 .or. nLastKey == 286
	return
Endif

&& Query que retorna os dados do pedido de compra e os dados dos itens.
cQuery := "SELECT "
cQuery += 	 "C7_EMISSAO,C7_NUM,C7_DATPRF,C7_ITEM,C7_PRODUTO,C7_DESCRI,C7_UM,C7_QUANT,C7_IPI,C7_PRECO,C7_TOTAL,"
cQuery += 	 "C7_VALIPI,C7_VALFRE,C7_SEGURO,C7_VALICM,C7_DESPESA,C7_VLDESC,C7_TPFRETE,C7_CC,C7_OBS,C7_CONAPRO,C7_USER,C7_IPI,"
cQuery += 	 "C7_MSG,C7_DESC1,C7_DESC2,C7_DESC3,C7_COND,C7_VALFRE,C7_ZZVALID,C7_ZZTRANS,C7_TES,"
cQuery += 	 "A2_COD, A2_LOJA, A2_HPAGE, A2_NOME, A2_NREDUZ, A2_END,A2_CEP,A2_DDD,A2_TEL,A2_FAX,A2_EMAIL,A2_CGC,A2_INSCR,A2_MUN, A2_EST, A2_CONTATO, A2_BAIRRO,"
cQuery +=    "E4_DESCRI,"
cQuery +=    "CTT_DESC01,"
cQuery +=    "A4_NOME "
cQuery += "FROM "
cQuery +=    RetSqlName("SC7") + " AS SC7 "
cQuery += "INNER JOIN "
cQuery +=    RetSqlName("SA2") + " AS SA2 ON A2_FILIAL = '" + xFilial("SA2") + "' AND C7_FORNECE = A2_COD AND C7_LOJA = A2_LOJA AND SA2.D_E_L_E_T_ = ' ' "
cQuery += "LEFT JOIN "
cQuery +=    RetSqlName("SA4") + " AS SA4 ON A4_FILIAL = '" + xFilial("SA4") + "' AND C7_ZZTRANS = A4_COD AND SA4.D_E_L_E_T_ = ' ' "
cQuery += "LEFT JOIN "
cQuery +=    RetSqlName("SE4") + " AS SE4 ON E4_FILIAL = '" + xFilial("SE4") + "' AND C7_COND = E4_CODIGO AND SE4.D_E_L_E_T_ = ' ' "
cQuery += "LEFT JOIN "
cQuery +=    RetSqlName("CTT") + " AS CTT ON CTT_FILIAL = '" + xFilial("CTT") + "' AND C7_CC = CTT_CUSTO AND CTT.D_E_L_E_T_ = ' ' "
cQuery += "WHERE "
cQuery +=    "C7_FILIAL = '" + xFilial("SC7") + "' "
If !lAuto
	cQuery +=    "AND C7_NUM BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "' "
	If !Empty(mv_par03) .AND. !Empty(mv_par04)
		cQuery +=    "AND C7_EMISSAO BETWEEN '" + DtoS(mv_par03) + "' AND '" + DtoS(mv_par04) + "' "
	EndIf
	cQuery +=    "AND C7_PRODUTO BETWEEN '" + mv_par05 + "' AND '" + mv_par06 + "' "
Else
	cQuery +=    "AND C7_NUM = '" + cPedNum + "' "
Endif
cQuery +=    "AND SC7.D_E_L_E_T_ = ' ' "
cQuery += "ORDER BY C7_NUM, C7_ITEM "

TCQUERY cQuery NEW ALIAS "cAlias"

TCSETFIELD("cAlias","C7_EMISSAO","D",08,00)
TCSETFIELD("cAlias","C7_DATPRF","D",08,00)
TCSETFIELD("cAlias","C7_ZZVALID","D",08,00)  

Count to nCount

cAlias->(dbgotop())

If 	cAlias->(EOF())
	MsgSTOP(cMens)
	cAlias->(dbCloseArea())
Else
	Do While  cAlias->(!Eof())
		cNPc 		:= cAlias->C7_NUM
		cEmissao	:= cAlias->C7_EMISSAO
		cCond       := cAlias->C7_COND
		cTpFrete	:= cAlias->C7_TPFRETE
		cE4Desc		:= cAlias->E4_DESCRI
		cValid		:= cAlias->C7_ZZVALID
		cDesc1		:= cAlias->C7_DESC1
		cDesc2 		:= cAlias->C7_DESC2
		cDesc3		:= cAlias->C7_DESC3
		cTrans		:= cAlias->C7_ZZTRANS
		cNTran		:= cAlias->A4_NOME
		cFornece	:= cAlias->A2_COD
		cLoja		:= cAlias->A2_LOJA
		cNomeFor	:= cAlias->A2_NREDUZ
		
		//Incluso tratamento com variavel cEmail para pegar os contatos atraves da tabela SA2
		cEmailFor 	:= Alltrim(cAlias->A2_EMAIL)
		
		cHtml   := '<body>'
		
		cHtml   += '<table width="100%" border="0">'
		cHtml   += '<tr>'
		cHtml   += '	<td width="53%" height="99"><div align="left"><img src="'+cLogoMail+'" width="252" height="88"></div></td>'
		cHtml   += '	<td width="47%"><div align="left"><p><font size="2" face="Arial, Helvetica, sans-serif"><strong>'+ RTrim(SM0->M0_NOMECOM)+ '<br>'
		cHtml   +=  AllTrim(SM0->M0_ENDENT) + ' ' + AllTrim(SM0->M0_CIDENT) + '/' + AllTrim(SM0->M0_ESTENT) + ' ' + LEFT(AllTrim(SM0->M0_CEPENT),5) + '-' + RIGHT(AllTrim(SM0->M0_CEPENT),3) + '<br>'
		
		cHtml   += '	E-mail: ' + Alltrim(cEmailCab) + '<br>'
		
		cHtml   += '	Fone: '+AllTrim(SM0->M0_TEL) + ' FAX: ' + AllTrim(SM0->M0_FAX)+'<br>'
		cHtml   += ' 	CNPJ: '+ AllTrim(Transform(SM0->M0_CGC, "@R 99.999.999/9999-99")) + ' - IE: ' +  AllTrim(Transform(SM0->M0_INSC, "@R 999.999.999.999"))+ '</p>'
		cHtml   += '	</strong></font></div></td>'
		cHtml   += '</tr>'
		cHtml   += '</table>'
		
		cHtml   += '<hr> '
		cHtml   += '<table width="100%" border="0">'
		cHtml   += ' <tr>'
		cHtml   += '   <td><font size="3" face="Arial, Helvetica, sans-serif"><strong>Pedido de Compra N° '+cNPc+'</strong></font></td>'
		cHtml   += '   <td><div align="right"><font size="3" face="Arial, Helvetica, sans-serif"><strong>Data: ' + DTOC(cEMISSAO)+ '</strong></font></div></td>'
		cHtml   += ' </tr>'
		cHtml   += '</table>'
		cHtml   += '<hr>'
		
		cHtml   += '<table width="100%" border="0"> '
		cHtml   += '  <tr>'
		cHtml   += '    <td width="12%"><font size="2" face="Arial, Helvetica, sans-serif"><strong>Fornecedor:</strong></font></td>'
		cHtml   += '    <td width="39%"><font size="2" face="Arial, Helvetica, sans-serif">'+ cAlias->A2_COD + " - " + cAlias->A2_NOME+'</font></td>'
		cHtml   += '    <td width="9%"><font size="2" face="Arial, Helvetica, sans-serif">&nbsp;</font></td>'
		cHtml   += '    <td width="40%">&nbsp;</td>'
		cHtml   += '  </tr>'
		cHtml   += '  <tr>'
		cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif"><strong>E-Mail:</strong></font></td>'
		cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">'+cAlias->A2_EMAIL+'</font></td>'
		cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif"><strong>Contato:</strong></font></td>'
		cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">'+cAlias->A2_CONTATO+'</font></td>'
		cHtml   += '  </tr>'
		cHtml   += '  <tr>'
		cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif"><strong>Endereço:</strong></font></td>'
		cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">'+cAlias->A2_END+'</font></td>'
		cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif"><strong>Bairro:</strong></font></td>'
		cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">'+cAlias->A2_BAIRRO+'</font></td>'
		cHtml   += '  </tr>'
		cHtml   += '  <tr>'
		cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif"><strong>Cidade:</strong></font></td>'
		cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">'+AllTrim(cAlias->A2_MUN)+"/"+cAlias->A2_EST+'</font></td>'
		cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif"><strong>Cep:</strong></font></td>'
		cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">'+LEFT(cAlias->A2_CEP,5) + "-" + RIGHT(cAlias->A2_CEP,3)+'</font></td>'
		cHtml   += '  </tr>'
		cHtml   += '  <tr>'
		cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif"><strong>Tel:</strong></font></td>'
		cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">(' + cAlias->A2_DDD + ') ' + LEFT(cAlias->A2_TEL,4) + '-' + SUBSTR(cAlias->A2_TEL,5,8)+'</font></td>'
		cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif"><strong>FAX:</strong></font></td>'
		cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">(' + cAlias->A2_DDD + ') ' + LEFT(cAlias->A2_FAX,4) + '-' + SUBSTR(cAlias->A2_FAX,5,8)+'</font></td>'
		cHtml   += '  </tr>'
		cHtml   += '  <tr>'
		
		If Len(ALLTRIM(cAlias->A2_CGC)) > 11
			cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif"><strong>CNPJ:</strong></font></td>'
			cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">' + AllTrim(Transform(cAlias->A2_CGC,"@R 99.999.999/9999-99")) + '</font></td>'
		Else
			cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif"><strong>CPF:</strong></font></td>'
			cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">' + AllTrim(Transform(cAlias->A2_CGC,"@R 999.999.999-99")) + '</font></td>'
		EndIf
		cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif"><strong>IE:</strong></font></td>'
		If Len(ALLTRIM(cAlias->A2_INSCR)) > 6
			cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">' + AllTrim(Transform(cAlias->A2_INSCR,"@R 999.999.999.999")) + '</font></td>'
		Else
			cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">' + AllTrim(cAlias->A2_INSCR) + '</font></td>'
		EndIF
		cHtml   += '  </tr>'
		cHtml   += '  <tr>'
		cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif"><strong>Site:</strong></font></td>'
		cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">' + cAlias->A2_HPAGE + '</font></td>'
		cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif"><strong>&nbsp;</strong></font></td>'
		cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">&nbsp;</font></td>'
		cHtml   += '  </tr>'
		cHtml   += '</table>'
		cHtml   += '	<table width="100%" border="1">'
		cHtml   += '<tr>'
		cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif"><strong>Item</strong></font></td>'
		cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif"><strong>Produto</strong></font></td>'
		cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif"><strong>Descrição</strong></font></td>'
		cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif"><strong>UM</strong></font></td>'
		cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif"><strong>Qtde.</strong></font></td>'
		cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif"><strong>Valor Unit.</strong></font></td>'
		cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif"><strong>Valor Total</strong></font></td>'
		cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif"><strong>%IPI</strong></font></td>'
		cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif"><strong>Entrega</strong></font></td>'
		cHtml   += '  </tr>'
		
		nTotal:=0
		
		While cNPc == cAlias->C7_NUM
			
			cHtml   += '  <tr>'
			cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">'+Ltrim(cAlias->C7_ITEM)+'</font></td>'
			cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">'+Ltrim(cAlias->C7_PRODUTO)+'</font></td>'
			cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">'+Ltrim(cAlias->C7_DESCRI)+'</font></td>'
			cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">'+LTrim(cAlias->C7_UM)+'</font></td>'
			cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">'+Alltrim(STR(cAlias->C7_QUANT))+'</font></td>'
			cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">'+Alltrim(Transform(cAlias->C7_PRECO,PesqPict('SC7', 'C7_PRECO')))+'</font></td>'
			cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">'+Alltrim(Transform(cAlias->C7_TOTAL,PesqPict('SC7', 'C7_TOTAL')))+'</font></td>'
			
			dbSelectArea("SF4")
			dbSetOrder(1)
			dbSeek(xFilial("SF4") + cAlias->C7_TES)
			If SF4->F4_IPI == "S"
				cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">'+Alltrim(STR(cAlias->C7_IPI,4,1))+'</font></td>'
			Else
				cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">0.0</font></td>'
			EndIf
			SF4->(dbCloseArea())
			
			//			cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">'+Alltrim(STR(cAlias->C7_IPI,4,1))+'</font></td>'
			cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">'+DTOC(cAlias->C7_DATPRF)+'</font></td>'
			cHtml   += '  </tr>'
			
			nTotal := cAlias->C7_TOTAL + nTotal
			
			nDespesa += cAlias->C7_DESPESA
			
			nFrete += cAlias->C7_VALFRE
			
			cNPc := cAlias->C7_NUM
			
			cAlias->(dbskip())
			
		EndDo
		
		cHtml   += '</table>'
		
		nTotal2 := nTotal + nDespesa + nFrete
		
		cHtml   += '<table width="100%" border="0">'
		
		cHtml   += '<tr>'
		cHtml   += '<td width="18%"><div align="left"><font size="2" face="Arial, Helvetica, sans-serif"><strong>Valor Frete: </strong></font></div></td>'
		cHtml   += '<td width="26%"><div align="right"><font size="2" face="Arial, Helvetica, sans-serif">' + Alltrim(Transform(nFrete,PesqPict('SC7', 'C7_VALFRE'))) + '</font><font size="2" face="Arial, Helvetica, sans-serif">&nbsp;</font></div></td>'
		cHtml   += '<td width="8%">&nbsp;</td>'
		cHtml   += '<td Colspan="2"><div align="left"><font size="2" face="Arial, Helvetica, sans-serif"><strong>Valor Total do Pedido:</strong></font></div></td>'
		cHtml   += '<td width="24%"><div align="right"><font size="2" face="Arial, Helvetica, sans-serif">' + Alltrim(Transform(nTotal,PesqPict('SC7', 'C7_TOTAL'))) + '</font></div></td>'
		cHtml   += '<tr> '
		cHtml   += '<td width="18%"><div align="left"><font size="2" face="Arial, Helvetica, sans-serif"><strong>Valor Despesa:&nbsp;&nbsp;</strong></font></div></td>'
		cHtml   += '<td width="26%"><div align="right"><font size="2" face="Arial, Helvetica, sans-serif">' + Alltrim(Transform(nDespesa,PesqPict('SC7', 'C7_DESPESA'))) + '</font><font size="2" face="Arial, Helvetica, sans-serif">&nbsp;</font></div></td>'
		cHtml   += '<td width="8%">&nbsp;</td>'
		cHtml   += '<td Colspan="2"><div align="left"><font size="2" face="Arial, Helvetica, sans-serif"><strong>Valor Total:</strong></font></div></td>'
		cHtml   += '<td width="24%"><div align="right"><font size="2" face="Arial, Helvetica, sans-serif">' + Alltrim(Transform(nTotal2,PesqPict('SC7', 'C7_TOTAL'))) + '</font></div></td>'
		
		cHtml   += '</table>'
		
		cHtml   += '<hr>  '
		cHtml   += '<table width="100%" border="0">'
		cHtml   += '  <tr> '
		cHtml   += '    <td colspan="2"><div align="center"><strong><font size="3" face="Arial, Helvetica, sans-serif">Informações Gerais</font></strong></div></td> '
		cHtml   += '  </tr>'
		cHtml   += '  <tr>'
		cHtml   += '    <td width="20%"><p><strong><font size="2" face="Arial, Helvetica, sans-serif">Forma de Pagamento:</font></strong></p></td>'
		cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">'+ cCond + ' - ' + cE4Desc +'</font></td>'
		cHtml   += '  </tr>'
		cHtml   += '    <td width="20%"><strong><font size="2" face="Arial, Helvetica, sans-serif">Tipo de Frete:</font></strong></td>'
		If AllTrim(cTpFrete) = "C"
			cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">CIF</font></td> '
		Else
			cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">FOB</font></td> '
		EndIf
		cHtml   += '  </tr>'
		cHtml   += '  <tr>'
		cHtml   += '    <td width="20%"><p><strong><font size="2" face="Arial, Helvetica, sans-serif">Validade:</font></strong></p></td>'
		cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">'+ DTOC(cValid) +'</font></td>'
		cHtml   += '  </tr>'
		cHtml   += '  <tr> '
		cHtml   += '    <td width="20%"><strong><font size="2" face="Arial, Helvetica, sans-serif">Descontos %:</font></strong></td>'
		cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">'+AllTrim(TRANSFORM(cDesc1,PesqPict('SC7', 'C7_DESC1'))) + ' + ' + AllTrim(TRANSFORM(cDesc2,PesqPict('SC7', 'C7_DESC2'))) + ' + ' + AllTrim(TRANSFORM(cDesc3,PesqPict('SC7', 'C7_DESC3')))+'</font></td> '
		cHtml   += '  </tr>'
		cHtml   += '  <tr> '
		cHtml   += '    <td width="20%"><strong><font size="2" face="Arial, Helvetica, sans-serif">Transportadora:</font></strong></td>'
		cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">(' + cTrans +') ' + cNTran + '</font></td> '
		cHtml   += '  </tr>'
		cHtml   += '  <tr>'
		cHtml   += '</table>'
		cHtml   += '<hr>
		
		cEmail := U_SU5COM(cNPC,cFornece,cLoja)
		If Empty(cEmail)
			cEmail := Alltrim(cEmailFor)
		Endif
		
		cMailDig := PADR(cEmail,255)
		
		Define MsDialog oDL Title "E-mail do Fornecedor " + cNomeFor From 0, 0 To 70, 330 Pixel Style 128
		oDL:lEscClose := .f.
		Define Font oBold Name "Arial" Size 0, -13 Bold
		@ 000, 000 Bitmap oBmp ResName "LOGIN" Of oDL Size 30, 120 NoBorder When .f. Pixel
		@ 003,040 Say "E-Mail: " Font oBold Pixel
		@ 014, 030 To 016, 400 Label '' Of oDL  Pixel
		@ 003,070 MsGet oEndMa Var cMailDig Size 090,008 Pixel
		@ 020, 120 Button "Confirmar" Size 40, 13 Pixel Of oDL Action oDL:End()
		Activate MsDialog oDL Centered
		
		//cEmail := IIF(!Empty(cMailDig), cEmail + ";" + cMailDig, cEmail) //Corrigido por Carlos Niemeyer - FSW - Totvs RP - 23/11/2011
		cEmail := AllTrim(cMailDig)
		
		//Funcao SendLog(cAssunto,cBody,cEmail,cEmailCC,cEmailBCC,cAnexo) -> lRet. Criada por Carlos H. Oliveira - FSW - Totvs RP - 08/08/2012
		lEnvio := SendLog(cAssunto,cHtml,cEmail)
		
		If lEnvio
			MsgInfo("Relatório de Pedido " + cNPc + " Enviado com Sucesso para '" + AllTrim(cEmail) + "'.","Envio de E-mail")
		Else
			MsgInfo("O relatório de pedido de compras não pode ser enviado!","Envio de E-mail")
		EndIf
	EndDo
	cAlias->(dbCloseArea())
EndIF

Return .T.

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SendLog    ºAutor  ³Carlos H. Oliveira º Data ³  08/08/2012 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³função auxiliar para envio de e-mail                        º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³MP11 - TOP                                                  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function SendLog(cAssunto,cBody,cEmail,cEmailCC,cEmailBCC,cAnexo)
Local oServer 	:= Nil
Local oMessage  := Nil
Local cFrom		:= AllTrim(GetMV("MV_RELFROM")) //RetEmailUsr()                // Email do Remetente "carlos.niemeyer@totvs.com.br"
Local cSMTPAddr := AllTrim(GetMV("MV_RELSERV")) // Endereco do servidor SMTP "mail.totvs.com.br"
Local nSMTPPort := GetMV("MV_PORSMTP")          // Porta do servidor SMTP 587
Local cUser     := AllTrim(GetMV("MV_RELACNT")) // Usuario que ira realizar a autenticacao "carlos.niemeyer"
Local cPass     := AllTrim(GetMV("MV_RELAPSW")) // Senha do usuario
Local nSMTPTime := GetMV("MV_RELTIME") 			// Timeout SMTP 60
Local UseSSL	:= GetMV("MV_RELSSL")			// Usa SSL .F.
Local UseTLS	:= GetMV("MV_RELTLS")			// Usa TLS .T.
Local lAuth		:= GetMV("MV_RELAUTH")			// Autentica Email .T.
Local lRet      := .F.                          // Variável lógica de retorno da funcao

Default cAssunto	:= ""
Default cBody		:= ""
Default cEmail		:= ""
Default cEmailCC	:= ""
Default cEmailBCC	:= ""
Default cAnexo		:= ""

If !Empty(cAssunto) .And. !Empty(cBody)
	
	//Cria o Objeto para Envio de Emails
	oServer := tMailManager():NEW()
	
	//Define Propriedades Adicionais de Conexão
	oServer:setUseSSL(UseSSL)	//Usa SSL na conexao
	oServer:setUseTLS(UseTLS)	//Usa TLS na conexao
	
	//Inicializa o Servidor de Conexão SMTP
	oServer:Init("", cSMTPAddr, cUser, cPass , 0 , nSMTPPort)
	
	//Define o TimeOut
	If nSMTPTime > 0
		CONOUT("[TIMEOUT] ENABLE()")
		nRet := oServer:SetSmtpTimeOut( nSMTPTime )
		If nRet <> 0
			CONOUT("[TIMEOUT] Fail to set")
			CONOUT("[TIMEOUT][ERROR] " + str(nRet,6) , oServer:GetErrorString(nRet))
			Return lRet
		EndIf
	Else
		CONOUT("[TIMEOUT] DISABLE")
	EndIf
	
	//Realiza a conexão SMTP
	CONOUT( "[SMTPCONNECT] connecting ..." )
	nRet := oServer:SmtpConnect()
	If nRet <> 0
		CONOUT("[SMTPCONNECT] Fail to connect" )
		CONOUT("[SMTPCONNECT][ERROR] " + str(nRet,6) , oServer:GetErrorString(nRet))
		Return lRet
	Else
		CONOUT( "[SMTPCONNECT] Sucess ao conectar" )
	EndIf
	
	If lAuth
		CONOUT("[AUTH] ENABLE")
		CONOUT("[AUTH] TRY with ACCOUNT() and PASS()")			// try with account and pass
		nRet := oServer:SMTPAuth(cUser, cPass)
		If nRet <> 0
			CONOUT("[AUTH] FAIL TRY with USER() and PASS()")
			CONOUT("[AUTH][ERROR] " + str(nRet,6) , oServer:GetErrorString(nRet))
			Return lRet
		Else
			CONOUT("[AUTH] SUCEEDED TRY with USER() and PASS()")
		EndIf
	Else
		CONOUT("[AUTH] DISABLE")
	EndIf
	
	//Apos a conexão, cria o objeto da mensagem
	CONOUT("[MESSAGE] Criando mensagem do email")
	oMessage := TMailMessage():New()
	
	//Limpa o objeto
	oMessage:Clear()
	
	//Popula com os dados de envio
	oMessage:cFrom 		:= cFrom
	oMessage:cTo 		:= cEmail
	oMessage:cCc 		:= cEmailCC
	oMessage:cBcc 		:= cEmailBCC
	oMessage:cSubject 	:= cAssunto
	oMessage:cBody 		:= cBody
	oMessage:MsgBodyType("text/html")
	
	//Adiciona um anexo (Se Houver)
	If !Empty(cAnexo)
		If oMessage:AttachFile( cAnexo ) < 0 //Arquivo Precisa estar dentro do Protheus_Data
			CONOUT( "Erro ao anexar o arquivo" )
			Return lRet
		Else
			//adiciona uma tag informando que é um anexo e o nome do arq
			oMessage:AddAtthTag( "Content-Disposition: attachment; filename=" + cAnexo )
		EndIf
	EndIf
	
	//Adiciona um anexo, nesse caso a imagem esta no root
	//oMessage:AttachFile( '\siga.jpg' )
	
	//Essa tag, é a referecia para o arquivo ser mostrado no corpo, o nome declarado nela deve ser o usado no HTML
	//oMessage:AddAttHTag( 'Content-ID: <ID_siga.jpg>' )
	
	// Para solicitar confimação de envio
	//oMessage:SetConfirmRead( .T. )
	
	CONOUT("[SEND] Sending ...")
	nRet := oMessage:Send( oServer )
	If nRet <> 0
		CONOUT("[SEND] Fail to send message" )
		CONOUT("[SEND][ERROR] " + str(nRet,6) , oServer:GetErrorString(nRet))
		Return lRet
	Else
		CONOUT( "[SEND] Sucess to send message" )
	EndIf
	
	CONOUT("[DISCONNECT] smtp disconnecting ... ")
	nRet := oServer:SmtpDisconnect()
	If nRet <> 0
		CONOUT("[DISCONNECT] Fail smtp disconnecting ... ")
		CONOUT("[DISCONNECT][ERROR] " + str(nRet,6) , oServer:GetErrorString(nRet))
		Return lRet
	Else
		CONOUT("[DISCONNECT] Sucess smtp disconnecting ... ")
	EndIf
	lRet := .T.
EndIf

Return lRet

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
Local aRegs   := {}       
Local cSeq    := "01"
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)
//cPerg := PADR(cPerg,6)
cPerg := PADR(cPerg,Len(SX1->X1_GRUPO))

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
aAdd(aRegs, {cPerg, "01", "Pedido de "        			,"" ,"" ,"mv_ch1", "C", 06, 0, 0, "G", "", "mv_par01", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SC7"})
aAdd(aRegs, {cPerg, "02", "Pedido até "        			,"" ,"" ,"mv_ch2", "C", 06, 0, 0, "G", "", "mv_par02", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SC7"})
aAdd(aRegs, {cPerg, "03", "Data de "        			,"" ,"" ,"mv_ch3", "D", 08, 0, 0, "G", "", "mv_par03", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""})
aAdd(aRegs, {cPerg, "04", "Data até "        			,"" ,"" ,"mv_ch4", "D", 08, 0, 0, "G", "", "mv_par04", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""})
aAdd(aRegs, {cPerg, "05", "Produto de "     			,"" ,"" ,"mv_ch5", "C", 06, 0, 0, "G", "", "mv_par05", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SB1"})
aAdd(aRegs, {cPerg, "06", "Produto até "     			,"" ,"" ,"mv_ch6", "C", 06, 0, 0, "G", "", "mv_par06", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SB1"})
aAdd(aRegs, {cPerg, "07", "Fornecedor de "     			,"" ,"" ,"mv_ch7", "C", 06, 0, 0, "G", "", "mv_par07", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SA2"})
aAdd(aRegs, {cPerg, "08", "Loja de "     				,"" ,"" ,"mv_ch8", "C", 02, 0, 0, "G", "", "mv_par08", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""})
aAdd(aRegs, {cPerg, "09", "Fornecedor até "     		,"" ,"" ,"mv_ch9", "C", 06, 0, 0, "G", "", "mv_par09", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SA2"})
aAdd(aRegs, {cPerg, "10", "Loja até "     				,"" ,"" ,"mv_chA", "C", 02, 0, 0, "G", "", "mv_par10", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""})

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

cKey     := "P."+AllTrim(cPerg)+cSeq+"."
aHelpEng := {}
aHelpPor := {}
aHelpSpa := {}      
cSeq     := StrZero(Val(cSeq)+1,2,0)
aAdd(aHelpEng,"")
aAdd(aHelpEng,"")
aAdd(aHelpPor,"Informe ou selecione o código")
aAdd(aHelpPor,"de pedido inicial para filtro dos") 
aAdd(aHelpPor,"dados. Tecla[F3] disponível para")   
aAdd(aHelpPor,"efetuar a busca do pedido.")
aAdd(aHelpSpa,"")
aAdd(aHelpSpa,"")
PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)  

cKey     := "P."+AllTrim(cPerg)+cSeq+"."
aHelpEng := {}
aHelpPor := {}
aHelpSpa := {}      
cSeq     := StrZero(Val(cSeq)+1,2,0)
aAdd(aHelpEng,"")
aAdd(aHelpEng,"")
aAdd(aHelpPor,"Informe ou selecione o código")
aAdd(aHelpPor,"de pedido final para filtro dos") 
aAdd(aHelpPor,"dados. Tecla[F3] disponível para")   
aAdd(aHelpPor,"efetuar a busca do pedido")
aAdd(aHelpSpa,"")
aAdd(aHelpSpa,"")
PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)   

cKey     := "P."+AllTrim(cPerg)+cSeq+"."
aHelpEng := {}
aHelpPor := {}
aHelpSpa := {}      
cSeq     := StrZero(Val(cSeq)+1,2,0)
aAdd(aHelpEng,"")
aAdd(aHelpEng,"")
aAdd(aHelpPor,"Informe ou selecione a data")
aAdd(aHelpPor,"inicial da cotação para filtro") 
aAdd(aHelpPor,"dos dados.")   
aAdd(aHelpSpa,"")
aAdd(aHelpSpa,"")
PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

cKey     := "P."+AllTrim(cPerg)+cSeq+"."
aHelpEng := {}
aHelpPor := {}
aHelpSpa := {}      
cSeq     := StrZero(Val(cSeq)+1,2,0)
aAdd(aHelpEng,"")
aAdd(aHelpEng,"")
aAdd(aHelpPor,"Informe ou selecione a data")
aAdd(aHelpPor,"final da cotação para filtro") 
aAdd(aHelpPor,"dos dados.") 
aAdd(aHelpSpa,"")
aAdd(aHelpSpa,"")
PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)        

cKey     := "P."+AllTrim(cPerg)+cSeq+"."
aHelpEng := {}
aHelpPor := {}
aHelpSpa := {}      
cSeq     := StrZero(Val(cSeq)+1,2,0)
aAdd(aHelpEng,"")
aAdd(aHelpEng,"")
aAdd(aHelpPor,"Informe ou selecione o código")
aAdd(aHelpPor,"do produto inicial para filtro") 
aAdd(aHelpPor,"dos dados. Tecla [F3] disponível")
aAdd(aHelpPor,"para efetuar a busca do produto.")  
aAdd(aHelpSpa,"")
aAdd(aHelpSpa,"")
PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

cKey     := "P."+AllTrim(cPerg)+cSeq+"."
aHelpEng := {}
aHelpPor := {}
aHelpSpa := {}      
cSeq     := StrZero(Val(cSeq)+1,2,0)
aAdd(aHelpEng,"")
aAdd(aHelpEng,"")
aAdd(aHelpPor,"Informe ou selecione o código")
aAdd(aHelpPor,"do produto final para filtro") 
aAdd(aHelpPor,"dos dados. Tecla [F3] disponível")
aAdd(aHelpPor,"para efetuar a busca do produto.")  
aAdd(aHelpSpa,"")
aAdd(aHelpSpa,"")
PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa) 

cKey     := "P."+AllTrim(cPerg)+cSeq+"."
aHelpEng := {}
aHelpPor := {}
aHelpSpa := {}      
cSeq     := StrZero(Val(cSeq)+1,2,0)
aAdd(aHelpEng,"")
aAdd(aHelpEng,"")
aAdd(aHelpPor,"Informe ou selecione o código")
aAdd(aHelpPor,"do fornecedor inicial para filtro") 
aAdd(aHelpPor,"dos dados. Tecla [F3] disponível")
aAdd(aHelpPor,"para efetuar a busca do fornecedor.")  
aAdd(aHelpSpa,"")
aAdd(aHelpSpa,"")
PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

cKey     := "P."+AllTrim(cPerg)+cSeq+"."
aHelpEng := {}
aHelpPor := {}
aHelpSpa := {}      
cSeq     := StrZero(Val(cSeq)+1,2,0)
aAdd(aHelpEng,"")
aAdd(aHelpEng,"")
aAdd(aHelpPor,"Informe o código inicial do")
aAdd(aHelpPor,"intervalo de lojas para filtro") 
aAdd(aHelpPor,"dos dados.")  
aAdd(aHelpSpa,"")
aAdd(aHelpSpa,"")
PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

cKey     := "P."+AllTrim(cPerg)+cSeq+"."
aHelpEng := {}
aHelpPor := {}
aHelpSpa := {}      
cSeq     := StrZero(Val(cSeq)+1,2,0)
aAdd(aHelpEng,"")
aAdd(aHelpEng,"")
aAdd(aHelpPor,"Informe ou selecione o código")
aAdd(aHelpPor,"do fornecedor final para filtro") 
aAdd(aHelpPor,"dos dados. Tecla [F3] disponível")
aAdd(aHelpPor,"para efetuar a busca do fornecedor.")
aAdd(aHelpSpa,"")
aAdd(aHelpSpa,"")
PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

cKey     := "P."+AllTrim(cPerg)+cSeq+"."
aHelpEng := {}
aHelpPor := {}
aHelpSpa := {}      
cSeq     := StrZero(Val(cSeq)+1,2,0)
aAdd(aHelpEng,"")
aAdd(aHelpEng,"")
aAdd(aHelpPor,"Informe o código final do")
aAdd(aHelpPor,"intervalo de lojas para filtro") 
aAdd(aHelpPor,"dos dados.")    
aAdd(aHelpSpa,"")
aAdd(aHelpSpa,"")
PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)
  
Return .T.

//Retorna o Email do Usuário Logado ou informado
Static Function  RetEmailUsr(cCodUser)
Local aDadUser	:= {}
Local cEmail	:= ""

Default cCodUser := RetCodUsr()

PswOrder(1)
If PswSeek(cCodUser, .T.)
	aDadUser:= PswRet(1)
	cEmail	:= Alltrim(aDadUser[1, 14])	// E-mail do Usuario
Endif

Return (cEmail)