#Include 'Protheus.ch'

/*/{Protheus.doc} CADSZ1

Cadastro de norma DIN
	
@author André Oquendo
@since 22/04/2015

/*/

User Function CADSZ1()

	Local cTabela		:= "SZ1"
	
	dbSelectArea(cTabela)
	dbSetOrder(1)
	axCadastro(cTabela,"Cadastro de norma DIN")

Return

