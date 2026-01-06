#include "Protheus.ch"
#include "Totvs.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณTMKCBPRO บAutor  ณBorin - TOTVS IP     บ Data ณ 08/06/2015  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPonto de Entrada do modulo Call Center para inclusao de novaบฑฑ
ฑฑบ          ณop็ใo em acoes relacionadas do atendimento do Televendas.   บฑฑ
ฑฑบ			 ณ															  บฑฑ
ฑฑฬออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso     ณGenerico                                                      บฑฑ
ฑฑฬออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ                    Manutencoes desde sua criacao                      บฑฑ
ฑฑฬออออออออัออออออออออออออออออออัอออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบData    ณAutor               ณDescricao                                บฑฑ
ฑฑฬออออออออุออออออออออออออออออออุอออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบ08/06/15ณ Borin - TOTVS IP   ณFuncao para adicionar nova opcao em acoesบฑฑ
ฑฑบ        ณ                    ณrelacionadas no atendimento do Televendasบฑฑ
ฑฑบ        ณ                    ณ				                          บฑฑ
ฑฑศออออออออฯออออออออออออออออออออฯอออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function TMKCBPRO()

	Local aButtons  := {}

	If Posicione("SU7",4,xFilial("SU7")+RetCodUsr(),"U7_ZZREL") == "S"
		AAdd(aButtons ,{ "TABPRICE"	,{|| MATR780()}, "Fat Cliente x Produto" , "Fat Cliente x Produto" ,, })
	EndIf
	If Posicione("SU7",4,xFilial("SU7")+RetCodUsr(),"U7_ZZNF") == "S"
		AAdd(aButtons ,{ "TABPRICE"	,{|| MATC090()}, "Consulta Nota Fiscal"	 , "Consulta Nota Fiscal"  ,, })
	EndIf
	AAdd(aButtons ,{ "Hist๓rico"		,{|| u_KSTHST01()}, "Hist๓rico"	 , "Hist๓rico"  ,, })
	AAdd(aButtons ,{ "Consulta Estoque"	,{|| u_KSTEST01()}, "Consulta Estoque"	 , "Consulta Estoque"  ,, })
	
	AAdd(aButtons ,{ "Hist๓rico Atendimento"	,{|| u_histAtend()}, "Hist๓rico Atendimento"	 , "Hist๓rico Atendimento"  ,, })
	
	
Return(aButtons)