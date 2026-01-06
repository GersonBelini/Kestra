#INCLUDE "TOTVS.CH"

/*
Autor: 	Guilherme Ricci
Data:	19/01/2017
Uso:	Criado para permitir que o pedido tenha sua liberação de estoque (reserva) estornada, sem que o item seja retornado ao financeiro para reliberação.
		Solicitado por Daniel Rizzo.
		Remove a rotina de nova liberação padrão e inclui a liberação Kestra no lugar.
*/

User Function MA455MNU

	Local nPos 			:= 0
	Local nX			:= 0
	Local aNewRotina 	:= aClone(aRotina)
	
	aRotina := {}

	aAdd( aNewRotina, { "Pick List Kestra","U_PLPV.XRP"	, 0 , 3,0,NIL} )
	
	nPos := aScan(aNewRotina, {|x| Upper(x[2]) == "A455LIBALT"})
	
	If nPos <> 0
		aDel( aNewRotina, nPos )
		aAdd( aNewRotina, { "Nova Liberacao KST","U_NOVALIBE", 0, 4, 0, NIL })
		For nX := 1 To Len(aNewRotina)
			If ValType(aNewRotina[nX]) == "A"
				aAdd( aRotina, aNewRotina[nX] )
			Endif
		Next
	Endif

Return