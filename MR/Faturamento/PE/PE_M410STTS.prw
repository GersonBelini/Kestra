#Include 'Protheus.ch'

/*{protheus.doc}

Descrição:
Este ponto de entrada pertence à rotina de pedidos de venda, MATA410().
Está em todas as rotinas de inclusão, alteração, exclusão, cópia e devolução de compras.

Executado após todas as alterações no arquivo de pedidos terem sido feitas.

Parâmetros:
nOper --> Tipo: Numérico - Descrição: Operação que está sendo executada, sendo:

3 - Inclusão
4 - Alteração
5 - Exclusão
6 - Cópia
7 - Devolução de Compras


Programa Fonte:
MATA410.PRX

Sintaxe:
M410STTS( nOper ) --> Nenhum


Retorno:
Nenhum

*/


User Function M410STTS()

Local _nOper := PARAMIXB[1]
/*
If _nOper == 6 //Cópia


EndIf
*/
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Posiciona o Pedido de Venda                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
SA4->(dbSetOrder(1))
If !SC5->C5_TIPO$"DB"
	//If SoftLock("SC5")
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Busca as referencias fiscais                 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aFisGet	:= MaFisRelImp("MATA461",{"SC6"})
		aSort(aFisGet,,,{|x,y| x[3]<y[3]})
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Busca referencias no SC5                     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aFisGetSC5	:= MaFisRelImp("MATA461",{"SC5"})
		aSort(aFisGetSC5,,,{|x,y| x[3]<y[3]})

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Posiciona a trasnportadora³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If SA4->(dbSeek(xFilial("SA4")+SC5->C5_TRANSP))
			aTransp[01] := SA4->A4_EST
			aTransp[02] := SA4->A4_TPTRANS
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Inicializa a funcao fiscal                   ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		MaFisSave()
		MaFisEnd()
		MaFisIni(Iif(Empty(SC5->C5_CLIENT),SC5->C5_CLIENTE,SC5->C5_CLIENT),;
			SC5->C5_LOJAENT,;
			IIf(SC5->C5_TIPO$'DB',"F","C"),;
			SC5->C5_TIPO,;
			SC5->C5_TIPOCLI,;
			Nil,;
			Nil,;
			Nil,;
			Nil,;
			"MATA461",; 
			Nil,;
			Nil,;
			Nil,;
			Nil,;
			Nil,;
			Nil,;
			Nil,;
			aTransp,,,,SC5->C5_CLIENTE,SC5->C5_LOJACLI,,,SC5->C5_TPFRETE)

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Realiza alteracoes de referencias do SC5         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If Len(aFisGetSC5) > 0
			dbSelectArea("SC5")
			For nX := 1 to Len(aFisGetSC5)
				If !Empty(&(aFisGetSC5[nX][2]))
					MaFisAlt(aFisGetSC5[nX][1],&(aFisGetSC5[nX][2]),nItem,.T.)
				EndIf
			Next nX
		EndIf

		If cPaisLoc == 'ARG'
			SA1->(DbSetOrder(1))
			SA1->(MsSeek(xFilial()+IIf(!Empty(SC5->C5_CLIENT),SC5->C5_CLIENT,SC5->C5_CLIENTE)+SC5->C5_LOJAENT))
			MaFisAlt('NF_SERIENF',LocXTipSer('SA1',MVNOTAFIS))
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Agrega os itens para a funcao fiscal         ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea("SC6")
		dbSetOrder(1)

		cAliasSC6 := "Ma410Fluxo"
		aStruSC6  := SC6->(dbStruct())
		cQuery    := "SELECT * "
		cQuery    += "FROM "+RetSqlName("SC6")+" SC6 "
   		cQuery    += "WHERE SC6.C6_FILIAL='"+cFilSC6+"' AND "
		cQuery    += "SC6.C6_NUM='"+cNumPV+"' AND "
		cQuery    += "SC6.C6_BLQ NOT IN('R ','S ') AND "
		cQuery    += "SC6.D_E_L_E_T_=' ' "

		cQuery := ChangeQuery(cQuery)
		dbUseArea(.T.,"TOPCONN",cAliasSC6,TcGenQry(,,cQuery))

		For nX := 1 To Len(aStruSC6)
			If aStruSC6[nX][2] <> "C" .And. aStruSC6[nX][2] <> "M"
				TcSetField(cAliasSC6,aStruSC6[nX][1],aStruSC6[nX][2],aStruSC6[nX][3],aStruSC6[nX][4])
			EndIf
		Next nX

   		While !Eof() .And. cFilSC6 == (cAliasSC6)->C6_FILIAL .And. cNumPV == (cAliasSC6)->C6_NUM
			If !Substr((cAliasSc6)->C6_BLQ,1,1) $"RS" .And. Empty((cAliasSc6)->C6_BLOQUEI)
				nItem++
				If !Empty((cAliasSC6)->C6_NFORI) .And. !Empty((cAliasSC6)->C6_ITEMORI)
					SD1->(dbSetOrder(1))
					If SD1->(MSSeek(xFilial("SD1")+(cAliasSC6)->C6_NFORI+(cAliasSC6)->C6_SERIORI+SC5->C5_CLIENTE+SC5->C5_LOJACLI+(cAliasSC6)->C6_PRODUTO+(cAliasSC6)->C6_ITEMORI))
						nRecOri := SD1->(Recno())
					Endif
				Endif

				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Calcula o preco de lista                     ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				nValMerc  := IIf((cAliasSC6)->C6_QTDVEN==0,(cAliasSC6)->C6_VALOR,((cAliasSC6)->C6_QTDVEN-(cAliasSC6)->C6_QTDENT)*(cAliasSC6)->C6_PRCVEN)
				nPrcLista := (cAliasSC6)->C6_PRUNIT
				If ( nPrcLista == 0 )
					nPrcLista := NoRound(nValMerc/IIf((cAliasSC6)->C6_QTDVEN==0,(cAliasSC6)->C6_VALOR,((cAliasSC6)->C6_QTDVEN-(cAliasSC6)->C6_QTDENT)),TamSX3("C6_PRCVEN")[2])
				EndIf
				
				nAcresUnit:= A410Arred((cAliasSC6)->C6_PRCVEN*SC5->C5_ACRSFIN/100,"D2_PRCVEN")
				nAcresFin := A410Arred(((cAliasSC6)->C6_QTDVEN-(cAliasSC6)->C6_QTDENT)*nAcresUnit,"D2_TOTAL")
				nAcresTot += nAcresFin
				nValMerc  += nAcresFin
				nDesconto := a410Arred(nPrcLista*((cAliasSC6)->C6_QTDVEN-(cAliasSC6)->C6_QTDENT),"D2_DESCON")-nValMerc
				nDesconto := IIf(nDesconto==0,(cAliasSC6)->C6_VALDESC,nDesconto)				
				nDesconto := Max(0,nDesconto)
				nPrcLista += nAcresUnit
					
				If cPaisLoc=="BRA"
					nValMerc  += nDesconto
				EndIf
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Agrega os itens para a funcao fiscal         ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				MaFisAdd((cAliasSC6)->C6_PRODUTO,;   	// 1-Codigo do Produto ( Obrigatorio )
							(cAliasSC6)->C6_TES,;	   	// 2-Codigo do TES ( Opcional )
							(cAliasSC6)->C6_QTDENT,;  	// 3-Quantidade ( Obrigatorio )
							(cAliasSC6)->C6_PRUNIT,;	// 4-Preco Unitario ( Obrigatorio )
							nDesconto,; 				// 5-Valor do Desconto ( Opcional )
							"",;	   					// 6-Numero da NF Original ( Devolucao/Benef )
							"",;						// 7-Serie da NF Original ( Devolucao/Benef )
							nRecOri,;					// 8-RecNo da NF Original no arq SD1/SD2
							0,;							// 9-Valor do Frete do Item ( Opcional )
							0,;							// 10-Valor da Despesa do item ( Opcional )
							0,;							// 11-Valor do Seguro do item ( Opcional )
							0,;							// 12-Valor do Frete Autonomo ( Opcional )
							nValMerc,;					// 13-Valor da Mercadoria ( Obrigatorio )
							0,;							// 14-Valor da Embalagem ( Opiconal )
			   				,,,,,,,,,;                	// 15,16,17,18,19,20,21,22 e 23
							(cAliasSC6)->C6_LOTECTL,;	// 24-Lote Produto
							(cAliasSC6)->C6_NUMLOTE)	// 25-Sub-Lote Produto

				SB1->(dbSetOrder(1))
				If SB1->(MsSeek(xFilial("SB1")+(cAliasSC6)->C6_PRODUTO))
					nQtdPeso := ((cAliasSC6)->C6_QTDVEN-(cAliasSC6)->C6_QTDENT)*SB1->B1_PESO
				EndIf
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Calculo do ISS                               ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				SF4->(dbSetOrder(1))
				SF4->(MsSeek(xFilial("SF4")+(cAliasSC6)->C6_TES))
				If ( SC5->C5_INCISS == "N" .And. SC5->C5_TIPO == "N")
					If ( SF4->F4_ISS=="S" )
						nPrcLista := a410Arred(nPrcLista/(1-(MaAliqISS(nItem)/100)),"D2_PRCVEN")
						nValMerc  := a410Arred(nValMerc/(1-(MaAliqISS(nItem)/100)),"D2_PRCVEN")
					EndIf
				EndIf
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Altera peso para calcular frete              ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				MaFisAlt("IT_PESO",nQtdPeso,nItem)
				MaFisAlt("IT_PRCUNI",nPrcLista,nItem)
				MaFisAlt("IT_VALMERC",nValMerc,nItem)
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Forca os valores de impostos que foram informados no SC6.              ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				dbSelectArea("SC6")
				For nX := 1 to Len(aFisGet)
					If !Empty(&(aFisGet[nX][2]))
						MaFisAlt(aFisGet[nX][1],&(aFisGet[nX][2]),nItem,.T.)
					EndIf
				Next nX
				If nItem == 1
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³Realiza alteracoes de referencias do SC5 Suframa ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					nPSuframa:=aScan(aFisGetSC5,{|x| x[1] == "NF_SUFRAMA"})
					If !Empty(nPSuframa)
						dbSelectArea("SC5")
						If !Empty(&(aFisGetSC5[nPSuframa][2]))
							MaFisAlt(aFisGetSC5[nPSuframa][1],Iif(&(aFisGetSC5[nPSuframa][2]) == "1",.T.,.F.),nItem,.T.)
						EndIf
					Endif
				EndIf
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³Verifica a data de entrega para as duplicatas³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				dData   := Iif( (cAliasSc6)->C6_ENTREG < dDataBase, dDataBase, (DataValida((cAliasSc6)->C6_ENTREG)))
				aAdd(aFluxoTmp,{dData,nItem})
				If SF4->F4_DUPLIC=="S"
					nTotDesc += MaFisRet(nItem,"IT_DESCONTO")
				Else
					If GetNewPar("MV_TPDPIND","1")=="1"
						nTotDesc += MaFisRet(nItem,"IT_DESCONTO")
					EndIf
				EndIf
			EndIf
			dbSelectArea(cAliasSC6)
			dbSkip()
		EndDo
		
		dbSelectArea(cAliasSC6)
		dbCloseArea()
		dbSelectArea("SC6")

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Indica os valores do cabecalho               ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		MaFisAlt("NF_FRETE",SC5->C5_FRETE)
		MaFisAlt("NF_VLR_FRT",SC5->C5_VLR_FRT)
		MaFisAlt("NF_SEGURO",SC5->C5_SEGURO)
		MaFisAlt("NF_AUTONOMO",SC5->C5_FRETAUT)
		MaFisAlt("NF_DESPESA",SC5->C5_DESPESA)  
		If cPaisLoc == "PTG"                    
			MaFisAlt("NF_DESNTRB",SC5->C5_DESNTRB)  
			MaFisAlt("NF_TARA",SC5->C5_TARA)  
		Endif
		If SC5->C5_DESCONT > 0
			MaFisAlt("NF_DESCONTO",Min(MaFisRet(,"NF_VALMERC")-0.01,nTotDesc+SC5->C5_DESCONT),/*nItem*/,/*lNoCabec*/,/*nItemNao*/,GetNewPar("MV_TPDPIND","1")=="2" )
		EndIf
		If SC5->C5_PDESCAB > 0
			MaFisAlt("NF_DESCONTO",A410Arred(MaFisRet(,"NF_VALMERC")*SC5->C5_PDESCAB/100,"C6_VALOR")+MaFisRet(,"NF_DESCONTO"))
		EndIf
		MaFisWrite(1)
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Obtem os valores da funcao fiscal                ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		For nX := 1 To Len(aFluxoTmp)
			nPosEntr := Ascan(aEntr,{|x| x[1]==aFluxoTmp[nX][1]})
			If nPosEntr == 0
				aAdd(aEntr,{aFluxoTmp[nX][1],MaFisRet(aFluxoTmp[nX][2],"IT_BASEDUP"),MaFisRet(aFluxoTmp[nX][2],"IT_VALIPI"),MaFisRet(aFluxoTmp[nX][2],"IT_VALSOL")})
			Else
				aEntr[nPosEntr][2]+= MaFisRet(aFluxoTmp[nX][2],"IT_BASEDUP")
				aEntr[nPosEntr][3]+= MaFisRet(aFluxoTmp[nX][2],"IT_VALIPI")
				aEntr[nPosEntr][4]+= MaFisRet(aFluxoTmp[nX][2],"IT_VALSOL")
			EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Ponto de Entrada M410IPI para alterar os valores do IPI referente a palnilha financeira           ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If lM410Ipi 
				VALORIPI    := MaFisRet(nItem,"IT_VALIPI")
				BASEIPI     := MaFisRet(nItem,"IT_BASEIPI")
				QUANTIDADE  := MaFisRet(nItem,"IT_QUANT")
				ALIQIPI     := MaFisRet(nItem,"IT_ALIQIPI")
				BASEIPIFRETE:= MaFisRet(nItem,"IT_FRETE")
				MaFisAlt("IT_VALIPI",ExecBlock("M410IPI",.F.,.F.,),nItem,.T.)
				MaFisLoad("IT_BASEIPI",BASEIPI ,nItem)
				MaFisLoad("IT_ALIQIPI",ALIQIPI ,nItem)
				MaFisLoad("IT_FRETE"  ,BASEIPIFRETE,nItem,"11")
				MaFisEndLoad(nItem,1)
			EndIf
		Next nX
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Calcula os venctos conforme a condicao de pagto  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectarea("SE4")
		dbSetOrder(1)
		If MsSeek(xFilial("SE4")+SC5->C5_CONDPAG)
			For nY := 1 to Len(aEntr)
				nAcerto  := 0
				
				If SFB->FB_JNS == 'J' .And. cPaisLoc == 'COL'
					dbSelectArea("SFC")
					dbSetOrder(2)
					If dbSeek(xFilial("SFC") + SF4->F4_CODIGO + "RV0" )
						nValRetImp 	:= MaFisRet(,"NF_VALIV2")
						Do Case
							Case FC_INCDUPL == '1'
								nlValor := aEntr[nY][2] - nValRetImp
							Case FC_INCDUPL == '2'
								nlValor :=aEntr[nY][2] + nValRetImp
							Otherwise
								nlValor :=aEntr[nY][2]
						EndCase
					Elseif dbSeek(xFilial("SFC") + SF4->F4_CODIGO + "RF0" )
						nValRetImp 	:= MaFisRet(,"NF_VALIV4")
						Do Case
							Case FC_INCDUPL == '1'
								nlValor := aEntr[nY][2] - nValRetImp
							Case FC_INCDUPL == '2'
								nlValor :=aEntr[nY][2] + nValRetImp
							Otherwise
								nlValor :=aEntr[nY][2]
						EndCase
					Elseif dbSeek(xFilial("SFC") + SF4->F4_CODIGO + "RC0" )
						nValRetImp 	:= MaFisRet(,"NF_VALIV7")
						Do Case
							Case FC_INCDUPL == '1'
								nlValor := aEntr[nY][2] - nValRetImp
							Case FC_INCDUPL == '2'
								nlValor :=aEntr[nY][2] + nValRetImp
							Otherwise
								nlValor :=aEntr[nY][2]
						EndCase
					Endif
				ElseIf cPaisLoc=="EQU" 
					nlValor := aEntr[nY][2]
					SA1->(DbSetOrder(1))
					SA1->(MsSeek(xFilial()+IIf(!Empty(SC5->C5_CLIENT),SC5->C5_CLIENT,SC5->C5_CLIENTE)+SC5->C5_LOJAENT))
					cNatureza:=SA1->A1_NATUREZ
					lPParc:=Posicione("SED",1,xFilial("SED")+cNatureza,"ED_RATRET")=="1"	
					If lPParc
						DbSelectArea("SFC")
						SFC->(dbSetOrder(2))
						If DbSeek(xFilial("SFC") + SF4->F4_CODIGO + "RIR") //Retenção IVA
							cImpRet		:= SFC->FC_IMPOSTO
							DbSelectArea("SFB")
							SFB->(dbSetOrder(1))
							If SFB->(DbSeek(xFilial("SFB")+AvKey(cImpRet,"FB_CODIGO")))
								nValRetImp 	:= MaFisRet(,"NF_VALIV"+SFB->FB_CPOLVRO)
						    Endif       
						    DbSelectArea("SFC")
							If SFC->FC_INCDUPL == '1'
								nlValor	:=aEntr[nY][2] - nValRetImp				
							ElseIf SFC->FC_INCDUPL == '2'
								nlValor :=aEntr[nY][2] + nValRetImp
							EndIf   
						EndIf	
				    Endif
				Else
					nlValor := aEntr[nY][2]
				EndIf
				
				aFluxoTmp := Condicao(nlValor,SC5->C5_CONDPAG,aEntr[nY][3],aEntr[nY][1],aEntr[nY][4],,,nAcresTot)
				If !Empty(aFluxoTmp)             
					If cPaisLoc=="EQU"
						For nX := 1 To Len(aFluxoTmp)
							If nX==1                            
								If SFC->FC_INCDUPL == '1'
									aFluxoTmp[nX][2]+= nValRetImp
								ElseIf SFC->FC_INCDUPL == '2'
									aFluxoTmp[nX][2]-= nValRetImp
								Endif										
							Endif	
						Next nX
					Else
						For nX := 1 To Len(aFluxoTmp)
							nAcerto += aFluxoTmp[nX][2]
						Next nX	
						aFluxoTmp[Len(aFluxoTmp)][2] += aEntr[nY][2] - nAcerto	
					Endif
					For nX := 1 To Len(aFluxoTmp)
						nZ := aScan(aFluxo,{|x| x[1] == aFluxoTmp[nX][1]})
						If nZ == 0
							aAdd(aFluxo,{aFluxoTmp[nX][1],0})
							nZ := Len(aFluxo)
						EndIf
						aFluxo[nZ][2] += aFluxoTmp[nX][2]
					Next nX
				EndIf
			Next nY
		EndIf
		If Len(aFluxo) == 0
			aDupl := {{dDataBase,MaFisRet(,"NF_BASEDUP"),PesqPict("SE1","E1_VALOR")}}
		Endif
		MaFisEnd()
		MaFisRestore()
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Atualiza a tabela de fluxo de caixa do PV        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

		Begin Transaction
			dbSelectArea("AID")
			
			cQuery := "DELETE FROM "+RetSqlName("AID")+" WHERE AID_FILIAL='"+cFilAID+"' AND AID_NUMPV='"+cNumPV+"' "
			TcSqlExec(cQuery)
	
			For nX := 1 To Len(aFluxo)
				If aFluxo[nX,2] <> 0
					RecLock("AID",.T.)
					AID->AID_FILIAL := xFilial("AID")
					AID->AID_NUMPV  := cNumPV
					AID->AID_DATA   := aFluxo[nX,1]
					AID->AID_VALOR  := aFluxo[nX,2]
					MsUnLock()
				EndIf
			Next nX
		
		End Transaction
		SC5->(MsUnLockAll())
//	EndIf
EndIf

Return Nil
