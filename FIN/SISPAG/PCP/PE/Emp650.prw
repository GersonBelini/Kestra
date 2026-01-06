#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/**
 * Rotina		:	EMP650
 * Módulo		:  	PCP
**/

User Function EMP650()

Local aArea			:= GetArea()
Local aAreaSC2		:= SC2->(GetArea())
Local aAreaSB1		:= SB1->(GetArea())
Local aLote			:= {}
Local cLocal 		:= ""
Local nI			:= 0
Local nPosComp  	:= aScan(aHeader, {|x| x[2] == "G1_COMP"})
Local nPosLocal 	:= aScan(aHeader, {|x| x[2] == "D4_LOCAL"})
Local nPOsQtd		:= aScan(aHeader, {|x| x[2] == "D4_QUANT"})
Local nPosLote		:= aScan(aHeader, {|x| x[2] == "D4_LOTECTL"})
Local nPosSubLote	:= aScan(aHeader, {|x| x[2] == "D4_NUMLOTE"})
Local nPosValid		:= aScan(aHeader, {|x| x[2] == "D4_DTVALID"})
Local nPosEnd		:= aScan(aHeader, {|x| x[2] == "DC_LOCALIZ"})
Local nPosDel		:= Len(aHeader)+1
Local aNewPos		:= {}
Local aProdOk		:= {}

SB1->(DbSetOrder(1))

For nI := 1 To Len(aCols)

	If !aCols[nI, nPosDel]
		
		If aScan( aProdOk, aCols[nI, nPosComp] ) > 0
			Loop
		Endif
	
		If SB1->(DbSeek(xFilial("SB1")+aCols[nI, nPosComp]))
		
			aAdd( aProdOK, aCols[nI, nPosComp] )
					
			If !Empty(SB1->B1_ZZLOCPR) .and. SB1->B1_ZZLOCPR <> aCols[nI, nPosLocal]
				cLocal := SB1->B1_ZZLOCPR
			Else
				cLocal := aCols[nI, nPosLocal]
			Endif
			
			If SB1->B1_RASTRO == "N" .OR. MV_PAR08 == 2 // Se nao sugerir lotes, nao deve realizar mudancas
			
				aCols[nI, nPosLocal]	:= cLocal
				aCols[nI, nPosQtd] 		:= Round( aCols[nI, nPosQtd], 2 )
				
			Elseif SB1->B1_RASTRO $ "L/S"
			
				AnalisaEmpenhos( aCols[nI, nPosComp] )
				
				GetLote(cLocal, aCols[nI, nPosComp], aCols[nI, nPOsQtd], @aLote)
				
				If Len(aLote) > 1
					For nX := 2 To Len(aLote)
						aAdd(aCols, aClone( aCols[nI] ) )
						aCols[ Len(aCols), nPosLote ] := ""
						aCols[ Len(aCols), nPosSubLote ] := ""
						aCols[ Len(aCols), nPosValid ] := Stod("")
						aCols[ Len(aCols), nPosQtd ] := 0
						aCols[ Len(aCols), nPosEnd ] := ""
						aAdd( aNewPos, Len(aCols) )
					Next nX
				Endif
										
				aCols[nI, nPosLocal]	:= cLocal
				aCols[nI, nPosLote] 	:= aLote[1,1]
				aCols[nI, nPosSubLote] 	:= aLote[1,2]
				aCols[nI, nPosValid]	:= IF(Empty(aLote[1,3]), "", SToD(aLote[1,3]))
				aCols[nI, nPosQtd]		:= Round(aLote[1,4],2)
				aCols[nI, nPosEnd]		:= aLote[1,5]
				
				If Len(aLote) > 1
					For nX := 2 To Len(aLote)
						aCols[aNewPos[nX-1], nPosLocal]	:= cLocal
						aCols[aNewPos[nX-1], nPosLote] 	:= aLote[nX,1]
						aCols[aNewPos[nX-1], nPosSubLote] 	:= aLote[nX,2]
						aCols[aNewPos[nX-1], nPosValid]	:= IF(Empty(aLote[nX,3]), "", SToD(aLote[nX,3]))
						aCols[aNewPos[nX-1], nPosQtd]	:= Round(aLote[nX,4], 2 )
						aCols[aNewPos[nX-1], nPosEnd] := aLote[nX,5]
					Next nX
				Endif
			
			Endif
				
		EndIf
	
	EndIf

Next nI

RestArea(aAreaSB1)
RestArea(aAreaSC2)
RestArea(aArea)

Return

Static Function AnalisaEmpenhos( cProd )

