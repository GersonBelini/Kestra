//|=====================================================================|
//|Programa: F240FIL.PRW   |Autor: Marciane Gennari   | Data: 24/11/2010|
//|=====================================================================|
//|Descricao: Ponto de entrada para filtrar os titulos do contas a pagar|
//|           conforme tipo de pagamento do bordero.                    |
//|=====================================================================|
//|Sintaxe:                                                             |
//|=====================================================================|
//|Uso: Ponto de entrada da rotina FINA090                              |
//|=====================================================================|
//|       ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.             |
//|---------------------------------------------------------------------|
//|Programador |Data:      |BOPS  |Motivo da Alteracao                  |
//|---------------------------------------------------------------------|
//| ====================================================================|
#include "Protheus.ch"                                                                       

User Function F240fil()                                                                       
	Local aArea	:= GetArea()
	Local aSA6	:= SA6->(GetArea())
	
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de variaveis utilizadas no programa atraves da funcao    ³
//³ SetPrvt, que criara somente as variaveis definidas pelo usuario,    ³
//³ identificando as variaveis publicas do sistema utilizadas no codigo ³
//³ Incluido pelo assistente de conversao do AP5 IDE                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SetPrvt("_cFiltro,")

_cFiltro:=""

If !Empty(SA6->A6_COD_BC)

cPort240 := Alltrim(Posicione("SA6",1,xFilial("SA6") + cPort240,"A6_COD_BC"))

EndIf	


If cModPgto == "30"
   
   If cPort240 == "341"                                        
      _cFiltro := " SUBS(E2_CODBAR,1,3)=="+"'"+cPort240+"'"
   Else   
      _cFiltro := " !EMPTY(E2_CODBAR) "
   EndIf                                                                                                 
   
   _cFiltro += " .AND. SUBS(E2_CODBAR,1,1)<>'8' "
   
ElseIf cModPgto == "31"
   
   _cFiltro := " !EMPTY(E2_CODBAR)"
   
   If cPort240 == "341"                                         
      _cFiltro += " .AND. SUBS(E2_CODBAR,1,3)<>"+"'"+cPort240+"'"
   EndIf

   _cFiltro += " .AND. SUBS(E2_CODBAR,1,1)<>'8' "

ElseIf cModPgto == "01"
   _cFiltro := " Empty(E2_CODBAR)  .and. " 
   _cFiltro += "  GetAdvFval('SA2','A2_BANCO',xFilial('SA2')+E2_FORNECE+E2_LOJA,1)  =="+" '"+cPort240+ "'" 

ElseIf cModPgto == "03" 
   _cFiltro := " Empty(E2_CODBAR) .and. "// .and. "
   _cFiltro += " (  !Empty(GetAdvFval('SA2','A2_BANCO',xFilial('SA2')+E2_FORNECE+E2_LOJA,1))  "
   _cFiltro += "  .and. GetAdvFval('SA2','A2_BANCO'  ,xFilial('SA2')+E2_FORNECE+E2_LOJA,1)  <>"+"'"+cPort240+"'  )"

ElseIf cModPgto == "41" .or. cModPgto == "43"
   _cFiltro := " Empty(E2_CODBAR) .and. " 
   _cFiltro += " (  !Empty(GetAdvFval('SA2','A2_BANCO',xFilial('SA2')+E2_FORNECE+E2_LOJA,1))  "
   _cFiltro += "  .and. GetAdvFval('SA2','A2_BANCO'  ,xFilial('SA2')+E2_FORNECE+E2_LOJA,1)  <>"+"'"+cPort240+"'  )"
 
ElseIf cModPgto == "13"  //--- Concessionarias

   _cFiltro := " !EMPTY(E2_CODBAR) .AND. SUBS(E2_CODBAR,1,1)=='8' .AND. E2_TIPO <> 'ISS'"

ElseIf cModPgto == "16"  //--- Darf Normal - Selecionar com codigo de retencao e tipo TX              

   _cFiltro := " ( !Empty(E2_CODRET) .OR. !Empty(E2_ZZCDREC) ) .AND. E2_TIPO == 'TX '"

ElseIf cModPgto == "17"  //--- GPS 

   _cFiltro := " E2_TIPO == 'INS'"

ElseIf cModPgto == "19"  //--- ISS  

   //_cFiltro := " E2_TIPO == 'ISS'" - Comentado por Waldir - Nao estava filtrando o ISS gerado no faturamento.
   
   _cFiltro := " E2_TIPO == 'ISS' .OR. E2_TIPO == 'TX ' .AND. E2_NATUREZ == 'ISS       ' .AND. E2_ORIGEM == 'MATA460 ' .OR. 'PREF' $ E2_NOMFOR"
   EndIf
        
  RestArea(aSA6)
  RestArea(aArea)

Return(_cFiltro)        
