#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

/*/{Protheus.doc} grvDestC

Usado para gravar C7_ZZDESTC.
	
@author André Oquendo
@since 12/05/2015

@param cPed, String, Numero do Pedido de Compra

/*/

User Function grvDestC(cPed)
	Local aCombo	:= {"C=Consumo","I=Industrialização","S=Serviço","M=Imobilizado","R=Revenda"}
	Private cDestComp		:= ""
	SetPrvt("oFont1","oDlg1","oSay1","oCBox1","oBtn1")
		
	oFont1     := TFont():New( "Times New Roman",0,-19,,.F.,0,,400,.F.,.F.,,,,,, )
	//oDlg1      := MSDialog():New( 264,362,391,722,"Destino da Compra",,,.F.,,,,,,.T.,,,.T. )
	DEFINE MsDialog oDlg1 From 264,362 To 391,722 Title "Destino da Compra" Pixel Style 128
	oDlg1:lEscClose     := .F. 
	oSay1      := TSay():New( 008,004,{||"Destino da Compra:"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,080,012)
	oCBox1     := TComboBox():New( 008,088,{|u| If(PCount()>0,cDestComp:=u,cDestComp)},aCombo,072,014,oDlg1,,,,CLR_BLACK,CLR_WHITE,.T.,oFont1,"",,,,,,,cDestComp )
	oBtn1      := TButton():New( 036,112,"SALVAR",oDlg1,{||oDlg1:End()},048,012,,oFont1,,.T.,,"",,,,.F. )
	
	oDlg1:Activate(,,,.T.)
	
	dbSelectArea("SC7")
	dbSetOrder(1)//
	If SC7->(dbSeek( xFilial("SC7") + cPed ))
		While SC7->(!Eof()) .and. SC7->C7_NUM == cPed
			RecLock("SC7",.F.)
			SC7->C7_ZZDESTC := cDestComp
			SC7->(MsUnLock())
			SC7->(dbSkip())
		Enddo
	Endif

Return

