#INCLUDE "protheus.ch"
#INCLUDE "colors.ch"
#INCLUDE "font.ch"
#INCLUDE "topconn.ch"  
#INCLUDE "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AIMAILM    ºAutor  ³Hermes Vieira Jr	 º Data ³  16/06/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Relatorio de Pedido de Venda / Orçamento / Despacho PV      º±±
±±           ³chamado via menu para envio via E-mail.                     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³MP8 - TOP                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function MSRCOTHT(lAuto,cNum)

Local lEnvio	 := .F. && Retorno para envio de e-mail
Local cAssunto 	 := "Relatório de Cotação"
Local cMens 	 := "Não há registros para os parametros informados !!"  
Local cEmail     := ""  
Local cMailDig   := Space(255)  
Local nLastKey	 := 0         
Local nCount	 := 0  
Local nTotal     := 0
Local nTotal2    := 0
Local nFrete     := 0
Local nDespesa   := 0
Local cEmailCab	 := RetEmailUsr(__cuserid)
Local cEmailFor	 := "" 
Local cEmail	 := "" 
Local oMailServer:= Nil
Local oMessage	 := Nil
Local nErr		 := 0
Local cPerg		 := "PERCOT"  
Local cLogoMail	 := AllTrim(GETMV("ZZ_LOGOEXT"))    
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
Default cNum  	 := ""

&& Faz a chamada do grupo de perguntas, caso a chamada seja feita a partir do menu
ValidPerg(cPerg)

If lAuto
	If !IsInCallStack("U_MSRCOTGF") //Somente se não tiver sido chamado pela rotina - Considera os mesmos parâmetros
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
	Endif
Else
	If !(Pergunte(cPerg,.T.))
		Return
	EndIf 
EndIf
 	
If lastKey() == 27 .or. nLastKey == 27 .or. nLastKey == 286
	return
EndIf
     
&& Query que retorna os dados do pedido de compra e os dados dos itens.
cQuery := "SELECT "
cQuery += "  	C8_EMISSAO,C8_NUM,C8_DATPRF,C8_ITEM,C8_PRODUTO,C8_UM,C8_QUANT,C8_ALIIPI,C8_PRECO,C8_NUMSC,C8_ITEMSC, "
cQuery += "  	C8_TOTAL,C8_VALIPI,C8_VALFRE,C8_SEGURO,C8_VALICM,C8_DESPESA,C8_VLDESC,C8_TPFRETE,C8_TES, "
cQuery += "  	C8_OBS,C8_MSG,C8_DESC1,C8_DESC2,C8_DESC3,C8_COND,C8_VALFRE,C8_VALIDA,C8_ZZTRANS, "
cQuery += "  	C8_FORNECE, C8_LOJA, "
cQuery += "  	A2_COD, A2_HPAGE, A2_NOME,A2_END,A2_CEP,A2_DDD,A2_TEL,A2_FAX,A2_EMAIL,A2_CGC,A2_INSCR, "
cQuery += "  	A2_MUN, A2_EST, A2_CONTATO, A2_BAIRRO, A2_NREDUZ, "	
cQuery += "  	E4_DESCRI, "
cQuery += "  	A4_NOME " 
cQuery += "FROM " + RetSQLName("SC8") + " AS SC8 " 
cQuery += "INNER JOIN " + RetSQLName("SA2") + " AS SA2 ON A2_FILIAL = '" + xFilial("SA2") + "' AND C8_FORNECE = A2_COD AND C8_LOJA = A2_LOJA AND SA2.D_E_L_E_T_ = ' ' " 
cQuery += "LEFT JOIN " + RetSQLName("SA4") + " AS SA4 ON A4_FILIAL = '" + xFilial("SA4") + "' AND C8_ZZTRANS = A4_COD AND SA4.D_E_L_E_T_ = ' ' " 
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
	
TCQUERY cQuery NEW ALIAS "cAlias"

TCSETFIELD("cAlias","C8_EMISSAO","D",08,00)
TCSETFIELD("cAlias","C8_DATPRF","D",08,00)  
TCSETFIELD("cAlias","C8_VALIDA","D",08,00)  

Count to nCount      

cAlias->(dbgotop()) 
		
If 	cAlias->(EOF())
	MsgSTOP(cMens)
	cAlias->(dbCloseArea())
