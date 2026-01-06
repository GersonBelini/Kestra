#Include 'Protheus.ch'
#Include 'TopConn.ch'

#define GRUPO_ER					'PA06/PI01'
#define GRUPO_AT					'PA07/PI02'
#define GRUPO_RV					'RV'

#define SEQ_ER_INICIO 			'0001'
#define SEQ_ER_FIM	 			'2000'
#define SEQ_ER_AM_INICIO 		'2001'
#define SEQ_ER_AM_FIM	 		'3500'
#define SEQ_AT_INICIO 			'3501'
#define SEQ_AT_FIM	 			'5799'
#define SEQ_AT_AM_INICIO 		'5800'
#define SEQ_AT_AM_FIM	 		'5999'
#define SEQ_RV_INICIO 			'6000'
#define SEQ_RV_FIM	 			'8999'
#define SEQ_OU_INICIO 			'9000'
#define SEQ_OU_FIM	 			'9999'

/*/{Protheus.doc} retCorri

Salva o numero da corrida KESTRA.
	
@author André Oquendo
@since 24/04/2015

/*/

User Function retCorri()
	Local cCorrida		:= ""
	dbSelectArea("SB1")
	dbSetOrder(1)//B1_FILIAL+B1_COD
	dbSeek(xFilial("SB1")+SC2->C2_PRODUTO)
	
	If empty(SC2->C2_ZZNCORR)
		cCorrida := geraCod(substr(SB1->B1_GRUPO,1,2),SC2->C2_ZZAMOST,SB1->B1_TIPO)
		
		Reclock("SC2",.f.)
			SC2->C2_ZZNCORR := cCorrida
		SC2->( msUnlock() )
	EndIf

Return


/*/{Protheus.doc} geraCod

Gera o codigo da corrida conforme regras definidas na especificação.
	
@author André Oquendo
@since 24/04/2015

@param cGrupo, String, Grupo do produto
@param cAmostra, String, OP de amostra
@param cTipo, String, Tipo do produto

@return String Numero da corrida

/*/

Static Function geraCod(cGrupo,cAmostra,cTipo)	
	Local cQuery			:= ""
	Local cData			:= substr(DtoS(SC2->C2_DATPRI),1,4)+substr(DtoS(SC2->C2_DATPRI),5,2)
	Local cRet				:= substr(DtoS(SC2->C2_DATPRI),3,2)+substr(DtoS(SC2->C2_DATPRI),5,2)
	Local cSequen			:= ""
	
	cQuery := " SELECT " + CRLF		
	cQuery += "	R_E_C_N_O_ AS RECNO						" + CRLF
	cQuery += " FROM " + RetSqlName("SZ4") + " SZ4 						" + CRLF	
	cQuery += " WHERE 														" + CRLF
	cQuery += "	   	SZ4.D_E_L_E_T_ 	= 	' ' 							" + CRLF		
	cQuery += "	   	AND Z4_GRPPRO = 	'"+cGrupo+"'						" + CRLF
	cQuery += "	   	AND Z4_AMOSTRA = 	'"+cAmostra+"'					" + CRLF
	cQuery += "	   	AND Z4_ANOMES = 	'"+cData+"'						" + CRLF	
	
	TcQuery cQuery New Alias "QRYCORRIDA"
	QRYCORRIDA->(DbGoTop())
	
	If QRYCORRIDA->(!Eof())
		SZ4->(dbGoto(QRYCORRIDA->RECNO))
		cSequen := soma1(SZ4->Z4_SEQUEN)
		cRet += cSequen
		RecLock("SZ4",.F.)
			SZ4->Z4_SEQUEN := cSequen
		MsUnLock()
	Else
		If cGrupo $ GRUPO_ER
			If cAmostra == "S"
				cSequen := SEQ_ER_AM_INICIO
			Else
				cSequen := SEQ_ER_INICIO
			EndIf
		ElseIf cGrupo $ GRUPO_AT
			If cAmostra == "S"
				cSequen := SEQ_AT_AM_INICIO
			Else
				cSequen := SEQ_AT_INICIO
			EndIf
		ElseIf cTipo == GRUPO_RV			
			cSequen := SEQ_RV_INICIO
		Else
			cSequen := SEQ_OU_INICIO
		EndIf			
		
		cRet += cSequen
		RecLock("SZ4",.T.)
			SZ4->Z4_FILIAL 	:= xFilial("SZ4")
			SZ4->Z4_GRPPRO 	:= cGrupo
			SZ4->Z4_AMOSTRA 	:= cAmostra
			SZ4->Z4_ANOMES 	:= cData
			SZ4->Z4_SEQUEN 	:= cSequen
		MsUnLock()		
	EndIf
	
	QRYCORRIDA->(DbCloseArea())

Return cRet


/*
User Function fAjuSUA()

_cCmdSql := " SELECT SC5.C5_NUM, SUA.UA_NUMSC5, SUA.UA_OPERADO, SC5.C5_ZZOPER, SC5.R_E_C_N_O_ AS  RECNO"
_cCmdSql += " FROM " + RetSqlName("SC5") + " SC5 " 
_cCmdSql += " 	INNER JOIN "+ RetSqlName("SUA") + " SUA ON "
_cCmdSql += " 	SC5.C5_NUM     = SUA.UA_NUMSC5  AND "
_cCmdSql += " 	SUA.UA_FILIAL  = '"+xFilial("SUA")+"' AND "
_cCmdSql += " 	SUA.D_E_L_E_T_ = ' ' " 
_cCmdSql += " WHERE " 
_cCmdSql += " 	SC5.C5_FILIAL = '"+xFilial("SC5")+"' AND "
_cCmdSql += " 	SC5.D_E_L_E_T_ = ' ' AND "
_cCmdSql += " 	SC5.C5_ZZOPER = ' ' " 

TcQuery _cCmdSql Alias "QRY" New

If QRY->(!EOF())

	While !EOf()

		dbSelectArea("SC5")
		dbgoto(QRY->RECNO)
		
		RecLock("SC5",.F.)
		SC5->C5_ZZOPER := QRY->UA_OPERADO
		MsUnlock()
	
		dbSelectArea("QRY")
		dbSkip()

	Enddo

Endif

Return()
*/