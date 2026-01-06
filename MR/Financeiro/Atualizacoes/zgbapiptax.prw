#include "tbiconn.ch"
#include 'PROTHEUS.ch'
#include 'parmtype.ch'
#include "fwmvcdef.ch"

// #########################################################################################
// Projeto: Kestra - Acessar API do Bacen para taxas PTax
// Modulo :
// Fonte  : ZGBAPIPTAX
// ----------+-------------------+-----------------------------------------------------------
// Data      | Autor             | Descricao
// ----------+-------------------+-----------------------------------------------------------
// 14/01/2019| Gerson Belini     | Acessar API do Bacen para taxas PTax
// ----------+-------------------+-----------------------------------------------------------
//GB Consultoria|


user function ZGBApiPtax(_aPar1)
	Local lAuto     := .F.
	Local _nCtFil   := 0
	Local _aFilProc := {}
	Local oPanel1
	Local oSay1
	Local _nCount   := 0

	Static oDlg
	Private _aPar	   := _aPar1
	Private _cGrpMarca := ""
	Private _aMarProc  := {}
	Private aHeader    := {}
	Private _cToken    := ""
	Private cUrlBase   := ""
	Private _aProcesso := {}
	Default _lPortaria := .F.

	if ValType(_aPar1) == 'A'
		//WfPrepEnv('01','05','U_PXLogSmart',{'DAK','SF2','SC2','Z24','Z26'})
		RpcSetType ( 3 )
		PREPARE ENVIRONMENT EMPRESA "01" FILIAL "04" MODULO "EST" TABLES 'DAK','SF2','SC2','Z24','Z26'
		lAuto := .T.
		if Len(_aPar1) > 0 .and. _aPar1[1] == "PORTARIA"
			_lPortaria := .T.
		endif
	endif

	/*
	Os Status Possiveis para os envios serão os seguintes:
	1 - Aguardando Envio
	2 - Enviado com Sucesso
	3 - Enviado com Rejeição
	4 - Retornado com Sucesso
	*/


	if !lAuto
		DEFINE MSDIALOG oDlg TITLE OemToAnsi("PAINEL PARA RETORNO DOS MOVIMENTOS") FROM 000, 000  TO 490, 490 COLORS 0, 16777215 PIXEL

		@ 000, 000 MSPANEL oPanel1 SIZE 349, 251 OF oDlg COLORS 0, 16777215 RAISED
		@ 020, 025 BUTTON oButton1 PROMPT "Busca Cotação" SIZE 068, 015 OF oPanel1 ACTION ZGbSApiPtx() PIXEL
		@ 050, 025 BUTTON oButton2 PROMPT "Atualizar Taxa do Período" SIZE 068, 015 OF oPanel1 ACTION ZGbupdtax() PIXEL
		@ 080, 025 BUTTON oButton3 PROMPT "Busca Cotação HTTPSGet" SIZE 068, 015 OF oPanel1 ACTION TSTGetSSL() PIXEL
		@ 110, 025 BUTTON oButton4 PROMPT "Rest Teste Quaresma" SIZE 068, 015 OF oPanel1 ACTION RestTest() PIXEL
		@ 140, 025 BUTTON oButton4 PROMPT "Carrega Dados ZZ7" SIZE 068, 015 OF oPanel1 ACTION KstCnSD1() PIXEL
		//@ 140, 025 BUTTON oButton5 PROMPT "Envia Portaria" SIZE 068, 015 OF oPanel1 ACTION U_PxLsEnvPor("T") PIXEL
		//@ 170, 025 BUTTON oButton5 PROMPT "Tst Retorna XML" SIZE 068, 015 OF oPanel1 ACTION U_TstGetXML() PIXEL
		//@ 200, 025 BUTTON oButton5 PROMPT "Exporta Textos Carteira" SIZE 068, 015 OF oPanel1 ACTION U_PxExpTxtP() PIXEL
		//@ 230, 025 BUTTON oButton5 PROMPT "Exporta Textos LogSmart" SIZE 068, 015 OF oPanel1 ACTION ExpPxLS() PIXEL
		//@ 020, 150 BUTTON oButton6 PROMPT "Retorno Endereçamento" SIZE 068, 015 OF oPanel1 ACTION PxLSGetEnd() PIXEL
		//@ 050, 150 BUTTON oButton7 PROMPT "Retorna Ordem de Produção" SIZE 068, 015 OF oPanel1 ACTION PxLSGetOp() PIXEL
		//@ 080, 150 BUTTON oButton7 PROMPT "Retorna Cargas Separadas" SIZE 068, 015 OF oPanel1 ACTION PxLSGetCar() PIXEL
		//@ 110, 150 BUTTON oButton7 PROMPT "Retorna Portaria" SIZE 068, 015 OF oPanel1 ACTION U_PxLSGetPor() PIXEL
		//@ 140, 150 BUTTON oButton7 PROMPT "Consula OP" SIZE 068, 015 OF oPanel1 ACTION U_LsOpBrowse() PIXEL
		//@ 170, 150 BUTTON oButton7 PROMPT "Envia Produtos" SIZE 068, 015 OF oPanel1 ACTION U_LsSB1Browse() PIXEL
		//@ 200, 150 BUTTON oButton7 PROMPT "Leitura de Inventário" SIZE 068, 015 OF oPanel1 ACTION PxLSGetInv() PIXEL
		//@ 200, 150 BUTTON oButton7 PROMPT "Armazém RC (Transf.)" SIZE 068, 015 OF oPanel1 ACTION PxLSTrRC() PIXEL
		//@ 230, 150 BUTTON oButton7 PROMPT "Est.End.Devolução" SIZE 068, 015 OF oPanel1 ACTION PxEstEnd() PIXEL

		ACTIVATE MSDIALOG oDlg CENTERED

		Return
	endif


