#Include 'Protheus.ch'
#Include 'TOPCONN.CH'

User Function histAtend()
	Local nOpc := 0
	Private aCoBrw1 := {}
	Private aCoBrw2 := {}
	Private aCoBrw3 := {}
	Private aHoBrw1 := {}
	Private aHoBrw2 := {}
	Private aHoBrw3 := {}
	Private oPreto  	:= LoadBitmap( GetResources(), "BR_PRETO")
	Private oAzul	  	:= LoadBitmap( GetResources(), "BR_AZUL")
	Private oAmarelo  	:= LoadBitmap( GetResources(), "BR_AMARELO")
	Private oVermelho	:= LoadBitmap( GetResources(), "BR_VERMELHO")	
	
	/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±± Declaração de Variaveis Private dos Objetos                             ±±
	Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
	SetPrvt("oDlg1","oSay1","oSay2","oSay3","oBrw1","oBtn1","oBrw2","oBrw3")
	
	/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±± Definicao do Dialog e todos os seus componentes.                        ±±
	Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
	oDlg1      := MSDialog():New( 092,232,571,1158,"Histórico",,,.F.,,,,,,.T.,,,.T. )
	oSay1      := TSay():New( 004,004,{||"Produtos:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
	oSay2      := TSay():New( 004,244,{||"Estoque:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
	oSay3      := TSay():New( 076,004,{||"Histórico:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
	MHoBrw1()
	MCoBrw1()
	oBrw1      := MsNewGetDados():New(012,004,072,212,nOpc,'AllwaysTrue()','AllwaysTrue()','',,0,99,'AllwaysTrue()','','AllwaysTrue()',oDlg1,aHoBrw1,aCoBrw1,{||atuProds()} )
		
	MHoBrw2()	
	oBrw2      := MsNewGetDados():New(012,244,072,452,nOpc,'AllwaysTrue()','AllwaysTrue()','',,0,99,'AllwaysTrue()','','AllwaysTrue()',oDlg1,aHoBrw2,aCoBrw2 )
	
	MHoBrw3()
	oBrw3      := MsNewGetDados():New(084,004,208,452,nOpc,'AllwaysTrue()','AllwaysTrue()','',,0,99,'AllwaysTrue()','','AllwaysTrue()',oDlg1,aHoBrw3,aCoBrw3 )
		
	oBtn1      := TButton():New( 216,416,"Sair",oDlg1,{||oDlg1:End()},037,012,,,,.T.,,"",,,,.F. )
	oDlg1:Activate(,,,.T.)

Return

Static Function atuProds()
	MCoBrw2()
	MCoBrw3()
Return

Static Function MCoBrw3()
	Local cQuery	:= ""
	cQuery += "SELECT TOP 10 "+CRLF 
	cQuery += "	UB_NUM AS NUM, "+CRLF 
	cQuery += "	UA_EMISSAO AS EMISSAO, "+CRLF
	cQuery += "	UB_ITEM AS ITEM, "+CRLF
	cQuery += "	UB_PRODUTO AS PRODUTO, "+CRLF 
	cQuery += "	UB_UM AS UM, "+CRLF
	cQuery += "	UB_QUANT AS QUANT, "+CRLF
	cQuery += "	UB_VRUNIT AS VRUNIT, "+CRLF
	cQuery += "	UB_VLRITEM AS VLRITEM, "+CRLF
	cQuery += "	UB_NUMPV AS NUMPV, "+CRLF
	cQuery += "	Z8_ZZDESMT AS MOTIVO, "+CRLF
	cQuery += "	C6_NOTA AS NOTA, "+CRLF
	cQuery += "	C6_DATFAT AS DTFAT "+CRLF
	cQuery += "FROM "+RetSqlName("SUA")+" SUA "+CRLF
	cQuery += "INNER JOIN "+RetSqlName("SUB")+" SUB ON "+CRLF
	cQuery += "	UA_NUM = UB_NUM AND UA_FILIAL = UB_FILIAL --AND SUB.D_E_L_E_T_ = ' ' "+CRLF
	cQuery += "LEFT JOIN "+RetSqlName("SZ8")+" SZ8 ON "+CRLF
	cQuery += "	UB_NUM = Z8_NUM AND UB_ITEM = Z8_ITEM AND UB_FILIAL = Z8_FILIAL "+CRLF
	cQuery += "LEFT JOIN "+RetSqlName("SC6")+" SC6 ON "+CRLF
	cQuery += "	UB_NUMPV = C6_NUM AND UB_ITEMPV = C6_ITEM AND UB_FILIAL = C6_FILIAL "+CRLF
	cQuery += "WHERE --SUA.D_E_L_E_T_ = ' ' "+CRLF
	cQuery += "	UA_FILIAL = '"+xFilial("SUA")+"' "+CRLF
	cQuery += "	AND UA_CLIENTE = '"+M->UA_CLIENTE+"' "+CRLF
	cQuery += "	AND UA_LOJA = '"+M->UA_LOJA+"' "+CRLF
	cQuery += "	AND UB_PRODUTO = '"+aCoBrw1[N][01]+"' "+CRLF
	cQuery += "	AND UA_NUM <> '"+M->UA_NUM+"' "+CRLF
	cQuery += "ORDER BY UA_EMISSAO DESC, UB_NUM, UB_ITEM "+CRLF
	
	TcQuery cQuery New Alias "QREL"
	QREL->(DbGoTop())
	aCoBrw3 := {}		
	While QREL->(!Eof())
		If !empty(QREL->MOTIVO)
			aadd(aCoBrw3,{oPreto,QREL->NUM,DTOC(STOD(QREL->EMISSAO)),QREL->ITEM,QREL->UM,QREL->QUANT,QREL->VRUNIT,QREL->VLRITEM,QREL->NUMPV,QREL->NOTA,DTOC(STOD(QREL->DTFAT)),QREL->MOTIVO,.F.})
		ElseIf empty(QREL->NUMPV)
			aadd(aCoBrw3,{oAzul,QREL->NUM,DTOC(STOD(QREL->EMISSAO)),QREL->ITEM,QREL->UM,QREL->QUANT,QREL->VRUNIT,QREL->VLRITEM,QREL->NUMPV,QREL->NOTA,DTOC(STOD(QREL->DTFAT)),QREL->MOTIVO,.F.})
		ElseIf empty(QREL->NOTA)
			aadd(aCoBrw3,{oAmarelo,QREL->NUM,DTOC(STOD(QREL->EMISSAO)),QREL->ITEM,QREL->UM,QREL->QUANT,QREL->VRUNIT,QREL->VLRITEM,QREL->NUMPV,QREL->NOTA,DTOC(STOD(QREL->DTFAT)),QREL->MOTIVO,.F.})
		Else
			aadd(aCoBrw3,{oVermelho,QREL->NUM,DTOC(STOD(QREL->EMISSAO)),QREL->ITEM,QREL->UM,QREL->QUANT,QREL->VRUNIT,QREL->VLRITEM,QREL->NUMPV,QREL->NOTA,DTOC(STOD(QREL->DTFAT)),QREL->MOTIVO,.F.})
		EndIf		
		QREL->(DbSkip())
	EndDo
	QREL->(dbCloseArea())

	oBrw3:oBrowse:SetArray( aCoBrw3 )
	oBrw3:aCols := aCoBrw3
	oBrw3:oBrowse:Refresh(.T.)	
Return

Static Function MHoBrw3()

	Aadd(aHoBrw3, {;
					"",;//X3Titulo()
					"IMAGEM",;  //X3_CAMPO
					"@BMP",;		//X3_PICTURE
					3,;			//X3_TAMANHO
					0,;			//X3_DECIMAL
					".F.",;			//X3_VALID
					"",;			//X3_USADO
					"C",;			//X3_TIPO
					"",; 			//X3_F3
					"V",;			//X3_CONTEXT
					"",;			//X3_CBOX
					"",;			//X3_RELACAO
					"",;			//X3_WHEN
					"V"})			//
					
	Aadd(aHoBrw3,{"COTACAO",;
	           "UB_NUM",;
	           pesqPict("SUB","UB_NUM"),;
	           10,;
	           tamSX3("UB_NUM")[2],;
	           "",;
	           "",;
	           "C",;
	           "",;
	           "" } )
	Aadd(aHoBrw3,{"EMISSAO",;
	           "UA_EMISSAO",;
	           pesqPict("SUA","UA_EMISSAO"),;
	           tamSX3("UA_EMISSAO")[1],;
	           tamSX3("UA_EMISSAO")[2],;
	           "",;
	           "",;
	           "C",;
	           "",;
	           "" } )
	Aadd(aHoBrw3,{"ITEM",;
	           "UB_ITEM",;
	           pesqPict("SUB","UB_ITEM"),;
	           tamSX3("UB_ITEM")[1],;
	           tamSX3("UB_ITEM")[2],;
	           "",;
	           "",;
	           "C",;
	           "",;
	           "" } )
	Aadd(aHoBrw3,{"UM",;
	           "UB_UM",;
	           pesqPict("SUB","UB_UM"),;
	           tamSX3("UB_UM")[1],;
	           tamSX3("UB_UM")[2],;
	           "",;
	           "",;
	           "C",;
	           "",;
	           "" } )
	Aadd(aHoBrw3,{"QUANTIDADE",;
	           "UB_QUANT",;
	           pesqPict("SUB","UB_QUANT"),;
	           tamSX3("UB_QUANT")[1],;
	           tamSX3("UB_QUANT")[2],;
	           "",;
	           "",;
	           "N",;
	           "",;
	           "" } )
	Aadd(aHoBrw3,{"VALOR UNITARIO",;
	           "UB_VRUNIT",;
	           pesqPict("SUB","UB_VRUNIT"),;
	           tamSX3("UB_VRUNIT")[1],;
	           tamSX3("UB_VRUNIT")[2],;
	           "",;
	           "",;
	           "N",;
	           "",;
	           "" } )
	Aadd(aHoBrw3,{"VALOR TOTAL",;
	           "UB_VLRITEM",;
	           pesqPict("SUB","UB_VLRITEM"),;
	           tamSX3("UB_VLRITEM")[1],;
	           tamSX3("UB_VLRITEM")[2],;
	           "",;
	           "",;
	           "N",;
	           "",;
	           "" } )
	Aadd(aHoBrw3,{"PEDIDO",;
	           "UB_NUMPV",;
	           pesqPict("SUB","UB_NUMPV"),;
	           tamSX3("UB_NUMPV")[1],;
	           tamSX3("UB_NUMPV")[2],;
	           "",;
	           "",;
	           "C",;
	           "",;
	           "" } )	
		Aadd(aHoBrw3,{"NOTA",;
	           "C6_NOTA",;
	           pesqPict("SC6","C6_NOTA"),;
	           tamSX3("C6_NOTA")[1],;
	           tamSX3("C6_NOTA")[2],;
	           "",;
	           "",;
	           "C",;
	           "",;
	           "" } )	
	  Aadd(aHoBrw3,{"DT FATURAMENTO",;
	           "C6_DATFAT",;
	           pesqPict("SC6","C6_DATFAT"),;
	           tamSX3("C6_DATFAT")[1],;
	           tamSX3("C6_DATFAT")[2],;
	           "",;
	           "",;
	           "C",;
	           "",;
	           "" } )	
	DbSelectArea("SX3")
	DbSetOrder(1)
	DbSeek("SZ8")
	While !Eof()
	   If alltrim(SX3->X3_CAMPO) $ "Z8_ZZDESMT"	      
	      Aadd(aHoBrw3,{"MOTIVO",;
	           SX3->X3_CAMPO,;
	           SX3->X3_PICTURE,;
	           SX3->X3_TAMANHO,;
	           SX3->X3_DECIMAL,;
	           "",;
	           "",;
	           SX3->X3_TIPO,;
	           "",;
	           "" } )
	   EndIf
	   DbSkip()
	EndDo
	
Return

Static Function MCoBrw2()
	
	aCoBrw2 := {}
	
	dbSelectArea("SB2")
	dbSetOrder(1)
	dbSeek(xFilial("SB2")+aCoBrw1[N][01]+"04")
	aadd(aCoBrw2,{SB2->B2_LOCAL,saldoSB2(,.T.),.F.})
		
	oBrw2:oBrowse:SetArray( aCoBrw2 )
	oBrw2:aCols := aCoBrw2
	oBrw2:oBrowse:Refresh(.T.)	
Return

Static Function MHoBrw2()	
	Aadd(aHoBrw2, {;
					"ARMAZEM",;//X3Titulo()
					"ARMAZEM",;  //X3_CAMPO
					pesqPict("SB2","B2_LOCAL"),;		//X3_PICTURE
					10,;			//X3_TAMANHO
					0,;			//X3_DECIMAL
					"",;			//X3_VALID
					"",;			//X3_USADO
					"C",;			//X3_TIPO
					"",; 			//X3_F3
					"",;			//X3_CONTEXT
					"",;			//X3_CBOX
					"",;			//X3_RELACAO
					"",;			//X3_WHEN
					""})			//
	Aadd(aHoBrw2, {;
					"QUANTIDADE",;//X3Titulo()
					"QUANTIDADE",;  //X3_CAMPO
					pesqPict("SB2","B2_QATU"),;		//X3_PICTURE
					20,;			//X3_TAMANHO
					0,;			//X3_DECIMAL
					"",;			//X3_VALID
					"",;			//X3_USADO
					"N",;			//X3_TIPO
					"",; 			//X3_F3
					"",;			//X3_CONTEXT
					"",;			//X3_CBOX
					"",;			//X3_RELACAO
					"",;			//X3_WHEN
					""})			//		
Return

Static Function MCoBrw1()
	
	aCoBrw1 := {}
	For nI := 1 to len(aCols)
		dbSelectArea("SB1")
		dbSetOrder(1)
		dbSeek(xFilial("SB1")+aCols[nI][GdFieldPos("UB_PRODUTO")])
		aadd(aCoBrw1,{SB1->B1_COD,SB1->B1_DESC,.F.})
	Next	
	
Return

Static Function MHoBrw1()	
	Aadd(aHoBrw1, {;
					"PRODUTO",;//X3Titulo()
					"PRODUTO",;  //X3_CAMPO
					pesqPict("SB1","B1_COD"),;		//X3_PICTURE
					15,;			//X3_TAMANHO
					0,;			//X3_DECIMAL
					"",;			//X3_VALID
					"",;			//X3_USADO
					"C",;			//X3_TIPO
					"SB1",; 			//X3_F3
					"",;			//X3_CONTEXT
					"",;			//X3_CBOX
					"",;			//X3_RELACAO
					"",;			//X3_WHEN
					""})			//
	Aadd(aHoBrw1, {;
					"DESCRICAO",;//X3Titulo()
					"DESCRICAO",;  //X3_CAMPO
					pesqPict("SB1","B1_DESC"),;		//X3_PICTURE
					50,;			//X3_TAMANHO
					0,;			//X3_DECIMAL
					"",;			//X3_VALID
					"",;			//X3_USADO
					"C",;			//X3_TIPO
					"",; 			//X3_F3
					"",;			//X3_CONTEXT
					"",;			//X3_CBOX
					"",;			//X3_RELACAO
					"",;			//X3_WHEN
					""})			//
Return
