#Include 'Protheus.ch'
#Include 'TopConn.ch'

#define GRUPO_ER					"PA06,PI01"
#define GRUPO_AT					"PA07,PI02"


User Function imprPes()
	Local nSomaD4 := 0
	
	Private cTipo	:= ""

	Private oPrint
	
	Private nLinha	:= 0	
	Private nLimHor	:= 0
	Private nColuna	:= 0
	Private aColImp	:= {}
		
	Private oFont08 	:= TFont():New("Arial", 08, 08,, .F.,,,,, .F., .F.)
	Private oFont08N 	:= TFont():New("Arial", 08, 08,, .T.,,,,, .F., .F.)
	Private oFont09 	:= TFont():New("Arial", 09, 09,, .F.,,,,, .F., .F.)
	Private oFont09N 	:= TFont():New("Arial", 09, 09,, .T.,,,,, .F., .F.)
	Private oFont10 	:= TFont():New("Arial", 10, 10,, .F.,,,,, .F., .F.)
	Private oFont10N 	:= TFont():New("Arial", 10, 10,, .T.,,,,, .F., .F.)
	Private oFont11 	:= TFont():New("Arial", 11, 11,, .F.,,,,, .F., .F.)
	Private oFont11N 	:= TFont():New("Arial", 11, 11,, .T.,,,,, .F., .F.)
	Private oFont12 	:= TFont():New("Arial", 12, 12,, .F.,,,,, .F., .F.)
	Private oFont12N 	:= TFont():New("Arial", 12, 12,, .T.,,,,, .F., .F.)
	Private oFont14N 	:= TFont():New("Arial", 14, 14,, .T.,,,,, .F., .F.)
	Private oFont16N 	:= TFont():New("Arial", 16, 16,, .T.,,,,, .F., .F.)
	Private oFont16NI	:= TFont():New("Arial", 16, 16,, .T.,,,,, .F., .T.)
		
	oPrint := TMSPrinter():New()	
		
	impCabec()
	impOP()
	nSomaD4 := impProd()
	impDados( nSomaD4 )
	impFim()	
	
	Define MsDialog oDlg Title "Ordem de Pesagem" From 0, 0 To 090, 500 Pixel
	Define Font oBold Name "Arial" Size 0, -13 Bold
	@ 000, 000 Bitmap oBmp ResName "LOGIN" Of oDlg Size 30, 120 NoBorder When .F. Pixel
	@ 003, 040 Say "Arame Tubular" Font oBold Pixel
	@ 014, 030 To 016, 400 Label '' Of oDlg  Pixel
	@ 020, 040 Button "Configurar" 	Size 40, 13 Pixel Of oDlg Action oPrint:Setup()
	@ 020, 082 Button "Imprimir"   	Size 40, 13 Pixel Of oDlg Action oPrint:Print()
	@ 020, 124 Button "Visualizar" 	Size 40, 13 Pixel Of oDlg Action oPrint:Preview() 	
	@ 020, 208 Button "Sair"       	Size 40, 13 Pixel Of oDlg Action oDlg:End()
	Activate MsDialog oDlg Centered
Return

Static Function impCabec()
	Local cLogo			:= AllTrim(GetMV("ZZ_LOGOEMP")) //Imagem dentro do SYSTEM

	nLinha		:= 0050	
	nLimHor	:= 2400
	nColuna	:= 0050
	
	nTamCol := nLimHor/20	
	For nI := 1 To 20
		aAdd(aColImp, nI * nTamCol)	
	Next nI
		
	//Inicia uma Nova Pagina para Impressao
	oPrint:StartPage()
		
	//Define o modo de Impressao como Retrato
	oPrint:SetPortrait()
		
	oPrint:SayBitmap(nLinha + 0005, nColuna, cLogo, 410, 185)
	
	dbSelectArea("SM0")
	SM0->(dbseek(cEmPant + cFilant))
	
	// oPrint:Say(Coluna, Linha, Texto, Fonte, Num de Caracteres, , ,Alinhamento - 0=Left, 1=Right e 2=Center)
	oPrint:Say(nLinha + 0080, aColImp[11], RTrim(SM0->M0_NOMECOM), oFont12N, 100,,, 2)
	
	oPrint:Say(nLinha + 0080, aColImp[19], DtoC(dDataBase), oFont12N, 100,,, 2)
	
	
	//Linhas
	oPrint:Box(nLinha, nColuna, nLinha + 0200, aColImp[20])
	
	oPrint:Line(nLinha, aColImp[05], nLinha + 0200, aColImp[05])
	oPrint:Line(nLinha, aColImp[18], nLinha + 0200, aColImp[18])
	
	nLinha += 0200

