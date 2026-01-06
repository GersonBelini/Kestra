#Include 'Protheus.ch'
#Include 'TopConn.ch'

#define GRUPO_ER					"PA06,PI01"
#define GRUPO_AT					"PA07,PI02"

/*/{Protheus.doc} imprER

Imprime a OP de Eletrodo Revestido.
	
@author André Oquendo
@since 12/06/2015

/*/

User Function imprER()
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

	Define MsDialog oDlg Title "Eletrodo Revestido" From 0, 0 To 090, 500 Pixel
	Define Font oBold Name "Arial" Size 0, -13 Bold
	@ 000, 000 Bitmap oBmp ResName "LOGIN" Of oDlg Size 30, 120 NoBorder When .F. Pixel
	@ 003, 040 Say "Eletrodo Revestido" Font oBold Pixel
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
	
	dbSelectArea("SB1")
	dbSetOrder(1)
	dbSeek(xFilial("SB1")+SC2->C2_PRODUTO)
	
	oPrint:Say(nLinha+0010, nColuna+0005,"Ordem de Produção - Eletrodo Revestido", oFont10N, 100,,, 0)
	oPrint:Say(nLinha+0010, aColImp[15]+0005,"No", oFont10N, 100,,, 0)
	oPrint:Say(nLinha+0010, aColImp[17]+0005,SC2->C2_NUM, oFont10, 100,,, 0)
	//Linhas 
	oPrint:Box(nLinha, nColuna, nLinha + 0070, aColImp[20])
	oPrint:Line(nLinha, aColImp[15], nLinha + 0070, aColImp[15])
	
	
	nLinha += 0070	
	oPrint:Say(nLinha+0010, nColuna+0005,"Eletrodo: ", oFont10N, 100,,, 0)
	oPrint:Say(nLinha+0010, aColImp[02]+0005,SB1->B1_DESC, oFont10, 100,,, 0)
	oPrint:Say(nLinha+0010, aColImp[15]+0005,"Código", oFont10N, 100,,, 0)
	oPrint:Say(nLinha+0010, aColImp[17]+0005,SB1->B1_COD, oFont10, 100,,, 0)
	//Linhas 
	oPrint:Box(nLinha, nColuna, nLinha + 0070, aColImp[20])
	oPrint:Line(nLinha, aColImp[15], nLinha + 0070, aColImp[15])
	
	nLinha += 0070
	oPrint:Say(nLinha, aColImp[02],"Corrida", oFont10N, 100,,, 2)
	oPrint:Say(nLinha, aColImp[06],"No Massa", oFont10N, 100,,, 2)
	oPrint:Say(nLinha, aColImp[10],"Extrusora", oFont10N, 100,,, 2)
	oPrint:Say(nLinha, (aColImp[12]+aColImp[18])/2,"Fieira", oFont10N, 100,,, 2)
	oPrint:Say(nLinha, aColImp[19],"Visto", oFont10N, 100,,, 2)
	//Linhas 
	oPrint:Box(nLinha, nColuna, nLinha + 0040, aColImp[20])
	oPrint:Line(nLinha, aColImp[04], nLinha + 0050, aColImp[04])
	oPrint:Line(nLinha, aColImp[08], nLinha + 0050, aColImp[08])
	oPrint:Line(nLinha, aColImp[12], nLinha + 0050, aColImp[12])
	oPrint:Line(nLinha, aColImp[18], nLinha + 0050, aColImp[18])
	
	nLinha += 0040
	
	oPrint:Say(nLinha-0005, (aColImp[12]+(aColImp[12]+aColImp[18])/2)/2,"Espec.", oFont09N, 100,,, 2)
	oPrint:Say(nLinha-0005, (((aColImp[12]+aColImp[18])/2)+aColImp[18])/2,"Real", oFont09N, 100,,, 2)
		
	oPrint:Say(nLinha+0035, aColImp[02],SC2->C2_ZZNCORR, oFont10, 100,,, 2)
	oPrint:Say(nLinha+0035, aColImp[06],alltrim(Transform(SD4->D4_QUANT, "@E 999,999.99")), oFont10, 100,,, 2)
	oPrint:Say(nLinha+0035, aColImp[10],SC2->C2_ZZEXTRU, oFont10, 100,,, 2)	
	oPrint:Say(nLinha+0035, (aColImp[12]+(aColImp[12]+aColImp[18])/2)/2,SC2->C2_ZZFIEIR, oFont10, 100,,, 2)	
	//Linhas 
	oPrint:Box(nLinha, nColuna, nLinha + 0080, aColImp[20])
	oPrint:Line(nLinha, aColImp[04], nLinha + 0080, aColImp[04])
	oPrint:Line(nLinha, aColImp[08], nLinha + 0080, aColImp[08])
	oPrint:Line(nLinha, aColImp[12], nLinha + 0080, aColImp[12])
	oPrint:Line(nLinha, (aColImp[12]+aColImp[18])/2, nLinha + 0080, (aColImp[12]+aColImp[18])/2)
	oPrint:Line(nLinha, aColImp[18], nLinha + 0080, aColImp[18])
	
	nLinha += 0080
