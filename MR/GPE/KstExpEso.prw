#INCLUDE "TOTVS.CH"
/*
Inclusão de registros de inventário, utilizando matriz extraída de planilha
Eco_Verd
*/
User Function kSTExpEso()

	Local aVetor     := {}
	Local cAliasExp  := ""
	Local _cEvento   := ""
	Local _cDir      := ""
	Local _aFields   := {}
	Local _nContador := 0
	PRIVATE aInvent  := {}

	if !ExistDir("\XMLESOCIAL")
		MakeDir("\XMLESOCIAL")
	endif



	// Verificar se o funcionário pertence a empresa
	cAliasExp := GetNextAlias()

	//-------------------
	//Criação do objeto
	//-------------------
//	oTempTable := FWTemporaryTable():New( cAliasExp )
	//--------------------------
	//Monta os campos da tabela
	//--------------------------

	_aFields := {}
	aadd(_aFields,{'ENTIDADE'  , 'C',006,0})
	aadd(_aFields,{'VERSAO'    , 'C',015,0})
	aadd(_aFields,{'AMBIENTE'  , 'C',001,0})
	aadd(_aFields,{'LOTE'      , 'C',015,0})
	aadd(_aFields,{'ID'        , 'C',100,0})
	aadd(_aFields,{'CODEVENTO' , 'C',010,0})
	aadd(_aFields,{'CHAVE'     , 'C',036,0})
	aadd(_aFields,{'PROTOCOLO' , 'C',040,0})
	aadd(_aFields,{'STATUS'    , 'C',001,0})
	aadd(_aFields,{'DETSTATUS' , 'C',250,0})
	aadd(_aFields,{'DTENTRADA' , 'C',008,0})
	aadd(_aFields,{'HRENTRADA' , 'C',008,0})
	aadd(_aFields,{'DTTRANS'   , 'C',008,0})
	aadd(_aFields,{'HRTRANS'   , 'C',008,0})
	aadd(_aFields,{'CODRECEITA', 'C',010,0})
	aadd(_aFields,{'XMLERP'    , 'M',010,0})
	aadd(_aFields,{'XMLRET'    , 'M',010,0})
	aadd(_aFields,{'DSCRECEITA', 'C',250,0})
	aadd(_aFields,{'XMLSIG'    , 'M',010,0})
	aadd(_aFields,{'LOGID'     , 'C',040,0})
	aadd(_aFields,{'RETPROC'   , 'M',010,0})


//	oTemptable:SetFields( _aFields )

	//------------------
	//Criação da tabela
	//------------------
//	oTempTable:Create()

	_cQuery := ""
//	_cQuery += " SELECT * "
	_cQuery += " SELECT "
	_cQuery += " ENTIDADE, "
	_cQuery += " VERSAO, "
	_cQuery += " AMBIENTE, "
	_cQuery += " LOTE, "
	_cQuery += " ID, "
	_cQuery += " CODEVENTO, "
	_cQuery += " CHAVE, "
	_cQuery += " PROTOCOLO, "
	_cQuery += " STATUS, "
	_cQuery += " DETSTATUS, "
	_cQuery += " DTENTRADA, "
	_cQuery += " HRENTRADA, "
	_cQuery += " DTTRANS, "
	_cQuery += " HRTRANS, "
	_cQuery += " CODRECEITA, "
	_cQuery += " DSCRECEITA, "
	_cQuery += " LOGID, "
	_cQuery += " convert(varchar(max), convert(varbinary(max),XMLERP)) AS XMLERP, "
	_cQuery += " convert(varchar(max), convert(varbinary(max),XMLRET)) AS XMLRET, "
	_cQuery += " convert(varchar(max), convert(varbinary(max),XMLSIG)) AS XMLSIG, "
	_cQuery += " convert(varchar(max), convert(varbinary(max),RETPROC)) AS RETPROC"
	_cQuery += " FROM SPED400 "
	_cQuery += " ORDER BY CODEVENTO,DTENTRADA "

	DBUseArea(.T.,"TOPCONN",TCGENQRY(,,_cQuery),cAliasExp,.F.,.T.)


//	Processa({||SqlToTrb(_cQuery, _aFields, cAliasExp )})	// Cria arquivo temporario

	dbSelectArea( cAliasExp )
	dbGoTop()

	While !Eof()

		// Criar um diretorio para cada evento
		_cEvento := StrTran((cAliasExp)->CODEVENTO,"-","")
		_cDir    := "\XMLESOCIAL\"+AllTrim(_cEvento)
		if !ExistDir(AllTrim(_cDir))
			MakeDir(AllTrim(_cDir))
		endif

		// Dividir os eventos em ANO/MES (AAAAMM)
		_cDir := "\XMLESOCIAL\"+AllTrim(_cEvento)+"\"+Substr(AllTrim(DTENTRADA),1,6)
		if !ExistDir(AllTrim(_cDir))
			MakeDir(AllTrim(_cDir))
		endif

		// Criar um diretorio para os XMLS de envio
		_cDirEnv := _cDir+"\"+"XMLENV"
		if !ExistDir(AllTrim(_cDirEnv))
			MakeDir(AllTrim(_cDirEnv))
		endif

		// Criar um diretorio para os XMLS de retorno
		_cDirRet := _cDir+"\"+"XMLRET"
		if !ExistDir(AllTrim(_cDirRet))
			MakeDir(AllTrim(_cDirRet))
		endif


		_cArq := _cDirEnv+"\"+AllTrim((cAliasExp)->CODEVENTO)+"_"+dtos(date())+"_"+StrTran(Time(),":","")+".xml"
		_nHandle := fCreate(_cArq,0)
		_cBuffers := (cAliasExp)->XMLERP
		FWrite(_nHandle,_cBuffers)
		fClose(_nHandle)

		if (cAliasExp)->XMLRET != nil .and. !Empty((cAliasExp)->XMLRET)
			_cArq := _cDirRet+"\"+AllTrim((cAliasExp)->CODEVENTO)+"_"+dtos(date())+"_"+StrTran(Time(),":","")+".xml"
			_nHandle := fCreate(_cArq,0)
			_cBuffers := (cAliasExp)->XMLRET
			FWrite(_nHandle,_cBuffers)
			fClose(_nHandle)
		endif

		DbSelectArea(cAliasExp)
		dbSkip()
	Enddo

	//---------------------------------
	//Exclui a tabela
	//---------------------------------
//	oTempTable:Delete()

Return(NIL)
