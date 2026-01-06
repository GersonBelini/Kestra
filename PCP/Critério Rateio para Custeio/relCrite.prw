#Include 'Protheus.ch'
#Include 'Topconn.ch'

/*/{Protheus.doc} relCrite

Relatório de Rateio Off-line por critério.
	
@author André Oquendo
@since 15/04/2015

/*/

User Function relCrite()
	Local oReport
	Local cPerg := "RELCRITE"
	
	ValidPerg(cPerg)
	Pergunte(cPerg,.F.) 	
	oReport := RepDef(cPerg)		
	oReport:PrintDialog()   
	  
Return

/*/{Protheus.doc} RepDef

Relatório do status da integracao.
	
@author André Oquendo
@since 15/04/2015

@param cPerg, String, Nome do grupo de perguntas

/*/
Static Function RepDef(cPerg)
	Local 	oReport
	Local 	oCabec
	Local 	cTitulo	:= "Rateio Off-line por Criterio"
	
    oReport := TReport():New(cPerg,cTitulo,cPerg,{|oReport| RepPrint( oReport )},cTitulo) 
    //oReport:SetLandScape()   
    oReport:lParamPage  := .F.    

     
   	oCabec := TRSection():New(oReport,"Rateio Off-line por Criterio",{"TMP1"})		
	oCabec:SetHeaderSection(.T.)    
	oCabec:SetLineStyle()//Define a impressao da secao em linha	
	oCabec:SetReadOnly()
	oCabec:AutoSize()				   	   		
   		TRCell():New(oCabec,"CTQ_RATEIO"	,"TMP1", "RATEIO"  			,pesqPict("CTQ","CTQ_RATEIO")	  	 	,150)
   		TRCell():New(oCabec,"CTQ_ZZCRAT"  	,"TMP1", "CRITÉRIO"   		,pesqPict("CTQ","CTQ_ZZCRAT")	  	 	,150)   		   	
   	
   	oItens := TRSection():New(oCabec,"Rateio Off-line por Criterio",{"TMP1"})
	oItens:SetHeaderBreak()
	oItens:SetReadOnly()
	oItens:bCustomText := { || oItens:aCustomText := {"__NOLINEBREAK__"} }
	oItens:AutoSize()	 					
   		TRCell():New(oItens,"CTQ_SEQUEN"		   	,"TMP1", "SEQUENCIAL"   			, pesqPict("CTQ","CTQ_SEQUEN")		  	, 15)
   		TRCell():New(oItens,"CTQ_CTCPAR"		   	,"TMP1", "CONTA C. PARTIDA"   	, pesqPict("CTQ","CTQ_CTCPAR")	  		, 30)
   		TRCell():New(oItens,"CTQ_CCCPAR"		  	,"TMP1", "C. CUSTO PARTIDA"   	, pesqPict("CTQ","CTQ_CCCPAR")	  	 	, 30)
   		TRCell():New(oItens,"CTQ_ZZQTDE"	   	 	,"TMP1", "QUANTIDADE"   			, pesqPict("CTQ","CTQ_ZZQTDE")	  		, 20)
   		TRCell():New(oItens,"CTQ_PERCEN"	   	 	,"TMP1", "PERCENTUAL RATEIO"   	, pesqPict("CTQ","CTQ_PERCEN")	  		, 20)
	  

	oBreak := TRBreak():New(oCabec,oCabec:Cell("CTQ_RATEIO"),"Total Rateio")
	TRFunction():New(oItens:Cell("CTQ_PERCEN"),NIL,"SUM",oBreak,NIL,PesqPict("CTQ","CTQ_PERCEN"),,.F.,.F.,.F.)
	TRFunction():New(oItens:Cell("CTQ_ZZQTDE"),NIL,"SUM",oBreak,NIL,PesqPict("CTQ","CTQ_ZZQTDE"),,.F.,.F.,.F.)
		     
Return (oReport)  

/*/{Protheus.doc} RepPrint

Imprime o relatório.
	
@author André Oquendo
@since 15/04/2015

@param oReport, Objeto, Objeto de impressão

/*/

