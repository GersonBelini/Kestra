#include "totvs.ch"
/*
Ponto de entrada
Para definir as descrições das cores das legendas, complementa o ponto de entrada TK271COR.
Por Sergio Braz
*/
User Function TK271LEG(cPar)
	Local aRet := {}

	aRet := { 	{"BR_VERDE"   	,"Pedido em Carteira"},;
				{"BR_VERMELHO"  ,"NF Emitida"},;
				{"BR_AZUL"     	,"Orçamento"},;
				{"BR_AMARELO" 	,"Pedido Liberado / NF Parcial"},;
				{"BR_MARRON"   	,"Atendimento"},;
				{"BR_LARANJA"   ,"Bloqueado por Regra"},;
				{"BR_PRETO"  	,"Cancelado"}}
	&& CORES:
	&& VERDE = Pedido em Carteira
	&& VERMELHO = NF Emitida
	&& AZUL = Orçamento
	&& AMARELO = Pedido Liberado / NF Parcial
	&& MARROM = Atendimento 
	&& LARANJA = Bloqueado por Regra
	&& PRETO = Cancelado


Return(aRet)
