#Include 'Protheus.ch'

/*/{Protheus.doc} MT160WF

Após a gravação dos pedidos de compras pela analise da cotação e antes dos eventos de 
contabilização, utilizado para os processos de workFlow posiciona a tabela SC8 e 
passa como parametro o numero da cotação.

Usado para gravar C7_ZZDESTC.
	
@author André Oquendo
@since 12/05/2015

/*/

User Function MT160WF()
	
	//Salvar C7_ZZDESTC
	u_grvDestC(SC8->C8_NUMPED)
	
	&& Envio workflow de pedido de compra, quando a cotação de compra nacional
	U_WFPC()
	
Return