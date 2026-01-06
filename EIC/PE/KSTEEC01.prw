#include "Protheus.ch"
#include "Totvs.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³KSTEEC01  ºAutor  ³Borin - TOTVS IP     º Data ³ 29/04/2016 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±³Descricao ³ Funcao de usuario para alteracao de alguns campos do		  ³±±
±±³          ³ pedido de exportacao e que serao gravados nas tabelas	  ³±±
±±³          ³ EE7 - Capa Pedido de Exportaca, EE8 - Itens do Pedido de   ³±±
±±³          ³ Exportacao, SC5 - Capa Pedido de Venda. Utilizado no 	  ³±±
±±º			 ³ ponto de entrada EAP100MNU.								  º±±
±±º																		  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso     ³Especifico KESTRA                                             º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º                    Manutencoes desde sua criacao                      º±±
±±ÌÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºData    ³Autor               ³Descricao                                º±±
±±ÌÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º17/10/13³ Borin - TOTVS IP   ³Adicionado botao 'Alt Campos Pedido'     º±±
±±º        ³                    ³chamando a funcao de usuario U_KSTEEC01. º±±
±±º        ³                    ³										  º±±
±±ÌÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º06/11/13³ Borin - TOTVS 		³Gravacao do valor do frete e seguro na   º±±
±±º        ³                    ³capa do Embarque (EEC) quando o mesmo	  º±±
±±º        ³                    ³existir e nao estiver embarcado.		  º±±
±±º        ³                    ³										  º±±
±±ÌÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º21/11/13³ Borin - TOTVS 		³Retirada validação da OP. Permitindo     º±±
±±º        ³                    ³alterar independente da OP, apenas nao	  º±±
±±º        ³                    ³permite quando estiver faturado.		  º±±
±±º        ³                    ³										  º±±
±±ÌÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º01/07/15³ Borin - TOTVS		³Incluido gravacao do valor do frete e    º±±
±±º        ³                    ³seguro para os itens do embarque e os 	  º±±
±±º        ³                    ³itens da Invoice. Tambem incluido a 	  º±±
±±º        ³                    ³gravacao do campo total do pedido no 	  º±±
±±º        ³                    ³embarque para atualizar conforme o valor º±±
±±º        ³                    ³novo do frete e seguro. 				  º±±
±±º        ³                    ³										  º±±
±±ÌÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º01/07/15³ Borin - TOTVS		³Adicionado os campos de peso liquido e   º±±
±±º        ³                    ³Bruto Total para atualizar no pedido de  º±±
±±º        ³                    ³venda para sair posteriormente na NF.	  º±±
±±º        ³                    ³										  º±±
±±ÌÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º28/07/15³ Borin - TOTVS		³Adicionado a gravacao dos campos de peso º±±
±±º        ³                    ³liquido e bruto total na capa do embarqueº±±
±±º        ³                    ³e invoice e seus itens.				  º±±
±±º        ³                    ³										  º±±
±±ÌÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º29/04/16³ Borin - TOTVS 		³Adaptação para Kestra verificando se o   º±±
±±º        ³                    ³pedido de venda está liberado ou não.	  º±±
±±º        ³                    ³										  º±±
±±ÌÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºdd/mm/aa³analista    - TOTVS ³							              º±±
±±º        ³                    ³										  º±±
±±º        ³                    ³										  º±±
±±ÈÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function KSTEEC01

Local cTit		:= ""
Local cMsg		:= ""
Local aOpc		:= {"Sim","Não"}
Local nOpc		:= 0
Local lLiberPV	:= .F.

