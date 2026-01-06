#INCLUDE "TOTVS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³KSCusVlMov ºAutor  ³Gerson Belini      º Data ³  13/03/2018 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Verificar inconsistências nas movimentações de estoque.     ±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Kestra                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function KSCusVlMov()
	Local _cNumOp  := ""
	Local _cQuery  := ""
	Local _aOrdens := {}
	Local _aCabEmp := {}
	Local _aIteEmp := {}
	Local _aIteAux := {}
	Local _aOPSeq  := {}

// 1) Verificar se o número sequencial da produção final da ordem (D3_PARCTOT = "T") é o maior entre as movimentações de produção da ordem
// 2) Verificar se a data de produção final é maior ou igual ao último apontamento de produção	
	
	// Ordens que potencialmente podem ter problemas
	
/*	
	_cQuery := " "
	_cQuery += " SELECT D3_FILIAL,D3_OP,MAX(D3_NUMSEQ) D3_NUMSEQ,MAX(D3_EMISSAO) D3_EMISSAO
	_cQuery += " FROM "+RetSqlName("SD3")+" SD3"
	_cQuery += " WHERE SD3.D_E_L_E_T_ = ' '
	_cQuery += " AND D3_EMISSAO BETWEEN '20171101' AND '20171130'
	_cQuery += " AND D3_ESTORNO = ' '
	_cQuery += " AND D3_CF LIKE 'PR%'
	_cQuery += " GROUP BY D3_FILIAL,D3_OP
	_cQuery += " HAVING COUNT(*) > 1
*/

	_cQuery := " "
	_cQuery += " SELECT D3_FILIAL,D3_OP,MAX(D3_NUMSEQ) D3_NUMSEQ "
	_cQuery += " FROM SD3010 "
	_cQuery += " WHERE D_E_L_E_T_ = ' ' "
	_cQuery += " AND D3_CF LIKE 'PR%' "
	_cQuery += " AND D3_PARCTOT != 'T' "
	_cQuery += " AND EXISTS(SELECT * "
	_cQuery += " FROM SD3010 D3INT "
	_cQuery += " WHERE D3INT.D_E_L_E_T_ = ' ' "
	_cQuery += " AND SD3010.D_E_L_E_T_ = ' ' "
	_cQuery += " AND D3INT.D3_FILIAL = SD3010.D3_FILIAL "
	_cQuery += " AND D3INT.D3_OP = SD3010.D3_OP "
	_cQuery += " AND D3INT.D3_NUMSEQ < SD3010.D3_NUMSEQ "
	_cQuery += " AND D3INT.D3_PARCTOT = 'T' "
	_cQuery += " AND D3INT.D3_CF LIKE 'PR%') "
	_cQuery += " AND D3_EMISSAO >= '20171101' "
	_cQuery += " GROUP BY D3_FILIAL,D3_OP "
	_cQuery += " ORDER BY D3_FILIAL,D3_OP "
	_cQuery := ChangeQuery(_cQuery)
	dbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), "TRB", .F., .T.)
	aEval(SD3->(dbStruct()), {|x| If(x[2] != "C" .And. FieldPos(x[1]) > 0, TcSetField("TRB",x[1],x[2],x[3],x[4]),Nil)})
	
	// Verificar se o D3_NUMSEQ é para a última produção
	DbSelectArea("TRB")
	DbGoTop()
	While !Eof()
		DbSelectArea("SD3")
		DbSetOrder(1)
		DbSeek(TRB->D3_FILIAL+TRB->D3_OP)
		While !Eof() .and. SD3->D3_FILIAL+SD3->D3_OP == TRB->D3_FILIAL+TRB->D3_OP 
			if Substr(SD3->D3_CF,1,2) == "PR" .and. SD3->D3_NUMSEQ < TRB->D3_NUMSEQ .and. SD3->D3_PARCTOT == "T"
			 	 RecLock("SD3",.F.)
				 SD3->D3_PARCTOT := "P"
				 MsUnLock()
			elseif Substr(SD3->D3_CF,1,2) == "PR" .and. SD3->D3_NUMSEQ == TRB->D3_NUMSEQ .and. SD3->D3_PARCTOT != "T"
			 	 RecLock("SD3",.F.)
				 SD3->D3_PARCTOT := "T"
				 MsUnLock()
			Endif
			DbSelectArea("SD3")
			DbSkip()
		End
		DbSelectArea("TRB")
		DbSkip()
	End
	

	DbSelectArea("TRB")
	DbGoTop()
	While !Eof()
		DbSelectArea("SD3")
		DbSetOrder(4)
		DbSeek(TRB->D3_FILIAL+SD3->D3_NUMSEQ)
		if SD3->D3_EMISSAO < TRB->D3_EMISSAO
			_cTeste := "TESTE"
		Endif
		DbSelectArea("TRB")
		DbSkip()
	End

	// Verificar produções com número sequencial maior que registro de Total de produção 
	// D3_PARCTOT deve ser no último número sequencial para que o sistema distribua corretamente o custo da ordem
	// para os apontamentos

