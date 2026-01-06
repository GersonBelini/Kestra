#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ KSFIS08	³ Autor ³ Guilherme / Marcos    ³ Data ³03/06/2013³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Rotina GERA DETALHES TABELAS CDT E CDD                     ³±±
±±³          ³                          					              ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ -  PROTHEUS 11		                                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/


User Function KSFIS08()

	aParamBox := {}
	aAdd(aParamBox,{1,"Data de ",dDataBase,,"","","",40,.T.})
	aAdd(aParamBox,{1,"Data Ate",dDataBase,,"","","",40,.T.}) 
	If !ParamBox(aParamBox,"Parâmetros",,,,.T.,,,,"KSFIS08",.F.,.F.)
		Return()
	Endif

	dbSelectArea("SF2")
	dbSetOrder(3)
	dbSeek(xFilial("SF2")+" "+DtoS(MV_PAR01),.T.)

	_cFilial := xFilial("SF2")
	While !EOf() .and. xFilial("SF2") = _cFilial .and. DTOS(SF2->F2_EMISSAO) >= DtoS(MV_PAR01) .and. DTOS(SF2->F2_EMISSAO) <= DtoS(MV_PAR02)
		_cChaPes := xFilial("SF2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA
		MsgRun("Importando CDD. Aguarde.. Por favor ..",,{||U_KTN_ProcCDD("S",_cChaPes) })
		&& Aqui devemos criar o CDT para as notas normais.
		_cChaPes := xFilial("SF2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA
		MsgRun("Importando CDT. Aguarde.. Por favor ..",,{||U_KTN_CDT_Proc("S",_cChaPes)})				
		dbSElectArea("SF2")
		dbSkip()
	Enddo
	
	dbSelectArea("SD1")
	dbSetOrder(3)
	dbSeek(xFilial("SD1")+DtoS(MV_PAR01),.T.)
	_cFilial := xFilial("SD1")
	While !EOf() .and. xFilial("SD1") = _cFilial .and. DTOS(SD1->D1_EMISSAO) >= DtoS(MV_PAR01) .and. DTOS(SD1->D1_EMISSAO) <= DtoS(MV_PAR02)
		_cChaPes := xFilial("SD1")+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA
		MsgRun("Importando CDD. Aguarde.. Por favor ..",,{||U_KTN_ProcCDD("E",_cChaPes) })				
		dbSElectArea("SD1")
		dbSkip()
	Enddo

Return()


User Function KTN_ProcCDD(_cTpMov,_cChaPes)

If _cTpMov = "S"
	&& Ja estou posicionado n\ tabela SF2
	dbSelectArea("SD2")
	dbSetOrder(3)
	If dbSeek(_cChaPes)
		_cChave := xFilial("SD2")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA
		While !EOf() .and. xFilial("SD2")+SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA = _cChave
			If !Empty(Alltrim(SD2->D2_NFORI)) .AND. !Empty(Alltrim(SD2->D2_ITEMORI)) && !Empty(Alltrim(SD2->D2_SERIORI)) .AND.
			&& Deveremos grava o CDD
				dbSelectArea("SZZ")
				dbSetOrder(1)
					If dbSeek(xFilial("SZZ")+"S"+SD2->D2_DOC+SD2->D2_SERIE+SD2->D2_CLIENTE+SD2->D2_LOJA)
						_cChaveSZZ := xFilial("SZZ")+"S"+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA
						While !EOf() .and. xFilial("SZZ")+"S"+SZZ->ZZ_DOC+SZZ->ZZ_SERIE+SZZ->ZZ_CLIFOR+SZZ->ZZ_LOJA = _cChaveSZZ
							_cMensagenSZZ := Alltrim(SZZ->ZZ_TXTMENS)
												
							_cCmdCCE := " SELECT * FROM "+ RetSqlName("CCE")
							_cCmdCCE += " WHERE "
							_cCmdCCE += " CCE_FILIAL = '"+xFilial("CCE")+"' AND "
							_cCmdCCE += " CCE_DESCR  = '"+_cMensagenSZZ +"' AND "
							_cCmdCCE += " D_E_L_E_T_ = ' ' "
							
							TcQuery _cCmdCCE Alias "SQLCCE" New
							dbSelectArea("SQLCCE")
							Count to nTotReg
							dbSelectArea("SQLCCE")
							dbGoTop()
							If nTotReg = 0
								&& Deveremos gravar a mensagem da tabela SZZ para a tabela CCE para amarra-la na CDD.
								_nNumCCE := GETSX8NUM("CCE","CCE_COD")
								ConfirmSX8()
								RecLock("CCE",.T.)
								CCE->CCE_FILIAL := xFilial("CCE")
								CCE->CCE_COD  	:= _nNumCCE
								CCE->CCE_DESCR	:= _cMensagenSZZ
								MsUnlock()
							Else
								&& Indica que ja existe o dado na tabela CCE e deveremos apenas criar o registro na tabela CCD.
								_nNumCCE := SQLCCE->CCE_COD
							Endif
							
							dbSelectArea("SQLCCE")
							dbCloseArea()
							
							&& Deveremos agora gravar os dados na tabela CDD
							dbSelectArea("CDD")
							dbSetOrder(1)
							IF !dbSeek(xFilial("CDD")+_cTpMov+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA+SD2->D2_NFORI+SD2->D2_SERIORI)
								RecLock("CDD",.T.)
								CDD->CDD_FILIAL	:= xFilial("SF2")
								CDD->CDD_TPMOV	:= _cTpMov
								CDD->CDD_DOC	:= SF2->F2_DOC
								CDD->CDD_SERIE	:= SF2->F2_SERIE
								CDD->CDD_CLIFOR	:= SF2->F2_CLIENTE
								CDD->CDD_LOJA	:= SF2->F2_LOJA
								CDD->CDD_DOCREF	:= SD2->D2_NFORI
								CDD->CDD_SERREF	:= SD2->D2_SERIORI
								CDD->CDD_IFCOMP	:= _nNumCCE
								MsUnlock()
							Endif
							
							&& Deveremos agora gravar os dados na tabela CDD
							dbSelectArea("CDT")
							dbSetOrder(1)
							If !dbSeek(xFilial("CDT")+_cTpMov+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA+_nNumCCE)
								RecLock("CDT",.T.)
								CDT->CDT_FILIAL	:= xFilial("SF2")
								CDT->CDT_TPMOV	:= _cTpMov
								CDT->CDT_DOC	:= SF2->F2_DOC
								CDT->CDT_SERIE	:= SF2->F2_SERIE
								CDT->CDT_CLIFOR	:= SF2->F2_CLIENTE
								CDT->CDT_LOJA	:= SF2->F2_LOJA
								CDT->CDT_IFCOMP	:= _nNumCCE
								MsUnlock()
							Endif
							dbSelectArea("SZZ")	
							dbSkip()
						Enddo	
					Endif	
				Endif
			dbSelectArea("SD2")
			dbSkip()
		Enddo
	Endif
Else
	&& Ja estou posicionado na tabela SF2
	dbSelectArea("SD1")
	dbSetOrder(1)
	If dbSeek(_cChaPes)
		
		_cChave := xFilial("SD1")+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA
		While !EOf() .and. xFilial("SD1")+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA = _cChave
			
				If !Empty(Alltrim(SD1->D1_NFORI)) .AND. !Empty(Alltrim(SD1->D1_ITEMORI)) && !Empty(Alltrim(SD2->D2_SERIORI)) .AND.
					&& Deveremos grava o CDD
					dbSelectArea("SZZ")
					dbSetOrder(1)
					If dbSeek(xFilial("SZZ")+"E"+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA)
						_cChaveSZZ := xFilial("SZZ")+"E"+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA
						While !EOf() .and. xFilial("SZZ")+"E"+SZZ->ZZ_DOC+SZZ->ZZ_SERIE+SZZ->ZZ_CLIFOR+SZZ->ZZ_LOJA = _cChaveSZZ
							_cMensagenSZZ := Alltrim(SZZ->ZZ_TXTMENS)
					
							_cCmdCCE := " SELECT * FROM "+ RetSqlName("CCE")
							_cCmdCCE += " WHERE "
							_cCmdCCE += " CCE_FILIAL = '"+xFilial("CCE")+"' AND "
							_cCmdCCE += " CCE_DESCR  = '"+_cMensagenSZZ +"' AND "
							_cCmdCCE += " D_E_L_E_T_ = ' ' "
							
							TcQuery _cCmdCCE Alias "SQLCCE" New
							dbSelectArea("SQLCCE")
							Count to nTotReg
							dbSelectArea("SQLCCE")
							dbGoTop()
							If nTotReg = 0
								&& Deveremos gravar a mensagem da tabela SZZ para a tabela CCE para amarra-la na CDD.
								_nNumCCE := GETSX8NUM("CCE","CCE_COD")
								ConfirmSX8()
								RecLock("CCE",.T.)
								CCE->CCE_FILIAL := xFilial("CCE")
								CCE->CCE_COD  	:= _nNumCCE
								CCE->CCE_DESCR	:= _cMensagenSZZ
								MsUnlock()
							Else
								&& Indica que ja existe o dado na tabela CCE e deveremos apenas criar o registro na tabela CCD.
								_nNumCCE := SQLCCE->CCE_COD
							Endif
							
							dbSelectArea("SQLCCE")
							dbCloseArea()
							
							&& Deveremos agora gravar os dados na tabela CDD
							dbSelectArea("CDD")
							dbSetOrder(1)
							IF !dbSeek(xFilial("CDD")+_cTpMov+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA+SD1->D1_NFORI+SD1->D1_SERIORI)
								RecLock("CDD",.T.)
								CDD->CDD_FILIAL	:= xFilial("SD1")
								CDD->CDD_TPMOV	:= _cTpMov
								CDD->CDD_DOC	:= SD1->D1_DOC
								CDD->CDD_SERIE	:= SD1->D1_SERIE
								CDD->CDD_CLIFOR	:= SD1->D1_FORNECE
								CDD->CDD_LOJA	:= SD1->D1_LOJA
								CDD->CDD_DOCREF	:= SD1->D1_NFORI
								CDD->CDD_SERREF	:= SD1->D1_SERIORI
								CDD->CDD_IFCOMP	:= _nNumCCE
								MsUnlock()
							Endif
							
							&& Deveremos agora gravar os dados na tabela CDD
							dbSelectArea("CDT")
							dbSetOrder(1)
							If !dbSeek(xFilial("CDT")+_cTpMov+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA+_nNumCCE)
								RecLock("CDT",.T.)
								CDT->CDT_FILIAL	:= xFilial("SD1")
								CDT->CDT_TPMOV	:= _cTpMov
								CDT->CDT_DOC	:= SD1->D1_DOC
								CDT->CDT_SERIE	:= SD1->D1_SERIE
								CDT->CDT_CLIFOR	:= SD1->D1_FORNECE
								CDT->CDT_LOJA	:= SD1->D1_LOJA
								CDT->CDT_IFCOMP	:= _nNumCCE
								MsUnlock()
							Endif
							dbSelectArea("SZZ")	
							dbSkip()
						Enddo	
					Endif
				Endif	
			
			dbSelectArea("SD1")
			dbSkip()
		Enddo
	Endif
Endif

Return()


User Function KTN_CDT_Proc(_cTpMov,_cChaPes)

dbSelectArea("SZZ")
dbSetOrder(1)
If dbSeek(xFilial("SZZ")+"S"+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA)
	_cChaveSZZ := xFilial("SZZ")+"S"+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA
	While !EOf() .and. xFilial("SZZ")+"S"+SZZ->ZZ_DOC+SZZ->ZZ_SERIE+SZZ->ZZ_CLIFOR+SZZ->ZZ_LOJA = _cChaveSZZ
		_cMensagenSZZ := Alltrim(SZZ->ZZ_TXTMENS)
		_cCmdCCE := " SELECT * FROM "+ RetSqlName("CCE")
		_cCmdCCE += " WHERE "
		_cCmdCCE += " CCE_FILIAL = '"+xFilial("CCE")+"' AND "
		_cCmdCCE += " CCE_DESCR  = '"+_cMensagenSZZ +"' AND "
		_cCmdCCE += " D_E_L_E_T_ = ' ' "
		
		TcQuery _cCmdCCE Alias "SQLCCE" New
		dbSelectArea("SQLCCE")
		Count to nTotReg
		dbSelectArea("SQLCCE")
		dbGoTop()
		If nTotReg = 0
			&& Deveremos gravar a mensagem da tabela SZZ para a tabela CCE para amarra-la na CDD.
			_nNumCCE := GETSX8NUM("CCE","CCE_COD")
			ConfirmSX8()
			RecLock("CCE",.T.)
			CCE->CCE_FILIAL := xFilial("CCE")
			CCE->CCE_COD  	:= _nNumCCE
			CCE->CCE_DESCR	:= _cMensagenSZZ
			MsUnlock()
		Else
			&& Indica que ja existe o dado na tabela CCE e deveremos apenas criar o registro na tabela CCD.
			_nNumCCE := SQLCCE->CCE_COD
		Endif
		
		dbSelectArea("SQLCCE")
		dbCloseArea()
		
		&& Deveremos agora gravar os dados na tabela CDD
		dbSelectArea("CDT")
		dbSetOrder(1)
		If !dbSeek(xFilial("CDT")+_cTpMov+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA+_nNumCCE)
			RecLock("CDT",.T.)
			CDT->CDT_FILIAL	:= xFilial("SF2")
			CDT->CDT_TPMOV	:= _cTpMov
			CDT->CDT_DOC	:= SF2->F2_DOC
			CDT->CDT_SERIE	:= SF2->F2_SERIE
			CDT->CDT_CLIFOR	:= SF2->F2_CLIENTE
			CDT->CDT_LOJA	:= SF2->F2_LOJA
			CDT->CDT_IFCOMP	:= _nNumCCE
			MsUnlock()
		Endif
		
		dbSelectArea("SZZ")
		dbSkip()
	Enddo
Endif

Return
