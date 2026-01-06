#Include 'Protheus.ch'

//-------------------------------------------------------------------
/*/{Protheus.doc} SX5NOTA
Retorna apenas a serie da NF conforme parametro

@param nenhum
@return nenhum


/*/
//-------------------------------------------------------------------
User Function SX5NOTA()

	Local _lret := .F.
	Local _lPren:= .F.
	Local aArea    := GetArea()
	Local aAreaSX5 := SX5->(GetArea())


	If  ALLTRIM(X5_CHAVE) $ GetNewPar("ZZ_SERNOTA","1")
		_lret := .T.
	Endif
 

	RestArea(aArea)
	RestArea(aAreaSX5)


return(_lret)