Private aArea 		:= GetArea()
Private	aAreaEE7	:= EE7->(GetArea())
Private aAreaEE8	:= EE8->(GetArea())
Private aAreaSC5	:= SC5->(GetArea())
Private aAreaSC6	:= SC6->(GetArea())
Private aAreaEEC	:= EEC->(GetArea())
Private aAreaEE9	:= EE9->(GetArea())
Private aAreaEXP	:= EXP->(GetArea())
Private aAreaEXR	:= EXR->(GetArea())
Private lRet		:= .T.
Private lNumOP		:= .F.
Private aTpFrete	:= {"C=CIF","F=FOB","T=Por Conta Terceiros","S=Sem Frete"}
Private cTpFrete	:= EE7->EE7_ZZTPFR
Private cPedExp		:= EE7->EE7_PEDIDO
Private cPedVen 	:= EE7->EE7_PEDFAT
Private cMenNota	:= EE7->EE7_ZZMENN
Private cMenPad		:= EE7->EE7_ZZMENP
Private cCodTran	:= EE7->EE7_ZZCODT
Private cNomTran	:= EE7->EE7_ZZNOMT
Private	cCodRede	:= EE7->EE7_ZZCODR
Private cNomRede	:= EE7->EE7_ZZNOMR
Private cEspeci1	:= EE7->EE7_ZZESP1
Private cEspeci2	:= EE7->EE7_ZZESP2
Private nVolume1	:= EE7->EE7_ZZVOL1
Private nVolume2	:= EE7->EE7_ZZVOL2
Private nFrete		:= EE7->EE7_FRPREV
Private nSeguro		:= EE7->EE7_SEGPRE
Private nPesoLiq	:= EE7->EE7_PESLIQ
Private nPesoBru	:= EE7->EE7_PESBRU


	dbSelectArea("SC5")
	SC5->(dbSetOrder(1))
	If SC5->( dbSeek( xFilial("SC5") + cPedVen ))
		
		/*
		dbSelectArea("SC6")
		SC6->(dbSetOrder(1))
		If SC6->( dbSeek( xFilial("SC6") + cPedVen ))
		
			While !SC6->(EOF()) .AND. (xFilial("SC6") + cPedVen == SC6->C6_FILIAL + SC6->C6_NUM)
				
				If !Empty(SC6->C6_NUMOP)
					lNumOP := .T.
					Exit
				EndIf
				
				SC6->(dbSkip())
			EndDo
		EndIf
		*/
		dbSelectArea("SC9")
		SC9->(dbSetOrder(1))
		If SC9->(dbSeek(xFilial("SC9") + SC5->C5_NUM ))
			lLiberPV := .T.
		EndIf
		
		If Empty(SC5->C5_NOTA) .AND. lLiberPV // .AND. lNumOP == .T.
			
			ALTEE7C5()	&& Chama função com os campos alteraveis do Pedido de Exportacao.
			
		&& ElseIf Empty(SC5->C5_NOTA) .AND. lNumOP == .F.
		&&   	Alert("Pedido não está amarrado a OP. Utilizar a rotina padrão de alteração")
		
		ElseIf Empty(SC5->C5_NOTA) .AND. !lLiberPV
			Alert("Pedido ainda não está liberado. Utilizar a Alteração Padrão do sistema")
			
		Else
			cTit := "ATENÇÃO!!!"
			cMsg := "Pedido já está faturado. Deseja mesmo alterar?"
			nOpc := Aviso(cTit,cMsg,aOpc)
			
			If nOpc == 1
				ALTEE7C5()
			EndIf
		EndIf
	EndIf

RestArea(aAreaEXR)
RestArea(aAreaEXP)
RestArea(aAreaEE9)
RestArea(aAreaEEC)
RestArea(aAreaSC6)
RestArea(aAreaSC5)
RestArea(aAreaEE8)
RestArea(aAreaEE7)
RestArea(aArea)

Return               
                            

&& Função para alterar os campos do Pedido de Exportacao e Pedido de Venda.
****************************
Static Function ALTEE7C5() 
****************************

