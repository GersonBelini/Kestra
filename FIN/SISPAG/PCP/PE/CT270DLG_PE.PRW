#INCLUDE "PROTHEUS.CH"

/*/{Protheus.doc} CT270DLG

O ponto de entrada CT270DLG permite a customização da tela do Rateio Off-Line.
	
@author André Oquendo
@since 09/04/2015

@return Objeto Objeto recebido com o novo campo.
/*/

User function CT270DLG()

	Local oDlgPE 		:= paramixb	    
	Local oGet
	Public _cCrit		:= space(tamSX3("CTQ_ZZCRAT")[1])
	
	If !INCLUI
		_cCrit := CTQ->CTQ_ZZCRAT
	EndIf
	@ 277,  07 SAY "Criterio de Rateio" OF oDlgPE PIXEL 
	@ 275,  55 MSGET oGet VAR _cCrit OF oDlgPE PIXEL SIZE 30,9 F3 "Z1" VALID valCrit()

Return (oDlgPE)


Static Function valCrit()
	Local lRet		:= .T.

	If empty(_cCrit)
		msgAlert("Campo critério de rateio obrigatório!")
		lRet		:= .F.
	Else
		dbSelectArea("SX5")
		dbSetOrder(1)
		If !dbSeek(xFilial("SX5")+"Z1"+_cCrit)
			msgAlert("Critério não cadastrado!")
			lRet		:= .F.
		EndIf
	EndIf	

Return lRet