Return()

Static Function ZGbSApiPtx(_dCotacao,_cMoeda)
	//	Local cUrlBase  := ""
	Local _nCtFil   := 0
	Local _aFilProc := {}
	Local _cQuery   := ""
	Local _cMetodo  := ""
	Local _oObj     := nil
	Local _nCount   := 0
	Local _aRetTaxa := {}
	Private _nCtEnvio   := 0
	Private _lReproce   := .F.
	Private _nCTRepro   := 0
	Private cHoraInicio := NIL
	Private cElapsed    := NIL
	DEFAULT _dCotacao := dDatabase-1

	ConOut("ZGbSApiPtx Consultar a cotação PTAX do governo para alimentar as tabelas SM2 e SYE (Commex)")

	cUrlBase := "https://olinda.bcb.gov.br/olinda/servico/PTAX/versao/v1/odata"

	//https://olinda.bcb.gov.br/olinda/servico/PTAX/versao/v1/odata/CotacaoMoedaDia(moeda=@moeda,dataCotacao=@dataCotacao)?@moeda='USD'&@dataCotacao='09-24-2020'&$top=100&$skip=0&$format=json

	aHeader := {}
	Aadd(aHeader, "Content-Type: application/json")
	AAdd(aHeader, "User-Agent: Chrome/65.0 (compatible; Protheus " + GetBuild() + ")")

	oRestClient := FWRest():New(cUrlBase)

	_cData := Dtos(_dCotacao)

	_cData := Substr(_cData,5,2)+"-"+Substr(_cData,7,2)+"-"+Substr(_cData,1,4)

//	oRestClient:setPath(escape("/CotacaoMoedaDia(moeda=@moeda,dataCotacao=@dataCotacao)?@moeda='USD'&@dataCotacao='09-24-2020'&$top=100&$skip=0&$format=json"))
	//oRestClient:setPath("/CotacaoMoedaDia(moeda=@moeda,dataCotacao=@dataCotacao)?@moeda='USD'&@dataCotacao='09-24-2020'&$top=100&$skip=0&$format=json")
	oRestClient:setPath("/CotacaoMoedaDia(moeda=@moeda,dataCotacao=@dataCotacao)?@moeda='USD'&@dataCotacao='"+_cData+"'&$top=100&$skip=0&$format=json")

