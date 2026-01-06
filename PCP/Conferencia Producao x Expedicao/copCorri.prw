#Include 'Protheus.ch'
#Include 'TopConn.ch'

User Function copCorri()

	Local cQuery	:= ""
	
	cQuery += " SELECT C2_ZZAMOST, C2_ZZNCORR, C2_ZZREQUA, C2_ZZNDIN, C2_ZZNEPR, C2_ZZASME, C2_ZZTPOPK " +CRLF
	cQuery += " FROM "+RetSqlName("SC2")+" " +CRLF
	cQuery += " WHERE " +CRLF
	cQuery += " D_E_L_E_T_ = ' ' " +CRLF
	cQuery += " AND C2_FILIAL = '"+xFilial("SC2")+"' "+CRLF
	cQuery += " AND C2_NUM = '"+SC2->C2_NUM+"' "+CRLF
	cQuery += " AND C2_ITEM = '"+SC2->C2_ITEM+"' "+CRLF
	cQuery += " AND C2_SEQUEN = '"+SC2->C2_SEQPAI+"' "+CRLF
	
	TCQUERY cQuery NEW ALIAS "cAlias"
		
	If cAlias->(!Eof())	
		Reclock("SC2",.f.)
			SC2->C2_ZZAMOST := cAlias->C2_ZZAMOST
			SC2->C2_ZZNCORR := cAlias->C2_ZZNCORR
			SC2->C2_ZZREQUA := cAlias->C2_ZZREQUA
			SC2->C2_ZZNDIN  := cAlias->C2_ZZNDIN
			SC2->C2_ZZNEPR  := cAlias->C2_ZZNEPR
			SC2->C2_ZZASME  := cAlias->C2_ZZASME
			SC2->C2_ZZTPOPK  := cAlias->C2_ZZTPOPK
		SC2->( msUnlock() )
	EndIf
	cAlias->(dbCloseArea())
	
Return

