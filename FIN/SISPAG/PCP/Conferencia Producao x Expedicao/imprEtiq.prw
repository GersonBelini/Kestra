#Include 'Protheus.ch'
#Include 'TopConn.ch'

#define GRUPO_ER					"'PA06','PI01'"
#define GRUPO_AT					"'PA07','PI02'"
/*/{Protheus.doc} imprEtiq

Imprime etiqueta.
	
@author André Oquendo
@since 27/04/2015

/*/

User Function imprEtiq()
	Local lFinal 		:= .T.
	Local cLayout		:= ""
	
	While lFinal
		If ValidPerg()
			cLayout := If(valType(MV_PAR06) == 'N',cvaltochar(MV_PAR06),substr(MV_PAR06,1,1))			
			If cLayout == "1"
				imprAT()
			ElseIf cLayout == "2"
				imprER()
			EndIf			
		Else
			lFinal := .F.
		EndIf	
	EndDo

Return

/*/{Protheus.doc} imprAT

Imprime etiqueta AT.
	
@author André Oquendo
@since 27/04/2015

/*/

Static Function imprAT()	
	Local cOPDe		:= MV_PAR01
	Local cOPAte		:= MV_PAR02
	Local cLoteDe		:= MV_PAR03
	Local cLoteAte	:= MV_PAR04
	Local nQtdEtq		:= MV_PAR05
	Local cSequencia	:= ""
	Local cNorma1		:= ""
	Local cNorma2		:= ""
	Local cNorma3		:= ""
	Local cLogo		:= ""
	Local cDesc1		:= ""
	Local cDesc2		:= ""
	Local nPosDiam	:= 0
	cLogo += "~DG000.GRF,01920,020,,::::::::::::::::::V0A2,U0D56,T03FHFC0,T0H5D5C0,T0KF8,"
	cLogo += "H0H7H037K757J7F7L780H0F740040,H07F803FEFIFEFRFE0H0HFE01F8,"
	cLogo += "H05D005D6D5D5D5D5D5D5D5D5D5D001D5C0114,H07F807FCFXFC01FFE0206,H0H7H0F747L757P74017760504,"
	cLogo += "H07F80FF8FXFE01FFE09F2,H0H581D705D5D5D40155D5D5D5D5C015D501H1,H07F81FF0FKFE01FPF03FHF0913,"
	cLogo += "H0H7037607K74007P7037H70171,H07F83FE0FKFC007FKFC3FF03FHF89E3,H05D055C0550055C0I0HD015C15505D1D0161,"
	cLogo += "H07F87FC0FF00FFE0I0HF83FC0FF07F3F8933,H0H70770077007760I0F70174077077378112,"
	cLogo += "H07F8FF80FF00FHF80H0HF83FC0FF07F3F8D1A,H0H595D005D005D5C0H0D501D405D055154404,"
	cLogo += "H07F9FF00FF00FIF800FF83FC0FF0FF3FC60C,H0H7376007755F7H7F007701740770771741F0,"
	cLogo += "H07FBFE00FNFC0FF83FC0FF0FE1FC0E0,H05D5D40055D5D5D5D40DD015C1D505C1D40,H07FHFC00FIFBFJF0FF83FE3FE1FE0FE0,"
	cLogo += "H0J7I0J717J78770177F761740760,H07FHFC00FIF8FJF8FF83FIFE1FC0FE0,H0H5D5C005D5D055D5D4D501D5D541D40DD0,"
	cLogo += "H07FBFE00FIF81FIFCFF83FIF83FC0FF0,H0H7376007I7H057H7477017I701740770,H07FBFF00FIF800FHFEFF83FHFC03F807E0,"
	cLogo += "H05D1D500550J01D5CDD015D5C015H5D50,H07F9FF80FF0K0HFEFF83FHFE07FJF8,H0H707740770K0H767701757707K70,"
	cLogo += "H07F8FFC0FF0020H07FEFF83FCFF07FJF8,H0H585D405D0010H05D4D501D4D505D5D5D0,H07F87FE0FF0038007FEFF83FCFF8FKFC,"
	cLogo += "H0H7017507J74007747701747747K74,H07F83FF0FJFE00FFEFF83FC7FCFKFC,H05D015D055D5D501D5CDD015C1D4D40015C,"
	cLogo += "H07F81FF8FKFA3FFEFF83FC3FHFE201FE,H0H7H0H747O747701743757600176,H07F80FFEFOF8FF83FC1FHFE001FE,"
	cLogo += "H0H58055CDD5D5D5D5D8D501D41DD5C001D4,H07F803FEFOF0FF83FC0FHFE0H0HF,H0H7H017Q7077017407H740H075,"
	cLogo += "H07F803FPFE0FE83FC0FHFC0H0HF,S0H5D5D40,S03FIF80,T0F7H7,T03FFC,,:::::::::::::::::::::::::^XA^MMT^PW799^LL0400^LS0^FT0,96^XG000.GRF,1,1^FS"
 	
 
	
	cQuery := " SELECT TOP (1)																" + CRLF		
	cQuery += " B1_DESC, C2_ZZASME, C2_ZZNDIN, C2_ZZNEPR, B1_CODBAR, B1_CONV,				" + CRLF
	cQuery += " C2_ZZNCORR, C2_ZZREQUA, C2_PRODUTO, C2_QUANT, D3_OP, B1_UM, D3_EMISSAO	" + CRLF
	cQuery += " FROM " + RetSqlName("SD3") + " SD3 											" + CRLF
	cQuery += " INNER JOIN " + RetSqlName("SB1") + " SB1 ON									" + CRLF
	cQuery += " B1_COD = D3_COD AND B1_GRUPO IN ("+GRUPO_AT+") AND		" + CRLF
	cQuery += " SB1.D_E_L_E_T_ = ' '															" + CRLF
	cQuery += " INNER JOIN " + RetSqlName("SC2") + " SC2 ON									" + CRLF
	cQuery += " C2_NUM + C2_ITEM + C2_SEQUEN = D3_OP AND C2_PRODUTO = D3_COD AND		" + CRLF
	cQuery += " SC2.D_E_L_E_T_ = ' '															" + CRLF	
	cQuery += " WHERE 																			" + CRLF
	cQuery += "	   	SD3.D_E_L_E_T_ 	= 	' ' 												" + CRLF		
	cQuery += "	   	AND D3_OP >= 	'"+cOPDe+"'												" + CRLF
	cQuery += "	   	AND D3_OP <= 	'"+cOPAte+"'												" + CRLF
	cQuery += "	   	AND D3_LOTECTL >= 	'"+cLoteDe+"'										" + CRLF
	cQuery += "	   	AND D3_LOTECTL <= 	'"+cLoteAte+"'									" + CRLF
	cQuery += "	   	AND D3_CF = 'PR0'															" + CRLF
	cQuery += "	   	AND D3_ESTORNO = ' '													" + CRLF
	cQuery += "	   	ORDER BY D3_EMISSAO													" + CRLF
			
	TcQuery cQuery New Alias "QRYAT"
	QRYAT->(DbGoTop())
	While QRYAT->(!Eof())	
		If QRYAT->C2_ZZASME == "000000" .AND. QRYAT->C2_ZZNDIN == "000000" .AND. QRYAT->C2_ZZNEPR == "000000"
			msgAlert("Produto: "+alltrim(QRYAT->B1_DESC)+" sem normas cadastradas. Etiqueta não gerada!")
			QRYAT->(DbSkip())
			Loop
		EndIf
		dbSelectArea("SZ1")
		dbSetOrder(1)
		If dbSeek(xFilial("SZ1")+QRYAT->C2_ZZNDIN) .AND. QRYAT->C2_ZZNDIN != '000000'	
			cNorma3 := SZ1->Z1_DESC
		Else
			cNorma3 := ""
		EndIf
		
		dbSelectArea("SZ2")
		dbSetOrder(1)
		If dbSeek(xFilial("SZ2")+QRYAT->C2_ZZNEPR) .AND. QRYAT->C2_ZZNEPR != '000000'	
			cNorma3 := SZ2->Z2_DESC
		Else
			cNorma3 := ""
		EndIf
		
		dbSelectArea("SZ3")
		dbSetOrder(1)
		If dbSeek(xFilial("SZ3")+QRYAT->C2_ZZASME) .AND. QRYAT->C2_ZZASME != '000000'	
			cNorma1 := SZ3->Z3_DESC1
			cNorma2 := SZ3->Z3_DESC2 
		Else
			cNorma1 := ""
			cNorma2 := "" 
		EndIF
		cPorta := "LPT1"
		MSCBPRINTER("Z4M",cPorta,,,.F.,,,,,,.T.)
		nPosDiam := At("Ø",QRYAT->B1_DESC)
		cDesc1 := subStr(QRYAT->B1_DESC,1,nPosDiam-1)
		cDesc2 := subStr(QRYAT->B1_DESC,nPosDiam+1) 
		For nX := 1 to nQtdEtq
			cSequencia := retSeqEti(QRYAT->D3_OP, QRYAT->C2_PRODUTO)
			salvaSeq(QRYAT->D3_OP, QRYAT->C2_PRODUTO,QRYAT->C2_QUANT,cSequencia)
			MSCBBEGIN(1,6)
			MSCBWRITE(cLogo)
			MSCBWRITE("^FT184,65^ABN,44,14^FH\^FD"+cDesc1+"^FS")
			MSCBWRITE("^FT184,100^ABN,44,14^FH\^FDØ"+cDesc2+"^FS")
			MSCBWRITE("^FT184,142^AAN,27,10^FH\^FD"+cNorma1+"^FS")
			MSCBWRITE("^FT184,173^AAN,27,10^FH\^FD"+cNorma2+"^FS")
			MSCBWRITE("^FT184,205^AAN,27,10^FH\^FD"+cNorma3+"^FS")
			
			
			MSCBLineV(021,001,0049)
			MSCBSAY(022,001,"Produto / Dimensão","N","B","010,006")
			//MSCBSAY(023,003,subStr(QRYAT->B1_DESC,1,30),"N","B","035,015")			
			//MSCBSAY(023,008,subStr(QRYAT->B1_DESC,31,30),"N","B","035,015")
			
			MSCBSAY(022,013,"Norma","N","B","010,006")
			//MSCBSAY(023,015,cNorma1,"N","B","025,015")
			//MSCBSAY(023,019,cNorma2,"N","B","025,015")		
			//MSCBSAY(023,023,cNorma3,"N","B","025,015")
			
			MSCBSAYBAR(026,027,QRYAT->B1_CODBAR,"C","MB04",5,.F.,.T.,.F.,,3,2)
			
			MSCBSAYBAR(023,036,QRYAT->C2_ZZNCORR+QRYAT->C2_ZZREQUA+cSequencia,"C","MB07",5,.F.,.T.,.F.,,2,2)
			
			MSCBSAY(023,045,QRYAT->C2_PRODUTO,"N","B","025,015")
			
			MSCBSAY(073,042,"No. de Controle","N","B","010,006")
			MSCBSAY(065,045,QRYAT->C2_ZZNCORR+QRYAT->C2_ZZREQUA,"N","B","035,020")
			
			MSCBSAY(018,012,"CNPJ: "+Transform(SM0->M0_CGC,"@r 99.999.999/9999-99"),"R","B","025,010")
			MSCBSAY(013,012,"Peso Liq.","R","B","010,006")
			If MV_PAR07 > 0
				MSCBSAY(012,025,alltrim(Transform(MV_PAR07, "@E 999,999,999.99"))+" "+QRYAT->B1_UM,"R","B","035,015") 
			Else
				MSCBSAY(012,025,alltrim(Transform(QRYAT->B1_CONV, "@E 999,999,999.99"))+" "+QRYAT->B1_UM,"R","B","035,015")				
			EndIf
			
			MSCBSAY(006,012,"Data Fabricação","R","B","010,006")
			MSCBSAY(005,035,DtoC(StoD(QRYAT->D3_EMISSAO)),"R","B","025,010")
			
			MSCBEND()
		Next
		MSCBCLOSEPRINTER()
		QRYAT->(DbSkip())			
	EndDo	
	QRYAT->(DbCloseArea())