//============> Verificar problema entre datas.
/*

SELECT D3PARC.D3_FILIAL,D3PARC.D3_COD,D3PARC.D3_OP
FROM SD3010 D3PARC,
SD3010 D3TOT
WHERE D3PARC.D_E_L_E_T_ = ' '
AND D3TOT.D_E_L_E_T_ = ' '
AND D3PARC.D3_FILIAL = D3TOT.D3_FILIAL
AND D3PARC.D3_OP = D3TOT.D3_OP
AND D3PARC.D3_CF LIKE 'PR%'
AND D3TOT.D3_CF LIKE 'PR%'
AND D3PARC.D3_PARCTOT = 'P'
AND D3TOT.D3_PARCTOT = 'T'
AND D3PARC.D3_EMISSAO BETWEEN '20171101' AND '20171130'
AND D3TOT.D3_EMISSAO BETWEEN '20171101' AND '20171130'
AND D3PARC.D3_EMISSAO > D3TOT.D3_EMISSAO
AND D3PARC.D3_ESTORNO = ' '
AND D3TOT.D3_ESTORNO = ' '
GROUP BY D3PARC.D3_FILIAL,D3PARC.D3_COD,D3PARC.D3_OP
ORDER BY D3PARC.D3_FILIAL,D3PARC.D3_COD,D3PARC.D3_OP



UPDATE SD5010
SET D5_DATA = '20180606'
WHERE D_E_L_E_T_ = ' '
AND D5_NUMSEQ = '729530'



UPDATE SD3010
SET D3_EMISSAO = '20180606'
WHERE D_E_L_E_T_ = ' '
AND D3_NUMSEQ = '729530'
AND D3_CF = 'PR0'

*/

/*	
	_cQuery := " "
	_cQuery += " SELECT D3_OP,MAX(D3_EMISSAO) D3_EMISSAO,MAX(D3_NUMSEQ) D3_NUMSEQ "
	_cQuery += " FROM "+RetSqlName("SD3")+" SD3 "
	_cQuery += " WHERE SD3.D_E_L_E_T_ = ' ' "
	_cQuery += " AND D3_EMISSAO BETWEEN '20171101' AND '20171130' "
	_cQuery += " AND D3_CF LIKE 'PR%' "
	_cQuery += " AND D3_ESTORNO = ' ' "
	_cQuery += " GROUP BY D3_OP "
	_cQuery += " HAVING COUNT(*) > 1 "
	_cQuery += " ORDER BY D3_OP "
	_cQuery := ChangeQuery(_cQuery)
	dbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), "TRB", .F., .T.)
	aEval(SD3->(dbStruct()), {|x| If(x[2] != "C" .And. FieldPos(x[1]) > 0, TcSetField("TRB",x[1],x[2],x[3],x[4]),Nil)})


// Somente para fins de recálculo de custos, mudar a data do movimento, para a maior data.

	DbGoTop()
	While !Eof()
	
		DbSelectArea("SD3")
		DbSetOrder(4)
		MsSeek(xFilial("SD3")+TRB->D3_NUMSEQ)
		While !Eof() .and. xFilial("SD3")+TRB->D3_NUMSEQ == SD3->D3_FILIAL+SD3->D3_NUMSEQ
			if Substr(SD3->D3_CF,1,2) == 'PR' .and. SD3->D3_ESTORNO =  ' ' .and. TRB->D3_EMISSAO > SD3->D3_EMISSAO
				RecLock("SD3",.F.)
				SD3->D3_EMISSAO := TRB->D3_EMISSAO
				MsUnLock()
//				_cTexto := "TESTE"
			endif
			DbSkip()
		End
		DbSelectArea("TRB")
		DbSkip()
	End
	DbSelectArea("TRB")
	DbCloseArea()
	*/
Return()

