#Include 'Protheus.ch'

/*/{Protheus.doc} geraLote

Gera o lote Kestra
	
@author André Oquendo
@since 24/04/2015

@return Logico Validação do campo

/*/

User Function geraLote()
	Local lRet			:= .T.
	Local cLote		:= ""
	
	dbSelectArea("SC2")
	dbSetOrder(1)//C2_FILIAL+C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD
	dbSeek(xFilial("SC2")+M->H6_OP)
	
	cLote := SC2->C2_ZZNCORR + SC2->C2_ZZREQUA
	
	M->H6_LOTECTL := cLote 

Return lRet

