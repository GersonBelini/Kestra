#INCLUDE "PROTHEUS.CH"
#INCLUDE "restful.ch"

#IFNDEF CRLF
   #DEFINE CRLF Chr(13)+Chr(10)
#EndIF

#DEFINE STR0001 "Serviço de inclusão de estrutura de produtos"

//#####################################################################################################
//# API para inclusão de estrutura de produtos                                                        #
//# Autoria: Gerson Belini                                                                            #
//# Data: 10/05/2022                                                                                  #
//# OBS.: Para o release 17 é necessário possuir LIB / binário que suporte ID na declaração do método #
//#####################################################################################################

WSRESTFUL wskstmt200 DESCRIPTION 'KESTRA - API para inclusão de estrutura de produtos'
//WSRESTFUL wskstmt200 DESCRIPTION 'KESTRA - API para inclusão de estrutura de produtos' SECURITY 'MATA200' FORMAT APPLICATION_JSON
//   WSDATA EMPRESA   As Character
//   WSDATA FILIAL    As Character
//   WSDATA CNPJ      As Character
//   WSDATA DOCUMENTO As Character
//   WSDATA CHAVENFE  As Character
//   WSMETHOD GET GetXmlNFSe DESCRIPTION 'Consulta XML de nota fiscal de saída e retorna o XML' WSSYNTAX '/gbapi/impostos/{EMPRESA,FILIAL,CNPJ,DOCUMENTO}' PRODUCES APPLICATION_JSON
   WsMethod POST Description "Inclusão de estrutura de produtos via POST"    WsSyntax "/POST/{method}"
END WSRESTFUL

//#####################################################################################################
//# Impostos método POST                                                                              #
//# Autoria: Gerson Belini                                                                            #
//# Data Criação....: 10/05/2022                                                                      #
//#####################################################################################################

//WSMETHOD POST KstPostMTA200 WSRECEIVE EMPRESA,FILIAL,CNPJ,DOCUMENTO,CHAVENFE WSRESTFUL wskstmt200
WSMETHOD POST WsService wskstmt200


Return()



/*
User Function altMT200()
Local aCab := {}
Local aGets := {}
Local aItens := {}
PRIVATE lMsErroAuto := .F.

PREPARE ENVIRONMENT EMPRESA '99' FILIAL '01'

aCab := {{"G1_COD","PA-001 ",NIL},; 
 {"G1_QUANT",1,NIL},; 
 {"NIVALT","S",NIL},;
 {"ATUREVSB1","N",NIL}} 
 
aadd(aGets,{"G1_COD","PA-001 ",NIL}) 
aadd(aGets,{"G1_COMP","MP-001 ",NIL}) 
aadd(aGets,{"G1_TRT",Space(3),NIL}) 
aadd(aGets,{"G1_QUANT",1,NIL}) 
aadd(aGets,{"G1_PERDA",0,NIL}) 
aadd(aGets,{"G1_INI",dDataBase,NIL}) 
aadd(aGets,{"G1_FIM",CTOD("31/12/49"),NIL})
aadd(aGets,{"G1_REVINI",'001',NIL}) 
aadd(aGets,{"G1_REVFIM",'002',NIL})
aadd(aItens,aGets) 
 
aGets := {} 
aadd(aGets,{"G1_COD","PA-001 ",NIL}) 
aadd(aGets,{"G1_COMP","MP-003 ",NIL}) 
aadd(aGets,{"G1_TRT",Space(3),NIL}) 
aadd(aGets,{"G1_QUANT",5,NIL}) 
aadd(aGets,{"G1_PERDA",0,NIL}) 
aadd(aGets,{"G1_INI",dDataBase,NIL}) 
aadd(aGets,{"G1_FIM",CTOD("31/12/49"),NIL}) 
aadd(aGets,{"G1_REVINI",'001',NIL}) 
aadd(aGets,{"G1_REVFIM",'001',NIL})
aadd(aItens,aGets) 
 
ConOut("Teste de Alteração") 
ConOut("Inicio: "+Time()) 
 
MSExecAuto({|x,y,z| mata200(x,y,z)},aCab,aItens,4) 
 
If lMsErroAuto
 MostraErro()
Else
 ConOut("Alterado com sucesso: "+Time())
EndIf 
 
ConOut("Fim: "+Time())

RESET ENVIRONMENT

Return
*/
