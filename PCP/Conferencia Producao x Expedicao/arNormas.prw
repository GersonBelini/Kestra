#Include 'Protheus.ch'

/*/{Protheus.doc} arNormas

Carrega as normas do SB1 para os campos no SC2
	
@author André Oquendo
@since 24/04/2015


@return Logico Validação do campo
/*/

User Function arNormas()
	Local lRet		:= .T.
	
	dbSelectArea("SB1")
	dbSetOrder(1)//B1_FILIAL+B1_COD
	dbSeek(xFilial("SB1")+M->C2_PRODUTO)
	
	M->C2_ZZNDIN	:= SB1->B1_ZZNDIN
	M->C2_ZZNEPR	:= SB1->B1_ZZNEPR
	M->C2_ZZASME	:= SB1->B1_ZZASME

Return lRet

