#include "totvs.ch"
#include "topconn.ch"

/*
Autor: 	Guilherme Ricci
Data:	21/06/2016
Uso: 	Função para ser colocada no cadastro de fórmulas, que por sua vez será utilizada no cadastro do produto, no campo B1_ESTFOR.
*/

User Function EstSeg1( cOpcao, cProduto )
                    
Local aAreaAtu	:= GetArea()
Local nRet 		:= 0
Local cQuery	:= ""
Local cMedia1	:= "(B3_Q10 + B3_Q11 + B3_Q12 + B3_Q01 + B3_Q02 + B3_Q03) / 6"
Local cMedia2 	:= "(B3_Q04 + B3_Q05 + B3_Q06 + B3_Q07 + B3_Q08 + B3_Q09) / 6"
Local nMedia	:= 0
Local nQtdDia	:= 0
Local nFator	:= 0
Local nCont		:= 0
Local nX		:= 0

/*
Formula definida com usuário Kestra Sergio Silva (PCP)
Periodos:
Outubro até março;
Abril até setembro;

Faz média dos 2 períodos e compara: a maior é a que vale.

Pegar a maior média, dividir por 30 (valor diário) e fazer multiplicação por:

PA:
Consumo médio preenchido de:
				10 - 12 meses = 15 dias
				6 - 9 meses = 10 dias
				0 - 5 meses = 0 (zerar conteúdo, caso houver algum)

MP / EM:
Valor diário * lead time do produto.
*/
If cProduto <> Nil
	SB1->(dbSetOrder(1))
	If !SB1->(dbSeek(xFilial("SB1")+cProduto))
		Return nRet
	Endif
Else
	cProduto := SB1->B1_COD
Endif

nRet := SB1->B1_ESTSEG

If SB1->B1_ZZATUES == "S"

	If Select("ESTSEG") > 0
		ESTSEG->(DbCloseArea())
	Endif
	
	cQuery := " SELECT ROUND("+ cMedia1 + ",0) MEDIA1, ROUND(" + cMedia2 + ",0) MEDIA2"
	cQuery += " FROM " + RetSqlName("SB3") + " B3"
	cQuery += " WHERE B3_COD = '" + cProduto + "'"
	cQuery += " AND D_E_L_E_T_=' '"
	
	tcQuery cQuery New Alias "ESTSEG"
	
	If ESTSEG->(!eof())
		nMedia 	:= Max( ESTSEG->MEDIA1, ESTSEG->MEDIA2 )
		nQtdDia := nMedia / 30
		
		// Define fator de multiplicacao
		If SB1->B1_TIPO == "PA"
			SB3->(dbSetOrder(1))
			SB3->(dbSeek(xFilial("SB3")+cProduto))
			For nX := 1 To 12
				If SB3->&("B3_Q" + StrZero(nX,2)) > 0
					nCont++
				Endif
			Next nX
			
			If nCont >= 10
				nFator := 15
			Elseif nCont >= 6
				nFator := 10
			Else
				nFator := 0
			Endif
		Elseif SB1->B1_TIPO $ "MP/EM"
			nFator := SB1->B1_PE
		Endif
		
		// Preenche retorno de acordo com opcao da funcao escolhida
		If cOpcao == "CALC" // Qtd Calculada
			nRet := Round(nFator * nQtdDia,0)
			
		// Abaixo opcoes que podem ser utilizadas em relatorios, atraves do uso direto da função
		Elseif cOpcao == "FATOR" // Somente Fator 
			nRet := nFator
			
		Elseif cOpcao == "MEDIA1" // Media calculada do primeiro periodo
			nRet := ESTSEG->MEDIA1
			
		Elseif cOpcao == "MEDIA2" // Media calculada do segundo periodo
			nRet := ESTSEG->MEDIA2
			
		Elseif cOpcao == "MEDIAF" // Maior media entre as 2
			nRet := nMedia
			
		Elseif cOpcao == "QTDDIA" // Quantidade por dia (dividida por 30)
			nRet := nQtdDia
			
		Elseif cOpcao == "CONT" // Contagem de meses que houveram consumo
			nRet := nCont
			
		Endif
	
	Endif
	
	ESTSEG->(DbCloseArea())
Endif

RestArea(aAreaAtu)
                                                                                                
Return nRet