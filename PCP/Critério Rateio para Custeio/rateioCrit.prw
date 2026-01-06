#Include 'Protheus.ch'
#Include 'Topconn.ch'

#DEFINE HORAS_HOMEM			"01"//Horas Homem Trabalhadas
#DEFINE HORAS_MAQUINAS		"02"//Horas Maquinas Trabalhadas
#DEFINE NUM_FUNCIONARIOS	"03"//Numero de Funcionarios
#DEFINE NUM_VIDAS			"04"//Numero de Vidas
#DEFINE ENERGIA_ELETRICA	"05"//Energia Eletrica

/*/{Protheus.doc} rateioCrit

Programa para chamar o rateio a ser feito.
	
@author André Oquendo
@since 10/04/2015

/*/

User Function rateioCrit()
	Local cRatDe		:= ""
	Local cRatAte		:= ""
	Local dProdDe		:= CtoD("")
	Local dProdAte	:= CtoD("")
	Local dDemiDe		:= CtoD("")
	Local dDemiAte	:= CtoD("")

	If ValidPerg()
		cRatDe		:= MV_PAR01
		cRatAte		:= MV_PAR02
		dProdDe		:= MV_PAR03
		dProdAte	:= MV_PAR04
		dDemiDe		:= MV_PAR05
		dDemiAte	:= MV_PAR06
		
		buscaCrit(cRatDe,cRatAte)
		While QRYTRB->(!Eof())	
			Do Case
				Case alltrim(QRYTRB->X5_CHAVE) == HORAS_HOMEM	
					Processa({||u_ratHrHome(dProdDe,dProdAte)},"Fazendo Rateio Horas Homem Trabalhadas...") 			
				Case alltrim(QRYTRB->X5_CHAVE) == HORAS_MAQUINAS					
					Processa({||u_ratHrMaq(dProdDe,dProdAte)},"Fazendo Rateio Horas Maquinas Trabalhadas...")
				Case alltrim(QRYTRB->X5_CHAVE) == NUM_FUNCIONARIOS			
					Processa({||u_ratFunci(dDemiDe,dDemiAte)},"Fazendo Rateio Funcionarios...")
				Case alltrim(QRYTRB->X5_CHAVE) == NUM_VIDAS
					Processa({||u_ratVidas(dDemiDe,dDemiAte)},"Fazendo Rateio Vidas...")				
				Case alltrim(QRYTRB->X5_CHAVE) == ENERGIA_ELETRICA
					Processa({||u_ratEnerg(dProdDe,dProdAte)},"Fazendo Rateio Energia Eletrica...")			
			EndCase	
			QRYTRB->(DbSkip())			
		EndDo	
		
		QRYTRB->(DbCloseArea())	
	
	EndIf

Return


/*/{Protheus.doc} buscaCrit

Busca os critérios a serem calculados
	
@author André Oquendo
@since 10/04/2015

@param cRatDe, String, Rateio de
@param cRatAte, String, Rateio até

/*/

Static Function buscaCrit(cRatDe,cRatAte)   
	Local cQuery			:= ""
	
	cQuery := " SELECT " + CRLF		
	cQuery += "	X5_CHAVE " + CRLF
	cQuery += " FROM " + RetSqlName("SX5") + " SX5 				" + CRLF
	cQuery += " WHERE " + CRLF
	cQuery += "	   	SX5.D_E_L_E_T_ 	= 	' ' 											" + CRLF
	cQuery += "	   	AND X5_FILIAL 	= 	'"+xFilial("SX5")+"' 						" + CRLF
	cQuery += "	   	AND X5_TABELA 	= 	'Z1' 						" + CRLF
	cQuery += "	   	AND X5_CHAVE 		>= 	'"+cRatDe+"' 											" + CRLF
	cQuery += "	   	AND X5_CHAVE 		<= 	'"+cRatAte+"' 											" + CRLF
	TcQuery cQuery New Alias "QRYTRB"	
	QRYTRB->(DbGoTop())

Return

/*/{Protheus.doc} ValidPerg

Programa para chamar o rateio a ser feito.
	
@author André Oquendo
@since 10/04/2015

@return Logico Indica se foi selecionado o OK ou não.
/*/

Static Function ValidPerg()   

	Local aRet 		:= {}
	Local aParamBox	:= {}
	Local lRet 		:= .F. 
	
	aAdd(aParamBox,{1,"Regra Rateio De"	  					,space(TamSX3("CTQ_ZZCRAT")[1])		,"","","Z1CRIT"	,"", 30,.T.})	// MV_PAR01
	aAdd(aParamBox,{1,"Regra Rateio Até"	   				,space(TamSX3("CTQ_ZZCRAT")[1])		,"","","Z1CRIT"	,"", 30,.T.})	// MV_PAR02	
	aAdd(aParamBox,{1,"Data Inicial Apuração Produção" 		,CtoD("")								,"","",""			,"", 60,.T.})	// MV_PAR03
	aAdd(aParamBox,{1,"Data Final Apuração Produção"	   	,CtoD("")								,"","",""			,"", 60,.T.})	// MV_PAR04
	aAdd(aParamBox,{1,"Data Demissão De"	   				,CtoD("")								,"","",""			,"", 60,.T.})	// MV_PAR05
	aAdd(aParamBox,{1,"Data Demissão Até"					,CtoD("")								,"","",""			,"", 60,.T.})	// MV_PAR06
		
	If ParamBox(aParamBox,"Rateio Off-Line",@aRet,,,,,,,"Rateio Off-Line",.T.,.T.)
		lRet := .t.
	EndIf
	                                                              
Return lRet