#INCLUDE "PROTHEUS.CH" 
#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³TITICMST   º Autor ³ Felipi Marques 	    º Data ³ 22/11/11 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³  Ponto de Entrada para gravaçao gravação do título         º±±
±±º          ³financeiro de impostos ICMS/ST na função GravaTit().        º±±
±±º          ³Este ponto de entrada deve ser utilizado para complementar  º±±
±±º          ³ a gravação dos títulos gerados pelos programas 			  º±±
±±º          ³ MATA461(Nota Fiscal de Saída)/MATA103(Nota Fiscal Entrada),º±± 
±±º          ³ por meio da configuração via F12	    		  			  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ NETWORK                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
Implantado na: (manter historico dos clientes que utilizam a rotina)
	JARVIS 		em 16/10/2013 por R.Bataglia (TCP318)
	GRIMALDI 	em 17/06/2014 por R.Bataglia
	KESTRA		em 05/10/2015 por R.Bataglia
	
*/

User Function TITICMST 
Local 	aArea    	:= 	GetArea()
Local 	aAreaSE2 	:= 	SE2->(GetArea())
Local 	aAreaSF2 	:= 	SF2->(GetArea())
Local	cOrigem		:=	PARAMIXB[1]
Local 	cTipoImp	:=  PARAMIXB[2]

IF ALLTRIM(cOrigem) == "MATA460A"
		
	SE2->E2_NUM			:= SF2->F2_DOC 
	SE2->E2_PARCELA		:= AllTrim(cTipoImp)
	SE2->E2_NATUREZ		:= SuperGetMv( "MV_ZZNATST" , .F. , "5.20.03" ,  )
	SE2->E2_VENCTO  	:= DataValida(dDataBase,.T.)
	SE2->E2_VENCREA 	:= DataValida(dDataBase,.T.)
	SE2->E2_HIST        := "ICMS ST/DIFAL/FECP ref.NF"+"-"+SF2->F2_DOC+"-"+Alltrim(cOrigem)
	
	RecLock("SF2",.F.)
		SF2->F2_NFICMST		:= "ICM"+SF2->F2_DOC
	MsUnlock()
	 
	RestArea(aAreaSF2)
	RestArea(aAreaSE2)
	RestArea(aArea)  
	Return {SE2->E2_NUM,SE2->E2_VENCREA}

EndIf 

RestArea(aAreaSF2)
RestArea(aAreaSE2)
RestArea(aArea)  
Return 

/*
0=GUIA ESTADUAL;
1=ICMS;
2=ISS;
3=ICMS/ST;
4=FUNRURAL;
5=SIMPLES FEDERAL;
6=FUNDERSUL;
7=SIMPLES NACIONAL;
8=FUST/FUNTTEL;
9=SENAR;
A=FUMA
B=DIFAL

X2_UNICO
E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA                                                                                                                                                                                         

ANALISAR A OPÇÃO DE MUDAR A ORIGEM PARA COMO SENDO DO FINANCEIRO

*/


