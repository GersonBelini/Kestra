#Include 'Protheus.ch'
#Include 'TopConn.ch'

/*/{Protheus.doc} imprAT

Imprime a OP de Arame Tubular.
	
@author André Oquendo
@since 18/06/2015

/*/

User Function imprAT()

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
	impProd()
	impDados()
	impFim()	
	
	Define MsDialog oDlg Title "Arame Tubular" From 0, 0 To 090, 500 Pixel
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
	
	oPrint:Say(nLinha+0010, nColuna+0005,"Ordem de Produção - Arame Tubular", oFont10N, 100,,, 0)
	oPrint:Say(nLinha+0010, aColImp[15]+0005,"No", oFont10N, 100,,, 0)
	oPrint:Say(nLinha+0010, aColImp[17]+0005,SC2->C2_NUM, oFont10, 100,,, 0)
	//Linhas 
	oPrint:Box(nLinha, nColuna, nLinha + 0070, aColImp[20])
	oPrint:Line(nLinha, aColImp[15], nLinha + 0070, aColImp[15])
	
	nLinha += 0070	
	
	oPrint:Say(nLinha+0010, nColuna+0005,"Arame Tubular: ", oFont10N, 100,,, 0)
	oPrint:Say(nLinha+0010, aColImp[03]+0005,SB1->B1_DESC, oFont10, 100,,, 0)
	oPrint:Say(nLinha+0010, aColImp[15]+0005,"Código", oFont10N, 100,,, 0)
	oPrint:Say(nLinha+0010, aColImp[17]+0005,SB1->B1_COD, oFont10, 100,,, 0)
	//Linhas 
	oPrint:Box(nLinha, nColuna, nLinha + 0070, aColImp[20])
	oPrint:Line(nLinha, aColImp[15], nLinha + 0070, aColImp[15])
		
	nLinha += 0070
	
	oPrint:Say(nLinha+0020, (nColuna+aColImp[02])/2,"F.G %", oFont10N, 100,,, 2)
	oPrint:Say(nLinha+0020, (aColImp[02]+aColImp[05])/2,"Corrida", oFont10N, 100,,, 2)
	oPrint:Say(nLinha+0020, (aColImp[05]+aColImp[08])/2,"No. Massa", oFont10N, 100,,, 2)
	oPrint:Say(nLinha+0020, (aColImp[08]+aColImp[11])/2,"Receita", oFont10N, 100,,, 2)
	oPrint:Say(nLinha+0020, (aColImp[11]+aColImp[14])/2,"Data", oFont10N, 100,,, 2)
	oPrint:Say(nLinha+0020, (aColImp[14]+aColImp[18])/2,"Laminadora No", oFont10N, 100,,, 2)
	oPrint:Say(nLinha+0020, (aColImp[18]+aColImp[20])/2,"Visto", oFont10N, 100,,, 2)
	
	oPrint:Box(nLinha, nColuna, nLinha + 0070, aColImp[20])
	oPrint:Line(nLinha, aColImp[02], nLinha + 0070, aColImp[02])
	oPrint:Line(nLinha, aColImp[05], nLinha + 0070, aColImp[05])
	oPrint:Line(nLinha, aColImp[08], nLinha + 0070, aColImp[08])
	oPrint:Line(nLinha, aColImp[11], nLinha + 0070, aColImp[11])
	oPrint:Line(nLinha, aColImp[14], nLinha + 0070, aColImp[14])
	oPrint:Line(nLinha, aColImp[18], nLinha + 0070, aColImp[18])
	
	nLinha += 0070
	
	nMassa := retMassa()
	
	oPrint:Say(nLinha+0020, (nColuna+aColImp[02])/2,SC2->C2_ZZFG+"%", oFont10, 100,,, 2)
	oPrint:Say(nLinha+0020, (aColImp[02]+aColImp[05])/2,SC2->C2_ZZNCORR, oFont10, 100,,, 2)
	oPrint:Say(nLinha+0020, (aColImp[05]+aColImp[08])/2,alltrim(Transform(nMassa, "@E 999,999.99")), oFont10, 100,,, 2)
	oPrint:Say(nLinha+0020, (aColImp[11]+aColImp[14])/2,"____/____", oFont10, 100,,, 2)
	oPrint:Say(nLinha+0020, (aColImp[14]+aColImp[18])/2,SC2->C2_ZZLAM, oFont10, 100,,, 2)	
	
	oPrint:Box(nLinha, nColuna, nLinha + 0070, aColImp[20])
	oPrint:Line(nLinha, aColImp[02], nLinha + 0070, aColImp[02])
	oPrint:Line(nLinha, aColImp[05], nLinha + 0070, aColImp[05])
	oPrint:Line(nLinha, aColImp[08], nLinha + 0070, aColImp[08])
	oPrint:Line(nLinha, aColImp[11], nLinha + 0070, aColImp[11])
	oPrint:Line(nLinha, aColImp[14], nLinha + 0070, aColImp[14])
	oPrint:Line(nLinha, aColImp[18], nLinha + 0070, aColImp[18])
	
	nLinha += 0070