//	If oRestClient:Get(aHeader)
	If oRestClient:Get()

		__cNewID  := ""
		__cNewURL := ""
		_nQuantConf := 0
		_aRetCar    := {}
		_cObserv    := ""

		If FWJsonDeserialize(oRestClient:GetResult(),@_oObj)
			If _oOBj <> Nil
				if _oObj:Value <> Nil
					For _nCount := 1 to Len(_oObj:Value)
						if "FECHAMENTO" $ Upper(_oObj:Value[_nCount]:TIPOBOLETIM)
							aadd(_aRetTaxa,_oObj:Value[_nCount]:COTACAOVENDA)
							aadd(_aRetTaxa,_oObj:Value[_nCount]:COTACAOCOMPRA)
							//_nTaxaFec := _oObj:Value[_nCount]:COTACAOCOMPRA
						endif
					Next _nCount
				endif
			Endif
		Endif
	Else
		Teste := "TESTE"
		_cMensErro := ""
		if ValType(oRestClient:GetResult()) == "C"
			_cMensErro := oRestClient:GetResult()
		else
			_cMensErro := oRestClient:GetLastError()
		endif
		MsgInfo(_cMensErro,'Integração não efetuada: ' + oRestClient:GetLastError())
	Endif
	oRestClient := Nil
	_oObj := Nil
Return(_aRetTaxa)

Static Function zgbupdtax()

	Local aSays		:={}, aButtons:={}
	Local aArea 	:= GetArea()
	Local bBlock	:= Nil
	Local nOpca     := 0

	Private oProcess
	Private cCadastro  := "Atualizar taxas PTAX"
	Private _dCotaIni  := stod("")
	Private _dCotaFim  := stod("")

//	Pergunte("PXOMSRTRAN",.F.)
	/*/
	MV_PAR01 Da Transportadora
	MV_PAR02 Até a Transportadora
	MV_PAR03 Da Emissão
	MV_PAR04 Até a Emissão
	MV_PAR05 Da Carga
	MV_PAR06 Até a Carga

	/*/
	_dCotaIni  := dDataBase - 365
	_dCotaFim  := dDataBase - 1

	AADD(aSays,' Atualizar as taxas PTAX da tabela SM2 e SYE' )

	//===================================
	//Inicializa o log de processamento
	//===================================
	ProcLogIni( aButtons )

//	AADD(aButtons, { 5,.T.,{|| Pergunte("PXOMSRTRAN",.T.) } } )
	AADD(aButtons, { 1,.T.,{|| nOpca := 1,FechaBatch()    } } )
	AADD(aButtons, { 2,.T.,{|| FechaBatch()               } } )

	FormBatch( cCadastro, aSays, aButtons ,,,445)

	If nOpca == 1
		//===================================
		// Atualiza o log de processamento
		//===================================
		ProcLogAtu("INICIO")

		_dCotaIni  := dDataBase - 1500
		_dCotaFim  := dDataBase - 1
		//incluído o parâmetro lEnd para controlar o cancelamento da janela
		oProcess := MsNewProcess():New({|lEnd| GbAtuTax(@oProcess, @lEnd, @_dCotaIni, @_dCotaFim) },"Processando Planilhas","Calculando Tempos e Gerando Planilha",.T.)
		oProcess:Activate()

		// Faz a chamada da função para processamento

		//===================================
		// Atualiza o log de processamento
		//===================================
		ProcLogAtu("FIM")

	Endif

Return(NIL)

Static Function GbAtuTax(oProcess, lEnd,_dCotaIni,_dCotaFim)

	Local _nCtRule1 := 0
	Local _nCtRule2 := 0
	Local _dDataAtu := _dCotaFim
	Local _aTaxa    := {}
	Local _cMoeda   := "USD"
	Default lEnd    := .F.

	_nCtRule1 := 1

	oProcess:SetRegua1(_nCtRule1) // As operacoes executadas pela função

	oProcess:IncRegua1(" Processando Taxa ")

	_nCtRule2 := 365

	oProcess:SetRegua2(_nCtRule2)

	While _dDataAtu >= _dCotaIni

		oProcess:IncRegua2(" Processando taxa "+dtoc(_dDataAtu))

		if dow(_dDataAtu) == 1 .or. dow(_dDataAtu) == 7
			_dDataAtu --
			Loop
		endif

		_aTaxa := RestTest(_dDataAtu,_cMoeda)

		if Len(_aTaxa) > 0
			DbSelectArea("SM2")
			DbsetOrder(1)
			if DbSeek(dtos(_dDataAtu))
				RecLock("SM2",.F.)
			else
				RecLock("SM2",.T.)
				SM2->M2_DATA := _dDataAtu
			endif
			SM2->M2_MOEDA2 := _aTaxa[2] // Taxa de compra
			SM2->M2_MOEDA6 := _aTaxa[1] // Taxa de Venda
			MsUnLock("SM2")
		endif