Return

Static Function impOP()	
	Local nMassa		:= 0
	
	dbSelectArea("SB1")
	dbSetOrder(1)
	dbSeek(xFilial("SB1")+SC2->C2_PRODUTO)
	
	If SB1->B1_GRUPO $ GRUPO_ER
		cTipo := "ER"
	ElseIf SB1->B1_GRUPO $ GRUPO_AT
		cTipo := "AT"
	EndIf
	
	oPrint:Say(nLinha+0020, nColuna+0005,"Ordem de Pesagem", oFont10N, 100,,, 0)
	oPrint:Say(nLinha+0020, aColImp[15]+0005,"No", oFont10N, 100,,, 0)
	oPrint:Say(nLinha+0020, aColImp[17]+0005,SC2->C2_NUM, oFont10, 100,,, 0)
	//Linhas 
	oPrint:Box(nLinha, nColuna, nLinha + 0070, aColImp[20])
	oPrint:Line(nLinha, aColImp[15], nLinha + 0070, aColImp[15])
	
	nLinha += 0070	
	
	oPrint:Say(nLinha+0020, nColuna+0005,"Produto: ", oFont10N, 100,,, 0)
	oPrint:Say(nLinha+0020, aColImp[03]+0005,SB1->B1_DESC, oFont10, 100,,, 0)
	oPrint:Say(nLinha+0020, aColImp[15]+0005,"Código", oFont10N, 100,,, 0)
	oPrint:Say(nLinha+0020, aColImp[17]+0005,SB1->B1_COD, oFont10, 100,,, 0)
	//Linhas 
	oPrint:Box(nLinha, nColuna, nLinha + 0070, aColImp[20])
	oPrint:Line(nLinha, aColImp[15], nLinha + 0070, aColImp[15])
		
	nLinha += 0070
	
	oPrint:Say(nLinha+0020, (nColuna+aColImp[05])/2,"Corrida", oFont10N, 100,,, 2)
	oPrint:Say(nLinha+0020, (aColImp[05]+aColImp[10])/2,"No Massa", oFont10N, 100,,, 2)
	oPrint:Say(nLinha+0020, (aColImp[10]+aColImp[15])/2,"Extrusora", oFont10N, 100,,, 2)
	oPrint:Say(nLinha+0020, (aColImp[15]+aColImp[20])/2,"Fieira", oFont10N, 100,,, 2)
	
	oPrint:Box(nLinha, nColuna, nLinha + 0070, aColImp[20])
	oPrint:Line(nLinha, aColImp[05], nLinha + 0070, aColImp[05])
	oPrint:Line(nLinha, aColImp[10], nLinha + 0070, aColImp[10])
	oPrint:Line(nLinha, aColImp[15], nLinha + 0070, aColImp[15])
	
	nLinha += 0070
	
	oPrint:Say(nLinha+0040, (nColuna+aColImp[05])/2,SC2->C2_ZZNCORR, oFont10, 100,,, 2)
	oPrint:Say(nLinha+0040, (aColImp[05]+aColImp[10])/2,alltrim(Transform(SC2->C2_QUANT, "@E 999,999.99")), oFont10, 100,,, 2)
	oPrint:Say(nLinha+0040, (aColImp[10]+aColImp[15])/2,SC2->C2_ZZEXTRU, oFont10, 100,,, 2)
	oPrint:Say(nLinha+0040, (aColImp[15]+aColImp[20])/2,SC2->C2_ZZNREV, oFont10, 100,,, 2)
	
	oPrint:Box(nLinha, nColuna, nLinha + 0100, aColImp[20])
	oPrint:Line(nLinha, aColImp[05], nLinha + 0100, aColImp[05])
	oPrint:Line(nLinha, aColImp[10], nLinha + 0100, aColImp[10])
	oPrint:Line(nLinha, aColImp[15], nLinha + 0100, aColImp[15])
		
	nLinha += 0100
Return

