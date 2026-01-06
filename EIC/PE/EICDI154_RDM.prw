#include "Protheus.ch"
#include "Totvs.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³EICDI154  ºAutor  ³Borin - TOTVS IP     º Data ³ 29/01/2013 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Ponto de Entrada EICDI154 referente rotina de               º±±
±±º          ³Recebimento da Importação (geração da NF).				  º±±
±±º          ³															  º±±
±±º			 ³															  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso     ³Generico                                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º                    Manutencoes desde sua criacao                      º±±
±±ÌÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºData    ³Autor               ³Descricao                                º±±
±±ÌÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º29/01/13³ Borin - TOTVS IP   ³Parâmetro: "GRAVACAO_SD1"		          º±±
±±º        ³                    ³ - Adiciona informações no array do SD1  º±±
±±º        ³                    ³para geração da nota fiscal de entrada.  º±±
±±º        ³                    ³				                          º±±
±±ÌÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º29/01/13³ Borin - TOTVS IP   ³Parâmetro: "GRAVACAO_SF1"		          º±±
±±º        ³                    ³ - Adiciona informações no array do SF1  º±±
±±º        ³                    ³para geração da nota fiscal de entrada.  º±±
±±º        ³                    ³				                          º±±
±±ÌÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º30/04/13³ Borin - TOTVS IP   ³Parâmetro: "GRAVACAO_SF1"                º±±
±±º        ³                    ³Variavel Volume: 						  º±±
±±º        ³                    ³Alterada a variavel de caracter para 	  º±±
±±º        ³                    ³numerica.								  º±±
±±º        ³                    ³										  º±±
±±ÌÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º20/06/13³ Borin - TOTVS IP   ³Parâmetro: "GRAVACAO_SF1"                º±±
±±º        ³                    ³Adicionado no array o Peso Bruto.		  º±±
±±º        ³                    ³										  º±±
±±ÌÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º24/06/13³ Borin - TOTVS IP   ³Parâmetro: "GRAVACAO_SF1"                º±±
±±º        ³                    ³Adicionado no array a mensagem para NF e º±±
±±º        ³                    ³mensagem padrao.						  º±±
±±º        ³                    ³										  º±±
±±ÌÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º30/07/13³ Borin - TOTVS IP   ³Parâmetro: "GRAVACAO_SF1"	              º±±
±±º        ³                    ³Adicionado tratamento de mensagem para   º±±
±±º        ³                    ³nota filha. 							  º±±
±±º        ³                    ³										  º±±
±±ÌÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºdd/mm/aa³analista    - TOTVS ³							              º±±
±±º        ³                    ³										  º±±
±±º        ³                    ³										  º±±
±±ÈÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function EICDI154

Local aArea		:= GetArea() 
Local aAreaSW6	:= SW6->(GetArea())
Local aAreaSWN	:= SWN->(GetArea())
Local aAreaSF1	:= SF1->(GetArea())
Local aAreaSD1	:= SD1->(GetArea())
Local cEspeci1	:= ""
Local cMenNota	:= ""
Local cMenPad	:= ""
Local cNumDI	:= "" 
Local cDataDI	:= ""
Local cProcesso	:= ""
Local cNumCnt	:= ""
Local cDocOri	:= ""
Local nVolume1	:= 0
Local nPesoB	:= 0

&& Parametro para gravacao no array de campos na tabela SF1 - Cabecalho Documento de Entrada
If Alltrim(ParamIXB) == "GRAVACAO_SF1"

	&& Salva variaveis
	nPesoB 		:= SW6->W6_PESO_BR							&& Peso Bruto
	cProcesso	:= "Ref. Emb.: " + Alltrim(SW6->W6_HAWB) 	&& Numero Processo
	cNumDI 		:= "DI: " + Alltrim(SW6->W6_DI_NUM) 		&& Numero da DI
	cDataDI		:= "Data DI: " + DtoC(SW6->W6_DTREG_D) 		&& Data da DI
	cDocOri		:= "Nota Original: " + SWN->WN_DOC 			&& Numero da Nota Original
	
	&& Apenas quando for nota primeira, mae ou unica
	If nTipoNF <> 2 .AND. nTipoNF <> 6

		&& Salva variavel para mensagem para nota fiscal de entrada
		// cMenNota := cProcesso + " - " + cNumDI + " - " + cDataDI
		cMenNota := IIF(!Empty(SW6->W6_ZZMENNF)," - " + Alltrim(SW6->W6_ZZMENNF) + ".","")
		cMenPad  := SW6->W6_ZZMENPD
	
		&& Salva variavel para volume e especie da nota fiscal
		dbSelectArea("EIH")
		EIH->(dbSetOrder(1))
		If EIH->( dbSeek( xFilial("EIH") + SW6->W6_HAWB ))
		
			nVolume1 := EIH->EIH_QTDADE   
			
			dbSelectArea("SJF")
			SJF->(dbSetOrder(1))
			If SJF->( dbSeek( xFilial("SJF") + EIH->EIH_CODIGO ))
			
				cEspeci1 := SJF->JF_DESC
			EndIf
		EndIf
	
	&& Apenas Nota Complementar	
	ElseIf nTipoNF == 2
	
		cEspeci1 := "OUTROS"
		nVolume1 := 1
		cMenNota := Alltrim(SW6->W6_HAWB) + " Nota Fiscal " + Alltrim(SWN->WN_DOC) + ". " + Alltrim(SW6->W6_ZZMNFCP) + "."
		cMenPad  := SW6->W6_ZZMPDCP
	
	&& Apenas Nota Filha
	ElseIf nTipoNF == 6
		
		cEspeci1 := "BAU METAL"
		nVolume1 := 1
		cMenNota := cProcesso + " - " + cNumDI + " - " + cDataDI + " - " + cDocOri + "."
	EndIf
	
	&& Adiciona as variaveis no array do cabecalho da nota fiscal de entrada
	aAdd(aCab,{"F1_ESPECI1" , cEspeci1 , Nil}) && Especie 1
	aAdd(aCab,{"F1_VOLUME1" , nVolume1 , Nil}) && Volume 1
	aAdd(aCab,{"F1_PBRUTO"  , nPesoB   , Nil}) && Peso Bruto
	aAdd(aCab,{"F1_MENNOTA" , cMenNota , Nil}) && Mensagam para Nota Fiscal
	aAdd(aCab,{"F1_MENPAD"  , cMenPad  , Nil}) && Mensagam Padrao para Nota Fiscal
	If nTipoNF == 2
		aAdd(aCab,{"F1_PLIQUI"  , 0    , Nil}) && Peso Liquido zerado quando NF Complementar
		aAdd(aCab,{"F1_TRANSP"  , ""   , Nil}) && Transportadora em branco quando NF Complementar
	EndIf
EndIf    

&& Parametro para gravacao no array de campos na tabela SD1 - Itens Documento de Entrada
If Alltrim(ParamIXB) == "GRAVACAO_SD1"

	aAdd(aItem,{"D1_LOTEFOR"	,Work1->WK_LOTE	,Nil }) && Lote do Fornecedor informado no EIC
	aAdd(aItem,{"D1_LOTECTL"	,""		   		,Nil }) && Lote do Estoque
	aAdd(aItem,{"D1_ZZFOBR"		,Work1->WKFOB_R	,Nil }) && Valor FOB em Reais
EndIf

RestArea(aAreaSD1)
RestArea(aAreaSF1)
RestArea(aAreaSWN)
RestArea(aAreaSW6)
RestArea(aArea)

Return