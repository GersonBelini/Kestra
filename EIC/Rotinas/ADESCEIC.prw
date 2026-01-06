#Include 'Protheus.ch'

User Function ADESCEIC()
	Private oDlg1
	Private oSay1
	Private oBtn1
	Private oBtn2
	Private oMGet1
	Private cDescri		:= E_MSMM(SB1->B1_DESC_I,36)
	
	/*컴컴컴컴컴컴컨컴컴컴컴좔컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
	굇 Definicao do Dialog e todos os seus componentes.                        굇
	袂굼컴컴컴컴컴컴컴좔컴컴컴컨컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�*/
	oDlg1      := MSDialog():New( 220,351,441,825,"DESCRI플O EIC",,,.F.,,,,,,.T.,,,.T. )
	oSay1      := TSay():New( 004,004,{||"DESCRI플O:"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,036,008)
	oMGet1     := TMultiGet():New( 016,004,{|u| If(PCount()>0,cDescri:=u,cDescri)},oDlg1,220,064,,,CLR_BLACK,CLR_WHITE,,.T.,"",,,.F.,.F.,.F.,,,.F.,,  )
	oBtn1      := TButton():New( 088,136,"SALVAR",oDlg1,{|| grvDesc() },037,012,,,,.T.,,"",,,,.F. )
	oBtn2      := TButton():New( 088,188,"SAIR",oDlg1,{||oDlg1:End()},037,012,,,,.T.,,"",,,,.F. )
		
	oDlg1:Activate(,,,.T.)

Return

Static Function grvDesc()
	If alltrim(cDescri) == ""
		dbSelectArea("SYP")
		dbSeek(xFilial("SYP")+SB1->B1_DESC_I)		
		While SYP->(!Eof()) .AND. SYP->YP_CHAVE == SB1->B1_DESC_I
			Reclock("SYP",.F.)
				dbDelete()
			MsUnlock()
			SYP->(dbSkip())
		Enddo
	Else
		MSMM(,tamSX3("B1_VM_I")[1],,cDescri,1,,,"SB1","B1_DESC_I")
	EndIf	
	oDlg1:End()
Return