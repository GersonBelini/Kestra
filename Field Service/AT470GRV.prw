#include "Totvs.ch"    

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³AT470GRV  ³ Autor ³TOTVS                  ³ Rev. ³05.08.2015 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³Ponto de entrada executado depois da gravaca da requisicao.  ³±±
±±³          ³Objetivos:Executar processamentos diversos.                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Gestao de Servicos                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
*/

User Function AT470GRV()

Local cNumOS   := M->ABF_NUMOS   // Numero da OS
Local cItemOS  := M->ABF_ITEMOS  // Item da OS
Local cSeqOrc  := M->ABF_SEQRC   // Sequencia da OS
Local cNumSA   := ""
Local cItemSA  := ""  
Local cArmazem := ""
Local aArea    := GetArea()
Local aAreaABG := ABG->(GetArea())
Local aAreaSCP := SCP->(GetArea()) 

if INCLUI .or. ALTERA
	
	ABG->(dbSetOrder(1))
	If ABG->(dbSeek(xFilial("ABG")+cNumOS+cItemOS+cSeqOrc))
		While ABG->(!Eof()) .and. xFilial("ABG")+cNumOS+cItemOS+cSeqOrc == ABG->ABG_FILIAL+ABG->ABG_NUMOS+ABG->ABG_ITEMOS+ABG->ABG_SEQRC
			
			cNumSA   := ABG->ABG_NUMSA
			cItemSA  := ABG->ABG_ITEMSA
			cArmazem := ABG->ABG_ZZLOCA
			
			// Grava o armazem selecionado pelo usuario
			SCP->(dbSetOrder(1))
			If SCP->(dbSeek(xFilial("SCP")+cNumSA+cItemSA))
				recLock("SCP",.F.)
				SCP->CP_LOCAL := cArmazem      
				SCP->(msUnlock())
			Endif
			
			ABG->(dbSkip())
		EndDo
	Endif
Endif     

RestArea(aArea)
RestArea(aAreaABG)
RestArea(aAreaSCP) 

Return