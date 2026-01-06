#Include 'Protheus.ch'

User Function imprCor()
	Private oPrint
	
	Private nLinha	:= 0	
	Private nLimHor	:= 0
	Private nColuna	:= 0
	Private aColImp	:= {}
	Private nCount	:= 0
		
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
	impRot()
	impLinha()
	impLista()
	impFim()	

	Define MsDialog oDlg Title "Corte" From 0, 0 To 090, 500 Pixel
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
	nCount++
	nTamCol := nLimHor/20	
	For nI := 1 To 20
		aAdd(aColImp, nI * nTamCol)	
	Next nI
		
	//Inicia uma Nova Pagina para Impressao
	oPrint:StartPage()
		
	//Define o modo de Impressao como Retrato
	oPrint:SetPortrait()
		
	oPrint:SayBitmap(nLinha + 0005, nColuna, cLogo, 410, 185)
	
	oPrint:Say(nLinha + 0020, aColImp[08], "Ordem de Fabricação", oFont14N, 100,,, 2)	
	oPrint:Say(nLinha + 0020, aColImp[11]+0005, "OP n.", oFont10N, 100,,, 0)
	oPrint:Say(nLinha + 0020, aColImp[13]+0005, "Data Emissão", oFont10N, 100,,, 0)
	oPrint:Say(nLinha + 0020, aColImp[16]+0005, "Data Entrega", oFont10N, 100,,, 0)
	oPrint:Say(nLinha + 0020, aColImp[19]+0005, "Página", oFont10N, 100,,, 0)
	
	oPrint:Box(nLinha, nColuna, nLinha + 0200, aColImp[11])
	oPrint:Box(nLinha, aColImp[11], nLinha + 0200, aColImp[13])
	oPrint:Box(nLinha, aColImp[13], nLinha + 0200, aColImp[16])
	oPrint:Box(nLinha, aColImp[16], nLinha + 0200, aColImp[19])
	oPrint:Box(nLinha, aColImp[19], nLinha + 0200, aColImp[20])
			
	nLinha += 0070
	
	oPrint:Say(nLinha + 0030, aColImp[08], "(ROFIMP1-009)", oFont09, 100,,, 2)
	oPrint:Say(nLinha + 0030, aColImp[11]+0005, SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN, oFont10, 100,,, 0)
	oPrint:Say(nLinha + 0030, aColImp[13]+0005, dToC(SC2->C2_EMISSAO), oFont10, 100,,, 0)
	oPrint:Say(nLinha + 0030, aColImp[16]+0005, dToC(SC2->C2_DATPRF), oFont10, 100,,, 0)
	oPrint:Say(nLinha + 0030, aColImp[19]+0005, cValtoChar(nCount), oFont10, 100,,, 0)
	
	nLinha += 0130
	
	oPrint:Say(nLinha + 0020, nColuna+0005, "Produto", oFont10N, 100,,, 0)	
	oPrint:Say(nLinha + 0020, aColImp[05]+0005, "Descrição do Produto", oFont10N, 100,,, 0)
	oPrint:Say(nLinha + 0020, aColImp[14]+0005, "Quantidade", oFont10N, 100,,, 0)
	oPrint:Say(nLinha + 0020, aColImp[17]+0005, "Lote", oFont10N, 100,,, 0)
	
	oPrint:Box(nLinha, nColuna, nLinha + 0140, aColImp[05])
	oPrint:Box(nLinha, aColImp[05], nLinha + 0140, aColImp[14])
	oPrint:Box(nLinha, aColImp[14], nLinha + 0140, aColImp[17])
	oPrint:Box(nLinha, aColImp[17], nLinha + 0140, aColImp[20])
			
	nLinha += 0070
	
	
	dbSelectArea("SB1")
	dbSetOrder(1)
	dbSeek(xFilial("SB1")+SC2->C2_PRODUTO)
	
	
	oPrint:Say(nLinha + 0020, nColuna+0005, SC2->C2_PRODUTO, oFont10N, 100,,, 0)	
	oPrint:Say(nLinha + 0020, aColImp[05]+0005, SB1->B1_DESC, oFont10N, 100,,, 0)
	oPrint:Say(nLinha + 0020, aColImp[14]+0005, alltrim(Transform(SC2->C2_QUANT, "@E 999,999.999")), oFont10N, 100,,, 0)
	oPrint:Say(nLinha + 0020, aColImp[17]+0005, SC2->C2_ZZNCORR+SC2->C2_ZZREQUA, oFont10N, 100,,, 0)
		
	nLinha += 0070
	
	oPrint:Say(nLinha + 0020, nColuna+0005, "Pedido", oFont10N, 100,,, 0)	
	oPrint:Say(nLinha + 0020, aColImp[07]+0005, "Empresa - Cliente", oFont10N, 100,,, 0)
	oPrint:Say(nLinha + 0020, aColImp[16]+0005, "Dt. Entrega PV", oFont10N, 100,,, 0)	
	
	oPrint:Box(nLinha, nColuna, nLinha + 0140, aColImp[07])
	oPrint:Box(nLinha, aColImp[07], nLinha + 0140, aColImp[16])
	oPrint:Box(nLinha, aColImp[16], nLinha + 0140, aColImp[20])
			
	nLinha += 0070
	
	If !empty(SC2->C2_PEDIDO)
		dbSelectArea("SC6")
		dbSetOrder(1)
		dbSeek(xFilial("SC6")+SC2->C2_PEDIDO+SC2->C2_ITEMPV)
		oPrint:Say(nLinha + 0020, nColuna+0005, SC2->C2_PEDIDO, oFont10, 100,,, 0)	
		oPrint:Say(nLinha + 0020, aColImp[07]+0005, SC6->C6_CLI+"/"+SC6->C6_LOJA+" - "+Posicione("SA1",1,xFilial("SA1")+SC6->C6_CLI+SC6->C6_LOJA,"A1_NOME"), oFont10, 100,,, 0)
		oPrint:Say(nLinha + 0020, aColImp[16]+0005, dToS(SC6->C6_ENTREG), oFont10, 100,,, 0)
	EndIf
		
	nLinha += 0070
	
