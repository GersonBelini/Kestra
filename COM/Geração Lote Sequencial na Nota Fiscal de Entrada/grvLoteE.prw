#Include 'Protheus.ch'

/*/{Protheus.doc} grvLoteE

Grava o lote no documento de entrada.
	
@author André Oquendo
@since 07/05/2015

/*/

User Function grvLoteE()
	Local nPosProd	:= GdFieldPos("D1_COD")
	Local nPosLote	:= GdFieldPos("D1_LOTECTL")
	If alltrim(funName()) == "MATA103"
		For nI := 1 to Len(aCols)
			If !aCols[nI,Len(aHeader)+1]/*Não deletado*/
				dbSelectArea("SB1")
				dbSetOrder(1)//B1_FILIAL+B1_COD
				dbSeek(xFilial("SB1")+aCols[nI,nPosProd])
				If SB1->B1_RASTRO == "L" .AND. alltrim(aCols[nI,nPosLote]) == ""
					aCols[nI,nPosLote] := geraSeqE()
				EndIf 
			EndIf
		Next
	EndIf


Return

/*/{Protheus.doc} geraSeqE

Gera o lote sequencia no documento de entrada.
	
@author André Oquendo
@since 07/05/2015

@return Caracter Numero do lote.
/*/

Static Function geraSeqE()

	Local cRet			:= ""
	Local cAnoMes		:= substr(DtoS(dDataBase),3,2)+substr(DtoS(dDataBase),5,2)
	Local cSequen		:= "0001"
	dbSelectArea("SZ7")
	dbSetOrder(1)//Filial+Ano/Mes
	If dbSeek(xFilial("SZ7")+cAnoMes)
		cSequen := soma1(SZ7->Z7_SEQUEN)		
		RecLock("SZ7",.F.)
			SZ7->Z7_SEQUEN := cSequen
		MsUnLock()
	Else		
		RecLock("SZ7",.T.)
			SZ7->Z7_FILIAL 	:= xFilial("SZ7")		
			SZ7->Z7_ANOMES 	:= cAnoMes
			SZ7->Z7_SEQUEN 	:= cSequen
		MsUnLock()			
	EndIf
	cRet := cAnoMes+cSequen
	
Return cRet