Return

Static Function impProd()
	Local cQuery	:= ""
	Local nTotD4	:= 0


	cQuery := "SELECT D4_COD, D4_QUANT, D4_LOTECTL " +CRLF	
	cQuery += "FROM " +CRLF
	cQuery +=		RetSqlName("SD4") + " SD4 "+CRLF
	cQuery += "INNER JOIN "+CRLF
	cQuery +=    RetSqlName("SB1") + " AS SB1 ON B1_FILIAL = '" + xFilial("SB1") + "' AND D4_COD = B1_COD AND B1_GRUPO = 'MP01' AND SB1.D_E_L_E_T_ = ' ' "+CRLF
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
		oPrint:Say(nLinha+0020, nColuna+0005,"Vareta Tipo: ", oFont10N, 100,,, 0)	
		oPrint:Say(nLinha+0020, aColImp[04]+0005,cAlias->D4_COD, oFont10, 100,,, 2)
		oPrint:Box(nLinha, nColuna, nLinha + 0070, aColImp[20])
		
		nLinha += 0070
		nMeio	:= (nColuna + aColImp[05])/2
		
		oPrint:Say(nLinha+0020, nMeio,"Classificação", oFont10N, 100,,, 2)	
		oPrint:Say(nLinha+0020, aColImp[08],"Consumto Total (Kg)", oFont10N, 100,,, 2)
		oPrint:Say(nLinha+0020, aColImp[11]+0005,"Observações:", oFont10N, 100,,, 0)
		oPrint:Say(nLinha+0020, aColImp[19],"No. Rev", oFont10N, 100,,, 2)	
		
		oPrint:Box(nLinha, nColuna, nLinha + 0070, aColImp[05])
		
		oPrint:Line(nLinha, aColImp[11], nLinha + 0210, aColImp[11])
		oPrint:Line(nLinha, aColImp[18], nLinha + 0210, aColImp[18])
		
		nLinha += 0070
		
		
		oPrint:Say(nLinha+0020, (nColuna+nMeio)/2,"AWS", oFont10N, 100,,, 2)	
		oPrint:Say(nLinha+0020, (nMeio+aColImp[05])/2,"SAE", oFont10N, 100,,, 2)
		oPrint:Say(nLinha+0020, aColImp[08],"Previsto", oFont10N, 100,,, 2)	
		
		oPrint:Box(nLinha, nColuna, nLinha + 0070, aColImp[05])
		oPrint:Line(nLinha, nMeio, nLinha + 0070, (nColuna + aColImp[05])/2)
		
		nLinha += 0070
		
		oPrint:Say(nLinha+0020, (nColuna+nMeio)/2,SC2->C2_ZZCODK, oFont10, 100,,, 2)	
		oPrint:Say(nLinha+0020, aColImp[08],alltrim(Transform(nTotD4, "@E 999,999.99")), oFont10, 100,,, 2)
		oPrint:Say(nLinha+0020, aColImp[19],SC2->C2_ZZNREV, oFont10, 100,,, 2)	
		
		oPrint:Box(nLinha, nColuna, nLinha + 0070, aColImp[05])	
		oPrint:Box(nLinha, aColImp[05], nLinha + 0070, aColImp[11])
		oPrint:Box(nLinha, aColImp[18], nLinha + 0070, aColImp[20])
		
		oPrint:Line(nLinha, (nColuna + aColImp[05])/2, nLinha + 0070, (nColuna + aColImp[05])/2)	
		
		nLinha += 0070
		
		oPrint:Line(nLinha, aColImp[11], nLinha, aColImp[18])
		oPrint:Line(nLinha-0210, aColImp[20], nLinha, aColImp[20])
		
		While cAlias->(!Eof())
			oPrint:Say(nLinha+0020, nColuna+0005,"Lote: ", oFont10N, 100,,, 0)	
			oPrint:Say(nLinha+0020, aColImp[03]+0005,cAlias->D4_LOTECTL, oFont10, 100,,, 2)
			oPrint:Box(nLinha, nColuna, nLinha + 0070, aColImp[09])
			
			oPrint:Say(nLinha+0020, aColImp[09]+0005,"Previsto: ", oFont10N, 100,,, 0)	
			oPrint:Say(nLinha+0020, aColImp[11]+0005,Transform(cAlias->D4_QUANT, "@E 999,999.99"), oFont10, 100,,, 2)			
			oPrint:Box(nLinha, aColImp[09], nLinha + 0070, aColImp[15])
			
			oPrint:Say(nLinha+0020, aColImp[15]+0005,"Real: ____________________ Kg ", oFont10N, 100,,, 0)	
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
				oPrint:Say(nLinha, nColuna,"SK028", oFont08, 100,,, 0)
				oPrint:Say(nLinha, (nColuna+aColImp[20])/2,"QUEM TEM QUALIDADE FAZ O PRESENTE E CONFIA NO FUTURO", oFont08, 100,,, 1)
				oPrint:EndPage()	
				impCabec()											
			EndI
			cAlias->(dbskip())		
		EndDo
	
	EndIf
	cAlias->(dbCloseArea())