Static Function impProd()
	Local cQuery	:= ""
	Local nItem	:= 0
	Local nSomaD4	:= 0

	cQuery := "SELECT D4_COD, D4_QUANT, D4_LOTECTL, B1_ZZCODK " +CRLF	
	cQuery += "FROM " +CRLF
	cQuery +=		RetSqlName("SD4") + " SD4 "+CRLF
	cQuery += "INNER JOIN "+CRLF
	cQuery +=    RetSqlName("SB1") + " AS SB1 ON B1_FILIAL = '" + xFilial("SB1") + "' AND D4_COD = B1_COD AND B1_GRUPO = 'MP04' AND SB1.D_E_L_E_T_ = ' ' "+CRLF
	cQuery += "WHERE "+CRLF
	cQuery += "	SD4.D_E_L_E_T_ = ' ' "+CRLF
	cQuery += "	AND D4_FILIAL = '" + xFilial("SD4") + "' "+CRLF
	cQuery += "	AND D4_OP = '"+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN+"' "+CRLF
		
	TCQUERY cQuery NEW ALIAS "cAlias"
	
	cAlias->(dbgotop())

	While cAlias->(!Eof())
	nSomaD4 += cAlias->D4_QUANT
		nItem ++
	
		oPrint:Say(nLinha+0010, (nColuna+aColImp[01])/2,"Item", oFont09N, 100,,, 2)
		oPrint:Say(nLinha+0010, (aColImp[01]+aColImp[02])/2,"Código", oFont09N, 100,,, 2)
		oPrint:Say(nLinha+0010, (aColImp[02]+aColImp[04])/2,"Qtd. (Kg)", oFont09N, 100,,, 2)
		oPrint:Say(nLinha+0010, (aColImp[04]+aColImp[06])/2,"Lote", oFont09N, 100,,, 2)
		oPrint:Say(nLinha+0010, (aColImp[06]+aColImp[12])/2,"Peso total do lote definido (Kg)", oFont09N, 100,,, 2)
		oPrint:Say(nLinha+0010, (aColImp[12]+aColImp[15])/2,"Lote", oFont09N, 100,,, 2)
		oPrint:Say(nLinha+0010, (aColImp[15]+aColImp[18])/2,"Qtd. (Kg)", oFont09N, 100,,, 2)
		oPrint:Say(nLinha+0010, (aColImp[18]+aColImp[20])/2,"Visto CQ", oFont09N, 100,,, 2)
		
		oPrint:Line(nLinha+ 0050, aColImp[06], nLinha+ 0050, aColImp[12])
		oPrint:Line(nLinha, nColuna, nLinha + 0050, nColuna)
		oPrint:Line(nLinha, aColImp[01], nLinha + 0050, aColImp[01])
		oPrint:Line(nLinha, aColImp[02], nLinha + 0050, aColImp[02])
		oPrint:Line(nLinha, aColImp[04], nLinha + 0050, aColImp[04])
		oPrint:Line(nLinha, aColImp[06], nLinha + 0050, aColImp[06])
		oPrint:Line(nLinha, aColImp[12], nLinha + 0050, aColImp[12])
		oPrint:Line(nLinha, aColImp[15], nLinha + 0050, aColImp[15])
		oPrint:Line(nLinha, aColImp[18], nLinha + 0050, aColImp[18])
		oPrint:Line(nLinha, aColImp[20], nLinha + 0050, aColImp[20])
		
		nLinha += 0050
		
		oPrint:Say(nLinha+0010, (nColuna+aColImp[01])/2,alltrim(Str(nItem)), oFont09N, 100,,, 2)
		oPrint:Say(nLinha+0010, (aColImp[01]+aColImp[02])/2,"M.P.", oFont09N, 100,,, 2)
		oPrint:Say(nLinha+0010, (aColImp[02]+aColImp[04])/2,"1 Massa", oFont09N, 100,,, 2)
		nMeioA := (aColImp[06] + aColImp[12])/2		
		oPrint:Say(nLinha+0010, (aColImp[06]+nMeioA)/2,"Previsto", oFont09N, 100,,, 2)
		oPrint:Say(nLinha+0010, (nMeioA+aColImp[12])/2,"Real", oFont09N, 100,,, 2)
		oPrint:Say(nLinha+0010, (aColImp[12]+aColImp[15])/2,"adicionado", oFont09N, 100,,, 2)
		oPrint:Say(nLinha+0010, (aColImp[15]+aColImp[18])/2,"adicionada", oFont09N, 100,,, 2)
		oPrint:Say(nLinha+0010, (aColImp[18]+aColImp[20])/2,"(Autorização)", oFont08N, 100,,, 2)
		
		oPrint:Line(nLinha+ 0050, aColImp[01], nLinha+ 0050, aColImp[20])		
		oPrint:Line(nLinha, nColuna, nLinha + 0050, nColuna)
		oPrint:Line(nLinha, aColImp[01], nLinha + 0050, aColImp[01])
		oPrint:Line(nLinha, aColImp[02], nLinha + 0050, aColImp[02])		
		oPrint:Line(nLinha, aColImp[04], nLinha + 0050, aColImp[04])
		oPrint:Line(nLinha, aColImp[06], nLinha + 0050, aColImp[06])
		oPrint:Line(nLinha, aColImp[12], nLinha + 0050, aColImp[12])
		oPrint:Line(nLinha, nMeioA, nLinha + 0050, nMeioA)
		oPrint:Line(nLinha, aColImp[15], nLinha + 0050, aColImp[15])
		oPrint:Line(nLinha, aColImp[18], nLinha + 0050, aColImp[18])
		oPrint:Line(nLinha, aColImp[20], nLinha + 0050, aColImp[20])
		
		nLinha += 0050
		

		oPrint:Say(nLinha+0020, (aColImp[01]+aColImp[02])/2,cAlias->B1_ZZCODK, oFont09, 100,,, 2)
		oPrint:Say(nLinha+0020, (aColImp[02]+aColImp[04])/2,alltrim(Transform(cAlias->D4_QUANT/SC2->C2_QUANT, "@E 999,999.99")), oFont09, 100,,, 2)
		oPrint:Say(nLinha+0020, (aColImp[04]+aColImp[06])/2,cAlias->D4_LOTECTL, oFont09, 100,,, 2)
		nMeioA := (aColImp[06] + aColImp[12])/2		
		oPrint:Say(nLinha+0020, (aColImp[06]+nMeioA)/2,alltrim(Transform(cAlias->D4_QUANT, "@E 999,999.99")), oFont09, 100,,, 2)
		
		oPrint:Line(nLinha+ 0070, aColImp[01], nLinha+ 0070, aColImp[18])		
		oPrint:Line(nLinha, nColuna, nLinha + 0070, nColuna)
		oPrint:Line(nLinha, aColImp[01], nLinha + 0070, aColImp[01])
		oPrint:Line(nLinha, aColImp[02], nLinha + 0070, aColImp[02])
		oPrint:Line(nLinha, aColImp[04], nLinha + 0070, aColImp[04])
		oPrint:Line(nLinha, aColImp[06], nLinha + 0070, aColImp[06])
		oPrint:Line(nLinha, aColImp[12], nLinha + 0070, aColImp[12])
		oPrint:Line(nLinha, nMeioA, nLinha + 0070, nMeioA)
		oPrint:Line(nLinha, aColImp[15], nLinha + 0070, aColImp[15])
		oPrint:Line(nLinha, aColImp[18], nLinha + 0070, aColImp[18])
		oPrint:Line(nLinha, aColImp[20], nLinha + 0070, aColImp[20])
		
		nLinha += 0070
				
		oPrint:Say(nLinha+0020, aColImp[01]+0005,"Obs.", oFont09N, 100,,, 0)
		nMeioA := (aColImp[06] + aColImp[12])/2		
		oPrint:Say(nLinha+0010, (aColImp[06]+nMeioA)/2,cAlias->D4_COD, oFont09, 100,,, 2)
		oPrint:Say(nLinha+0010, (nMeioA+aColImp[12])/2,"[ ] Lote Finalizado", oFont09N, 100,,, 2)
		oPrint:Say(nLinha+0010, (aColImp[12]+aColImp[18])/2,"[ ] Lote Finalizado", oFont09N, 100,,, 2)
				
		oPrint:Line(nLinha+ 0070, nColuna, nLinha+ 0070, aColImp[20])		
		oPrint:Line(nLinha, nColuna, nLinha + 0070, nColuna)
		oPrint:Line(nLinha, aColImp[01], nLinha + 0070, aColImp[01])
		oPrint:Line(nLinha, aColImp[06], nLinha + 0070, aColImp[06])
		oPrint:Line(nLinha, aColImp[04], nLinha + 0070, aColImp[04])
		oPrint:Line(nLinha, aColImp[06], nLinha + 0070, aColImp[06])
		oPrint:Line(nLinha, aColImp[12], nLinha + 0070, aColImp[12])
		oPrint:Line(nLinha, nMeioA, nLinha + 0070, nMeioA)
		oPrint:Line(nLinha, aColImp[18], nLinha + 0070, aColImp[18])
		oPrint:Line(nLinha, aColImp[18], nLinha + 0070, aColImp[18])
		oPrint:Line(nLinha, aColImp[20], nLinha + 0070, aColImp[20])
		
		nLinha += 0070
		
		oPrint:Box(nLinha, nColuna, nLinha + 0300, aColImp[20])
		
		oPrint:Say(nLinha, nColuna+0005,"Cole aqui as etiquetas de pesagem", oFont09N, 100,,, 0)
		
		nLinha += 0300
				
		If nLinha >= 2500			
			If cTipo == "AT"							
				oPrint:Say(nLinha, nColuna,"SK073-R.2 PK 7.5.1/7.5.3/8.2.4.i", oFont08, 100,,, 0)
			ElseIf cTipo == "ER"
				oPrint:Say(nLinha, nColuna,"SK029", oFont08, 100,,, 0)
			EndIf
			oPrint:Say(nLinha, (nColuna+aColImp[20])/2,"QUEM TEM QUALIDADE FAZ O PRESENTE E CONFIA NO FUTURO", oFont08, 100,,, 1)		
			oPrint:EndPage()	
			impCabec()											
		EndIf	
		cAlias->(dbskip())		
	EndDo
	cAlias->(dbCloseArea())
	