Return


/*/{Protheus.doc} imprER

Imprime etiqueta ER.
	
@author André Oquendo
@since 27/04/2015

/*/

Static Function imprER()	
	Local cOPDe		:= MV_PAR01
	Local cOPAte		:= MV_PAR02
	Local cLoteDe		:= MV_PAR03
	Local cLoteAte	:= MV_PAR04
	Local nQtdEtq		:= MV_PAR05
	Local cSequencia	:= ""
	Local cLogo		:= ""
	Local cDesc1		:= ""
	Local cDesc2		:= ""
	Local nPosDiam	:= 0
	cLogo += "~DG000.GRF,01920,020,,::::::::::::::::::V0A2,U0D56,T03FHFC0,T0H5D5C0,T0KF8,"
	cLogo += "H0H7H037K757J7F7L780H0F740040,H07F803FEFIFEFRFE0H0HFE01F8,"
	cLogo += "H05D005D6D5D5D5D5D5D5D5D5D5D001D5C0114,H07F807FCFXFC01FFE0206,H0H7H0F747L757P74017760504,"
	cLogo += "H07F80FF8FXFE01FFE09F2,H0H581D705D5D5D40155D5D5D5D5C015D501H1,H07F81FF0FKFE01FPF03FHF0913,"
	cLogo += "H0H7037607K74007P7037H70171,H07F83FE0FKFC007FKFC3FF03FHF89E3,H05D055C0550055C0I0HD015C15505D1D0161,"
	cLogo += "H07F87FC0FF00FFE0I0HF83FC0FF07F3F8933,H0H70770077007760I0F70174077077378112,"
	cLogo += "H07F8FF80FF00FHF80H0HF83FC0FF07F3F8D1A,H0H595D005D005D5C0H0D501D405D055154404,"
	cLogo += "H07F9FF00FF00FIF800FF83FC0FF0FF3FC60C,H0H7376007755F7H7F007701740770771741F0,"
	cLogo += "H07FBFE00FNFC0FF83FC0FF0FE1FC0E0,H05D5D40055D5D5D5D40DD015C1D505C1D40,H07FHFC00FIFBFJF0FF83FE3FE1FE0FE0,"
	cLogo += "H0J7I0J717J78770177F761740760,H07FHFC00FIF8FJF8FF83FIFE1FC0FE0,H0H5D5C005D5D055D5D4D501D5D541D40DD0,"
	cLogo += "H07FBFE00FIF81FIFCFF83FIF83FC0FF0,H0H7376007I7H057H7477017I701740770,H07FBFF00FIF800FHFEFF83FHFC03F807E0,"
	cLogo += "H05D1D500550J01D5CDD015D5C015H5D50,H07F9FF80FF0K0HFEFF83FHFE07FJF8,H0H707740770K0H767701757707K70,"
	cLogo += "H07F8FFC0FF0020H07FEFF83FCFF07FJF8,H0H585D405D0010H05D4D501D4D505D5D5D0,H07F87FE0FF0038007FEFF83FCFF8FKFC,"
	cLogo += "H0H7017507J74007747701747747K74,H07F83FF0FJFE00FFEFF83FC7FCFKFC,H05D015D055D5D501D5CDD015C1D4D40015C,"
	cLogo += "H07F81FF8FKFA3FFEFF83FC3FHFE201FE,H0H7H0H747O747701743757600176,H07F80FFEFOF8FF83FC1FHFE001FE,"
	cLogo += "H0H58055CDD5D5D5D5D8D501D41DD5C001D4,H07F803FEFOF0FF83FC0FHFE0H0HF,H0H7H017Q7077017407H740H075,"
	cLogo += "H07F803FPFE0FE83FC0FHFC0H0HF,S0H5D5D40,S03FIF80,T0F7H7,T03FFC,,:::::::::::::::::::::::::^XA^MMT^PW799^LL0400^LS0^FT0,96^XG000.GRF,1,1^FS"
 	
	cQuery := " SELECT 	TOP (1)																		" + CRLF		
	cQuery += " B1_DESC, C2_ZZASME, C2_ZZNDIN, C2_ZZNEPR, B1_CODBAR, B1_CONV,						" + CRLF
	cQuery += " C2_ZZNCORR, C2_ZZREQUA, C2_PRODUTO, C2_QUANT, D3_OP, B1_UM, D3_EMISSAO,			" + CRLF
	cQuery += " B1_ZZTSMIN, B1_ZZTSMAX, B1_ZZSOMIN, B1_ZZSOMAX, B1_ZZCRMIN, B1_ZZCRMAX,			" + CRLF
	cQuery += " B1_ZZVZMIN, B1_ZZVZMAX, B1_ZZGASPR												" + CRLF		
	cQuery += " FROM " + RetSqlName("SD3") + " SD3 												" + CRLF
	cQuery += " INNER JOIN " + RetSqlName("SB1") + " SB1 ON										" + CRLF
	cQuery += " B1_COD = D3_COD AND B1_GRUPO IN ("+GRUPO_ER+") AND							" + CRLF
	cQuery += " SB1.D_E_L_E_T_ = ' '															" + CRLF
	cQuery += " INNER JOIN " + RetSqlName("SC2") + " SC2 ON										" + CRLF
	cQuery += " C2_NUM + C2_ITEM + C2_SEQUEN = D3_OP AND C2_PRODUTO = D3_COD AND			" + CRLF
	cQuery += " SC2.D_E_L_E_T_ = ' '															" + CRLF	
	cQuery += " WHERE 																			" + CRLF
	cQuery += "	   	SD3.D_E_L_E_T_ 	= 	' ' 													" + CRLF		
	cQuery += "	   	AND D3_OP >= 	'"+cOPDe+"'													" + CRLF
	cQuery += "	   	AND D3_OP <= 	'"+cOPAte+"'												" + CRLF
	cQuery += "	   	AND D3_LOTECTL >= 	'"+cLoteDe+"'											" + CRLF
	cQuery += "	   	AND D3_LOTECTL <= 	'"+cLoteAte+"'											" + CRLF	
	cQuery += "	   	AND D3_CF = 'PR0' 															" + CRLF
	cQuery += "	   	AND D3_ESTORNO = ' ' 														" + CRLF
	cQuery += "	   	ORDER BY D3_EMISSAO															" + CRLF
		
	
	TcQuery cQuery New Alias "QRYER"
	QRYER->(DbGoTop())
	While QRYER->(!Eof())		
		If empty(QRYER->C2_ZZASME) .AND. empty(QRYER->C2_ZZNDIN) .AND. empty(QRYER->C2_ZZNEPR)
			msgAlert("Produto: "+alltrim(QRYER->B1_DESC)+" sem normas cadastradas. Etiqueta não gerada!")
			QRYER->(DbSkip())
			Loop
		EndIf
		dbSelectArea("SZ1")
		dbSetOrder(1)
		If dbSelectArea(xFilial("SZ1")+QRYER->C2_ZZNDIN)		
			cNorma3 := SZ1->Z1_DESC
		Else
			cNorma3 := ""
		EndIf
		
		dbSelectArea("SZ2")
		dbSetOrder(1)
		If dbSelectArea(xFilial("SZ2")+QRYER->C2_ZZNEPR)
			cNorma3 := SZ2->Z2_DESC
		Else
			cNorma3 := ""
		EndIf
		
		dbSelectArea("SZ3")
		dbSetOrder(1)
		If dbSelectArea(xFilial("SZ3")+QRYER->C2_ZZASME)
			cNorma1 := SZ3->Z3_DESC1
			cNorma2 := SZ3->Z3_DESC2 
		Else
			cNorma1 := ""
			cNorma2 := "" 
		EndIF
		cPorta := "LPT1"
		MSCBPRINTER("Z4M",cPorta,,,.F.,,,,,,.T.)
		nPosDiam := At("Ø",QRYAT->B1_DESC)
		cDesc1 := subStr(QRYAT->B1_DESC,1,nPosDiam-1)
		cDesc2 := subStr(QRYAT->B1_DESC,nPosDiam+1) 
		For nX := 1 to nQtdEtq
			cSequencia := retSeqEti(QRYER->D3_OP, QRYER->C2_PRODUTO)
			salvaSeq(QRYER->D3_OP, QRYER->C2_PRODUTO,QRYER->C2_QUANT,cSequencia)
			MSCBBEGIN(1,6)
			MSCBWRITE(cLogo)
			MSCBWRITE("^FT184,65^ABN,44,14^FH\^FD"+cDesc1+"^FS")
			MSCBWRITE("^FT184,100^ABN,44,14^FH\^FDØ"+cDesc2+"^FS")
			MSCBWRITE("^FT184,142^AAN,27,10^FH\^FD"+cNorma1+"^FS")
			MSCBWRITE("^FT184,173^AAN,27,10^FH\^FD"+cNorma2+"^FS")
			MSCBWRITE("^FT184,205^AAN,27,10^FH\^FD"+cNorma3+"^FS")
			
			MSCBLineV(021,001,0049)
			MSCBSAY(022,001,"Produto / Dimensão","N","B","010,006")
			//MSCBSAY(023,003,subStr(QRYER->B1_DESC,1,30),"N","B","035,015")			
			//MSCBSAY(023,008,subStr(QRYER->B1_DESC,31,30),"N","B","035,015")
			
			MSCBSAY(022,013,"Norma","N","B","010,006")
			//MSCBSAY(023,015,cNorma1,"N","B","025,015")
			//MSCBSAY(023,019,cNorma2,"N","B","025,015")		
			//MSCBSAY(023,023,cNorma3,"N","B","025,015")
			
			MSCBSAYBAR(026,027,QRYER->B1_CODBAR,"C","MB04",5,.F.,.T.,.F.,,3,2)
			
			MSCBSAYBAR(023,036,QRYER->C2_ZZNCORR+QRYER->C2_ZZREQUA+cSequencia,"C","MB07",5,.F.,.T.,.F.,,2,2)
			
			MSCBSAY(023,045,QRYER->C2_PRODUTO,"N","B","025,015")
			
			MSCBSAY(073,042,"No. de Controle","N","B","010,006")
			MSCBSAY(065,045,QRYER->C2_ZZNCORR+QRYER->C2_ZZREQUA,"N","B","035,020")
			
			MSCBSAY(018,012,"CNPJ: "+Transform(SM0->M0_CGC,"@r 99.999.999/9999-99"),"R","B","025,010")
			If MV_PAR07 > 0
				MSCBSAY(012,025,alltrim(Transform(MV_PAR07, "@E 999,999,999.99"))+" "+QRYAT->B1_UM,"R","B","035,015") 
			Else
				MSCBSAY(012,025,alltrim(Transform(QRYAT->B1_CONV, "@E 999,999,999.99"))+" "+QRYAT->B1_UM,"R","B","035,015")				
			EndIf
				
			MSCBBOX(002,009,013,049)
			
			MSCBSAY(011,010,"Tensão(V)","R","B","008,002")
			MSCBSAY(011,021,"Stick-out(mm)","R","B","008,002")
			MSCBSAY(011,036,"Corrente(A)","R","B","008,004")
			
			MSCBSAY(009,010,QRYER->B1_ZZTSMIN + " - " +QRYER->B1_ZZTSMAX,"R","B","008,002")
			MSCBSAY(009,021,QRYER->B1_ZZSOMIN + " - " +QRYER->B1_ZZSOMAX,"R","B","008,002")
			MSCBSAY(009,036,QRYER->B1_ZZCRMIN + " - " +QRYER->B1_ZZCRMAX,"R","B","008,004")
			
			MSCBSAY(007,010,"Gás de Proteção","R","B","008,002")
			MSCBSAY(005,010,QRYER->B1_ZZGASPR,"R","B","008,002")
			
			MSCBSAY(003,010,"Vazão(l/mm) " + QRYER->B1_ZZVZMIN + " - " +QRYER->B1_ZZVZMAX,"R","B","008,002")
						
			MSCBEND()
		Next
		MSCBCLOSEPRINTER()
		QRYER->(DbSkip())			
	EndDo	
	QRYER->(DbCloseArea())
