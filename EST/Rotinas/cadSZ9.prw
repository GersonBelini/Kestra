#Include 'Protheus.ch'

User Function cadSZ9()
	Local cTabela		:= "SZ9"
	
	dbSelectArea(cTabela)
	dbSetOrder(1)
	axCadastro(cTabela,"Cadastro de Usuario x Cliente")
Return

