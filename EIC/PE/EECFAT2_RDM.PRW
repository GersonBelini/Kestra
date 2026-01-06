#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOTVS.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³EECFAT2  ºAutor  ³Borin - TOTVS IP     º Data ³ 10/06/2013  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±³Descricao ³ Ponto de Entrada na integração entre Pedido de Exportacao  ³±±
±±³          ³ e Pedido de Venda.										  ³±±
±±³          ³ 															  ³±±
±±º																		  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso     ³Generico                                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º                    Manutencoes desde sua criacao                      º±±
±±ÌÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºData    ³Autor               ³Descricao                                º±±
±±ÌÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º10/06/13³ Borin - TOTVS IP   ³Parametro "PE_GRVCAPA" e "PE_GRVITEM:    º±±
±±º        ³                    ³ 										  º±±
±±º        ³                    ³Parametro para levar campos da tabela    º±±
±±º        ³                    ³EE7 para SC5, e EE8 para SC6.			  º±±
±±º        ³                    ³										  º±±
±±ÌÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºdd/mm/aa³analista    - TOTVS ³							              º±±
±±º        ³                    ³										  º±±
±±º        ³                    ³										  º±±
±±ÈÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function EECFAT2()

Local aArea		:= GetArea()
Local aAreaEE7 	:= EE7->(GetArea())
Local aAreaEE8 	:= EE8->(GetArea())
Local aAreaSC5 	:= SC5->(GetArea())
Local aAreaSC6 	:= SC6->(GetArea())
 

If Upper(Alltrim(PARAMIXB[1])) == "PE_GRVCAPA"
	&& Adiciona no Array para inclusao no SC5.
	aAdd(aCab,{"C5_TRANSP"	,M->EE7_ZZCODT	,NIL})	  && Transportadora
	aAdd(aCab,{"C5_REDESP"	,M->EE7_ZZCODR	,NIL})	  && Redespacho
	aAdd(aCab,{"C5_MENNOTA"	,M->EE7_ZZMENN	,NIL})	  && Mensagem para Nota Fiscal
	aAdd(aCab,{"C5_MENPAD"	,M->EE7_ZZMENP	,NIL})	  && Mensagem Padrão para Nota Fiscal 
	aAdd(aCab,{"C5_TPFRETE"	,M->EE7_ZZTPFR	,NIL})	  && Tipo de Frete (CIF ou FOB)
	aAdd(aCab,{"C5_ZZTPFRE"	,M->EE7_ZZTFRR	,NIL})	  && Tipo de Frete Redespacho (CIF ou FOB)
	aAdd(aCab,{"C5_VOLUME1"	,M->EE7_ZZVOL1	,NIL})	  && Volume de Embalagem
	aAdd(aCab,{"C5_VOLUME2"	,M->EE7_ZZVOL2	,NIL})	  && Volume de Embalagem
	aAdd(aCab,{"C5_VOLUME3"	,M->EE7_ZZVOL3	,NIL})	  && Volume de Embalagem
	aAdd(aCab,{"C5_VOLUME4"	,M->EE7_ZZVOL4	,NIL})	  && Volume de Embalagem
	aAdd(aCab,{"C5_ESPECI1"	,M->EE7_ZZESP1	,NIL})	  && Especie da Embalagem
	aAdd(aCab,{"C5_ESPECI2"	,M->EE7_ZZESP2	,NIL})	  && Especie da Embalagem
	aAdd(aCab,{"C5_ESPECI3"	,M->EE7_ZZESP3	,NIL})	  && Especie da Embalagem
	aAdd(aCab,{"C5_ESPECI4"	,M->EE7_ZZESP4	,NIL})	  && Especie da Embalagem
	//aAdd(aCab,{"C5_NATUREZ"	,M->EE7_ZZNATU	,NIL})	  && Natureza Financeira
	aAdd(aCab,{"C5_ZZAPLIC"	,M->EE7_ZZAPLI	,NIL})	  && Aplicação de uso
	aAdd(aCab,{"C5_ZZCRIT"	,M->EE7_ZZCRIT	,NIL})	  && Criticidade
	aAdd(aCab,{"C5_OBS"		,M->EE7_ZZOBSE	,NIL})	  && Observacao Expedicao
Endif


If Upper(Alltrim(PARAMIXB[1])) == "PE_GRVITEM"
	&& Adiciona no Array para inclusao no SC6.
	aAdd(aReg,{"C6_ZZKS"	,WorkIt->EE8_ZZKS	,NIL}) && Se a venda é Kestra ou Kestra Service     
	aAdd(aReg,{"C6_ZZSTATU"	,WorkIt->EE8_ZZSTAT	,NIL}) && Status do item: C=Critico,N=Normal,P=Programado
		
	&& Atribui um novo valor para o array no SC6    
    && aReg[12][02] := "02" 		// Local do Produto que gravará no campo C6_LOCAL
Endif


RestArea(aAreaSC6)
RestArea(aAreaSC5)
RestArea(aAreaEE8)
RestArea(aAreaEE7)
RestArea(aArea)

Return