#Include "Protheus.ch"

/*/{Protheus.doc}	MT097END
Função da Dialog de liberação e bloqueio dos documentos com alçada, 
A097SUPERI - Função da Dialog de liberação e bloqueio dos documentos 
com alçada pelo superior e A097TRANSF Função responsável pela transferência 
do registro de bloqueio para aprovação do Superior.  

@author				Julio Lisboa - TOTVS IP Campinas
@since				01/12/2014
@return				Nil
/*/
User Function MT097END()
	
	Local aAreaATU	:= GetArea()
	Local aAreaSC7	:= SC7->(GetArea())
	Local cPedido		:= AllTrim(PARAMIXB[01])
	Local nOpc			:= PARAMIXB[03]
	
	//Opção 2 é "Libera Docto"
	If nOpc <> nil
		If nOpc == 2
			SC7->(DbSetOrder(1))
			If SC7->(DbSeek(xFilial("SC7") + cPedido))
				If SC7->C7_CONAPRO == "B"
					U_WFPC()
				ElseIf SC7->C7_CONAPRO == "L" .and. Empty(SC7->C7_ZZDTENV)
					U_PedEnviar(3,cPedido)
				EndIf
			EndIf
		EndIf
	EndIf
	
	RestArea(aAreaSC7)
	RestArea(aAreaATU)
	
Return
