#include "totvs.ch"

/*
Autor: 	Guilherme Ricci
Data:	12/01/2017
Função: Ponto de entrada para permitir ou não o encerramento de uma ordem de produção através do botão "Encerrar".
Motivo:	Criado para que não permita o usuário fechar uma ordem em um período já encerrado, pois isto está fazendo com que ordens parciais
		com custo em elaboração permaneçam neste estado eternamente. O procedimento será realizar um novo apontamento com quantidade zero
		e com perda, com uma data de emissão válida. Este apontamento é o apontamento que será utilizado para encerrar a ordem, retirando
		os custos de em elaboração.
*/

User Function A250ENOK

	Local lRet		:= .T.
	Local dUltFec   := GetMV("MV_ULMES")
	
	If SD3->D3_EMISSAO <= dUltFec
		Alert(	"Esta OP não pode ser encerrada com este apontamento, pois o apontamento " + ;
				"está com uma data anterior ao último fechamento de estoque/custos. Favor realizar o apontamento de perda com quantidade " +;
				"zero numa data válida e encerrar a ordem com este novo apontamento.", "A250ENOK" )
		lRet := .F.
	Endif

Return lRet