Return

Static Function retMassa()
	Local nRet		:= 0
	Local cQuery	:= 0
	cQuery := "SELECT SUM(D4_QUANT) as SOMA " +CRLF	
	cQuery += "FROM " +CRLF
	cQuery +=		RetSqlName("SD4") + " SD4 "+CRLF
	cQuery += "INNER JOIN "+CRLF
	cQuery +=    RetSqlName("SB1") + " AS SB1 ON B1_FILIAL = '" + xFilial("SB1") + "' AND D4_COD = B1_COD AND B1_GRUPO = 'MP01' AND SB1.D_E_L_E_T_ = ' ' "+CRLF
	cQuery += "WHERE "+CRLF
	cQuery += "	SD4.D_E_L_E_T_ = ' ' "+CRLF
	cQuery += "	AND D4_FILIAL = '" + xFilial("SD4") + "' "+CRLF
	cQuery += "	AND D4_OP = '"+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN+"' "+CRLF
		
	TCQUERY cQuery NEW ALIAS "cAlias"
		
	If cAlias->(!Eof())	
		nRet := cAlias->SOMA	
	EndIf
	cAlias->(dbCloseArea())

Return nRet


Static Function impProd()
	Local cQuery	:= ""
	Local nTotD4	:= 0


	cQuery := "SELECT D4_COD, D4_QUANT, D4_LOTECTL, B1_DESC " +CRLF	
	cQuery += "FROM " +CRLF
	cQuery +=		RetSqlName("SD4") + " SD4 "+CRLF
	cQuery += "INNER JOIN "+CRLF
	cQuery +=    RetSqlName("SB1") + " AS SB1 ON B1_FILIAL = '" + xFilial("SB1") + "' AND D4_COD = B1_COD AND B1_GRUPO = 'MP03' AND SB1.D_E_L_E_T_ = ' ' "+CRLF
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
	If cAlias->(!Eof())
		oPrint:Say(nLinha+0020, nColuna+0005,"Fita Tipo: ", oFont10N, 100,,, 0)	
		oPrint:Say(nLinha+0020, aColImp[04]+0005,cAlias->D4_COD, oFont10, 100,,, 2)
		//oPrint:Say(nLinha+0020, aColImp[08]+0005,"Descrição da Fita: ", oFont10N, 100,,, 0)	
		oPrint:Say(nLinha+0020, aColImp[08]+0005,cAlias->B1_DESC, oFont10, 100,,, 0)
		oPrint:Box(nLinha, nColuna, nLinha + 0070, aColImp[20])
		
		nLinha += 0070
		
		oPrint:Say(nLinha+0020, (nColuna + aColImp[07])/2,"Consumto Total Previsto (Kg)", oFont10N, 100,,, 2)	
		oPrint:Say(nLinha+0020, aColImp[08]+0005,"Observações:", oFont10N, 100,,, 0)
		oPrint:Say(nLinha+0020, aColImp[19],"No. Rev", oFont10N, 100,,, 2)	
		
		oPrint:Box(nLinha, nColuna, nLinha + 0090, aColImp[20])
		
		oPrint:Line(nLinha, aColImp[08], nLinha + 0090, aColImp[08])
		oPrint:Line(nLinha, aColImp[18], nLinha + 0090, aColImp[18])
		
		nLinha += 0090
		
		
		oPrint:Say(nLinha+0030, (nColuna + aColImp[07])/2,alltrim(Transform(nTotD4, "@E 999,999.99")), oFont10, 100,,, 2)			
		oPrint:Say(nLinha+0030, aColImp[19],SC2->C2_ZZNREV, oFont10, 100,,, 2)	
		
		oPrint:Box(nLinha, nColuna, nLinha + 0090, aColImp[20])
		
		oPrint:Line(nLinha, aColImp[08], nLinha + 0090, aColImp[08])
		oPrint:Line(nLinha, aColImp[18], nLinha + 0090, aColImp[18])
		
		
		nLinha += 0090
		
		oPrint:Line(nLinha, aColImp[11], nLinha, aColImp[18])
		oPrint:Line(nLinha-0210, aColImp[20], nLinha, aColImp[20])
		
		While cAlias->(!Eof())
		
			oPrint:Say(nLinha+0020, nColuna+0005,"[  ] Lote: ", oFont10N, 100,,, 0)	
			oPrint:Say(nLinha+0020, aColImp[04]+0005,cAlias->D4_LOTECTL, oFont10, 100,,, 2)
			oPrint:Box(nLinha, nColuna, nLinha + 0070, aColImp[07])
			
			oPrint:Say(nLinha+0020, aColImp[07]+0005,"[  ] Lote Finalizado ", oFont10N, 100,,, 0)	
			oPrint:Box(nLinha, aColImp[07], nLinha + 0070, aColImp[11])
			
			oPrint:Say(nLinha+0020, aColImp[11]+0005,"Previsto: ", oFont10N, 100,,, 0)	
			oPrint:Say(nLinha+0020, aColImp[13]+0005,Transform(cAlias->D4_QUANT, "@E 999,999.99"), oFont10, 100,,, 2)			
			oPrint:Box(nLinha, aColImp[11], nLinha + 0070, aColImp[15])
			
			oPrint:Say(nLinha+0020, aColImp[15]+0005,"Real: _________________ Kg ", oFont10N, 100,,, 0)	
			oPrint:Box(nLinha, aColImp[15], nLinha + 0070, aColImp[20])
			
			nLinha += 0070
			
			oPrint:Say(nLinha+0020, nColuna+0005,"[  ] Lote Alterado/adicionado: _________________ ", oFont10N, 100,,, 0)				
			oPrint:Box(nLinha, nColuna, nLinha + 0070, aColImp[09])
			
			oPrint:Say(nLinha+0020, aColImp[09]+0005,"[  ] Lote alt./adic. Finalizado ", oFont10N, 100,,, 0)			
			oPrint:Box(nLinha, aColImp[09], nLinha + 0070, aColImp[13])
			
			oPrint:Say(nLinha+0020, aColImp[13]+0005,"Qtd. Utilizada: _________________________ Kg ", oFont10N, 100,,, 0)	
			oPrint:Box(nLinha, aColImp[13], nLinha + 0070, aColImp[20])
			
			nLinha += 0070
			
			If nLinha >= 2500
				oPrint:Say(nLinha, nColuna,"SK074-R.2 PK 7.5.1/7.5.3/8.2.4.i", oFont08, 100,,, 0)
				oPrint:EndPage()	
				impCabec()											
			EndIf
			cAlias->(dbskip())		
		EndDo
	
	EndIf
	cAlias->(dbCloseArea())
