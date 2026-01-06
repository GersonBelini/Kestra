#Include 'Protheus.ch'

/*/{Protheus.doc} CTB270TOK

Ponto de entrada para validar o campo critério de rateio.
	
@author André Oquendo
@since 14/04/2015

/*/

User Function CTB270TOK()

	Local lRet				:= .T.
	If type("_cCrit") != "U"		
		If empty(_cCrit)
			msgAlert("Campo critério de rateio obrigatório!")
			lRet		:= .F.	
		EndIf
	EndIf

Return lRet