Return

/*/{Protheus.doc} retSeqEti

Retorna o numero da proxima sequencia da etiqueta.
	
@author André Oquendo
@since 27/10/2015

@param cOP, String, OP a ser buscada
@param cProduto, String, Produto a ser buscado

@return String Sequencia
/*/

Static Function retSeqEti(cOP, cProduto)
	Local cSequencia := '0001'
	
	cQuery := " SELECT 														" + CRLF		
	cQuery += "	TOP 1 Z5_SEQETI											" + CRLF
	cQuery += " FROM " + RetSqlName("SZ5") + " SZ5 						" + CRLF	
	cQuery += " WHERE 														" + CRLF
	cQuery += "	   	SZ5.D_E_L_E_T_ 	= 	' ' 							" + CRLF		
	cQuery += "	   	AND Z5_NUMOP = 	'"+cOP+"'							" + CRLF
	cQuery += "	   	AND Z5_PRODUTO = 	'"+cProduto+"'					" + CRLF
	cQuery += " ORDER BY Z5_SEQETI DESC									" + CRLF	
	
	TcQuery cQuery New Alias "QRYSEQ"
	QRYSEQ->(DbGoTop())
	If QRYSEQ->(!Eof())
		cSequencia := soma1(QRYSEQ->Z5_SEQETI)
	EndIf
	QRYSEQ->(DbCloseArea())
