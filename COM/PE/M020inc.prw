#INCLUDE "rwmake.ch"

User Function M020INC()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³M030INC  º Autor ³ MICROSIGA          º Data ³  13/03/09    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Ponto de Entrada p/ para geracao automatica da Conta Conta-º±±
±±º          ³ bil do Cliente conforme inclusao do mesmo.                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Cadastro de Clientes                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±ºAlterações³ 17/11/2004 Donizete/Microsiga.                             º±±
±±º          ³ Atualizado para versão MP 8 e alterado lógica.             º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

// Declaração das Variáveis.
Local _xAreaSA2		:= {}
Local _xAreaCTD		:= {}
Local _cNome		:= ""
Local _cCod			:= ""


If INCLUI 
	
	dbSelectArea("SA2")
	_xAreaSA2 := GetArea()
	
	// Memoriza dados.
	_cNome		:= SA2->A2_NOME
	_cCod		:= "F"+SA2->A2_COD+SA2->A2_LOJA
	_cCad		:= "G"+SA2->A2_COD+SA2->A2_LOJA
		
	
	dbSelectArea("CTD")
	_xAreaCTD := GetArea()
	dbSetOrder(1)
	DbSeek(xFilial("CTD") + _cCod )
	If .not. Found()
		Begin Transaction
		If Reclock("CTD", .T.)
			
			REPLACE CTD->CTD_FILIAL WITH xFilial("CTD")
			REPLACE CTD->CTD_ITEM  WITH _cCod
			REPLACE CTD->CTD_CLASSE WITH  "2"
			REPLACE CTD->CTD_DESC01 WITH _cNome
			REPLACE CTD->CTD_CRGNV1 WITH "CLI"
			MsUnlock()
		
		EndIf
		
		END TRANSACTION
	Endif            
	
	
	dbSelectArea("CTD")
	_xAreaCTD := GetArea()
	dbSetOrder(1)
	DbSeek(xFilial("CTD") + _cCad )
	If .not. Found()
		Begin Transaction
		If Reclock("CTD", .T.)
			
			REPLACE CTD->CTD_FILIAL WITH xFilial("CTD")
			REPLACE CTD->CTD_ITEM  WITH _cCad
			REPLACE CTD->CTD_CLASSE WITH  "2"
			REPLACE CTD->CTD_DESC01 WITH _cNome
			REPLACE CTD->CTD_CRGNV1 WITH "CLI"
			MsUnlock()
		
		EndIf
		
		END TRANSACTION
	Endif
	
	// Restaura áreas de trabalho.
	RestArea(_xAreaCTD)
	RestArea(_xAreaSA2)
	
Endif

Return