Static Function RepPrint(oReport)
	Local oCabec		:= oReport:Section(1)  
	Local oItens		:= oReport:Section(1):Section(1)
	Local nTotReg		:= 0	
	Local cRateio		:= ""
	
	MsAguarde({ || nTotReg := ReportQry() }, "Aguarde", "Selecionado Registros ..." )

	oReport:SetMeter(nTotReg)    	
	TMP1->(dbGotop())   
	While TMP1->(!Eof()) 
		oCabec:init()  
   		If oReport:Cancel()
			Exit
		EndIf	  
		oCabec:Cell("CTQ_RATEIO"):SetValue(TMP1->CTQ_RATEIO +" - "+ TMP1->CTQ_DESC)
		oCabec:Cell("CTQ_ZZCRAT"):SetValue(TMP1->CTQ_ZZCRAT +" - "+ TMP1->X5_DESCRI)
		oCabec:PrintLine() 
		
		oItens:init()
		cRateio := TMP1->CTQ_RATEIO   
		
		While TMP1->(!Eof()) .AND. cRateio == TMP1->CTQ_RATEIO			
	 		oItens:PrintLine() 			
			TMP1->(dbSkip())	
		EndDo 
		oItens:Finish() 	                                       	          	
		oCabec:Finish()
	EndDo 		  
    
	TMP1->(dbCloseArea())
Return        

/*/{Protheus.doc} ReportQry

Busca os dados a serem exibidos.
	
@author André Oquendo
@since 15/04/2015

/*/
Static Function ReportQry()
	Local	cQuery		:= ""                    
		
	cQuery := " SELECT CTQ_RATEIO, CTQ_DESC, CTQ_ZZCRAT, CTQ_SEQUEN, CTQ_CTCPAR, CTQ_CCCPAR, CTQ_ZZQTDE, CTQ_PERCEN, X5_DESCRI " + CRLF	
	cQuery += " FROM "+RetSqlName("CTQ")+" CTQ " + CRLF
	cQuery += " INNER JOIN "+RetSqlName("SX5")+" SX5 ON " + CRLF
	cQuery += " X5_TABELA = 'Z1' AND X5_CHAVE = CTQ_ZZCRAT AND SX5.D_E_L_E_T_ = ' ' " + CRLF                                                         	
	cQuery += " WHERE CTQ.D_E_L_E_T_ = ' ' " + CRLF
	cQuery += " AND CTQ_RATEIO >= '"+MV_PAR01+"' " + CRLF		
	cQuery += " AND CTQ_RATEIO <= '"+MV_PAR02+"' " + CRLF
	cQuery += " AND CTQ_ZZCRAT >= '"+MV_PAR03+"' " + CRLF
	cQuery += " AND CTQ_ZZCRAT <= '"+MV_PAR04+"' " + CRLF
	cQuery += " ORDER BY CTQ_ZZCRAT, CTQ_RATEIO, CTQ_SEQUEN " + CRLF
		
	TcQuery cQuery NEW Alias "TMP1"	
	Count to nTotReg				

Return (nTotReg)


/*/{Protheus.doc} ValidPerg

Cria a parambox das perguntas.
	
@author André Oquendo
@since 15/04/2015

@param cPerg, String, Nome do grupo de perguntas

/*/
Static Function ValidPerg(cPerg)   

	Local _sAlias 	:= Alias()
	Local aRegs 		:= {}
	Local i,j

	DbSelectArea("SX1")
	DbSetOrder(1)

	cPerg := PADR(cPerg,Len(SX1->X1_GRUPO))

	&& Grupo,Ordem,Perg Port,Perg Engl,Perg Espan,Variavel,Tipo,Tamanho,Decimal,Presel,GSC,Valid,Var01,Def01,Defspa1,Defeng1,Cnt01,Var02,Def02,Defspa2,Defeng2,Cnt02,Var03,Def03,Defspa3,Defeng3,Cnt03,Var04,Def04,Defspa4,Defeng4,Cnt04,Var05,Def05,Defspa5,Defeng5,Cnt05,F3,Pyme,GrpSXG,Help,Picture,IdFil	
	aAdd(aRegs,{cPerg,"01","Rateio de"					,"","","mv_ch1","C",TamSX3("CTQ_RATEIO")[1]	 			,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","CTQ"		,"","","","",""})
	aAdd(aRegs,{cPerg,"02","Rateio ate"				,"","","mv_ch2","C",TamSX3("CTQ_RATEIO")[1]	 			,0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","CTQ"		,"","","","",""})		
	aAdd(aRegs,{cPerg,"03","Criterio Rateio de"		,"","","mv_ch3","C",TamSX3("CTQ_ZZCRAT")[1]	 			,0,0,"G","","mv_par03","","","","","","","","","","","","","","","","","","","","","","","","","Z1CRIT"	,"","","","",""})
	aAdd(aRegs,{cPerg,"04","Criterio Rateio ate"		,"","","mv_ch4","C",TamSX3("CTQ_ZZCRAT")[1]	 			,0,0,"G","","mv_par04","","","","","","","","","","","","","","","","","","","","","","","","","Z1CRIT"	,"","","","",""})

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