#include "Totvs.ch"
#include "Protheus.ch"
#include "rwmake.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ZZTLVTMK  ºAutor  ³Borin - TOTVS IP     º Data ³ 14/04/2015 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina especifica para que ao acessar o atendimento de      º±±
±±º          ³Call Center possa escolher em qual atendimento entrar.      º±±
±±º			 ³															  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso     ³Generico                                                      º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º                    Manutencoes desde sua criacao                      º±±
±±ÌÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºData    ³Autor               ³Descricao                                º±±
±±ÌÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º14/04/15³ Borin - TOTVS IP   ³Opção de rotinas: 						  º±±
±±º        ³                    ³Televendas, Telemarketing, Telecobranca, º±±
±±º        ³                    ³TLV e TMK ou Todas.					  º±±
±±º        ³                    ³				                          º±±
±±ÈÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function ZZTLVTMK()

Local cUser := RetCodUsr()
Local cTit	:= "Atenção!"
Local cMsg	:= "Escolha qual das rotinas deseja acessar: Televendas, Telemarketing, Telecobrança, Televendas e Telemarketing ou Todas."
Local aOpc	:= {"TeleVendas","Marketing","TLV e TMK","Cancelar"}
Local nOpc	:= 0
Local lRet	:= .T.

	dbSelectArea("SU7")
	SU7->(dbSetOrder(4))
	If SU7->(dbSeek(xFilial("SU7") + cUser ))
	
		nOpc := Aviso(cTit,cMsg,aOpc)
	
		If nOpc == 1 // Televendas
	
			RecLock("SU7",.F.)
				SU7->U7_TIPOATE := "2"
			MsUnLock()
			
		ElseIf nOpc == 2 // Telemarketing
		
			RecLock("SU7",.F.)
				SU7->U7_TIPOATE := "1"
			MsUnLock()
	
		ElseIf nOpc == 3 // TLV e TMK
		
			RecLock("SU7",.F.)
				SU7->U7_TIPOATE := "5"
			MsUnLock()			

		EndIf
		
		If nOpc <> 4
			TMKA271() // Chamada da rotina padrão de atendimento com base no tipo de atendimento
		EndIf
		
	Else
	
		Alert("Usuário não é um operador")
	EndIf
Return