#Include 'Protheus.ch'
#Include 'TopConn.ch'

User Function PNM07001()
	Local aTotais 	:= Paramixb[1] 
	Local aBHACum 	:= Paramixb[2]
	Local cTipoHr		:= ""
	Local nHrNSind	:= 0
	Local aAux			:= {}
	Local nItem		:= 0
	Local cMatri		:= SRA->RA_MAT
	Local cQuery		:= ""
	Local aTemp		:= {}
	
	Private aExc		:= {}
	
	
	cQuery += " SELECT RA_REGRA, RA_SINDICA  " + CRLF
	cQuery += " FROM " + RetSqlName("SRA") + " " + CRLF
	cQuery += " WHERE D_E_L_E_T_ = ' ' " + CRLF
	cQuery += " AND RA_FILIAL = '"+xFilial("SRA")+"' " + CRLF
	cQuery += " AND RA_MAT = '"+cMatri+"' " + CRLF
	
	
	TcQuery cQuery New Alias "QRYRA"
	QRYRA->(DbGoTop())
	
	For nA := 1 to len(aTotais)
		aTotais[nA][3] := fConvHr(aTotais[nA][3], "D")					
	Next	
			
	If QRYRA->RA_REGRA == "02"			
		For nT := 1 to len(aTotais)
			cTipoHr := retTipo(aTotais[nT,2])		
			If QRYRA->RA_SINDICA == "03"
				If cTipoHr $ "1,3,5,7"				
					nItem := AScan(aAux, {|aX| aX[4] == '383'})
					If nItem == 0
						aAdd(aAux,aClone(aTotais[nT]))
						aAux[len(aAux)][1] := dDataBase
						aAux[len(aAux)][4] := '383'
					Else
						aAux[nItem,3] += aTotais[nT,3]
					EndIf						
				/*ElseIf cTipoHr == "5" 
					nItem := AScan(aAux, {|aX| aX[4] == '385'})
					If nItem == 0
						aAdd(aAux,aClone(aTotais[nT]))
						aAux[len(aAux)][1] := dDataBase
						aAux[len(aAux)][4] := '385'
					Else
						aAux[nItem,3] += aTotais[nT,3]
					EndIf */
				ElseIf cTipoHr $ "2,4,6,8"
					nItem := AScan(aAux, {|aX| aX[4] == '371'})
					If nItem == 0
						aAdd(aAux,aClone(aTotais[nT]))
						aAux[len(aAux)][1] := dDataBase
						aAux[len(aAux)][4] := '371'
					Else
						aAux[nItem,3] += aTotais[nT,3]
					EndIf
				/*ElseIf cTipoHr $ "6,7,8"
					nItem := AScan(aAux, {|aX| aX[4] == '373'})
					If nItem == 0
						aAdd(aAux,aClone(aTotais[nT]))
						aAux[len(aAux)][1] := dDataBase
						aAux[len(aAux)][4] := '373'
					Else
						aAux[nItem,3] += aTotais[nT,3]
					EndIf*/ 
				Else
					aAdd(aAux,aClone(aTotais[nT]))
				EndIf					
			Else		
				//If cTipoHr $ "2,3,4"
				If cTipoHr $ "2,4"
					cTipoHr := "A"
				//ElseIf cTipoHr $ "6,7,8"
				ElseIf cTipoHr $ "6,8"									
					cTipoHr := "B"
					aTemp := tipoEsp(aTotais,nT)
					If len(aTemp) > 0
						For nW := 1 to len(aTemp)																			
							nItem := AScan(aAux, {|aX| aX[1]+aX[3]+cValToChar(aX[4]) == aTemp[nW][1]+aTemp[nW][3]+cValToChar(aTemp[nW][4])})
							If nItem == 0
								aAdd(aAux,{aTemp[nW][1],aTemp[nW][2],aTemp[nW][3],aTemp[nW][4]})
							Else
								aAux[nItem,2] += aTemp[nW][2]
							EndIf										
						Next
						Loop
					EndIf
				Else
					loop
				EndIf
				If aTotais[nT,3] <= 8
					nItem := AScan(aAux, {|aX| aX[1]+aX[3]+cValToChar(aX[4]) == cTipoHr+"100"+cValToChar(nT)})
					If nItem == 0
						aAdd(aAux,{cTipoHr,aTotais[nT,3],"100",nT})
					Else
						aAux[nItem,2] += aTotais[nT,3]
					EndIf				
				Else
					nItem := AScan(aAux, {|aX| aX[1]+aX[3]+cValToChar(aX[4]) == cTipoHr+"100"+cValToChar(nT)})
					If nItem == 0
						aAdd(aAux,{cTipoHr,8,"100",nT})
					Else
						aAux[nItem,2] += 8
					EndIf
					nItem := AScan(aAux, {|aX| aX[1]+aX[3] == cTipoHr+"150"})
					If nItem == 0
						aAdd(aAux,{cTipoHr,aTotais[nT,3]-8,"150",nT})
					Else
						aAux[nItem,2] += aTotais[nT,3]-8
					EndIf				
				EndIf
			EndIf					
		Next
		
		
		If QRYRA->RA_SINDICA != "03"
			
			For nA := 1 to len(aAux)			
				aTemp := aClone(aTotais[aAux[nA,4]])
				If aAux[nA,1] == "A"
					If aAux[nA,3] == "100"
						aTotais[aAux[nA,4]][1] := dDataBase
						aTotais[aAux[nA,4]][2] := '925'
						aTotais[aAux[nA,4]][4] := '371'
						aTotais[aAux[nA,4]][3] := aAux[nA,2]											
					Else
						aTemp[1] := dDataBase
						aTemp[2] := '933'
						aTemp[4] := '375'
						aTemp[3] := aAux[nA,2]
						aTemp[16] := 150
						aAdd(aTotais,aTemp)
					EndIf 
				ElseIf aAux[nA,1] == "B" 
					If aAux[nA,3] == "100"
						aTotais[aAux[nA,4]][1] := dDataBase
						//aTotais[aAux[nA,4]][4] := '373'
						aTotais[aAux[nA,4]][4] := '371'
						aTotais[aAux[nA,4]][3] := aAux[nA,2]						
					Else
						aTemp[1] := dDataBase
						//aTemp[2] := '932'
						aTemp[2] := '933'
						aTemp[4] := '375'
						aTemp[3] := aAux[nA,2]
						aAdd(aTotais,aTemp) 						
					EndIf  				
				EndIf
			Next				
		Else	
			aTotais := {}
			aTotais := aClone(aAux)
		EndIf
	ElseIf QRYRA->RA_REGRA == "01"
		For nT := 1 to len(aTotais)
			cTipoHr := retTipo(aTotais[nT,2])						
			If cTipoHr $ "2,4,6,8"
				cTipoHr := "A"
				aTemp := tipoEsp2(aTotais,nT)
				If len(aTemp) > 0
					For nW := 1 to len(aTemp)																			
						nItem := AScan(aAux, {|aX| aX[1]+aX[3]+cValToChar(aX[4]) == aTemp[nW][1]+aTemp[nW][3]+cValToChar(aTemp[nW][4])})
						If nItem == 0
							aAdd(aAux,{aTemp[nW][1],aTemp[nW][2],aTemp[nW][3],aTemp[nW][4]})
						Else
							aAux[nItem,2] += aTemp[nW][2]
						EndIf										
					Next
					Loop
				EndIf
			Else
				loop
			EndIf
			If aTotais[nT,3] <= 8
				nItem := AScan(aAux, {|aX| aX[1]+aX[3]+cValToChar(aX[4]) == cTipoHr+"100"+cValToChar(nT)})
				If nItem == 0
					aAdd(aAux,{cTipoHr,aTotais[nT,3],"100",nT})
				Else
					aAux[nItem,2] += aTotais[nT,3]
				EndIf				
			Else
				nItem := AScan(aAux, {|aX| aX[1]+aX[3]+cValToChar(aX[4]) == cTipoHr+"100"+cValToChar(nT)})
				If nItem == 0
					aAdd(aAux,{cTipoHr,8,"100",nT})
				Else
					aAux[nItem,2] += 8
				EndIf
				nItem := AScan(aAux, {|aX| aX[1]+aX[3] == cTipoHr+"150"})
				If nItem == 0
					aAdd(aAux,{cTipoHr,aTotais[nT,3]-8,"150",nT})
				Else
					aAux[nItem,2] += aTotais[nT,3]-8
				EndIf				
			EndIf							
		Next
		For nA := 1 to len(aAux)			
			aTemp := aClone(aTotais[aAux[nA,4]])
			If aAux[nA,1] == "A"
				If aAux[nA,3] == "100"
					aTotais[aAux[nA,4]][1] := dDataBase
					aTotais[aAux[nA,4]][4] := '371'
					aTotais[aAux[nA,4]][3] := aAux[nA,2]											
				Else
					aTemp[1] := dDataBase
					aTemp[2] := '927'
					aTemp[4] := '375'
					aTemp[3] := aAux[nA,2]
					aTemp[16] := 150
					aAdd(aTotais,aTemp)
				EndIf 
			ElseIf aAux[nA,1] == "B" 
				If aAux[nA,3] == "100"
					aTotais[aAux[nA,4]][1] := dDataBase
					aTotais[aAux[nA,4]][4] := '373'
					aTotais[aAux[nA,4]][3] := aAux[nA,2]						
				Else
					aTemp[1] := dDataBase
					aTemp[2] := '927'
					aTemp[4] := '377'
					aTemp[3] := aAux[nA,2]
					aAdd(aTotais,aTemp) 						
				EndIf  				
			EndIf
		Next			
	EndIf	

	For nA := 1 to len(aTotais)
		aTotais[nA][3] := fConvHr(aTotais[nA][3], "H")					
	Next
	
	For nU := 1 to len(aExc)				
		ADel(aTotais, aExc[nU])
		ASize(aTotais, len(aTotais)-1)
		For nH := 1 to len(aExc)				
			aExc[nH] := aExc[nH] - 1
		Next
	Next	
	
	QRYRA->(DbCloseArea())	