Return


Static Function impDados()

	oPrint:Box(nLinha, nColuna, nLinha + 0070, aColImp[20])
	oPrint:Line(nLinha, aColImp[05], nLinha + 0070, aColImp[05])
	oPrint:Line(nLinha, aColImp[10], nLinha + 0070, aColImp[10])
	oPrint:Line(nLinha, aColImp[15], nLinha + 0070, aColImp[15])
	oPrint:Line(nLinha, aColImp[20], nLinha + 0070, aColImp[20])
			
	oPrint:Say(nLinha+0020, (nColuna 	  + aColImp[05])/2,"Homogeneização da Massa Seca (Min)", oFont08N, 100,,, 2)
	oPrint:Say(nLinha+0020, (aColImp[05] + aColImp[10])/2,"Pressão de Extrusão (kgf/cm2)", oFont08N, 100,,, 2)
	oPrint:Say(nLinha+0020, (aColImp[10] + aColImp[15])/2,"Período Producao", oFont08N, 100,,, 2)	
	oPrint:Say(nLinha+0020, (aColImp[15] + aColImp[20])/2,"Qtd. Prevista de Eletrodo (Kg)", oFont08N, 100,,, 2)
			
	nLinha += 0070
	
	oPrint:Box(nLinha, nColuna, nLinha + 0070, aColImp[15])
	oPrint:Line(nLinha, aColImp[05], nLinha + 0070, aColImp[05])
	oPrint:Line(nLinha, aColImp[10], nLinha + 0070, aColImp[10])
	oPrint:Line(nLinha, aColImp[15], nLinha + 0070, aColImp[15])
	oPrint:Line(nLinha, aColImp[20], nLinha + 0070, aColImp[20])	
	
	nMeioA := (nColuna 	  + aColImp[05])/2
	nMeioB := (aColImp[05] + aColImp[10])/2
	nMeioC := (aColImp[10] + aColImp[15])/2
	
	oPrint:Line(nLinha, nMeioA, nLinha + 0070, nMeioA)
	oPrint:Line(nLinha, nMeioB, nLinha + 0070, nMeioB)
	oPrint:Line(nLinha, nMeioC, nLinha + 0070, nMeioC)
	
	oPrint:Say(nLinha+0020, (nColuna + nMeioA)/2,"Min.", oFont10N, 100,,, 2)
	oPrint:Say(nLinha+0020, (nMeioA + aColImp[05])/2,"Max.", oFont10N, 100,,, 2)
	
	oPrint:Say(nLinha+0020, (aColImp[05] + nMeioB)/2,"Min.", oFont10N, 100,,, 2)
	oPrint:Say(nLinha+0020, (nMeioB + aColImp[10])/2,"Max.", oFont10N, 100,,, 2)
	
	oPrint:Say(nLinha+0020, (aColImp[10] + nMeioC)/2,"Início", oFont10N, 100,,, 2)
	oPrint:Say(nLinha+0020, (nMeioC + aColImp[15])/2,"Término", oFont10N, 100,,, 2)
	
	nLinha += 0070
	
	oPrint:Box(nLinha, nColuna, nLinha + 0070, aColImp[15])
	oPrint:Line(nLinha, aColImp[05], nLinha + 0070, aColImp[05])
	oPrint:Line(nLinha, aColImp[10], nLinha + 0070, aColImp[10])
	oPrint:Line(nLinha, aColImp[15], nLinha + 0070, aColImp[15])
	oPrint:Line(nLinha, aColImp[20], nLinha + 0070, aColImp[20])	
	
	nMeioA := (nColuna 	  + aColImp[05])/2
	nMeioB := (aColImp[05] + aColImp[10])/2
	nMeioC := (aColImp[10] + aColImp[15])/2
	nMeioD := (aColImp[15] + aColImp[20])/2
	
	oPrint:Line(nLinha, nMeioA, nLinha + 0070, nMeioA)
	oPrint:Line(nLinha, nMeioB, nLinha + 0070, nMeioB)
	oPrint:Line(nLinha, nMeioC, nLinha + 0070, nMeioC)
	
	oPrint:Say(nLinha+0020, (nColuna + nMeioA)/2,alltrim(Transform(SC2->C2_ZZHOMIN, "@E 999,999.99")), oFont10, 100,,, 2)
	oPrint:Say(nLinha+0020, (nMeioA + aColImp[05])/2,alltrim(Transform(SC2->C2_ZZHOMAC, "@E 999,999.99")), oFont10, 100,,, 2)
	
	oPrint:Say(nLinha+0020, (aColImp[05] + nMeioB)/2,alltrim(Transform(SC2->C2_ZZPRMIN, "@E 999,999.99")), oFont10, 100,,, 2)
	oPrint:Say(nLinha+0020, (nMeioB + aColImp[10])/2,alltrim(Transform(SC2->C2_ZZPRMAX, "@E 999,999.99")), oFont10, 100,,, 2)
	
	oPrint:Say(nLinha+0020, (aColImp[10] + nMeioC)/2,"___/___", oFont10, 100,,, 2)
	oPrint:Say(nLinha+0020, (nMeioC + aColImp[15])/2,"___/___", oFont10, 100,,, 2)
	
	nLinha += 0070
	
	oPrint:Line(nLinha, aColImp[15], nLinha, aColImp[20])
	
	oPrint:Say(nLinha-0100, nMeioD,alltrim(Transform(SC2->C2_QUANT, "@E 999,999.99")), oFont12, 100,,, 2)
		
	
	oPrint:Box(nLinha, nColuna, nLinha + 0070, aColImp[20])
		
	oPrint:Say(nLinha+0020, (nColuna + aColImp[20])/2,"Identificação - Carimbo", oFont10N, 100,,, 2)
	
	nLinha += 0070
	oPrint:Box(nLinha, nColuna, nLinha + 0070, aColImp[20])
	oPrint:Line(nLinha, aColImp[07], nLinha + 0070, aColImp[07])
	oPrint:Line(nLinha, aColImp[13], nLinha + 0070, aColImp[13])	
	
	oPrint:Say(nLinha+0020, (nColuna + aColImp[07])/2,"KESTRA", oFont10N, 100,,, 2)
	oPrint:Say(nLinha+0020, (aColImp[07] + aColImp[13])/2,"NORMA", oFont10N, 100,,, 2)
	oPrint:Say(nLinha+0020, (aColImp[13] + aColImp[20])/2,"VISTO OPERADOR", oFont10N, 100,,, 2)
	
	nLinha += 0070
	oPrint:Box(nLinha, nColuna, nLinha + 0070, aColImp[20])
	oPrint:Line(nLinha, aColImp[07], nLinha + 0070, aColImp[07])
	oPrint:Line(nLinha, aColImp[13], nLinha + 0070, aColImp[13])
	oPrint:Say(nLinha+0020, (nColuna + aColImp[07])/2,SC2->C2_ZZCARKE, oFont10, 100,,, 2)
	oPrint:Say(nLinha+0020, (aColImp[07] + aColImp[13])/2,SC2->C2_ZZCARNO, oFont10, 100,,, 2)
	
	nLinha += 0100
		