Return


Static Function impRot()

	oPrint:Say(nLinha + 0020, (nColuna+aColImp[20])/2, "SEQUÊNCIA DE FABRICAÇÃO DO PRODUTO", oFont10N, 100,,, 2)
	oPrint:Box(nLinha, nColuna, nLinha + 0070, aColImp[20])	
	
	nLinha += 0070

	oPrint:Say(nLinha + 0020, nColuna+0005, "Seq.", oFont10N, 100,,, 0)	
	oPrint:Say(nLinha + 0020, aColImp[02]+0005, "Operação", oFont10N, 100,,, 0)
	oPrint:Say(nLinha + 0020, aColImp[09]+0005, "Máquina", oFont10N, 100,,, 0)
	oPrint:Say(nLinha + 0020, aColImp[13]+0005, "Tmp. Prep.", oFont10N, 100,,, 0)
	oPrint:Say(nLinha + 0020, aColImp[15]+0005, "Tmp. Exc.", oFont10N, 100,,, 0)
	oPrint:Say(nLinha + 0020, aColImp[17]+0005, "Observações", oFont10N, 100,,, 0)
	
	oPrint:Box(nLinha, nColuna, nLinha + 0070, aColImp[02])
	oPrint:Box(nLinha, aColImp[02], nLinha + 0070, aColImp[09])
	oPrint:Box(nLinha, aColImp[09], nLinha + 0070, aColImp[13])
	oPrint:Box(nLinha, aColImp[13], nLinha + 0070, aColImp[15])
	oPrint:Box(nLinha, aColImp[15], nLinha + 0070, aColImp[17])
	oPrint:Box(nLinha, aColImp[17], nLinha + 0070, aColImp[20])
			
	nLinha += 0070
	
	dbSelectArea("SG2")
	dbSetOrder(1)//G2_FILIAL+G2_PRODUTO+G2_CODIGO+G2_OPERAC
	dbSeek(xFilial("SG2")+SC2->C2_PRODUTO)
	While SG2->(!Eof()) .AND. SC2->C2_PRODUTO == SG2->G2_PRODUTO
		dbSelectArea("SH1")
		dbSetOrder(1)//H1_FILIAL+H1_CODIGO
		dbSeek(xFilial("SH1")+SG2->G2_RECURSO)
		oPrint:Say(nLinha + 0020, nColuna+0005, SG2->G2_CODIGO, oFont10N, 100,,, 0)	
		oPrint:Say(nLinha + 0020, aColImp[02]+0005, SG2->G2_OPERAC +" - "+ SG2->G2_DESCRI, oFont10N, 100,,, 0)		
		oPrint:Say(nLinha + 0020, aColImp[09]+0005, SH1->H1_DESCRI, oFont10N, 100,,, 0)
		oPrint:Say(nLinha + 0020, aColImp[13]+0005, alltrim(Transform(SG2->G2_SETUP, "@E 99.99")), oFont10N, 100,,, 0)
		oPrint:Say(nLinha + 0020, aColImp[15]+0005, alltrim(Transform(SG2->G2_TEMPAD, "@E 99.99")), oFont10N, 100,,, 0)
		oPrint:Say(nLinha + 0020, aColImp[17]+0005, SC2->C2_OBS, oFont10N, 100,,, 0)
		
		oPrint:Box(nLinha, nColuna, nLinha + 0070, aColImp[02])
		oPrint:Box(nLinha, aColImp[02], nLinha + 0070, aColImp[09])
		oPrint:Box(nLinha, aColImp[09], nLinha + 0070, aColImp[13])
		oPrint:Box(nLinha, aColImp[13], nLinha + 0070, aColImp[15])
		oPrint:Box(nLinha, aColImp[15], nLinha + 0070, aColImp[17])
		oPrint:Box(nLinha, aColImp[17], nLinha + 0070, aColImp[20])
				
		nLinha += 0070
		
		If nLinha >= 2700
			oPrint:EndPage()	
			impCabec()		
			oPrint:Say(nLinha + 0020, (nColuna+aColImp[20])/2, "SEQUÊNCIA DE FABRICAÇÃO DO PRODUTO", oFont10N, 100,,, 2)
			oPrint:Box(nLinha, nColuna, nLinha + 0070, aColImp[20])	
			
			nLinha += 0070
		
			oPrint:Say(nLinha + 0020, nColuna+0005, "Seq.", oFont10N, 100,,, 0)	
			oPrint:Say(nLinha + 0020, aColImp[02]+0005, "Operação", oFont10N, 100,,, 0)
			oPrint:Say(nLinha + 0020, aColImp[09]+0005, "Máquina", oFont10N, 100,,, 0)
			oPrint:Say(nLinha + 0020, aColImp[13]+0005, "Tmp. Prep.", oFont10N, 100,,, 0)
			oPrint:Say(nLinha + 0020, aColImp[15]+0005, "Tmp. Exc.", oFont10N, 100,,, 0)
			oPrint:Say(nLinha + 0020, aColImp[17]+0005, "Observações", oFont10N, 100,,, 0)
			
			oPrint:Box(nLinha, nColuna, nLinha + 0070, aColImp[02])
			oPrint:Box(nLinha, aColImp[02], nLinha + 0070, aColImp[09])
			oPrint:Box(nLinha, aColImp[09], nLinha + 0070, aColImp[13])
			oPrint:Box(nLinha, aColImp[13], nLinha + 0070, aColImp[15])
			oPrint:Box(nLinha, aColImp[15], nLinha + 0070, aColImp[17])
			oPrint:Box(nLinha, aColImp[17], nLinha + 0070, aColImp[20])
					
			nLinha += 0070									
		EndIf
	
		SG2->(dbskip())	
	EndDo
	
