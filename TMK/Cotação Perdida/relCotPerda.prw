#Include 'Protheus.ch'
#Include 'TopConn.ch'

User Function relCotPerda()
	Local oReport	
	Private cPerg 		:= "ZZCORPER"	

	ValidPerg(cPerg)
	Pergunte(cPerg,.F.)
							
	oReport := RepDef()		
	oReport:PrintDialog()
Return

Static Function RepDef()
	Local oReport
	Local oVendedor
	Local oCotaLiq
	Local oTotLiq
	Local cTitulo		:= "Relatório de Cotaçoes Perdidas"
		
	
	oReport := TReport():New("relCotPerda",cTitulo,cPerg,{|oReport| RepPrint( oReport )},cTitulo)               
    oReport:SetLandscape()     
       
	oCota := TRSection():New(oReport,cTitulo,{"TMPQRY"})		
	oCota:SetHeaderSection(.T.)    
	oCota:SetReadOnly()
	oCota:AutoSize()			
	                                                                                            
		TRCell():New(oCota,"Z8_FILIAL"  	,"TMPQRY", "FILIAL" 				, pesqPict("SZ8","Z8_FILIAL")	  		, tamSx3("Z8_FILIAL")[1])				
		TRCell():New(oCota,"Z8_NUM"  		,"TMPQRY", "COTACAO" 				, pesqPict("SZ8","Z8_NUM")	  			, tamSx3("Z8_NUM")[1])
		TRCell():New(oCota,"A1_NOME" 		,"TMPQRY", "CLIENTE" 				, pesqPict("SA1","A1_NOME")	  			, tamSx3("A1_NOME")[1])											
		TRCell():New(oCota,"Z8_ITEM"  		,"TMPQRY", "ITEM" 					, pesqPict("SZ8","Z8_ITEM")	  			, tamSx3("Z8_ITEM")[1])
		TRCell():New(oCota,"Z8_PRODUTO" 	,"TMPQRY", "PRODUTO" 				, pesqPict("SZ8","Z8_PRODUTO")	  		, tamSx3("Z8_PRODUTO")[1])		
		TRCell():New(oCota,"B1_DESC" 		,"TMPQRY", "DESC. PRODUTO"			, pesqPict("SZ8","B1_DESC")	  			, tamSx3("B1_DESC")[1])
		TRCell():New(oCota,"Z8_QUANT" 		,"TMPQRY", "QUANT" 					, pesqPict("SZ8","Z8_QUANT")	  		, tamSx3("Z8_QUANT")[1])
		TRCell():New(oCota,"Z8_VRUNIT" 		,"TMPQRY", "VLR. UNIT." 			, pesqPict("SZ8","Z8_VRUNIT")	  		, tamSx3("Z8_VRUNIT")[1])
		TRCell():New(oCota,"Z8_VLRITEM" 	,"TMPQRY", "VLR. TOTAL" 			, pesqPict("SZ8","Z8_VLRITEM")	  		, tamSx3("Z8_VLRITEM")[1])
		TRCell():New(oCota,"Z8_DATA" 		,"TMPQRY", "DATA" 					, pesqPict("SZ8","Z8_DATA")	  			, tamSx3("Z8_DATA")[1])
		TRCell():New(oCota,"Z8_ZZDESMT" 	,"TMPQRY", "MOTIVO" 				, pesqPict("SZ8","Z8_ZZDESMT")	  		, tamSx3("Z8_ZZDESMT")[1])
		TRCell():New(oCota,"Z8_ORIGEM" 		,"TMPQRY", "ORIGEM" 				, pesqPict("SZ8","Z8_ORIGEM")	  		, tamSx3("Z8_ORIGEM")[1])												
	
Return (oReport) 

Static Function RepPrint(oReport)	
	Local oCota		:= oReport:Section(1)
	Local nTotReg	:= 0
		
	MsAguarde({ || nTotReg := ReportQry() }, "Aguarde", "Selecionado Registros ..." )
	
    oReport:SetMeter(nTotReg)     
    
	TMPQRY->(dbGotop())   
	oCota:Init()		
	While TMPQRY->(!Eof())		
		oCota:PrintLine()			
		TMPQRY->(dbSkip())								
	EndDo	 
	oCota:Finish() 
		
    
	TMPQRY->(dbCloseArea())
Return 