Return nSomaD4

Static Function impDados( nSomaD4 )
	Local cQuery	:= ""
	Local nTotD4	:= 0

	cQuery := "SELECT D4_COD, D4_QUANT, D4_LOTECTL, B1_ZZCODK " +CRLF	
	cQuery += "FROM " +CRLF
	cQuery +=		RetSqlName("SD4") + " SD4 "+CRLF
	cQuery += "INNER JOIN "+CRLF
	cQuery +=    RetSqlName("SB1") + " AS SB1 ON B1_FILIAL = '" + xFilial("SB1") + "' AND D4_COD = B1_COD AND B1_GRUPO = 'MP05' AND SB1.D_E_L_E_T_ = ' ' "+CRLF
	cQuery += "WHERE "+CRLF
	cQuery += "	SD4.D_E_L_E_T_ = ' ' "+CRLF
	cQuery += "	AND D4_FILIAL = '" + xFilial("SD4") + "' "+CRLF
	cQuery += "	AND D4_OP = '"+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN+"' "+CRLF
		
	TCQUERY cQuery NEW ALIAS "cAlias"
	
	cAlias->(dbgotop())
	While cAlias->(!Eof())
		nTotD4 += cAlias->D4_QUANT
		cAlias->(dbskip())	
	EndDo
	cAlias->(dbgotop())
	
	oPrint:Box(nLinha, nColuna, nLinha + 0070, aColImp[20])
	oPrint:Line(nLinha, aColImp[03], nLinha + 0070, aColImp[03])
	oPrint:Line(nLinha, aColImp[07], nLinha + 0070, aColImp[07])
	oPrint:Line(nLinha, aColImp[11], nLinha + 0070, aColImp[11])
	oPrint:Line(nLinha, aColImp[15], nLinha + 0070, aColImp[15])
			
	oPrint:Say(nLinha+0020, (nColuna 	  + aColImp[03])/2,"Peso (1 massa)", oFont09N, 100,,, 2)
	oPrint:Say(nLinha+0020, (aColImp[03] + aColImp[07])/2,"(1) Peso Total OP", oFont09N, 100,,, 2)
	oPrint:Say(nLinha+0020, (aColImp[07] + aColImp[11])/2,"(2) Adição de massa (Kg)", oFont09N, 100,,, 2)	
	oPrint:Say(nLinha+0020, (aColImp[11] + aColImp[15])/2,"Total (Kg) -> 1 + 2", oFont09N, 100,,, 2)
	oPrint:Say(nLinha+0020, (aColImp[15] + aColImp[20])/2,"Silicato Tipo", oFont09N, 100,,, 2)
			
	nLinha += 0070
	
	oPrint:Box(nLinha, nColuna, nLinha + 0070, aColImp[20])
	oPrint:Line(nLinha, aColImp[03], nLinha + 0070, aColImp[03])
	oPrint:Line(nLinha, aColImp[07], nLinha + 0070, aColImp[07])
	oPrint:Line(nLinha, aColImp[11], nLinha + 0070, aColImp[11])
	oPrint:Line(nLinha, aColImp[15], nLinha + 0070, aColImp[15])
			
	oPrint:Say(nLinha+0020, (nColuna 	  + aColImp[03])/2,alltrim(Transform(nSomaD4/SC2->C2_QUANT, "@E 999,999.99")), oFont09, 100,,, 2)	
	oPrint:Say(nLinha+0020, (aColImp[03] + aColImp[07])/2,alltrim(Transform(nSomaD4, "@E 999,999.99")), oFont09, 100,,, 2)
	If cAlias->(!Eof())	
		oPrint:Say(nLinha+0020, (aColImp[15] + aColImp[20])/2,cAlias->B1_ZZCODK, oFont09, 100,,, 2)
	EndIf
				
	nLinha += 0070
	
	oPrint:Box(nLinha, nColuna, nLinha + 0070, aColImp[20])
	oPrint:Line(nLinha, aColImp[03], nLinha + 0070, aColImp[03])
	oPrint:Line(nLinha, aColImp[07], nLinha + 0070, aColImp[07])
	oPrint:Line(nLinha, aColImp[11], nLinha + 0070, aColImp[11])
			
	oPrint:Say(nLinha+0020, (nColuna 	  + aColImp[03])/2,"% na massa", oFont09N, 100,,, 2)
	oPrint:Say(nLinha+0020, (aColImp[03] + aColImp[07])/2,"Silicato em 1 massa", oFont09N, 100,,, 2)
	oPrint:Say(nLinha+0020, (aColImp[07] + aColImp[11])/2,"Total silicato OP", oFont09N, 100,,, 2)	
	oPrint:Say(nLinha+0020, aColImp[11] + 0005,"Lotes de silicatos utilizados", oFont09N, 100,,, 0)
		
	nLinha += 0070
	
	oPrint:Box(nLinha, nColuna, nLinha + 0070, aColImp[20])
	oPrint:Line(nLinha, aColImp[03], nLinha + 0070, aColImp[03])
	oPrint:Line(nLinha, aColImp[07], nLinha + 0070, aColImp[07])
	oPrint:Line(nLinha, aColImp[11], nLinha + 0070, aColImp[11])
	
	If cAlias->(!Eof())			
		oPrint:Say(nLinha+0020, (nColuna 	  + aColImp[03])/2,alltrim(Transform(cAlias->D4_QUANT/nSomaD4*100, "@E 999,999.99")), oFont09N, 100,,, 2)
		oPrint:Say(nLinha+0020, (aColImp[03] + aColImp[07])/2,alltrim(Transform(cAlias->D4_QUANT/SC2->C2_QUANT, "@E 999,999.99")), oFont09N, 100,,, 2)
		oPrint:Say(nLinha+0020, (aColImp[07] + aColImp[11])/2,alltrim(Transform(cAlias->D4_QUANT, "@E 999,999.99")), oFont09N, 100,,, 2)		
		oPrint:Say(nLinha+0020, aColImp[11] + 0005,cAlias->D4_LOTECTL+cAlias->B1_ZZCODK, oFont09N, 100,,, 0)
	EndIf

	nLinha += 0070
							
	cAlias->(dbCloseArea())