Return

Static Function impLinha()

	nLinha += 0070

	oPrint:Say(nLinha + 0020, nColuna+0005, "Operador", oFont10N, 100,,, 0)	
	oPrint:Say(nLinha + 0020, aColImp[02]+0005, "Operação", oFont10N, 100,,, 0)
	oPrint:Say(nLinha + 0020, aColImp[04]+0005, "Data", oFont10N, 100,,, 0)
	oPrint:Say(nLinha + 0020, aColImp[06]+0005, "Hora Início", oFont10N, 100,,, 0)
	oPrint:Say(nLinha + 0020, aColImp[08]+0005, "Hora Fim", oFont10N, 100,,, 0)
	oPrint:Say(nLinha + 0020, aColImp[10]+0005, "Total Horas", oFont10N, 100,,, 0)
	oPrint:Say(nLinha + 0020, aColImp[12]+0005, "Qtd. Boas", oFont10N, 100,,, 0)
	oPrint:Say(nLinha + 0020, aColImp[14]+0005, "Qtd. Ref.", oFont10N, 100,,, 0)
	oPrint:Say(nLinha + 0020, aColImp[16]+0005, "% Rejeição", oFont10N, 100,,, 0)
	oPrint:Say(nLinha + 0020, aColImp[18]+0005, "Aprov. p/ OP", oFont10N, 100,,, 0)
	
	oPrint:Box(nLinha, nColuna, nLinha + 0070, aColImp[20])
	oPrint:Box(nLinha, aColImp[02], nLinha + 0070, aColImp[04])
	oPrint:Box(nLinha, aColImp[04], nLinha + 0070, aColImp[06])
	oPrint:Box(nLinha, aColImp[06], nLinha + 0070, aColImp[08])
	oPrint:Box(nLinha, aColImp[08], nLinha + 0070, aColImp[10])
	oPrint:Box(nLinha, aColImp[10], nLinha + 0070, aColImp[12])
	oPrint:Box(nLinha, aColImp[12], nLinha + 0070, aColImp[14])
	oPrint:Box(nLinha, aColImp[14], nLinha + 0070, aColImp[16])
	oPrint:Box(nLinha, aColImp[16], nLinha + 0070, aColImp[18])
	oPrint:Box(nLinha, aColImp[18], nLinha + 0070, aColImp[20])
	
	nLinha += 0070
		
	For nR := 1 to 15	
		oPrint:Box(nLinha, nColuna, nLinha + 0090, aColImp[20])
		oPrint:Box(nLinha, aColImp[02], nLinha + 0090, aColImp[04])
		oPrint:Box(nLinha, aColImp[04], nLinha + 0090, aColImp[06])
		oPrint:Box(nLinha, aColImp[06], nLinha + 0090, aColImp[08])
		oPrint:Box(nLinha, aColImp[08], nLinha + 0090, aColImp[10])
		oPrint:Box(nLinha, aColImp[10], nLinha + 0090, aColImp[12])
		oPrint:Box(nLinha, aColImp[12], nLinha + 0090, aColImp[14])
		oPrint:Box(nLinha, aColImp[14], nLinha + 0090, aColImp[16])
		oPrint:Box(nLinha, aColImp[16], nLinha + 0090, aColImp[18])
		oPrint:Box(nLinha, aColImp[18], nLinha + 0090, aColImp[20])
		
		nLinha += 0090
		
		If nLinha >= 2700
			oPrint:EndPage()	
			impCabec()		
			
			oPrint:Say(nLinha + 0020, nColuna+0005, "Operador", oFont10N, 100,,, 0)	
			oPrint:Say(nLinha + 0020, aColImp[02]+0005, "Operação", oFont10N, 100,,, 0)
			oPrint:Say(nLinha + 0020, aColImp[04]+0005, "Data", oFont10N, 100,,, 0)
			oPrint:Say(nLinha + 0020, aColImp[06]+0005, "Hora Início", oFont10N, 100,,, 0)
			oPrint:Say(nLinha + 0020, aColImp[08]+0005, "Hora Fim", oFont10N, 100,,, 0)
			oPrint:Say(nLinha + 0020, aColImp[10]+0005, "Total Horas", oFont10N, 100,,, 0)
			oPrint:Say(nLinha + 0020, aColImp[12]+0005, "Qtd. Boas", oFont10N, 100,,, 0)
			oPrint:Say(nLinha + 0020, aColImp[14]+0005, "Qtd. Ref.", oFont10N, 100,,, 0)
			oPrint:Say(nLinha + 0020, aColImp[16]+0005, "% Rejeição", oFont10N, 100,,, 0)
			oPrint:Say(nLinha + 0020, aColImp[18]+0005, "Aprov. p/ OP", oFont10N, 100,,, 0)
			
			oPrint:Box(nLinha, nColuna, nLinha + 0070, aColImp[20])
			oPrint:Box(nLinha, aColImp[02], nLinha + 0070, aColImp[04])
			oPrint:Box(nLinha, aColImp[04], nLinha + 0070, aColImp[06])
			oPrint:Box(nLinha, aColImp[06], nLinha + 0070, aColImp[08])
			oPrint:Box(nLinha, aColImp[08], nLinha + 0070, aColImp[10])
			oPrint:Box(nLinha, aColImp[10], nLinha + 0070, aColImp[12])
			oPrint:Box(nLinha, aColImp[12], nLinha + 0070, aColImp[14])
			oPrint:Box(nLinha, aColImp[14], nLinha + 0070, aColImp[16])
			oPrint:Box(nLinha, aColImp[16], nLinha + 0070, aColImp[18])
			oPrint:Box(nLinha, aColImp[18], nLinha + 0070, aColImp[20])
			
			nLinha += 0070			
		EndIf
	Next
	

