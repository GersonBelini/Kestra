#Include "Protheus.ch"

/*/{Protheus.doc}	MT150END
Ponto de entrada quando se incluir um novo participante ou uma nova proposta na análise da cotação.

@author				Waldir Baldin
@since				02/07/2013
@return				Nil
/*/
User Function MT150END()
	U_WFLOW02()					// Envio workflow de cotacao
Return
