#Include 'Protheus.ch'

/*/{Protheus.doc} CADSZ2

Cadastro de norma EPR
	
@author André Oquendo
@since 22/04/2015

/*/

User Function CADSZ2()

	Local cTabela		:= "SZ2"
	
	dbSelectArea(cTabela)
	dbSetOrder(1)
	axCadastro(cTabela,"Cadastro de norma EPR")

Return