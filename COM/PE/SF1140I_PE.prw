#Include "Protheus.ch"

/*/{Protheus.doc}	SF1140I
Ponto de entrada executado apos a inclusão da Pré Nota.

@author				Waldir Baldin
@since				20/08/2013
@return				Nil
/*/
User Function SF1140I()
	Local lPreNota	:= .T.

	// Notificacao NFE
	U_WFLOW01(lPreNota)
Return
