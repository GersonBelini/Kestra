#Include 'Protheus.ch'

/*/{Protheus.doc} CADSZ3

Cadastro de norma ASME
	
@author André Oquendo
@since 22/04/2015

/*/

User Function CADSZ3()

	Local cTabela		:= "SZ3"
	
	dbSelectArea(cTabela)
	dbSetOrder(1)
	axCadastro(cTabela,"Cadastro de norma ASME")

Return