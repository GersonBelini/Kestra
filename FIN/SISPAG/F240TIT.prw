#Include "Protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ F240TIT	³ Autor ³Waldir Esmerio S. Jr   ³ Data ³ 10/07/12 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Ponto de Entrada utilizado para validacao dos Valores dos   ³±±
±±³          ³Boletos x Valor Pagto na Geracao do Bordero				  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function F240TIT

Local lRet		:=	.T.
Local nTtAbat	:=	SomaAbat(SE2->E2_PREFIXO,SE2->E2_NUM,SE2->E2_PARCELA,'P',SE2->E2_MOEDA,DDATABASE,SE2->E2_FORNECE,SE2->E2_LOJA)
Local nLiquid	:=	SE2->E2_SALDO - nTtAbat - SE2->E2_DECRESC + SE2->E2_ACRESC
Local cPagto	:=	StrZero(nLiquid*100,10)
Local cCodBar	:=	SE2->E2_CODBAR
Local cPrefixo	:=	AllTrim(SE2->E2_PREFIXO)
Local cTitulo	:=	AllTrim(SE2->E2_NUM)
Local cParcela	:=	AllTrim(SE2->E2_PARCELA)
Local cPis		:=	SE2->E2_PIS
Local cCofins	:=	SE2->E2_COFINS
Local cCSLL		:=	SE2->E2_CSLL

If Substr(cCodBar,10,10) <> cPagto .AND. cModPgto $ '30#31'
	
	lRet := MsgYesNo('Valor a Pagar (' + AllTrim(Transform(Val(cPagto)/100,PesqPict('SE2','E2_SALDO'))) + ') do Título ' + AllTrim(cPrefixo + ' ' + cTitulo + ' ' + cParcela) + ' é diferente do valor do Codigo de Barras ('  + AllTrim(Transform(Val(Substr(cCodBar,10,10))/100,PesqPict('SE2','E2_SALDO'))) + '). Deseja incluí-lo no Borderô mesmo assim?','F240TIT')
	                                                                                                                                                    
EndIf

If FunName() = 'FINA240' .AND. (cPis > 0 .OR. cCofins > 0 .OR. cCSLL > 0)
	
	MsgStop('O Título ' + AllTrim(cPrefixo + ' ' + cTitulo + ' ' + cParcela) + ' possui Pis, Cofins e CSLL Retidos na Fonte. Para estes casos, utilizar a Rotina "Bordero Pagtos c/ Impostos"! ','F240TIT')
	lRet := .F.
	
EndIF

Return lRet