Return

Static Function impDados()

	oPrint:Say(nLinha+0020, (nColuna+aColImp[07])/2,"Forno", oFont10N, 100,,, 2)	
	oPrint:Say(nLinha+0020, (aColImp[07]+aColImp[14])/2,"Período de Produção", oFont10N, 100,,, 2)
	oPrint:Say(nLinha+0020, (aColImp[14]+aColImp[20])/2,"Arame", oFont10N, 100,,, 2)
	oPrint:Box(nLinha, nColuna, nLinha + 0070, aColImp[14])
	oPrint:Line(nLinha, aColImp[07], nLinha + 0070, aColImp[07])
	oPrint:Line(nLinha, aColImp[20], nLinha + 0070, aColImp[20])
	
	nLinha += 0070
	
	nMeioA	:= (nColuna+aColImp[07])/2
	nMeioB	:= (aColImp[07]+aColImp[14])/2
	
	oPrint:Say(nLinha+0020, (nColuna+nMeioA)/2,"Carga de Secagem No:", oFont10N, 100,,, 2)	
	oPrint:Say(nLinha+0020, (aColImp[07]+nMeioB)/2,"Início", oFont10N, 100,,, 2)
	oPrint:Say(nLinha+0020, (nMeioB+aColImp[14])/2,"Término", oFont10N, 100,,, 2)	
	oPrint:Say(nLinha+0020, (aColImp[14]+aColImp[20])/2,"Quantidade Prevista", oFont10N, 100,,, 2)
	oPrint:Box(nLinha, nColuna, nLinha + 0070, aColImp[14])
	oPrint:Line(nLinha, nMeioA, nLinha + 0070, nMeioA)
	oPrint:Line(nLinha, nMeioB, nLinha + 0070, nMeioB)
	oPrint:Line(nLinha, aColImp[20], nLinha + 0070, aColImp[20])
	oPrint:Line(nLinha, aColImp[07], nLinha + 0070, aColImp[07])
	
	oPrint:Line(nLinha+0070, aColImp[14], nLinha + 0070, aColImp[20])
	
	nLinha += 0070
	
	nMeioA	:= (nColuna+aColImp[07])/2
	nMeioB	:= (aColImp[07]+aColImp[14])/2
	
	oPrint:Say(nLinha+0020, (nColuna+nMeioA)/2,"Temperatura (°C)", oFont10N, 100,,, 2)	
	oPrint:Say(nLinha+0020, (nMeioA+aColImp[07])/2,"Tempo (h)", oFont10N, 100,,, 2)
	oPrint:Say(nLinha+0020, (aColImp[07]+nMeioB)/2,"____/____", oFont10N, 100,,, 2)
	oPrint:Say(nLinha+0020, (nMeioB+aColImp[14])/2,"____/____", oFont10N, 100,,, 2)	
	oPrint:Say(nLinha+0020, (aColImp[14]+aColImp[20])/2,"(Kg)", oFont10N, 100,,, 2)
	oPrint:Box(nLinha, aColImp[07], nLinha + 0070, aColImp[14])
	oPrint:Line(nLinha, nMeioA, nLinha + 0070, nMeioA)
	oPrint:Line(nLinha, nMeioB, nLinha + 0070, nMeioB)
	oPrint:Line(nLinha, nColuna, nLinha + 0070, nColuna)
	oPrint:Line(nLinha, aColImp[20], nLinha + 0070, aColImp[20])
	oPrint:Line(nLinha, aColImp[07], nLinha + 0070, aColImp[07])
	
	nLinha += 0070
	
	nMeioA	:= (nColuna+aColImp[07])/2
	nMeioB	:= (aColImp[07]+aColImp[14])/2
		
	oPrint:Say(nLinha+0020, (nMeioA+aColImp[07])/2,"____:____", oFont10N, 100,,, 2)
	oPrint:Say(nLinha+0020, (aColImp[07]+nMeioB)/2,"____/____", oFont10N, 100,,, 2)
	oPrint:Say(nLinha+0020, (nMeioB+aColImp[14])/2,"____/____", oFont10N, 100,,, 2)	
	oPrint:Say(nLinha+0020, (aColImp[14]+aColImp[20])/2,alltrim(Transform(SC2->C2_QUANT, "@E 999,999.99")), oFont10, 100,,, 2)	
	oPrint:Box(nLinha, aColImp[07], nLinha + 0070, aColImp[14])
	oPrint:Line(nLinha, nMeioA, nLinha + 0070, nMeioA)
	oPrint:Line(nLinha, nMeioB, nLinha + 0070, nMeioB)
	oPrint:Line(nLinha, nColuna, nLinha + 0070, nColuna)
	oPrint:Line(nLinha, aColImp[20], nLinha + 0070, aColImp[20])
	oPrint:Line(nLinha, aColImp[07], nLinha + 0070, aColImp[07])
	oPrint:Line(nLinha + 0070, nColuna, nLinha + 0070, aColImp[20])
	
	nLinha += 0070
	
	oPrint:Say(nLinha+0020, (nColuna+aColImp[20])/2,"CALIBRAGEM", oFont10N, 100,,, 2)	
	oPrint:Box(nLinha, nColuna, nLinha + 0070, aColImp[20])
	
	nLinha += 0070
	
	aColAux := {}
	nTamCol := (nColuna+aColImp[20])/23	
	For nI := 1 To 23
		aAdd(aColAux, nI * nTamCol)	
	Next nI
	
	oPrint:Say(nLinha+0020, (nColuna+aColAux[01])/2,"Nº", oFont10N, 100,,, 2)
	oPrint:Say(nLinha+0020, (aColAux[01]+aColAux[03])/2,"Veloc.", oFont10N, 100,,, 2)
	oPrint:Say(nLinha+0020, (aColAux[03]+aColAux[05])/2,"Tempo (s)", oFont10N, 100,,, 2)
	oPrint:Say(nLinha+0020, (aColAux[05]+aColAux[07])/2,"Fluxo (g)", oFont10N, 100,,, 2)
	oPrint:Say(nLinha+0020, (aColAux[07]+aColAux[09])/2,"Fita (g)", oFont10N, 100,,, 2)
	oPrint:Say(nLinha+0020, (aColAux[09]+aColAux[11])/2,"FG", oFont10N, 100,,, 2)
	
	oPrint:Say(nLinha+0020, (aColAux[11]+0020+aColAux[12])/2,"Nº", oFont10N, 100,,, 2)
	oPrint:Say(nLinha+0020, (aColAux[12]+aColAux[14])/2,"Veloc.", oFont10N, 100,,, 2)
	oPrint:Say(nLinha+0020, (aColAux[14]+aColAux[16])/2,"Tempo (s)", oFont10N, 100,,, 2)
	oPrint:Say(nLinha+0020, (aColAux[16]+aColAux[18])/2,"Fluxo (g)", oFont10N, 100,,, 2)
	oPrint:Say(nLinha+0020, (aColAux[18]+aColAux[20])/2,"Fita (g)", oFont10N, 100,,, 2)
	oPrint:Say(nLinha+0020, (aColAux[20]+aColAux[22])/2,"FG", oFont10N, 100,,, 2)
	
	oPrint:Box(nLinha, nColuna, nLinha + 0070, aColImp[20])
	oPrint:Line(nLinha, aColAux[01], nLinha + 0070, aColAux[01])
	oPrint:Line(nLinha, aColAux[03], nLinha + 0070, aColAux[03])
	oPrint:Line(nLinha, aColAux[05], nLinha + 0070, aColAux[05])
	oPrint:Line(nLinha, aColAux[07], nLinha + 0070, aColAux[07])
	oPrint:Line(nLinha, aColAux[09], nLinha + 0070, aColAux[09])
	oPrint:Line(nLinha, aColAux[11]+0030, nLinha + 0070, aColAux[11]+0030)
	oPrint:Line(nLinha, aColAux[12], nLinha + 0070, aColAux[12])
	oPrint:Line(nLinha, aColAux[14], nLinha + 0070, aColAux[14])
	oPrint:Line(nLinha, aColAux[16], nLinha + 0070, aColAux[16])
	oPrint:Line(nLinha, aColAux[18], nLinha + 0070, aColAux[18])
	oPrint:Line(nLinha, aColAux[20], nLinha + 0070, aColAux[20])
	
	
	nLinha += 0070
	
	For nO := 1 to 5
		oPrint:Box(nLinha, nColuna, nLinha + 0090, aColImp[20])
		oPrint:Line(nLinha, aColAux[01], nLinha + 0090, aColAux[01])
		oPrint:Line(nLinha, aColAux[03], nLinha + 0090, aColAux[03])
		oPrint:Line(nLinha, aColAux[05], nLinha + 0090, aColAux[05])
		oPrint:Line(nLinha, aColAux[07], nLinha + 0090, aColAux[07])
		oPrint:Line(nLinha, aColAux[09], nLinha + 0090, aColAux[09])
		oPrint:Line(nLinha, aColAux[11]+0030, nLinha + 0090, aColAux[11]+0030)
		oPrint:Line(nLinha, aColAux[12], nLinha + 0090, aColAux[12])
		oPrint:Line(nLinha, aColAux[14], nLinha + 0090, aColAux[14])
		oPrint:Line(nLinha, aColAux[16], nLinha + 0090, aColAux[16])
		oPrint:Line(nLinha, aColAux[18], nLinha + 0090, aColAux[18])
		oPrint:Line(nLinha, aColAux[20], nLinha + 0090, aColAux[20])
		
		nLinha += 0090
	Next
	
	oPrint:Say(nLinha+0020, (nColuna+aColImp[20])/2,"CONTROLE DE QUALIDADE", oFont10N, 100,,, 2)	
	oPrint:Box(nLinha, nColuna, nLinha + 0070, aColImp[20])
	
	nLinha += 0070
	
	oPrint:Say(nLinha+0020, (nColuna+aColAux[06])/2,"Diâmetro Medido", oFont10N, 100,,, 2)
	
	oPrint:Say(nLinha+0020, (aColImp[18]+aColImp[20])/2,"mm", oFont10N, 100,,, 2)
	
	oPrint:Box(nLinha, nColuna, nLinha + 0090, aColImp[20])	
	oPrint:Line(nLinha, aColImp[06], nLinha + 0090, aColImp[06])
	oPrint:Line(nLinha, aColImp[08], nLinha + 0090, aColImp[08])
	oPrint:Line(nLinha, aColImp[10], nLinha + 0090, aColImp[10])
	oPrint:Line(nLinha, aColImp[12], nLinha + 0090, aColImp[12])
	oPrint:Line(nLinha, aColImp[14], nLinha + 0090, aColImp[14])
	oPrint:Line(nLinha, aColImp[16], nLinha + 0090, aColImp[16])
	oPrint:Line(nLinha, aColImp[18], nLinha + 0090, aColImp[18])
	
	nLinha += 0090
	
	oPrint:Say(nLinha+0020, (nColuna+aColImp[02])/2,"Amostra", oFont10N, 100,,, 2)
	oPrint:Say(nLinha+0020, (aColImp[02]+aColImp[06])/2,"Arame (Kg)", oFont10N, 100,,, 2)
	oPrint:Say(nLinha+0020, (aColImp[06]+aColImp[10])/2,"Fita (g)", oFont10N, 100,,, 2)
	oPrint:Say(nLinha+0020, (aColImp[10]+aColImp[13])/2,"FG", oFont10N, 100,,, 2)
	oPrint:Say(nLinha+0020, aColImp[13]+0005,"Soldabilidade: [  ] Aprovado", oFont09N, 100,,, 0)
	oPrint:Say(nLinha+0020, aColImp[17]+0005,"Dureza: [  ] Aprovado", oFont09N, 100,,, 0)
	
	oPrint:Box(nLinha, nColuna, nLinha + 0070, aColImp[20])
	oPrint:Line(nLinha, aColImp[02], nLinha + 0070, aColImp[02])	
	oPrint:Line(nLinha, aColImp[06], nLinha + 0070, aColImp[06])
	oPrint:Line(nLinha, aColImp[10], nLinha + 0070, aColImp[10])
	oPrint:Line(nLinha, aColImp[13], nLinha + 0070, aColImp[13])
	oPrint:Line(nLinha, aColImp[17], nLinha + 0070, aColImp[17])

	nLinha += 0070
	
	oPrint:Say(nLinha+0020, (aColImp[13]+0100+aColImp[19])/2,"Perda", oFont10N, 100,,, 2)
	oPrint:Box(nLinha+0010, aColImp[13]+0100, nLinha + 0060, aColImp[19])
	oPrint:Box(nLinha+0010, aColImp[13]+0100, nLinha + 0130, aColImp[19])
	
	oPrint:Say(nLinha+0030, (nColuna+aColImp[02])/2,"1", oFont10N, 100,,, 2)
	
	oPrint:Box(nLinha, nColuna, nLinha + 0090, aColImp[13])
	oPrint:Line(nLinha, aColImp[02], nLinha + 0090, aColImp[02])	
	oPrint:Line(nLinha, aColImp[06], nLinha + 0090, aColImp[06])
	oPrint:Line(nLinha, aColImp[10], nLinha + 0090, aColImp[10])
	
	nLinha += 0090
	
	oPrint:Say(nLinha+0030, (nColuna+aColImp[02])/2,"2", oFont10N, 100,,, 2)
	
	oPrint:Say(nLinha+0050, (aColImp[13]+0100+aColImp[19])/2,"Total Poduzido", oFont10N, 100,,, 2)
	oPrint:Box(nLinha+0040, aColImp[13]+0100, nLinha + 0090, aColImp[19])
	oPrint:Box(nLinha+0040, aColImp[13]+0100, nLinha + 0160, aColImp[19])
	
	oPrint:Box(nLinha, nColuna, nLinha + 0090, aColImp[13])
	oPrint:Line(nLinha, aColImp[02], nLinha + 0090, aColImp[02])	
	oPrint:Line(nLinha, aColImp[06], nLinha + 0090, aColImp[06])
	oPrint:Line(nLinha, aColImp[10], nLinha + 0090, aColImp[10])
	
	nLinha += 0090
	
	oPrint:Say(nLinha+0030, (nColuna+aColImp[02])/2,"3", oFont10N, 100,,, 2)
	
	oPrint:Box(nLinha, nColuna, nLinha + 0090, aColImp[13])
	oPrint:Line(nLinha, aColImp[02], nLinha + 0090, aColImp[02])	
	oPrint:Line(nLinha, aColImp[06], nLinha + 0090, aColImp[06])
	oPrint:Line(nLinha, aColImp[10], nLinha + 0090, aColImp[10])
	
	nLinha += 0090
Return

Static Function impFim()
	
	nLinha += 0020
	
	oPrint:Say(nLinha, nColuna + 0005,"Instruções especiais e/ou requisitos suplementares", oFont10N, 100,,, 0)
	oPrint:Say(nLinha+0050, nColuna +0005,SC2->C2_OBS, oFont10, 100,,, 0)	
	oPrint:Box(nLinha, nColuna, nLinha + 0350, aColImp[20])
	
	nLinha += 0350
	
	oPrint:Say(nLinha, nColuna,"SK074-R.2 PK 7.5.1/7.5.3/8.2.4.i", oFont08, 100,,, 0)
	
	oPrint:EndPage()	

Return