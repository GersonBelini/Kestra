#include "totvs.ch"
#include "topconn.ch"

User Function MT680VAL

Local lRet 		:= .F.
Local cQuery	:= ""
Local aAreaAtu	:= GetArea()
Local aAreaSC2	:= SC2->(GetArea())

Local nQuant	:= 0
Local nQtdTot	:= 0
Local cProd		:= ""
Local cOp		:= SC2->C2_NUM
Local cCorrida	:= SC2->C2_ZZNCORR

If Select("EMP") > 0
	EMP->(dbCloseArea())
Endif

If !(A680UltOper(.T.)) // Parametro lMemory -> Se é para utilizar variaveis de memória (.T.) ou alias SH6 (.F.)
	Return .T.
Endif

// Verifica se a OP se trata de uma OP que possui niveis abaixo
SC2->(dbSetOrder(1))
SC2->(dbSeek(xFilial("SC2")+M->H6_OP))
SC2->(dbSkip())
If SC2->C2_NUM <> cOP .or. SC2->C2_ZZNCORR <> cCorrida .or. SC2->(EOF())
	Return .T.
Endif

SC2->(dbSeek(xFilial("SC2")+M->H6_OP))

// Query para achar o produto que está empenhado
cQuery := " SELECT DISTINCT D4_COD"
cQuery += " FROM " + RetSqlName("SD4") + " D4 "
cQuery += " WHERE D4.D_E_L_E_T_=' '"
cQuery += " AND D4_LOTECTL = '"+ SC2->(C2_ZZNCORR+C2_ZZREQUA) +"'"
cQuery += " AND D4_OP = '"+ M->H6_OP +"'"

tcQuery cQuery New Alias "EMP"

If EMP->(!eof())
	cProd := EMP->D4_COD
	EMP->(dbCloseArea())
Else
	MsgAlert("Não foi encontrado produto da OP anterior empenhado. Favor verificar os empenhos.")
	EMP->(dbCloseArea())
	Return .F.
Endif

// Query para achar as quantidades totais
cQuery := " SELECT D4_LOTECTL, SUM(D4_QUANT) D4_QUANT"
cQuery += " FROM " + RetSqlName("SD4") + " D4 "
cQuery += " WHERE D4.D_E_L_E_T_=' '"
cQuery += " AND D4_COD = '"+ cProd +"'"
cQuery += " AND D4_OP = '"+ M->H6_OP +"'"
cQuery += " GROUP BY D4_LOTECTL"
cQuery += " ORDER BY D4_LOTECTL DESC"

tcQuery cQuery New Alias "EMP"

While EMP->(!eof())
	If !Empty(EMP->D4_LOTECTL) .AND. EMP->D4_LOTECTL == SC2->(C2_ZZNCORR+C2_ZZREQUA)
		nQuant := EMP->D4_QUANT
	Endif
	nQtdTot += EMP->D4_QUANT
	
	EMP->(dbSkip())
EndDo

// Se o percentual apontado em relaçao a qtd total da OP for menor que o percentual que o produto está empenhado, permite apontamento.
If M->(H6_QTDPROD + H6_QTDPERD)/(SC2->(C2_QUANT-C2_QUJE)) <= nQuant/nQtdTot .or. (nQuant > 0 .and. nQuant == nQtdTot ) .or. nQtdTot == 0
	lRet := .T.
Else
	If nQuant > 0 
		If MsgYesNo(	"Quantidade produzida + Quantidade da perda apontada é maior que a quantidade prevista para o consumo do lote que está no empenho. ";
						+ "Isto pode gerar problemas no consumo. Deseja continuar?"+CRLF+CRLF;
						+ "Quantidade máxima a ser apontada: "+cValToChar((nQuant/nQtdTot)*SC2->C2_QUANT) )
			lRet := .T.
		Endif
	Else
		MsgAlert("Não foi encontrada quantidade do produto produzido na OP anterior para apontamento.")
	Endif
Endif

EMP->(dbCloseArea())

RestArea(aAreaSC2)
RestArea(aAreaAtu)

Return lRet