Return cSequencia

/*/{Protheus.doc} salvaSeq

Salva a sequencia na tabela SZ5.
	
@author André Oquendo
@since 27/10/2015

@param cOP,		 	String,		Numero da OP
@param cProduto, 		String, 		Produto
@param nQtdOP, 		Numerico, 		Quantidade da OP
@param cSeq, 			String, 		Sequencia

/*/

Static Function salvaSeq(cOP,cProduto,nQtdOP,cSeq)

	RecLock("SZ5",.T.)
		SZ5->Z5_FILIAL 	:= xFilial("SZ5")
		SZ5->Z5_NUMOP		:= cOP
		SZ5->Z5_PRODUTO	:= cProduto
		SZ5->Z5_QTDOP		:= nQtdOP
		SZ5->Z5_SEQETI	:= cSeq
	MsUnLock()
	
Return

/*/{Protheus.doc} ValidPerg

Cria o parambox das perguntas.
	
@author André Oquendo
@since 27/04/2015

@return Logico Indica devemos continuar com o processo.
/*/

Static Function ValidPerg()   

	Local aRet 		:= {}
	Local aParamBox	:= {}
	Local lRet 		:= .F. 
	Local aCombo := {"1-Arame Tubular","2-Eletrodo Revestido"}
	
	aAdd(aParamBox,{1,"OP de"	  				,space(TamSX3("D3_OP")[1])			,""					,"","SH6"	,"", 60,.F.})	// MV_PAR01
	aAdd(aParamBox,{1,"OP ate"	   				,space(TamSX3("D3_OP")[1])			,""					,"","SH6"	,"", 60,.F.})	// MV_PAR02	
	aAdd(aParamBox,{1,"Lote de" 				,space(TamSX3("D3_LOTECTL")[1])		,""					,"",""		,"", 60,.F.})	// MV_PAR03
	aAdd(aParamBox,{1,"Lote ate"	   			,space(TamSX3("D3_LOTECTL")[1])		,""					,"",""		,"", 60,.F.})	// MV_PAR04
	aAdd(aParamBox,{1,"Quantidade Etiqueta"	   	,0									,"@E 9999"			,"",""		,"", 60,.F.})	// MV_PAR05
	aAdd(aParamBox,{2,"Layout"					,1									,aCombo,50,"",.F.})	// MV_PAR06
	aAdd(aParamBox,{1,"Peso"	  			 	,0									,"@E 999,999,999.99","",""		,"", 60,.F.})	// MV_PAR07
	
	If ParamBox(aParamBox,"Dados Etiqueta",@aRet,,,,,,,"Dados Etiqueta",.T.,.T.)
		lRet := .t.
	EndIf
	                                                              
Return lRet