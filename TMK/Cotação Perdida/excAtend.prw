#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

User Function excAtend()
	Private cDescMot   := Space(30)
	Private cMotivo    := Space(6)
	
	SetPrvt("oFont1","oDlg1","oSay1","oGet1","oGet2","oBtn1")
	
	
	oFont1     := TFont():New( "MS Sans Serif",0,-19,,.F.,0,,400,.F.,.F.,,,,,, )
	//oDlg1      := MSDialog():New( 092,232,305,697,"Motivo Exclusão",,,.F.,,,,,,.T.,,,.T. )
	DEFINE MSDIALOG oDlg1 FROM  092,232 TO 305,697 TITLE OemToAnsi("Motivo Exclusão") OF GetWndDefault() STYLE DS_MODALFRAME PIXEL 
	oDlg1:lEscClose := .F. //Nao permite sair ao se pressionar a tecla ESC.
	oSay1      := TSay():New( 004,004,{||"Selecione o Motivo da Exclusão"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,140,012)
	oGet1      := TGet():New( 024,004,{|u| If(PCount()>0,cMotivo:=u,cMotivo)},oDlg1,060,014,'',{||vldMotivo()},CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.F.,.F.,"ZZ","cMotivo",,)
	oGet2      := TGet():New( 044,004,{|u| If(PCount()>0,cDescMot:=u,cDescMot)},oDlg1,216,014,'',,CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cDescMot",,)	
	oBtn1      := TButton():New( 076,176,"SALVAR",oDlg1,{|| grvMoti() },045,016,,oFont1,,.T.,,"",,,,.F. )
	
	oDlg1:Activate(,,,.T.)

Return

Static Function grvMoti()
	If empty(cMotivo) .OR. empty(cDescMot)
		msgAlert("Informe um motivo e sua descrição!")
		Return
	EndIf
	For nH := 1 to len(aCols)
		RecLock("SZ8",.T.)
			SZ8->Z8_FILIAL 	:= xFilial("SZ8")
			SZ8->Z8_NUM 	:= SUA->UA_NUM
			SZ8->Z8_CLIENTE := SUA->UA_CLIENTE
			SZ8->Z8_LOJA 	:= SUA->UA_LOJA
			SZ8->Z8_ITEM 	:= aCols[nH][GdFieldPos("UB_ITEM")]
			SZ8->Z8_PRODUTO	:= aCols[nH][GdFieldPos("UB_PRODUTO")]
			SZ8->Z8_QUANT 	:= aCols[nH][GdFieldPos("UB_QUANT")]
			SZ8->Z8_VRUNIT	:= aCols[nH][GdFieldPos("UB_VRUNIT")]
			SZ8->Z8_VLRITEM	:= aCols[nH][GdFieldPos("UB_VLRITEM")]
			SZ8->Z8_ZZCODMT	:= cMotivo
			SZ8->Z8_ZZDESMT	:= cDescMot
			SZ8->Z8_USUARIO	:= retCodUsr()
			SZ8->Z8_DATA	:= dDataBase
			SZ8->Z8_HORA	:= time()
			SZ8->Z8_ORIGEM	:= Iif(SUA->UA_OPER=="1","FATURAMENTO","ORCAMENTO")
		MsUnlock()
	Next		
	oDlg1:End()
Return

Static Function vldMotivo()
	Local lRet		:= .T.
	
	If empty(cMotivo)
		lRet := .F.
		cDescMot := ""
		msgAlert("Motivo em branco!")	
	Else
		dbSelectArea("SX5")
		dbSetOrder(1)
		If dbSeek(xFilial("SX5")+"ZZ"+cMotivo)
			cDescMot := SX5->X5_DESCRI
		Else
			lRet := .F.
			cDescMot := ""
			msgAlert("Código do motivo não encontrado!")			
		EndIf
	EndIf
	oGet1:Refresh(.T.)
	oGet2:Refresh(.T.)
	oDlg1:Refresh(.T.)
Return lRet 