Else
	While  cAlias->(!Eof())
		cNPc 		:= cAlias->C8_NUM
		cEmissao	:= cAlias->C8_EMISSAO 
		cCond		:= cAlias->C8_COND
		cTpFrete	:= cAlias->C8_TPFRETE
		cE4Desc		:= cAlias->E4_DESCRI
		cValid		:= cAlias->C8_VALIDA
		cDesc1		:= cAlias->C8_DESC1
		cDesc2 		:= cAlias->C8_DESC2
		cDesc3		:= cAlias->C8_DESC3
		cTrans		:= cAlias->C8_ZZTRANS
		cNTran		:= cAlias->A4_NOME
		cFornece 	:= cAlias->C8_FORNECE
		cLoja 		:= cAlias->C8_LOJA
		cEmissao	:= cAlias->C8_EMISSAO
		cNomeFor	:= cAlias->A2_NREDUZ
		
		//Incluso tratamento com variavel cEmail para pegar os contatos atraves da tabela SA2
		cEmailFor	:= Alltrim(cAlias->A2_EMAIL)

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
   		cHtml   += '   <td><font size="3" face="Arial, Helvetica, sans-serif"><strong>Cotação N° '+cNPc+'</strong></font></td>'
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
	    EndIf
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
			
		While cNPc == cAlias->C8_NUM  .AND. cAlias->C8_FORNECE == cFornece .AND. cAlias->C8_LOJA == cLoja
			
			cDescr	:= POSICIONE("SC1",1,XFILIAL("SC1")+cAlias->C8_NUMSC+cAlias->C8_ITEMSC,"C1_DESCRI")
			cHtml   += '  <tr>' 
			cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">'+Ltrim(cAlias->C8_ITEM)+'</font></td>'
			cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">'+Ltrim(cAlias->C8_PRODUTO)+'</font></td>'
			cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">'+cDescr+'</font></td>'
			cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">'+LTrim(cAlias->C8_UM)+'</font></td>'
			cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">'+Alltrim(STR(cAlias->C8_QUANT))+'</font></td>'
			cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">'+Alltrim(Transform(cAlias->C8_PRECO, PesqPict('SC8', 'C8_PRECO')))+'</font></td>'
			cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">'+Alltrim(Transform(cAlias->C8_TOTAL, PesqPict('SC8', 'C8_TOTAL')))+'</font></td>'
			
			dbSelectArea("SF4")
			dbSetOrder(1)
			dbSeek(xFilial("SF4") + cAlias->C8_TES)
			If SF4->F4_IPI == "S"
				cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">'+Alltrim(STR(cAlias->C8_ALIIPI,4,1))+'</font></td>'
		    Else
				cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">0.0</font></td>'
		    EndIf
	   		SF4->(dbCloseArea())
			
			cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">'+DTOC(cAlias->C8_DATPRF)+'</font></td>'
			cHtml   += '  </tr>'
			
			nTotal 		:= cAlias->C8_TOTAL + nTotal
			
			nDespesa 	+= cAlias->C8_DESPESA
			
			nFrete 		+= cAlias->C8_VALFRE
			
			cNPc 		:= cAlias->C8_NUM
			
			cFornece 	:= cAlias->C8_FORNECE
		
			cLoja 		:= cAlias->C8_LOJA
			
			cAlias->(dbSkip())
			
		EndDo
		
		cHtml   += '</table>' 
		
		nTotal2 := nTotal + nDespesa + nFrete 
		
		cHtml   += '<table width="100%" border="0">'     
		
		cHtml   += '<tr>' 
    	cHtml   += '<td width="18%"><div align="left"><font size="2" face="Arial, Helvetica, sans-serif"><strong>Valor Frete: </strong></font></div></td>'
    	cHtml   += '<td width="26%"><div align="right"><font size="2" face="Arial, Helvetica, sans-serif">' + Alltrim(Transform(nFrete, PesqPict('SC8', 'C8_VALFRE'))) + '</font><font size="2" face="Arial, Helvetica, sans-serif">&nbsp;</font></div></td>'
    	cHtml   += '<td width="8%">&nbsp;</td>'
    	cHtml   += '<td Colspan="2"><div align="left"><font size="2" face="Arial, Helvetica, sans-serif"><strong>Valor Total da Cotação:</strong></font></div></td>'
    	cHtml   += '<td width="24%"><div align="right"><font size="2" face="Arial, Helvetica, sans-serif">' + Alltrim(Transform(nTotal, PesqPict('SC8', 'C8_PRECO'))) + '</font></div></td>'
		cHtml   += '<tr> '
    	cHtml   += '<td width="18%"><div align="left"><font size="2" face="Arial, Helvetica, sans-serif"><strong>Valor Despesa:&nbsp;&nbsp;</strong></font></div></td>'
    	cHtml   += '<td width="26%"><div align="right"><font size="2" face="Arial, Helvetica, sans-serif">' + Alltrim(Transform(nDespesa, PesqPict('SC8', 'C8_DESPESA'))) + '</font><font size="2" face="Arial, Helvetica, sans-serif">&nbsp;</font></div></td>'
    	cHtml   += '<td width="8%">&nbsp;</td>'
    	cHtml   += '<td Colspan="2"><div align="left"><font size="2" face="Arial, Helvetica, sans-serif"><strong>Valor Total:</strong></font></div></td>' 
    	cHtml   += '<td width="24%"><div align="right"><font size="2" face="Arial, Helvetica, sans-serif">' + Alltrim(Transform(nTotal2, PesqPict('SC8', 'C8_TOTAL'))) + '</font></div></td>'
		
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
		cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">'+AllTrim(TRANSFORM(cDesc1, PesqPict('SC8', 'C8_DESC1'))) + ' + ' + AllTrim(TRANSFORM(cDesc2, PesqPict('SC8', 'C8_DESC2'))) + ' + ' + AllTrim(TRANSFORM(cDesc3, PesqPict('SC8', 'C8_DESC3')))+'</font></td> '
		cHtml   += '  </tr>'
		cHtml   += '  <tr> '
		cHtml   += '    <td width="20%"><strong><font size="2" face="Arial, Helvetica, sans-serif">Transportadora:</font></strong></td>'
		cHtml   += '    <td><font size="2" face="Arial, Helvetica, sans-serif">(' + cTrans +') ' + cNTran + '</font></td> '
		cHtml   += '  </tr>'
		cHtml   += '  <tr>' 
		cHtml   += '</table>'
		cHtml   += '<hr>'
		
		cEmail := U_SU5COT(cNPC,cFornece,cLoja)   
		
		If Empty(cEmail)
			cEmail := Alltrim(cEmailFor)
		EndIf           
		
		cMailDig := PADR(cEmail,255)
		
		Define MsDialog oDL Title "E-mail do Fornecedor " + cNomeFor From 0, 0 To 70, 330 Pixel Style 128
		oDL:lEscClose := .f.
		Define Font oBold Name "Arial" Size 0, -13 Bold
		@ 000, 000 Bitmap oBmp ResName "LOGIN" Of oDL Size 30, 120 NoBorder When .f. Pixel
		@ 003,040 Say "E-Mail: " Font oBold Pixel
		@ 014, 030 To 016, 400 Label '' Of oDL  Pixel 
		@ 003,070 MsGet oEndMa  		Var cMailDig  					Size 090,008 Pixel //	Valid cMailDig <> Space(60) .AND. "@" $ cEmail 
		@ 020, 120 Button "Confirmar" 		Size 40, 13 Pixel Of oDL Action oDL:End()
		Activate MsDialog oDL Centered
		                                                                            
		//cEmail := cEmail + cMailDig //Corrigido por Carlos Niemeyer - FSW - Totvs RP - 23/11/2011
		cEmail := AllTrim(cMailDig)
		
		//Funcao SendLog(cAssunto,cBody,cEmail,cEmailCC,cEmailBCC,cAnexo,cFrom) -> lRet. Criada por Carlos H. Oliveira - FSW - Totvs RP - 08/08/2012
		lEnvio := SendLog(cAssunto,cHtml,cEmail,,,,cEmailCab)
		
		If lEnvio		
			MsgInfo("Relatório de Cotação " + cNPc + " Enviado com Sucesso para '" + AllTrim(cEmail) + "'.","Envio de E-mail")
		Else
			MsgInfo("O relatório de cotação não pode ser enviado!","Envio de E-mail")    
		EndIf     
	EndDo 
	cAlias->(dbCloseArea())
