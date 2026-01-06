#Include 'Protheus.ch'

//-------------------------------------------------------------------
/*/{Protheus.doc} CHGX5FIL
P.E. - Utiliza Tabela 01 Exclusiva em um SX5 Compartilhado

*Para funcionar tem que preencher o campo X5_FILIAL mesmo a
tabela X5 sendo compartilhada

@param nenhum
@return nenhum

/*/
//-------------------------------------------------------------------
User Function CHGX5FIL()

	Local _cRet := ALLTRIM(SM0->M0_CODFIL)

Return(_cRet)