/*
		DbSelectArea("SYE")
		DbSetOrder(1)
		if !DbSeek(xFilial("SYE")+dtos(_dDataAtu)+_cMoeda)

//		_aTaxa := ZGbSApiPtx(_dDataAtu,_cMoeda)
			_aTaxa := RestTest(_dDataAtu,_cMoeda)

			if Len(_aTaxa) > 0

				RecLock("SYE",.T.)
				SYE->YE_FILIAL  := xfilial("SYE")
				SYE->YE_DATA    := _dDataAtu
				SYE->YE_MOE_FIN := "6"
				SYE->YE_MOEDA   := _cMoeda
				SYE->YE_VLCON_C := _aTaxa[1]
				SYE->YE_VLFISCA := _aTaxa[1]
				SYE->YE_TX_COMP := _aTaxa[2]
				MsUnLock()
			endif
		endif
*/
		_dDataAtu --

	End

Return()


Static function TSTGetSSL()
	Local cURL := "https://olinda.bcb.gov.br/olinda/servico/PTAX/versao/v1/odata"
	Local nTimeOut := 120
	Local aHeadOut := {}
	Local cHeadRet := ""
	Local cGetRet := ""

// Acrescenta o UserAgent na requisição ...
// http://tools.ietf.org/html/rfc3261#page-179

//Aadd( aHeadOut , "Content-Type: application/json")
//_cGetParam := "/CotacaoMoedaDia(moeda=@moeda,dataCotacao=@dataCotacao)?@moeda='USD'&@dataCotacao=09-24-2020&$top=100&$skip=0&$format=json"
//cGetRet := HTTPSGet( cURL,"\certs\cert.pem","\certs\privkey.pem", "pwdprivkey", _cGetParam, nTimeOut, aHeadOut, @cHeadRet )
//HttpGet( < cUrl >, [ cGetParms ], [ nTimeOut ], [ aHeadStr ], [ @cHeaderGet ] )
//cGetRet := HTTPGet( cURL, _cGetParam, nTimeOut, aHeadOut, @cHeadRet )
//cGetRet := HTTPGet( cURL, _cGetParam, nTimeOut, aHeadOut, @cHeadRet )
	cUrl += "/CotacaoMoedaDia(moeda=@moeda,dataCotacao=@dataCotacao)?@moeda='USD'&@dataCotacao=09-24-2020&$top=100&$skip=0&$format=json"
	cGetRet := HTTPSGet( cURL," "," ", " "," ", nTimeOut, aHeadOut, @cHeadRet )


	if Empty( sPostRet )
		conout( "Fail HTTPSGet" )
	else
		conout( "OK HTTPSGet" )
		varinfo( "WebPage", cGetRet )
	endif

	varinfo( "Header", cHeadRet )
return

Static Function RestTest(_dCotacao,_cMoeda)

	local cURL
	local cHeadRet
	local cGetRet
	local cParserError
	local nTimeOut
	Local oJson
	Local _oObj
	Local _nCount := 0
	Local _cData  := ""
	Local _aTaxas := {}
	DEFAULT _dCotacao := dDatabase-1
	DEFAULT _cMoeda   := "USD"

	Private _aRetTaxa := {}


	_cData := Dtos(_dCotacao)

	_cData := Substr(_cData,5,2)+"-"+Substr(_cData,7,2)+"-"+Substr(_cData,1,4)

// Se quiser gerar a cotação de moedas de um período
// https://olinda.bcb.gov.br/olinda/servico/PTAX/versao/v1/odata/CotacaoMoedaPeriodo(moeda=@moeda,dataInicial=@dataInicial,dataFinalCotacao=@dataFinalCotacao)?%40moeda='GBP'&%40dataInicial='09-01-2020'&%40dataFinalCotacao='09-30-2020'&$format=json&$filter=tipoBoletim%20eq%20'Fechamento'

	cHeadRet := ""
	cURL := "https://olinda.bcb.gov.br/olinda/servico/PTAX/versao/v1/odata/CotacaoMoedaDia(moeda=@moeda,dataCotacao=@dataCotacao)"
	cURL += "?@moeda='"+_cMoeda+"'&@dataCotacao='"+_cData+"'&$top=100&$skip=0&$format=json"
	nTimeOut := 15

