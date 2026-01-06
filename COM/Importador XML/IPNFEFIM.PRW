#INCLUDE "PROTHEUS.CH" 

/*
* Ponto Entrada  	:   IPNFEFIM
* Autor        		:   Paulo Romualdo - Totvs Interior Paulista
* Data				:   05/04/12
* Descricao    		:   Ponto de Entrada, localizado na classe [TImpNfe] de Importacao da NFe via XML gerando um pre-nota de entrada.
*						Executado depois da gravacao da pre nota de entrada.
*
* Parametros		: 	Nil
*
* Retorno			: 	Nil
*
* Observacoes		: 	Relacao das variaveis utilizadas neste fonte que foram definidas na classe TImpNfe: aInfNFe, cFornece e cLoja
*/

User Function IPNFEFIM()

	Local 	aArea	   		:= GetArea()
	Local 	aAreaSA5 		:= SA5->(GetArea())
	Local 	aAreaSA7 		:= SA7->(GetArea())
    Local 	aDados			:= {}
    Local 	aDetail			:= aInfNFe[2]
    Local 	cTpCliFor		:= Upper(AllTrim(aInfNFe[1,1,2]))		&& F-Fornecedor, C-Cliente
    Local 	nI				:= 0

	Private lMsErroAuto 	:= .F.                                      
	Private lMsHelpAuto		:= .T.

  
  	For nI:=1 To Len(aDetail) && Variavel aDet definida na classe TImpNfe

		If cTpCliFor == "F" && NF Fornecedor
		
			SA5->(dbSetOrder(1)) && A5_FILIAL+A5_FORNECE+A5_LOJA+A5_PRODUTO
			If !SA5->(dbSeek(xFilial("SA5")+Padr(cFornece,TamSx3("A5_FORNECE")[1])+Padr(cLoja,TamSx3("A5_LOJA")[1])+Padr(aDetail[nI,3],TamSx3("A5_PRODUTO")[1])))      

				aDados := {}			  	 
				aAdd(aDados, { "A5_FORNECE"	, cFornece			, Nil } )		&& Variavel cFornece definida na classe TImpNfe
				aAdd(aDados, { "A5_LOJA"	, cLoja				, Nil } )		&& Variavel cLoja definida na classe TImpNfe
				aAdd(aDados, { "A5_PRODUTO"	, aDetail[nI,3]		, Nil } )		
				aAdd(aDados, { "A5_CODPRF"	, aDetail[nI,2]		, Nil } )		
				aAdd(aDados, { "A5_UNID"	, aDetail[nI,5]		, Nil } )		

				lMsErroAuto := .F.
								
				MATA060(aDados, 3)
				If lMsErroAuto
					Mostraerro()
					DisarmTransaction()
				EndIf
											
			EndIf
		
		ElseIf cTpCliFor == "C" && NF Cliente

			SA7->(dbSetOrder(1)) && A7_FILIAL+A7_CLIENTE+A7_LOJA+A7_PRODUTO
			If !SA7->(dbSeek(xFilial("SA7")+Padr(cFornece,TamSx3("A7_CLIENTE")[1])+Padr(cLoja,TamSx3("A7_LOJA")[1])+Padr(aDetail[nI,3],TamSx3("A7_PRODUTO")[1])))      		
					    
				RecLock("SA7",.T.)
					SA7->A7_FILIAL 	:= xFilial("SA7")	
					SA7->A7_CLIENTE	:= cFornece
					SA7->A7_LOJA	:= cLoja
					SA7->A7_PRODUTO	:= aDetail[nI,3]
					SA7->A7_CODCLI	:= aDetail[nI,2] 
				SA7->(MsUnlock())
			
			EndIf
					
		EndIf
		
	Next nI  

	SA7->(Restarea(aAreaSA7))
	SA5->(Restarea(aAreaSA5))
	Restarea(aArea)	

Return