Static Function ReportQry()
	Local cQuery		:= ""       
	Local cCotaDe		:= MV_PAR01
	Local cCotaAte		:= MV_PAR02
	Local dDataDe		:= MV_PAR03
	Local dDataAte		:= MV_PAR04
	
	cQuery += " SELECT " + CRLF
	cQuery += " 	Z8_FILIAL, " + CRLF
	cQuery += " 	Z8_NUM, " + CRLF
	cQuery += " 	A1_NOME, " + CRLF	
	cQuery += " 	Z8_ITEM, " + CRLF
	cQuery += " 	Z8_PRODUTO, " + CRLF
	cQuery += " 	B1_DESC, " + CRLF
	cQuery += " 	Z8_QUANT, " + CRLF
	cQuery += " 	Z8_VRUNIT, " + CRLF
	cQuery += " 	Z8_VLRITEM, " + CRLF
	cQuery += " 	Z8_DATA, " + CRLF
	cQuery += " 	Z8_ZZDESMT, " + CRLF
	cQuery += " 	Z8_ORIGEM " + CRLF
	cQuery += " FROM "+RetSqlName("SZ8")+" SZ8 " + CRLF	
	cQuery += " INNER JOIN "+RetSqlName("SA1")+" SA1 " + CRLF
	cQuery += " 	ON A1_COD = Z8_CLIENTE AND A1_LOJA = Z8_LOJA AND SA1.D_E_L_E_T_ = ' ' " + CRLF
	cQuery += " INNER JOIN "+RetSqlName("SB1")+" SB1 " + CRLF
	cQuery += " 	ON B1_COD = Z8_PRODUTO AND SB1.D_E_L_E_T_ = ' ' " + CRLF
	cQuery += " WHERE SZ8.D_E_L_E_T_ = ' ' " + CRLF 
	cQuery += " AND Z8_NUM >= '"+cCotaDe+"' " + CRLF
	cQuery += " AND Z8_NUM <= '"+cCotaAte+"' " + CRLF
	cQuery += " AND Z8_DATA >= '"+dToS(dDataDe)+"' " + CRLF
	cQuery += " AND Z8_DATA <= '"+dToS(dDataAte)+"' " + CRLF		
	cQuery += " ORDER BY Z8_DATA, Z8_NUM " + CRLF		
	
	TcQuery cQuery NEW Alias "TMPQRY"	
	Count to nTotReg				
	TCSetField("TMPQRY","Z8_DATA","D")

Return (nTotReg)

Static Function ValidPerg(cPerg)
	Local _sAlias := Alias()
	Local aRegs := {}
	Local i,j

	DbSelectArea("SX1")
	DbSetOrder(1)

	cPerg := PADR(cPerg,Len(SX1->X1_GRUPO))

	&& Grupo,Ordem,Perg Port,Perg Engl,Perg Espan,Variavel,Tipo,Tamanho,Decimal,Presel,GSC,Valid,Var01,Def01,Defspa1,Defeng1,Cnt01,Var02,Def02,Defspa2,Defeng2,Cnt02,Var03,Def03,Defspa3,Defeng3,Cnt03,Var04,Def04,Defspa4,Defeng4,Cnt04,Var05,Def05,Defspa5,Defeng5,Cnt05,F3,Pyme,GrpSXG,Help,Picture,IdFil
	aAdd(aRegs, {cPerg, "01", "Cotação de			"    			,"" ,"" ,"mv_ch1", "C", TamSX3("UA_NUM")[1]		, 0, 0, "G", "", "mv_par01", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SUA"})	
	aAdd(aRegs, {cPerg, "02", "Cotação até			"        		,"" ,"" ,"mv_ch2", "C", TamSX3("UA_NUM")[1]		, 0, 0, "G", "", "mv_par02", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "SUA"})	
	aAdd(aRegs, {cPerg, "03", "Periodo de			"    			,"" ,"" ,"mv_ch3", "D", 08						, 0, 0, "G", "", "mv_par03", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""})	
	aAdd(aRegs, {cPerg, "04", "Periodo até 			"        		,"" ,"" ,"mv_ch4", "D", 08						, 0, 0, "G", "", "mv_par04", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""})
	
	For i:=1 to Len(aRegs)
		If !MsSeek(cPerg+aRegs[i,2])
			RecLock("SX1",.T.)
			For j:=1 to FCount()
				If j <= Len(aRegs[i])
					FieldPut(j,aRegs[i,j])
				Endif
			Next
			MsUnlock()
		Endif
	Next i
	
	DbSelectArea(_sAlias)

Return