//	cGetRet := HTTPSGet( cURL, "", "", "", "@moeda='USD'&@dataCotacao='10-14-2020'&$top=100&$skip=0&$format=json", nTimeOut, /*aHeadOut*/, @cHeadRet)
	cGetRet := HTTPSGet( cURL, "", "", "", "", nTimeOut, /*aHeadOut*/, @cHeadRet)

	//Recuperar a propriedade do json
	oJson := JsonObject():New()
	cErr := oJson:FromJson(cGetRet)

	//Se o cErro estiver vazio é pq fez o parser
	if !Empty(cErr)
		//se der erro ele fica armazedado no cErr
	EndIf

	//recuperar uma propriedade do json
	_oObj := oJson:GetJSonObject('value')
	if _oObj <> Nil
		if ValType(_oObj) == "A" .and. Len(_oObj) > 0
			u_PrintJson(_oObj,@_aRetTaxa)
		EndIf
		_aTaxas := _aRetTaxa
	/*
		For _nCount := 1 to Len(_oObj)
			if "FECHAMENTO" $ Upper(_oObj[_nCount]:TIPOBOLETIM)
				aadd(_aRetTaxa,_oObj[_nCount]:COTACAOVENDA)
				aadd(_aRetTaxa,_oObj[_nCount]:COTACAOCOMPRA)
				//_nTaxaFec := _oObj:Value[_nCount]:COTACAOCOMPRA
			endif
		Next _nCount
	*/
	endif

return(_aTaxas)


user function PrintJson(jsonObj,_aRetTaxa)
	local i, j
	local names
	local lenJson
	local item

	lenJson := len(jsonObj)

	if lenJson > 0
		for i := 1 to lenJson
			u_PrintJson(jsonObj[i],@_aRetTaxa)
		next
	else
		names := jsonObj:GetNames()
		for i := 1 to len(names)
//      conout("Label - " + names[i])
			item := jsonObj[names[i]]
//			if ValType(item) == "C" .or.  ValType(item) == "N"
			if ValType(item) == "C"
				if "FECHAMENTO" $ Upper(jsonObj[names[i]])
					aadd(_aRetTaxa,jsonObj[names[6]])
					aadd(_aRetTaxa,jsonObj[names[3]])
					//_nTaxaFec := _oObj:Value[_nCount]:COTACAOCOMPRA
				endif
				//conout( names[i] + " = " + cvaltochar(jsonObj[names[i]]))
			else
				if ValType(item) == "A"
					conout("Vetor[")
					for j := 1 to len(item)
						conout("Indice " + cValtochar(j))
						if ValType(item[j]) == "J"
							u_PrintJson(item[j],@_aRetTaxa)
						else
							conout(cvaltochar(item[j]))
						endif
					next j
					conout("]Vetor")
				endif
			endif
		next i
	endif
return


/*
{
  "@odata.context": "https://was-p.bcnet.bcb.gov.br/olinda/servico/PTAX/versao/v1/odata$metadata#Moedas",
  "value": [
    {
      "simbolo": "AUD",
      "nomeFormatado": "Dólar australiano",
      "tipoMoeda": "B"
    },
    {
      "simbolo": "CAD",
      "nomeFormatado": "Dólar canadense",
      "tipoMoeda": "A"
    },
    {
      "simbolo": "CHF",
      "nomeFormatado": "Franco suíço",
      "tipoMoeda": "A"
    },
    {
      "simbolo": "DKK",
      "nomeFormatado": "Coroa dinamarquesa",
      "tipoMoeda": "A"
    },
    {
      "simbolo": "EUR",
      "nomeFormatado": "Euro",
      "tipoMoeda": "B"
    },
    {
      "simbolo": "GBP",
      "nomeFormatado": "Libra Esterlina",
      "tipoMoeda": "B"
    },
    {
      "simbolo": "JPY",
      "nomeFormatado": "Iene",
      "tipoMoeda": "A"
    },
    {
      "simbolo": "NOK",
      "nomeFormatado": "Coroa norueguesa",
      "tipoMoeda": "A"
    },
    {
      "simbolo": "SEK",
      "nomeFormatado": "Coroa sueca",
      "tipoMoeda": "A"
    },
    {
      "simbolo": "USD",
      "nomeFormatado": "Dólar dos Estados Unidos",
      "tipoMoeda": "A"
    }
  ]
}
*/



