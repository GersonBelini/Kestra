#include "totvs.ch"

User Function MA330SEQ

Local cOrdem := ParamIXB[1] //-- Ordem informada pelo recalculo
Local cAlias := ParamIXB[2] //-- Nome da tabela pertencente ao registro processado
Local cCampo := Substr(cAlias,2,2)
Local aAreaAtu := GetArea()
Local aAreaSF4 := SF4->(GetArea())
Local aAreaSC2 := SC2->(GetArea())

//MsgAlert("Existem personalizações na ordenação do custo médio." + CRLF + CRLF + "Ponto de entrada: MA330SEQ")

If cAlias $ "SD1/SD2"
	If Posicione("SF4",1,xFilial("SF4") + (cAlias)->&(cCampo + "_TES"), "F4_ZZTER") == "3" // Notas de consignação
		If cAlias == "SD2" //Remessa
			cOrdem := "498"
		Elseif cAlias == "SD1" //Retorno
			cOrdem := "499"
		Endif
	Endif	
	/*
	If SF4->F4_TRANFIL == "1"
		cOrdem := "303"
	Endif
	*/
Elseif cAlias == "SD3"
	If cOrdem == "301" // Se for requisicao contra consumo, ordem original = 301. Alterar para 302, pois a ordem 301 serao os produtos de retrabalho.
		cOrdem := "302"
	Else
		// Se a ordem for de requalificacao, os produtos consumidos e produzidos nestas ordens, serao reordenados para que sejam custeados corretamente.
		If !Empty((cAlias)->D3_OP)
			If Posicione("SC2",1,xFilial("SC2") + (cAlias)->D3_OP, "C2_ZZTPOPK") $ "RQ/GR"
				cOrdem := "301"
			Endif
		Endif
	Endif
	
	If xFilial("SD3") <> "0101" // Se nao for a matriz
		If (cAlias)->D3_CF $ "RE4/DE4" // Transferencias
			cOrdem := "304"
		Endif
	Endif
	
Endif

RestArea(aAreaSC2)
RestArea(aAreaSF4)
RestArea(aAreaAtu)

Return cOrdem