Return


Static Function impFim()

	oPrint:Box(nLinha, nColuna, nLinha + 0400, aColImp[20])
		
	oPrint:Say(nLinha, nColuna+0005,"Observações: ", oFont09N, 100,,, 0)
	
	oPrint:Box(nLinha+0200, aColImp[12], nLinha + 0380, aColImp[16])
	
	oPrint:Say(nLinha+0200, (aColImp[12]+aColImp[16])/2,"RESPONSÁVEL PESAGEM", oFont08N, 100,,, 2)
	
	oPrint:Box(nLinha+0200, aColImp[16], nLinha + 0380, aColImp[20])
	
	oPrint:Say(nLinha+0200, (aColImp[16]+aColImp[20])/2,"DATA (TÉRMINO PESAGEM)", oFont08N, 100,,, 2)
	
	nLinha += 0400
	If cTipo == "AT"							
		oPrint:Say(nLinha, nColuna,"SK073-R.2 PK 7.5.1/7.5.3/8.2.4.i", oFont08, 100,,, 0)
	ElseIf cTipo == "ER"
		oPrint:Say(nLinha, nColuna,"SK029", oFont08, 100,,, 0)
	EndIf
	oPrint:Say(nLinha, (nColuna+aColImp[20])/2,"QUEM TEM QUALIDADE FAZ O PRESENTE E CONFIA NO FUTURO", oFont08, 100,,, 1)
	oPrint:EndPage()	
Return