Static Function KstCnSD1()

	Local aSays		:={}, aButtons:={}
	Local aArea 	:= GetArea()
	Local bBlock	:= Nil
	Local nOpca     := 0

	Private oProcess
	Private cCadastro  := "Gerar Registros ZZ7 - Custo Entrada Moeda Forte"
	Private _dCotaIni  := stod("")
	Private _dCotaFim  := stod("")

//	Pergunte("PXOMSRTRAN",.F.)
	/*/
	MV_PAR01 Da Transportadora
	MV_PAR02 Até a Transportadora
	MV_PAR03 Da Emissão
	MV_PAR04 Até a Emissão
	MV_PAR05 Da Carga
	MV_PAR06 Até a Carga

	/*/

	AADD(aSays,' Gerar Registros em Moeda Forte das Notas de Entrada' )

	//===================================
	//Inicializa o log de processamento
	//===================================
	ProcLogIni( aButtons )

//	AADD(aButtons, { 5,.T.,{|| Pergunte("PXOMSRTRAN",.T.) } } )
	AADD(aButtons, { 1,.T.,{|| nOpca := 1,FechaBatch()    } } )
	AADD(aButtons, { 2,.T.,{|| FechaBatch()               } } )

	FormBatch( cCadastro, aSays, aButtons ,,,445)

	If nOpca == 1
		//===================================
		// Atualiza o log de processamento
		//===================================
		ProcLogAtu("INICIO")

		//incluído o parâmetro lEnd para controlar o cancelamento da janela
		oProcess := MsNewProcess():New({|lEnd| GbGerZZ7(@oProcess, @lEnd) }," Processando Documentos de entrada ","Processando documentos de entrada e gerando ZZ7",.T.)
		oProcess:Activate()

		// Faz a chamada da função para processamento

		//===================================
		// Atualiza o log de processamento
		//===================================
		ProcLogAtu("FIM")

	Endif

Return(NIL)