Return

Static Function impLista()	
	Local nCout	:= 0
	nLinha += 0070
	
	oPrint:Say(nLinha + 0020, (nColuna+aColImp[20])/2, "LISTA DE MATERIAIS DA ORDEM DE FABRICAÇÃO", oFont10N, 100,,, 2)
	oPrint:Box(nLinha, nColuna, nLinha + 0070, aColImp[20])	
	
	nLinha += 0070

	oPrint:Say(nLinha + 0020, nColuna+0005, "Lote", oFont10N, 100,,, 0)	
	oPrint:Say(nLinha + 0020, aColImp[02]+0005, "Posicao", oFont10N, 100,,, 0)
	oPrint:Say(nLinha + 0020, aColImp[04]+0005, "Código", oFont10N, 100,,, 0)
	oPrint:Say(nLinha + 0020, aColImp[08]+0005, "Descricao", oFont10N, 100,,, 0)
	oPrint:Say(nLinha + 0020, aColImp[15]+0005, "Unidade", oFont10N, 100,,, 0)	
	oPrint:Say(nLinha + 0020, aColImp[17]+0005, "Quantidade", oFont10N, 100,,, 0)
	
	oPrint:Box(nLinha, nColuna, nLinha + 0070, aColImp[02])
	oPrint:Box(nLinha, aColImp[02], nLinha + 0070, aColImp[04])
	oPrint:Box(nLinha, aColImp[04], nLinha + 0070, aColImp[08])
	oPrint:Box(nLinha, aColImp[08], nLinha + 0070, aColImp[15])
	oPrint:Box(nLinha, aColImp[15], nLinha + 0070, aColImp[17])
	oPrint:Box(nLinha, aColImp[17], nLinha + 0070, aColImp[20])
			
	nLinha += 0070
	
	dbSelectArea("SD4")
	dbSetOrder(2)//D4_FILIAL+D4_OP+D4_COD+D4_LOCAL
	dbSeek(xFilial("SD4")+SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN)
	While SD4->(!Eof()) .AND. alltrim(SC2->C2_NUM+SC2->C2_ITEM+SC2->C2_SEQUEN) == alltrim(SD4->D4_OP)
		nCout++
		
		dbSelectArea("SB1")
		dbSetOrder(1)
		dbSeek(xFilial("SB1")+SD4->D4_COD)
		
		oPrint:Say(nLinha + 0020, nColuna+0005, SD4->D4_LOTECTL, oFont10, 100,,, 0)	
		oPrint:Say(nLinha + 0020, aColImp[02]+0005, alltrim(cValtoChar(nCout)), oFont10, 100,,, 0)
		oPrint:Say(nLinha + 0020, aColImp[04]+0005, SD4->D4_COD, oFont10, 100,,, 0)
		oPrint:Say(nLinha + 0020, aColImp[08]+0005, SB1->B1_DESC, oFont10, 100,,, 0)
		oPrint:Say(nLinha + 0020, aColImp[15]+0005, SB1->B1_UM, oFont10, 100,,, 0)	
		oPrint:Say(nLinha + 0020, aColImp[17]+0005, alltrim(Transform(SD4->D4_QUANT, "@E 999,999.99")), oFont10, 100,,, 0)
		
		oPrint:Box(nLinha, nColuna, nLinha + 0070, aColImp[02])
		oPrint:Box(nLinha, aColImp[02], nLinha + 0070, aColImp[04])
		oPrint:Box(nLinha, aColImp[04], nLinha + 0070, aColImp[08])
		oPrint:Box(nLinha, aColImp[08], nLinha + 0070, aColImp[15])
		oPrint:Box(nLinha, aColImp[15], nLinha + 0070, aColImp[17])
		oPrint:Box(nLinha, aColImp[17], nLinha + 0070, aColImp[20])
			
		nLinha += 0070
		
		If nLinha >= 2700
			oPrint:EndPage()	
			impCabec()		
			
			oPrint:Say(nLinha + 0020, nColuna+0005, "Lote", oFont10N, 100,,, 0)	
			oPrint:Say(nLinha + 0020, aColImp[02]+0005, "Posicao", oFont10N, 100,,, 0)
			oPrint:Say(nLinha + 0020, aColImp[04]+0005, "Código", oFont10N, 100,,, 0)
			oPrint:Say(nLinha + 0020, aColImp[08]+0005, "Descricao", oFont10N, 100,,, 0)
			oPrint:Say(nLinha + 0020, aColImp[15]+0005, "Unidade", oFont10N, 100,,, 0)	
			oPrint:Say(nLinha + 0020, aColImp[17]+0005, "Quantidade", oFont10N, 100,,, 0)
			
			oPrint:Box(nLinha, nColuna, nLinha + 0070, aColImp[02])
			oPrint:Box(nLinha, aColImp[02], nLinha + 0070, aColImp[04])
			oPrint:Box(nLinha, aColImp[04], nLinha + 0070, aColImp[08])
			oPrint:Box(nLinha, aColImp[08], nLinha + 0070, aColImp[15])
			oPrint:Box(nLinha, aColImp[15], nLinha + 0070, aColImp[17])
			oPrint:Box(nLinha, aColImp[17], nLinha + 0070, aColImp[20])
			
			nLinha += 0070			
		EndIf
	
		SD4->(dbskip())	
	EndDo

