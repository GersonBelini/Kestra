#Include "Protheus.ch"
#Include "Topconn.ch"

User Function SU5COM(cPedido,cFornece,cLoja)
Local oDlg
Local lRet		:= .t.  
Local cQuery	:= ""
Local bCancel 	:=	{ || oDlg:End()}
Local oOk      	:=	LoadBitmap( GetResources(), "LBOK")
Local oNo      	:=	LoadBitmap( GetResources(), "LBNO")
Local bOk		:=	{ || iif( Checagem(@aDados) , oDlg:End() , Nil ) }         
Local aDados 	:= {}
Local cNomeFor	:= POSICIONE("SA2",1,xFilial("SA2")+cFornece+cLoja,"A2_NREDUZ")

Private cMail   := ""         	                      

aDados    := CargaServicos(cPedido,cFornece,cLoja)   
	
If	Len(aDados) == 0
	lRet := .f.
Else
	Setapilha()
	Define MsDialog oDlg Title "Selecione os Contatos - Fornecedor: " + cNomeFor From 00,00 To 27,95 Of oMainWnd Style 128
	oDlg:lEscClose := .f.
	@ 015,005 ListBox oServ Var cVarQ Fields Header "","Codigo","Contato","Email" ColSizes 20,40,40,40 Size 365,170 Of oDlg Pixel
		oServ:SetArray(aDados)
		oServ:bLDblClick:= { || aDados[oServ:nAt,1] := !aDados[oServ:nAt,1] , Ver_Check(@aDados,oServ:nAt,@oDlg,@oServ,oOk,oNo) }
		oServ:bLine := { || {	iif(aDados[oServ:nAt,01],oOk,oNo),aDados[oServ:nAt,02],aDados[oServ:nAt,03],aDados[oServ:nAt,04]} }
   	Activate MsDialog oDlg Centered On Init EnchoiceBar(oDlg,bOk,bCancel) 
	Setapilha()        
	     
EndIf

Return cMail

/*********************************************************************/

Static Function Ver_Check(aDados,nPos,oDlg,oServ,oOk,oNo)
/*
For y := 1 to Len(aDados)
	if	y <> nPos
		aDados[y,1]	:=	.f.
	endif
Next y
  */
oServ:SetArray(aDados)
oServ:bLine := { || { iif(aDados[oServ:nAt,01],oOk,oNo),aDados[oServ:nAt,02],aDados[oServ:nAt,03],aDados[oServ:nAt,04] } }
oServ:Refresh()
oDlg:Refresh()

Return

/***********************************************************************/

Static Function Checagem(aDados)

Local lRet	:= .t.
Local nCont	:= 0
                            
For t := 1 to Len(aDados)
	if	aDados[t,1] 
		cMail += Alltrim(aDados[t,4]) + ";"
		nCont 	:= 1
	endif
Next t 
                            
If 	nCont < 1
	Alert("Selecione ao menos 1 Contato !!")
	lRet	:= .f.
Endif

Return lRet
                            	
/*********************************************************************/

Static Function CargaServicos(cPedido,cFornece,cLoja)
Local cQuery
Local aTemp		:=	{}           
                                                                
cQuery := " SELECT SU5.U5_CODCONT, SU5.U5_CONTAT, SU5.U5_EMAIL  "
cQuery += " FROM " + RetSQLName("AC8") + " AC8 "
cQuery += " INNER JOIN " + RetSQLName("SU5") + " SU5 ON SU5.U5_FILIAL = '" + xFilial("SU5") + "' AND SU5.U5_CODCONT = AC8.AC8_CODCON AND SU5.D_E_L_E_T_ = '  ' "
cQuery += " WHERE AC8.AC8_FILIAL = '" + xFilial("AC8") + "' AND AC8.AC8_ENTIDA = 'SA2' AND AC8.AC8_FILENT = '" + xFilial("SA2")+ "' AND AC8.AC8_CODENT = '" + cFornece + cLoja + "' AND AC8.D_E_L_E_T_ = ' ' "
cQuery += " ORDER BY SU5.U5_CONTAT "

TcQuery cQuery New Alias "SU5QRY"

If 	SU5QRY->(Eof())
	Alert("O fornecedor " + cFornece + "/" + cLoja + " não possui nenhum contato cadastrado!!")
Else
	do while SU5QRY->(!Eof())
		aAdd( aTemp , { .f. , SU5QRY->U5_CODCONT, SU5QRY->U5_CONTAT,SU5QRY->U5_EMAIL } )
		SU5QRY->(dbskip())
	enddo          
EndIF  
                       
//SA1QRY->(dbCloseArea())
SU5QRY->(dbCloseArea())
	
Return ( aTemp )