EndIf	

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
Static Function SendLog(cAssunto,cBody,cEmail,cEmailCC,cEmailBCC,cAnexo,cFrom)
Local oServer 	:= Nil
Local oMessage  := Nil 
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
Default cFrom		:= AllTrim(GetMV("MV_RELFROM")) //RetEmailUsr() // Email do Remetente "carlos.niemeyer@totvs.com.br"   

If Empty(cFrom) //Se passado em Branco
	cFrom		:= AllTrim(GetMV("MV_RELFROM"))
Endif

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
cPerg := PADR(cPerg,Len(SX1->X1_GRUPO))

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
aAdd(aRegs, {cPerg, "01", "Cotação de "        			,"" ,"" ,"mv_ch1", "C", 06, 0, 0, "G", "", "mv_par01", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SC8"})
aAdd(aRegs, {cPerg, "02", "Cotação até "        		,"" ,"" ,"mv_ch2", "C", 06, 0, 0, "G", "", "mv_par02", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SC8"})
aAdd(aRegs, {cPerg, "03", "Data de "        			,"" ,"" ,"mv_ch3", "D", 08, 0, 0, "G", "", "mv_par03", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "   "})
aAdd(aRegs, {cPerg, "04", "Data até "        			,"" ,"" ,"mv_ch4", "D", 08, 0, 0, "G", "", "mv_par04", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "   "})
aAdd(aRegs, {cPerg, "05", "Produto de "     			,"" ,"" ,"mv_ch5", "C", 06, 0, 0, "G", "", "mv_par05", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SB1"})
aAdd(aRegs, {cPerg, "06", "Produto até "     			,"" ,"" ,"mv_ch6", "C", 06, 0, 0, "G", "", "mv_par06", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SB1"})

For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			EndIf
		Next
		MsUnlock()
	EndIf
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
aAdd(aHelpPor,"de cotação inicial para filtro dos") 
aAdd(aHelpPor,"dados. Tecla[F3] disponível para")   
aAdd(aHelpPor,"efetuar a busca da cotação")
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
aAdd(aHelpPor,"de cotação final para filtro dos") 
aAdd(aHelpPor,"dados. Tecla[F3] disponível para")   
aAdd(aHelpPor,"efetuar a busca da cotação")
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
  
Return .T.

//Retorna o Email do Usuário Logado ou informado
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