#include "protheus.ch"

//************************************************************************************************************************************************
// Nome			: Diego de Angelo
// Fonte		: PEWFCT
// Descrição	: Ponto de entrada para tratamento e manipulação dos arquivos HTML (Inclusão de e alteração de campos)
//				: na rotina de cotação.
// Data			: 19/06/2012
//************************************************************************************************************************************************
User Function PEWFCT()
	Local aArea    		:= GetArea()
	Local aAreaSC8 		:= SC8->(GetArea())
	Local xRet := U_WFHTMLCOT(PARAMIXB)		
	RestArea(aAreaSC8)
	RestArea(aArea)   
Return(xRet)