Local aEmpenhos 	:= {}
Local nI			:= 0
Local nPosProd	:= 0
Local nPosEmp		:= 0
Local nPosComp  	:= aScan(aHeader, {|x| x[2] == "G1_COMP"})
Local nPosQtd		:= aScan(aHeader, {|x| x[2] == "D4_QUANT"})
Local nPosDel		:= Len(aHeader)+1

For nI := 1 To Len(aCols)
	
	If aCols[nI, nPosComp] <> cProd
		Loop
	Endif
	
	nPosProd 	:= aScan(aEmpenhos, {|x| x[1] == cProd })
	
	If nPosProd > 0
	
		aEmpenhos[nPosProd, 2] += aCols[nI, nPosQtd]
		
		aCols[nI, nPosDel] 		:= .T.
	
	Else
		aAdd(aEmpenhos, { cProd, aCols[nI, nPosQtd]})
	EndIf
	
Next nI 

For nI := 1 To Len(aCols)

	If aCols[nI, nPosComp] <> cProd
		Loop
	Endif
	
	If !aCols[nI, nPosDel]
		
		nPosProd := aScan(aEmpenhos, {|x| x[1] == cProd })
	
		If nPosProd > 0
			aCols[nI, nPosQtd] := aEmpenhos[nPosProd, 2]
		EndIf
		
	EndIf
	
Next nI 

Return

Static Function GetLote(cLocal, cComp, nQtd, aLote)

Local cQuery  	:= "" 
Local nQtdAju  := nQtd

aLote := {}
	
If nQtd <> 0
	If !Localiza( cComp )
		cQuery := "SELECT B8_LOTECTL AS LOTE, B8_NUMLOTE AS SUBLOTE, B8_DTVALID AS DTVALID, '' LOCALIZ, B8_SALDO - B8_EMPENHO - B8_QACLASS AS QTD " 
		cQuery += "FROM " + RetSqlName("SB8") + "	SB8 "
		cQuery += "WHERE B8_PRODUTO = '" + cComp + "' AND "
		cQuery += "B8_FILIAL = '" + xFilial("SB8") + "' AND "
		cQuery += "B8_LOCAL = '" + cLocal + "' AND "
		cQuery += "B8_SALDO - B8_EMPENHO - B8_QACLASS > 0 AND "
		cQuery += "SB8.D_E_L_E_T_ = ' ' "
		cQuery += "ORDER BY B8_DTVALID, B8_LOTECTL, B8_NUMLOTE "
	Else
		cQuery := "SELECT BF_LOTECTL AS LOTE, BF_NUMLOTE AS SUBLOTE, B8_DTVALID AS DTVALID, BF_LOCALIZ AS LOCALIZ, BF_QUANT - BF_EMPENHO - BF_QEMPPRE AS QTD"
		cQuery += " FROM " + RetSqlName("SBF") + " BF"
		cQuery += " INNER JOIN " + RetSqlName("SB8") + " B8 ON B8.D_E_L_E_T_=' ' AND B8_FILIAL = BF_FILIAL AND B8_PRODUTO = BF_PRODUTO AND B8_LOCAL = BF_LOCAL AND B8_LOTECTL = BF_LOTECTL AND B8_NUMLOTE = BF_NUMLOTE"
		cQuery += " WHERE BF.D_E_L_E_T_=' '"
		cQuery += " AND BF_PRODUTO = '" + cComp + "'"
		cQuery += " AND BF_LOCAL = '" + cLocal + "'"
		cQuery += " AND BF_QUANT - BF_EMPENHO - BF_QEMPPRE > 0"
		cQuery += " ORDER BY DTVALID, LOTE, SUBLOTE, LOCALIZ"
	Endif
		
	TCQuery cQuery NEW Alias "LOTE"
		
	While !LOTE->(EOF()) .and. nQtdAju > 0 .and. SB1->B1_TIPO <> "PI" // Se for PI, nao sugere lote em nenhuma configuracao.
		
		aAdd(aLote, { LOTE->LOTE , LOTE->SUBLOTE, LOTE->DTVALID, Iif(LOTE->QTD > nQtdAju, nQtdAju, LOTE->QTD ), LOTE->LOCALIZ } )
		
		nQtdAju -= LOTE->QTD
		
		LOTE->( dbSkip() )
	
	EndDo
		
	LOTE->(dbCloseArea())
Endif

If nQtdAju > 0 .or. nQtd == 0

	aAdd(aLote, {"", "", StoD(""), nQtdAju, ""} )
	
EndIf

Return
