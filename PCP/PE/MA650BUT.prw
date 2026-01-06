#Include "Protheus.ch"
#Include "TopConn.ch"

***********************************************************************************************************************
***********************************************************************************************************************
//Função: MA650BUT() - Ponto de Entrada na Ordem de Produção para impressão de Etiqueta de Produto - Caixa           //
***********************************************************************************************************************
***********************************************************************************************************************
User Function MA650BUT()
	
	Local aRetorno:= {}    
	
	aRetorno:= paramixb

	aAdd(aRetorno,{'Impressão OP','U_imprOP()',0,10,0,Nil })
	aAdd(aRetorno,{'Reabertura OP','U_reabreOP()',0,10,0,Nil })
	
Return aRetorno


User Function ReabreOP
	
	If !Empty(SC2->C2_DATRF)
		Reclock("SC2",.F.)
			SC2->C2_DATRF := StoD("")
		SC2->(MsUnlock())
		
		MsgInfo('Op reaberta. Favor encerrar utilizando o botão "Encerrar" na rotina de apontamento de produção.',"MA650BUT")
	Else
		MsgAlert('Op não está encerrada, portanto não há necessidade de reabrir.',"MA650BUT")
	Endif

Return
