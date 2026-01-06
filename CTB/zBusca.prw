#INCLUDE "PROTHEUS.CH"

// BUSCA CONTA CONTABIL NA TABELA ZJD -- ANTIGA Z@

User Function ZBUSZJD(cCHV) 
Local cConta := "ERRO"
lOCAL aAreaZJD := ZJD->(GetArea())

ZJD->(DbSelectArea("ZJD"))
ZJD->(DbSetOrder(1))   

    If ZJD->(DbSeek(xFilial("ZJD") + cCHV))
		cConta := ZJD->ZJD_CONTA
	Endif
	
RestArea(aAreaZJD)
	
Return (cConta)


// BUSCA GRUPO DE TRIBUTACAO PARA EXECEÇÃO FISCAL - UTILIZADO NO GATILHO B1_POSIPI

User Function ZBUSZJE(cNCM) 
Local cGrupo := "0000"
lOCAL aAreaZJE := ZJE->(GetArea())

cNCM := ALLTRIM(cNCM)
ZJE->(DbSelectArea("ZJE"))
ZJE->(DbSetOrder(1))   

    If ZJE->(DbSeek(xFilial("ZJE") + cNCM))
		cGrupo := ZJE->ZJE_GRUPO
	
	ElseIf ZJE->(DbSeek(xFilial("ZJE") + SUBSTR(cNCM,1,6)))
		cGrupo := ZJE->ZJE_GRUPO
	
	ElseIf ZJE->(DbSeek(xFilial("ZJE") + SUBSTR(cNCM,1,4)))
		cGrupo := ZJE->ZJE_GRUPO
	
	EndIf	
		
RestArea(aAreaZJE)
	
Return (cGrupo)

// BUSCA CEST ZJG - UTILIZADO NO GATILHO B1_POSIPI

User Function ZBUSZJG(cNCM) 
Local cCest := ""
lOCAL aAreaZJG := ZJG->(GetArea())

cNCM := ALLTRIM(cNCM)
ZJG->(DbSelectArea("ZJG"))
ZJG->(DbSetOrder(1))   

    If ZJG->(DbSeek(xFilial("ZJG") + cNCM))
		cCest := ZJG->ZJG_ZZCEST
	
	ElseIf ZJG->(DbSeek(xFilial("ZJG") + SUBSTR(cNCM,1,7)))
		cCest := ZJG->ZJG_ZZCEST
		
	ElseIf ZJG->(DbSeek(xFilial("ZJG") + SUBSTR(cNCM,1,6)))
		cCest := ZJG->ZJG_ZZCEST
	
	ElseIf ZJG->(DbSeek(xFilial("ZJG") + SUBSTR(cNCM,1,5)))
		cCest := ZJG->ZJG_ZZCEST

	ElseIf ZJG->(DbSeek(xFilial("ZJG") + SUBSTR(cNCM,1,4)))
		cCest := ZJG->ZJG_ZZCEST

	ElseIf ZJG->(DbSeek(xFilial("ZJG") + SUBSTR(cNCM,1,3)))
		cCest := ZJG->ZJG_ZZCEST

	ElseIf ZJG->(DbSeek(xFilial("ZJG") + SUBSTR(cNCM,1,2)))
		cCest := ZJG->ZJG_ZZCEST
		
	EndIf	
		
RestArea(aAreaZJG)
	
Return (cCest)