Return

Static Function impFim()
	oPrint:Say(nLinha+0020, (nColuna+aColImp[20])/2,"Fim da Produção", oFont10N, 100,,, 2)		
	oPrint:Box(nLinha, nColuna, nLinha + 0070, aColImp[20])
	
	nLinha += 0070
	
	oPrint:Say(nLinha+0050, (aColImp[03]+aColImp[07])/2,"Sobra de Massa (Kg)", oFont10N, 100,,, 2)
	oPrint:Box(nLinha+0100, aColImp[03], nLinha + 0250, aColImp[07])
	
	nCodBar :=  (nLinha+0150)/(oPrint:nlogpixelx()*0.393701)
	
	MSBAR3("CODE128",nCodBar,14,alltrim("12345"),oPrint,.F.,Nil,Nil,0.03,0.7,.T.,Nil,"A",.F.)
	
	oPrint:Box(nLinha, nColuna, nLinha + 0350, aColImp[20])
	
	nLinha += 0350
	
	oPrint:Say(nLinha, nColuna + 0005,"Instruções especiais e/ou requisitos suplementares", oFont10N, 100,,, 0)
	oPrint:Say(nLinha+0050, nColuna +0005,SC2->C2_OBS, oFont10, 100,,, 0)	
	oPrint:Box(nLinha, nColuna, nLinha + 0350, aColImp[20])
	
	nLinha += 0350
	
	oPrint:Say(nLinha, nColuna,"SK028", oFont08, 100,,, 0)
	oPrint:Say(nLinha, (nColuna+aColImp[20])/2,"QUEM TEM QUALIDADE FAZ O PRESENTE E CONFIA NO FUTURO", oFont08, 100,,, 1)
	
	oPrint:EndPage()	

Return