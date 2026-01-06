#Include "Protheus.ch"

/*/{Protheus.doc} MT160GRPC

PE para atualizacao de campos especificos do SC7 na Geração de Pedido de Compra pela Análise de Cotação
Este Ponto de Entrada é necessário qdo a Cotação já foi enviada por Workflow (C8_ZZDTENV preenchida) e ao 
gerar o Pedido de Compra pela análise da Cotação, o sistema pega todos os campos da C8 que tem o mesmo nome na SC7
e replica automaticamente, replicando incorretamente o campo C7_ZZDTENV. Se o campo C7_ZZDTENV estiver preenchido
não irá enviar e-mail do Pedido de Compra gerado para o Fornecedor após a Liberação do Pedido qdo há o controle de Alçada

@author Carlos Eduardo Niemeyer Rodrigues
@since 10/03/2015
@see Workflow de Compras
@sample

	Contexto:
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³PE para atualizacao de campos especificos do SC7      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ						
	If lPEGerPC
		ExecBlock("MT160GRPC",.F.,.F.,{aVencedor,aSC8})
	EndIf	
*/
User Function MT160GRPC()
	Local aVencedor := PARAMIXB[01]
	Local aSC8 		:= PARAMIXB[02]
	
	dbSelectArea("SC7")
	RecLock("SC7",.F.)
		SC7->C7_ZZDTENV := Stod("")
	SC7->(MsUnLock())

Return