Static Function GbGerZZ7(oProcess, lEnd)

	Local _nCtRule1 := 0
	Local _nCtRule2 := 0
	Local cAliasSD1 := GetNextAlias()
	Local aStruct	:= SD1->(DBSTRUCT()) //Estrutura da tabela de cabeçalho de cargas.
	Local aColumns	:= {}
	Local aPesq		:= {}
	Local oDlgLS	As Object
	Local _aFields  := {}

	Default lEnd    := .F.

	_nCtRule1 := 1

	oProcess:SetRegua1(_nCtRule1) // As operacoes executadas pela função

	oProcess:IncRegua1(" Gerando Tabela ")


	//-------------------
	//Criação do objeto
	//-------------------
	oTempTable := FWTemporaryTable():New( cAliasSD1 )
	//--------------------------
	//Monta os campos da tabela
	//--------------------------

	aEval(SD1->(dbStruct()), {|x| aadd(_aFields,{x[1],x[2],x[3],x[4]})})


	oTemptable:SetFields( _aFields )
	oTempTable:AddIndex("01", {'D1_FILIAL','D1_DOC','D1_SERIE','D1_FORNECE','D1_LOJA'} )

	//------------------
	//Criação da tabela
	//------------------
	oTempTable:Create()

	_cMarca := Space(2)
	_cQuery := ""
	_cQuery += " SELECT * "
	_cQuery += " FROM "+RetSqlName("SD1")+" SD1 "
	_cQuery += " WHERE SD1.D_E_L_E_T_ = ' ' "
	_cQuery += " AND D1_TP = 'MP'"
	_cQuery += " AND D1_CUSTO != 0 "
	//_cQuery += " AND D1_NFORI NOT LIKE ' %' "
	_cQuery += " AND D1_DTDIGIT >= '20200501' "
	_cQuery := ChangeQuery(_cQuery)

	Processa({||SqlToTrb(_cQuery, _aFields, cAliasSD1)})	// Cria arquivo temporario

	count to _nCtRule2

	oProcess:SetRegua2(_nCtRule2)

	DbGoTop()

	While !Eof()

		oProcess:IncRegua2(" Processando Documentos "+(cAliasSD1)->D1_DOC)


		DbSelectArea("SM2")
		DbSetOrder(1)
		if DbSeek((cAliasSD1)->D1_DTDIGIT) .and. SM2->M2_MOEDA6 != 0
			// Poscionar a tabela SD1
			DbSelectArea("SD1")
			DbSetOrder(1)
			DbSeek((cAliasSD1)->(D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM))
			DbSelectArea("ZZ7")
			RecLock("ZZ7",.T.)
			ZZ7->ZZ7_FILIAL := (cAliasSD1)->D1_FILIAL
			ZZ7->ZZ7_DOC    := (cAliasSD1)->D1_DOC
			ZZ7->ZZ7_SERIE  := (cAliasSD1)->D1_SERIE
			ZZ7->ZZ7_ITEM   := (cAliasSD1)->D1_ITEM
			ZZ7->ZZ7_COD    := (cAliasSD1)->D1_COD
			ZZ7->ZZ7_FORNEC := (cAliasSD1)->D1_FORNECE
			ZZ7->ZZ7_LOJA   := (cAliasSD1)->D1_LOJA
			ZZ7->ZZ7_TIPO   := (cAliasSD1)->D1_TIPO
			ZZ7->ZZ7_QUANT  := (cAliasSD1)->D1_QUANT
			ZZ7->ZZ7_PRCUNI := iif( (cAliasSD1)->D1_QUANT > 0, (cAliasSD1)->D1_CUSTO / (cAliasSD1)->D1_QUANT , (cAliasSD1)->D1_CUSTO)
			ZZ7->ZZ7_CUSTO  := (cAliasSD1)->D1_CUSTO
			ZZ7->ZZ7_CSTMFO := (cAliasSD1)->D1_CUSTO / SM2->M2_MOEDA6
			ZZ7->ZZ7_TXCONV := SM2->M2_MOEDA6
			ZZ7->ZZ7_MOEDA  := "6"
			ZZ7->ZZ7_DTDIGI := (cAliasSD1)->D1_DTDIGIT
			ZZ7->ZZ7_EMISSA := (cAliasSD1)->D1_EMISSAO
			ZZ7->ZZ7_DTCONV := (cAliasSD1)->D1_DTDIGIT
			ZZ7->ZZ7_RECDOC := SD1->(RECNO())
			// =====> Gravar dados do documento de origem
			// =====> Se for o proprio documento gravar os dados para fins de cálculo aglutinado
			if Empty((cAliasSD1)->D1_NFORI)
				ZZ7->ZZ7_DOCORI := (cAliasSD1)->D1_DOC
				ZZ7->ZZ7_SERORI := (cAliasSD1)->D1_SERIE
				ZZ7->ZZ7_ITORI  := (cAliasSD1)->D1_ITEM
				ZZ7->ZZ7_RECORI := SD1->(RECNO())
			else
				_nRecno := SD1->(RECNO())
				DbSelectArea("SD1")
				DbSetOrder(1)
				if DbSeek((cAliasSD1)->(D1_FILIAL+D1_NFORI+D1_SERIORI+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEMORI))
					ZZ7->ZZ7_DOCORI := (cAliasSD1)->D1_NFORI
					ZZ7->ZZ7_SERORI := (cAliasSD1)->D1_SERIORI
					ZZ7->ZZ7_ITORI  := (cAliasSD1)->D1_ITEMORI
					ZZ7->ZZ7_RECORI := SD1->(RECNO())
				else
					ZZ7->ZZ7_DOCORI := (cAliasSD1)->D1_NFORI
					ZZ7->ZZ7_SERORI := (cAliasSD1)->D1_SERIORI
					ZZ7->ZZ7_ITORI  := (cAliasSD1)->D1_ITEMORI
					ZZ7->ZZ7_RECORI := _nRecno
				endif
			endif
			MsUnLock()
		endif

		DbSelectArea(cAliasSD1)
		DbSkip()

	End

	//---------------------------------
	//Exclui a tabela
	//---------------------------------
	oTempTable:Delete()

Return()
