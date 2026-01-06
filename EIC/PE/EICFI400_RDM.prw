/*
Nome       			: EICFI400_RDM() -> Nil
Descrição  			: PE na geracao do titulo financeiro das despesas de importacao
Ponto	   			:
Nota       			: -
Ambiente   			: FATURAMENTO
Cliente				: KESTRA
Autor      			: Andre Borin - TOTVS IP
Data Criação 		: 29/07/2015
Param. Pers 		: -
Campos Pers.		: -

Nº Revisão			: -
Data Revisão		: -
Revisor				: -                 
Nota				: 
*/

User Function EICFI400
	
	If Alltrim(ParamIXB) == "FI400INCTIT"
		U_KSTEIC01()
	EndIf
Return