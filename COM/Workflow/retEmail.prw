#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE "TOPCONN.CH"


User Function retEmail(cForne, cLoja)
	Local cCodFor    		:= space(40)
	Local cNomeFor   		:= space(40)	
	Local oOk
	Local oNOk
	Private cRet			:= ""
	Private cMcWF 		:= GetMark()
	Private cEmail		:= space(80)
	
	Private cCodFor    	:= cForne+"/"+cLoja
	
	dbSelectArea("SA2")
	dbSetOrder(1)
	dbSeek(xFilial("SA2")+cForne+cLoja)
	
	cNomeFor := SA2->A2_NOME	
	
	criaSel(cForne,cLoja)
	
	oOk  := LoadBitmap(GetResources(),"wfchk")
	oNOk := LoadBitmap(GetResources(),"wfunchk")
	
	SetPrvt("oFont1","oDlg1","oSay1","oSay2","oSay3","oSay4","oSay5","oBrw1","oGet1","oBtn1")
	
	oFont1     	:= TFont():New( "Times New Roman",0,-16,,.F.,0,,400,.F.,.F.,,,,,, )
	//oDlg1      	:= MSDialog():New( 126,319,632,762,"Envio Cotação",,,.F.,,,,,,.T.,,,.T. )
	DEFINE MsDialog oDlg1 From 126,319 To 632,762 Title "Envio Cotação" Pixel Style 128
	oDlg1:lEscClose     := .F.
	oSay1      := TSay():New( 008,008,{||"Código:"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
	oSay2      := TSay():New( 024,008,{||"Nome:"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
	oSay3      := TSay():New( 008,040,{||cCodFor},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,400,008)
	oSay4      := TSay():New( 024,040,{||cNomeFor},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,400,008)
	oSay5      := TSay():New( 212,008,{||"E-mail:"},oDlg1,,oFont1,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
				
	oBrw1 		:= TCBrowse():New(043,002,220,150,,,,oDlg1,,,,,{|| mkrEmail() },,,,,,,,"TRB2",.T.,,,,.T.,)
	oBrw1:AddColumn(TcColumn():New("",{|| Iif(TRB2->MCWF == cMcWF,oOK,oNOK)},,,,,010,.T.,.F.,,,,,))
	oBrw1:AddColumn(TcColumn():New(RetTitle("U5_CONTAT")	,{|| TRB2->NOME }	,PesqPict("SU5","U5_CONTAT")	,,,,TamSX3("U5_CONTAT")[1]	,.F.,.F.,,,,,))
	oBrw1:AddColumn(TcColumn():New(RetTitle("U5_EMAIL")	,{|| TRB2->EMAIL }	,PesqPict("SU5","U5_EMAIL")	,,,,TamSX3("U5_EMAIL")[1]	,.F.,.F.,,,,,))
	//oBrw1:Align := CONTROL_ALIGN_ALLCLIENT
	
	oGet1      := TGet():New( 208,036,{|u| If(PCount()>0,cEmail:=u,cEmail)},oDlg1,172,011,'',,CLR_BLACK,CLR_WHITE,oFont1,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cEmail",,)	
	oBtn1      := TButton():New( 228,172,"ENVIAR",oDlg1,{||Processa( {|| geraEmail() }, "Aguarde...", "Atualizando...",.F.)},037,012,,oFont1,,.T.,,"",,,,.F. )
	
	oDlg1:Activate(,,,.T.)
	
	If empty(cRet)
		cRet := SA2->A2_EMAIL
	EndIf
	RecLock("SA2",.F.)
		SA2->A2_ZZWFEMA := cRet					
	MsUnLock()
	TRB2->(dbCloseArea())
Return cRet

Static Function criaSel(cForne,cLoja)
	Local _aStruct		:= {}
	Local _cArq		:= ""
	Local cQuery		:= ""		
	
	AADD(_aStruct, {"MCWF"  	, "C", 02, 0})
	AADD(_aStruct, {"NOME"  		, "C", tamSX3("U5_CONTAT")[1], 0})
	AADD(_aStruct, {"EMAIL"  	, "C", tamSX3("U5_EMAIL")[1], 0})	

	_cArq := CriaTrab(_aStruct, .T.)
	dbUseArea(.T.,, _cArq, "TRB2", .T.)
	
	
	cQuery += " SELECT U5_CONTAT, U5_EMAIL " + CRLF
	cQuery += " FROM "+retSqlName("SU5")+" SU5 " + CRLF
	cQuery += " INNER JOIN "+retSqlName("AC8")+" AC8 ON AC8_CODCON = U5_CODCONT AND AC8.D_E_L_E_T_ = ' ' " + CRLF
	cQuery += " WHERE SU5.D_E_L_E_T_ = ' ' " + CRLF
	cQuery += " AND U5_FILIAL = '"+xFilial("SU5")+"' " + CRLF
	cQuery += " AND AC8_CODENT = '"+cForne+cLoja+"' " + CRLF
	cQuery += " ORDER BY U5_CONTAT " + CRLF		
		
	TcQuery cQuery New Alias "QREL"
	QREL->(DbGoTop())
	
	While QREL->(!Eof())
		RecLock("TRB2", .T.)			
			TRB2->NOME			:= QREL->U5_CONTAT
			TRB2->EMAIL		:= QREL->U5_EMAIL															
		MsUnlock()			
		QREL->(DbSkip())
	EndDo
	QREL->(dbCloseArea())		
	TRB2->( dbGoTop() )			
Return


Static Function mkrEmail()
	
	If Type("cMcWF") <> "U"
		If Empty(cMcWF)
			cMcWF := ""	
		EndIf
	EndIf
	
	If !TRB2->(Eof())
		RecLock("TRB2",.F.)
		If TRB2->MCWF == cMcWF
			TRB2->MCWF := ""
		Else
			TRB2->MCWF := cMcWF
		EndIf
		TRB2->(MsUnlock())
	EndIf

Return

Static Function geraEmail()
	cRet := ""
	TRB2->( dbGoTop() )	
	While TRB2->(!Eof())
		If !Empty(TRB2->MCWF)
			If empty(cRet)				
				cRet += alltrim(TRB2->EMAIL)
			Else
				cRet += ";"+alltrim(TRB2->EMAIL)
			EndIf																	
		Endif						
		TRB2->(DbSkip())
	EndDo	
	
	If empty(cRet) .AND. !empty(cEmail)				
		cRet += alltrim(cEmail)
	Else
		If !empty(cRet)
			cRet += ";"+alltrim(cEmail)
		EndIf
	EndIf
	oDlg1:End()
Return