Local 	cTitulo		:= "Alteração do Pedido de Exportação"
Private lOK   		:= .F.
Private nLin   		:= 003
Private _oJanela

	&& Define os campos que irão aparecer e os que podem ser alterados.
	DEFINE MSDIALOG _oJanela  TITLE cTitulo FROM 000,000 to 400,800 PIXEL 
	
	@ nLin,010 Say "Pedido Exportação:" SIZE 100,20 OF _oJanela PIXEL
	@ nLin,080 MSGET cPedExp WHEN .F. SIZE 60,07  OF _oJanela PIXEL
	&& nLin+=15
	@ nLin,150 Say "Pedido Venda:" SIZE 100,20 OF _oJanela PIXEL
	@ nLin,220 MSGET cPedVen WHEN .F. SIZE 60,07  OF _oJanela PIXEL
	nLin+=15
	@ nLin,010 Say "Tipo Frete:" SIZE 100,20 OF _oJanela PIXEL
	@ nLin,080 COMBOBOX cTpFrete ITEMS aTpFrete WHEN .T. SIZE 60,07  OF _oJanela PIXEL
	nLin+=15
	@ nLin,010 Say "Valor Frete:" SIZE 100,20 OF _oJanela PIXEL
	@ nLin,080 MSGET nFrete WHEN .T. PICTURE "@E 999,999,999,999.99" SIZE 60,07  OF _oJanela PIXEL
	&& nLin+=15
	@ nLin,150 Say "Valor Seguro:" SIZE 100,20 OF _oJanela PIXEL
	@ nLin,220 MSGET nSeguro WHEN .T. PICTURE "@E 999,999,999,999.99" SIZE 60,07  OF _oJanela PIXEL
	nLin+=15
	@ nLin,010 Say "Transportadora:" SIZE 100,20 OF _oJanela PIXEL
	@ nLin,080 MSGET cCodTran F3 "SA4EEC" WHEN .T. VALID Vazio() .OR. ExistCpo("SA4") SIZE 60,07  OF _oJanela PIXEL
	&& nLin+=15
	@ nLin,150 Say "Nome Transportadora:" SIZE 100,20 OF _oJanela PIXEL
	@ nLin,220 MSGET cNomTran WHEN .F. SIZE 150,07  OF _oJanela PIXEL
	nLin+=15
	@ nLin,010 Say "Redespacho:" SIZE 100,20 OF _oJanela PIXEL
	@ nLin,080 MSGET cCodRede F3 "SA4EEC" WHEN .T. VALID Vazio() .OR. ExistCpo("SA4") SIZE 60,07  OF _oJanela PIXEL
	&& nLin+=15
	@ nLin,150 Say "Nome Redespacho:" SIZE 100,20 OF _oJanela PIXEL
	@ nLin,220 MSGET cNomRede WHEN .F. SIZE 150,07  OF _oJanela PIXEL
	nLin+=15
	@ nLin,010 Say "Mensagem para NF:" SIZE 100,20 OF _oJanela PIXEL
	@ nLin,080 MSGET cMenNota WHEN .T. PICTURE "@!" SIZE 250,07  OF _oJanela PIXEL
	nLin+=15
	@ nLin,010 Say "Mensagem Padrão NF:" SIZE 100,20 OF _oJanela PIXEL
	@ nLin,080 MSGET cMenPad F3 "SM4" WHEN .T. VALID Vazio() .OR. ExistCpo("SM4") SIZE 60,07  OF _oJanela PIXEL
	nLin+=15
	@ nLin,010 Say "Volume 1:" SIZE 100,20 OF _oJanela PIXEL
	@ nLin,080 MSGET nVolume1 WHEN .T. PICTURE "99999" SIZE 60,07  OF _oJanela PIXEL
	&& nLin+=15
	@ nLin,150 Say "Especie 1:" SIZE 100,20 OF _oJanela PIXEL
	@ nLin,220 MSGET cEspeci1 WHEN .T. PICTURE "@!" SIZE 60,07  OF _oJanela PIXEL
	nLin+=15
	@ nLin,010 Say "Volume 2:" SIZE 100,20 OF _oJanela PIXEL
	@ nLin,080 MSGET nVolume2 WHEN .T. PICTURE "99999" SIZE 60,07  OF _oJanela PIXEL
	&& nLin+=15
	@ nLin,150 Say "Especie 2:" SIZE 100,20 OF _oJanela PIXEL
	@ nLin,220 MSGET cEspeci2 WHEN .T. PICTURE "@!" SIZE 60,07  OF _oJanela PIXEL
	nLin+=15
	@ nLin,010 Say "Peso Líquido Total:" SIZE 100,20 OF _oJanela PIXEL
	@ nLin,080 MSGET nPesoLiq WHEN .T. PICTURE "@E 999,999,999.99" SIZE 60,07  OF _oJanela PIXEL
	&& nLin+=15
	@ nLin,150 Say "Peso Bruto Total:" SIZE 100,20 OF _oJanela PIXEL
	@ nLin,220 MSGET nPesoBru WHEN .T. PICTURE "@E 999,999,999.99" SIZE 60,07  OF _oJanela PIXEL
	nLin+=15
	
	@ 170,190 BUTTON "Salvar" SIZE 80,15 ACTION(GrvEE7C5()) OF _oJanela PIXEL
	@ 170,290 BUTTON "Cancelar" SIZE 80,15 ACTION(_oJanela:End()) OF _oJanela PIXEL
	
	Activate Dialog _oJanela Centered
	