Return({aTotais,aBHAcum})


Static Function tipoEsp(aTotais,nT)
	Local aRet	 	:=  {}
	Local dData	:= aTotais[nT,1]
	Local nHoras	:= aTotais[nT,3]
	
	For nY := 1 to len(aTotais)
		If nY != nT
			If dData == aTotais[nY,1]
				cTipoHr := retTipo(aTotais[nY,2])
				//If cTipoHr $ "2,3,4"
				If cTipoHr $ "2,4"
					If aTotais[nY,3] >= 8
						aAdd(aRet,{"B",nHoras,"150",nT}) 
						aadd(aExc,nT)	
					ElseIf aTotais[nY,3] + nHoras >= 8
						aAdd(aRet,{"B",nHoras - (aTotais[nY,3] + nHoras - 8),"100",nT})
						aAdd(aRet,{"B",aTotais[nY,3] + nHoras - 8,"150",nT})
					Else
						aAdd(aRet,{"B",nHoras,"100",nT}) 
					EndIf															
					Exit
				EndIf			
			EndIf
		EndIf
	Next
	
Return aRet

Static Function tipoEsp2(aTotais,nT)
	Local aRet	 	:=  {}
	Local dData	:= aTotais[nT,1]
	Local nHoras	:= aTotais[nT,3]
	
	For nY := 1 to len(aTotais)
		If nY != nT
			If dData == aTotais[nY,1]
				cTipoHr := retTipo(aTotais[nY,2])
				If cTipoHr $ "2,4,6,8"
					cTipoHr := retTipo(aTotais[nT,2])
					If cTipoHr $ "2,4"
						cTipoHr := "A"
					ElseIf cTipoHr $ "6,8"
						cTipoHr := "B"					
					EndIF
					If aTotais[nY,3] >= 8
						aAdd(aRet,{cTipoHr,nHoras,"150",nT}) 
						aadd(aExc,nT)	
					ElseIf nHoras >= 8
						aAdd(aRet,{cTipoHr,8,"100",nT})
						aAdd(aRet,{cTipoHr,nHoras - 8,"150",nT})
					ElseIf aTotais[nY,3] + nHoras >= 8
						aAdd(aRet,{cTipoHr,nHoras - (aTotais[nY,3] + nHoras - 8),"100",nT})
						aAdd(aRet,{cTipoHr,aTotais[nY,3] + nHoras - 8,"150",nT})
					Else
						aAdd(aRet,{cTipoHr,nHoras,"100",nT}) 
					EndIf											
					Exit
				EndIf			
			EndIf
		EndIf
	Next
	
Return aRet


Static Function retTipo(cTipo)
	Local cRet		:= ""
	Local cQuery	:= ""
	cQuery += " SELECT P4_TIPO " + CRLF
	cQuery += " FROM " + RetSqlName("SP4") + " " + CRLF
	cQuery += " WHERE D_E_L_E_T_ = ' ' " + CRLF
	cQuery += " AND P4_FILIAL = '"+xFilial("SP4")+"' " + CRLF
	cQuery += " AND P4_CODAUT = '"+cTipo+"' " + CRLF
	
	
	TcQuery cQuery New Alias "QRY"
	QRY->(DbGoTop())
	If QRY->(!Eof())		
		cRet := QRY->P4_TIPO
	EndIf	
	QRY->(DbCloseArea())

Return cRet