#include "protheus.ch"

//************************************************************************************************************************************************
// Nome			: Diego de Angelo
// Fonte		: WFHTML
// Descrição	: Ponto de entrada para tratamento e manipulação dos arquivos HTML (Inclusão de e alteração de campos)
//				: na rotina de cotação.
// Data			: 19/06/2012
//************************************************************************************************************************************************
User Function WFHTMLCOT(cDado)
	Local aArea    		:= GetArea()
	Local aAreaSC8 		:= SC8->(GetArea())
	Local cPonto		:= cDado
	Local xRet			:= {}
	Local aFarmacopeia	:= {}

	&& Cotação - Envio Cabecalho
	If Alltrim(cPonto) == "HTML_COTEN_CAMPOS_CAB"
		//xRet := {{"TESTE", "0001"}}
	Endif

	&& Cotação - Envio Itens
	If Alltrim(cPonto) == "HTML_COTEN_CAMPOS_ITEM"
		cUMRet	:= TMPSC8->C8_UM
		dbSelectArea("SA5")
		dbSetOrder(1)//A5_FILIAL+A5_FORNECE+A5_LOJA+A5_PRODUTO
		If dbSeek(xFilial("SA5")+TMPSC8->C8_FORNECE+TMPSC8->C8_LOJA+TMPSC8->C8_PRODUTO)    
			If !empty(SA5->A5_UNID)
				cUMRet := SA5->A5_UNID
			EndIf				
		EndIf		
		xRet:= {{"tb.umfor",cUMRet}}        
	Endif

	&& Cotação - endereços de emails alteranativos para enviar a cotação
	If Alltrim(cPonto) == "EMAIL_COTACAO"
		xRet := u_retEmail(TMPSC8->C8_FORNECE,TMPSC8->C8_LOJA)		
	Endif

	&& Cotação - Sem resposta
	If Alltrim(cPonto) == "HTML_COTSR_CAMPOS_CAB"
		//xRet := {{"TESTE", "0001"}}
	Endif

	&& Cotação - Aviso de geração de cotação para os itens
	If Alltrim(cPonto) == "HTML_COTAV_CAMPOS"
		cUMRet	:= SC8->C8_UM
		dbSelectArea("SA5")
		dbSetOrder(1)//A5_FILIAL+A5_FORNECE+A5_LOJA+A5_PRODUTO
		If dbSeek(xFilial("SA5")+SC8->C8_FORNECE+SC8->C8_LOJA+SC8->C8_PRODUTO)    
			If !empty(SA5->A5_UNID)
				cUMRet := SA5->A5_UNID
			EndIf				
		EndIf		
		xRet:= {{"tb.umfor",cUMRet}} 
	Endif

	&& Cotação - Aviso de geração de cotação para o cabeçalho
	If Alltrim(cPonto) == "HTML_COTAV_CAB_CAMPOS"
		//xRet := {{"TESTE", "0001"}}
	Endif

	&& Cotação - Cotação Repondida
	If Alltrim(cPonto) == "HTML_COTRESP_CAMPOS"
		//xRet := {{"TESTE", "0001"}}
	Endif
	RestArea(aAreaSC8)
	RestArea(aArea)  
Return(xRet)