Return(lRet)


&& Função para gravar as alterações feitas no Pedido de Exportacao e Pedido de Venda via RecLock.
***************************
Static Function GRVEE7C5() 
***************************

Local cTit		:= "ATENÇÃO"
Local cMsg		:= "Deseja realizar as alterações?"
Local aOpc		:= {"Sim","Não"}
Local nOpc		:= 0
Local nVlrTot	:= 0
Local nVlrIt	:= 0
Local nItemFre	:= 0
Local nItemSeg	:= 0

	&& Colocado aviso caso queira cancelar a alteração após clicar em gravar.
	nOpc := Aviso(cTit,cMsg,aOpc)
	
	If nOpc == 1
    
    	&& Gravacao de campos na Capa do Pedido de Exportacao	
		EE7->(RecLock("EE7",.F.))
			EE7->EE7_FRPREV	:= nFrete
			EE7->EE7_SEGPRE := nSeguro
			EE7->EE7_ZZMENN	:= cMenNota
			EE7->EE7_ZZMENP	:= cMenPad
			EE7->EE7_ZZCODT	:= cCodTran
			EE7->EE7_ZZNOMT	:= cNomTran
			EE7->EE7_ZZCODR	:= cCodRede
			EE7->EE7_ZZNOMR	:= cNomRede
			EE7->EE7_ZZTPFR	:= cTpFrete
			EE7->EE7_ZZVOL1	:= nVolume1
			EE7->EE7_ZZVOL2	:= nVolume2
			EE7->EE7_ZZESP1	:= cEspeci1
			EE7->EE7_ZZESP2	:= cEspeci2
			EE7->EE7_TIPSEG	:= "2"
			EE7->EE7_PESLIQ := nPesoLiq
			EE7->EE7_PESBRU := nPesoBru
		EE7->(MsUnLock())

		&& Gravacao de campos na Capa do Pedido de Venda	
		dbSelectArea("SC5")
		SC5->(dbSetOrder(1))
		If SC5->( dbSeek( xFilial("SC5") + cPedVen ))

			SC5->(RecLock("SC5",.F.))
				SC5->C5_FRETE 	:= nFrete
				SC5->C5_SEGURO	:= nSeguro
				SC5->C5_MENNOTA	:= cMenNota
				SC5->C5_MENPAD	:= cMenPad 
				SC5->C5_TRANSP	:= cCodTran
				SC5->C5_REDESP	:= cCodRede
				SC5->C5_TPFRETE	:= cTpFrete
				SC5->C5_VOLUME1	:= nVolume1
				SC5->C5_VOLUME2	:= nVolume2
				SC5->C5_ESPECI1	:= cEspeci1
				SC5->C5_ESPECI2	:= cEspeci2				
				SC5->C5_PESOL	:= nPesoLiq
				SC5->C5_PBRUTO	:= nPesoBru
			SC5->(MsUnLock())
		EndIf

		&& Gravacao do campo de Valor de Frete e Seguro nos Itens do Pedido de Exportacao
		&& Valores sao rateados por valor total dos itens		
		dbSelectArea("EE8")
		EE8->(dbSetOrder(1))
		If EE8->( dbSeek( xFilial("EE8") + cPedExp ))
		
			While !EE8->(EOF()) .AND. (xFilial("EE8") + cPedExp == EE8->EE8_FILIAL + EE8->EE8_PEDIDO) 
				
				nVlrTot	+= Round((EE8->EE8_SLDINI * EE8->EE8_PRECO),2)
								
				EE8->(dbSkip())
			EndDo	
			
			If EE8->( dbSeek( xFilial("EE8") + cPedExp ))
				While !EE8->(EOF()) .AND. (xFilial("EE8") + cPedExp == EE8->EE8_FILIAL + EE8->EE8_PEDIDO) 
				
					nItemFre := Round(((nFrete * (EE8->EE8_SLDINI * EE8->EE8_PRECO)) / nVlrTot),2)
					nItemSeg := Round(((nSeguro * (EE8->EE8_SLDINI * EE8->EE8_PRECO)) / nVlrTot),2)
				
					EE8->(RecLock("EE8",.F.))
						EE8->EE8_VLFRET := nItemFre
						EE8->EE8_VLSEGU	:= nItemSeg
					EE8->(MsUnLock())
					
					&& Gravacao do frete e seguro dos itens do embarque (EE9)
					&& Gravacao do frete e seguro dos itens da Invoice (EXR)
					dbSelectArea("EE9")
					EE9->(dbSetOrder(1))
					If EE9->( dbSeek( xFilial("EE9") + cPedExp + EE8->EE8_SEQUEN ))

						EE9->(RecLock("EE9",.F.))
							EE9->EE9_VLFRET := nItemFre
							EE9->EE9_VLSEGU := nItemSeg
							EE9->EE9_PSLQTO	:= EE8->EE8_PSLQTO
							EE9->EE9_PSBRTO	:= EE8->EE8_PSBRTO
						EE9->(MsUnLock())
						
						dbSelectArea("EXP")
						EXP->(dbSetOrder(1))
						If EXP->( dbSeek( xFilial("EXP") + EE9->EE9_PREEMB ))
						
							dbSelectArea("EXR")
							EXR->(dbSetOrder(1))
							If EXR->( dbSeek( xFilial("EXR") + EE9->EE9_PREEMB + EXP->EXP_NRINVO + EE9->EE9_SEQEMB ))
							
								EXR->(RecLock("EXR",.F.))
									EXR->EXR_VLFRET := nItemFre
									EXR->EXR_VLSEGU := nItemSeg
									EXR->EXR_PSLQTO	:= EE8->EE8_PSLQTO
									EXR->EXR_PSBRTO	:= EE8->EE8_PSBRTO
								EXR->(MsUnLock())
						    EndIf
						EndIf
					EndIf
					
					nItemFre := 0
					nItemSeg := 0
				
					EE8->(dbSkip())
				EndDo
			EndIf
		EndIf
		
		&& Gravacao do campo de Valor de Frete e Seguro na Capa do Embarque
		dbSelectArea("EEC")
		EEC->(dbSetOrder(14))
		If EEC->( dbSeek( xFilial("EEC") + cPedExp ))
            While !EEC->(EOF()) .AND. (xFilial("EEC") + cPedExp == EEC->EEC_FILIAL + EEC->EEC_PEDREF)
            
            	If Empty(EEC->EEC_DTEMBA)
            		EEC->(RecLock("EEC",.F.))
            			EEC->EEC_FRPREV := nFrete
            			EEC->EEC_SEGPRE	:= nSeguro
            			EEC->EEC_TOTPED := EEC->EEC_VLFOB + nFrete + nSeguro
            			EEC->EEC_PESLIQ	:= nPesoLiq
            			EEC->EEC_PESBRU	:= nPesoBru
            		EEC->(MsUnLock())
            	EndIf
            	
            	dbSelectArea("EXP")
            	EXP->(dbSetOrder(1))
            	If EXP->(dbSeek(xFilial("EXP") + EEC->EEC_PREEMB ))
            		
            		EXP->(RecLock("EXP",.F.))
            			EXP->EXP_PESLIQ	:= nPesoLiq
            			EXP->EXP_PESBRU	:= nPesoBru
            		EXP->(MsUnLock())
            	EndIf
            
				EEC->(dbSkip())
		    EndDo
		EndIf
		
		Alert("Dados Gravados!")
		_oJanela:End()
	EndIf
	
Return(lRet)                                       