Return

Static Function impFim()
	nLinha += 0070
	
	oPrint:Say(nLinha + 0020, (nColuna+aColImp[20])/2, "PROCESSOS NECESSARIOS", oFont10N, 100,,, 2)
	oPrint:Box(nLinha, nColuna, nLinha + 0070, aColImp[20])	
	
	nLinha += 0070

	oPrint:Say(nLinha + 0020, nColuna+0005, "FORNO", oFont10N, 100,,, 0)		
	oPrint:Say(nLinha + 0020, aColImp[08]+0005, "CORTE DAS PONTAS", oFont10N, 100,,, 0)	
	oPrint:Say(nLinha + 0020, aColImp[16]+0005, "OBSERVAÇÕES", oFont10N, 100,,, 0)	
	
	oPrint:Box(nLinha, nColuna, nLinha + 0070, aColImp[04])
	oPrint:Box(nLinha, aColImp[04], nLinha + 0070, aColImp[08])
	oPrint:Box(nLinha, aColImp[08], nLinha + 0070, aColImp[12])
	oPrint:Box(nLinha, aColImp[12], nLinha + 0070, aColImp[16])
	oPrint:Box(nLinha, aColImp[16], nLinha + 0280, aColImp[20])
	
	nLinha += 0070

	oPrint:Say(nLinha + 0020, nColuna+0005, "TREFILA", oFont10N, 100,,, 0)		
	oPrint:Say(nLinha + 0020, aColImp[08]+0005, "EMBALAGEM", oFont10N, 100,,, 0)		
	
	oPrint:Box(nLinha, nColuna, nLinha + 0070, aColImp[04])
	oPrint:Box(nLinha, aColImp[04], nLinha + 0070, aColImp[08])
	oPrint:Box(nLinha, aColImp[08], nLinha + 0070, aColImp[12])
	oPrint:Box(nLinha, aColImp[12], nLinha + 0070, aColImp[16])
	
	nLinha += 0070

	oPrint:Say(nLinha + 0020, nColuna+0005, "EMBOBINAMENTO", oFont10N, 100,,, 0)		
	oPrint:Say(nLinha + 0020, aColImp[08]+0005, "ETIQUETA", oFont10N, 100,,, 0)	
	
	oPrint:Box(nLinha, nColuna, nLinha + 0070, aColImp[04])
	oPrint:Box(nLinha, aColImp[04], nLinha + 0070, aColImp[08])
	oPrint:Box(nLinha, aColImp[08], nLinha + 0070, aColImp[12])
	oPrint:Box(nLinha, aColImp[12], nLinha + 0070, aColImp[16])
	
	nLinha += 0070

	oPrint:Say(nLinha + 0020, nColuna+0005, "MAQ. CORTE", oFont10N, 100,,, 0)		
	oPrint:Say(nLinha + 0020, aColImp[08]+0005, "TAMBOR", oFont10N, 100,,, 0)		
	
	oPrint:Box(nLinha, nColuna, nLinha + 0070, aColImp[04])
	oPrint:Box(nLinha, aColImp[04], nLinha + 0070, aColImp[08])
	oPrint:Box(nLinha, aColImp[08], nLinha + 0070, aColImp[12])
	oPrint:Box(nLinha, aColImp[12], nLinha + 0070, aColImp[16])
	
	nLinha += 0140
	
	oPrint:Say(nLinha + 0020, nColuna+0005, "Produção (Data/Assinatura)", oFont10N, 100,,, 0)		
	oPrint:Say(nLinha + 0020, aColImp[06]+0005, "Controle de Qualidade (Data/Assinatura)", oFont10N, 100,,, 0)
	oPrint:Say(nLinha + 0020, aColImp[14]+0005, "PCP (Data/Assinatura)", oFont10N, 100,,, 0)
			
	
	oPrint:Box(nLinha, nColuna, nLinha + 00210, aColImp[06])
	oPrint:Box(nLinha, aColImp[06], nLinha + 00210, aColImp[14])
	oPrint:Box(nLinha, aColImp[14], nLinha + 00210, aColImp[20])	
	
	
	oPrint:EndPage()	

Return