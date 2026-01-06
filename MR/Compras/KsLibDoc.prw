// #########################################################################################
// Projeto:
// Modulo :
// Fonte  : KSLIBDOC
// ---------+-------------------+-----------------------------------------------------------
// Data     | Autor             | Descricao
// ---------+-------------------+-----------------------------------------------------------
// 06/12/19 | Gerson Belini     | Developer Studio | Gerado pelo Assistente de Código
// ---------+-------------------+-----------------------------------------------------------
//          |Liberação de documentos - Função provisória - Função padrão relesase 12.1.25 com erro

#include "rwmake.ch"

//------------------------------------------------------------------------------------------
/*/{Protheus.doc} novo
Liberação de documentos - Função provisória - Função padrão relesase 12.1.25 com erro 
Tabela de documentos bloqueados SCR

@author    Gerson Belini
@version   1.xx
@since     06/12/2019
/*/
//------------------------------------------------------------------------------------------
user function KsLibDoc()
	//--< variáveis >---------------------------------------------------------------------------
	
	//Indica a permissão ou não para a operação (pode-se utilizar 'ExecBlock')
	local cVldAlt := ".T." // Operacao: ALTERACAO
	local cVldExc := ".T." // Operacao: EXCLUSAO
	
	//trabalho/apoio
	local cAlias
	Local aIndex := {} 
	Local ca097User  := RetCodUsr()

	Local cFiltro  := 'CR_FILIAL=="'+xFilial("SCR")+'".And.CR_USER=="'+ca097User+'"'
	
	//--< procedimentos >-----------------------------------------------------------------------
	cAlias := "SCR"
	chkFile(cAlias)
	dbSelectArea(cAlias)
	//indices
	dbSetOrder(1)
	//Título a ser utilizado nas operações
	private cCadastro := "Liberação de Documentos"

	 
	Private bFiltraBrw := { || FilBrowse( "SCR" , @aIndex , @cFiltro ) } //Determina a Expressao do Filtro Private 
	
	Eval( bFiltraBrw ) //Efetiva o Filtro antes da Chamada a mBrowse 

	//--<  monta 'arotina' proprio >------------------------------------------------------------
	aRotina := {}
	AADD(aRotina,{"Pesquisar"  ,"PesqBrw" ,0,1})
	AADD(aRotina,{"Visualizar" ,"AxVisual",0,2})
	AADD(aRotina,{"Liberar"    ,"U_PxMerRede('POST')",0,4})
	AADD(aRotina,{"Consultar"  ,"U_PxMerRede('PUT')",0,4})
	dbSelectArea(cAlias)
	mBrowse( 6, 1, 22, 75, cAlias)
	
	EndFilBrw( "SCR" , @aIndex )
	
return
//--< fim de arquivo >----------------------------------------------------------------------


static function PXMercos(_aPar1)
	Local _nCtFil   := 0
	Local _aFilProc := {}
	Local lAuto     := .F.

	Private _aPar	:= _aPar1
	Private oJson
	Private _cGrpMarca := ""
	Private _aMarProc  := {}
	Private aHeader := {}
	Private aArqUpd := {}
	Private cUrlBase := ""

	_lHomologa  := .F.
	_aIpServer  := GetServerIP(.T.)
	For _nCount := 1 to Len(_aIpServer)
		if Len(_aIpServer[_nCount]) >= 4
			if AllTrim(_aIpServer[_nCount][4]) $ "10.8.86.36###10.8.86.35###10.8.86.45"
				_lHomologa := .T.
			endif
		endif
	Next _nCount

	if _lHomologa
		// Homologacao
		cUrlBase := "https://sandbox.mercos.com/api/v1"
		aadd(_aMarProc,{"PK","CompanyToken: 83afd724-d957-11e9-92d3-5e6e072873b5","ApplicationToken: 384f7e7e-0932-11e9-962d-26c247380a83"})
		aadd(_aMarProc,{"EL","CompanyToken: 82673064-d958-11e9-9953-8ec967b94a82","ApplicationToken: 384f7e7e-0932-11e9-962d-26c247380a83"})

	else
		// Producao
		cUrlBase := "https://app.mercos.com/api/v1"
		aadd(_aMarProc,{"PK","CompanyToken: ed8c6b86-9298-11e9-8476-023c0b98dbec","ApplicationToken: 6e3bd5b2-91d3-11e9-9c46-0a91e39ebfa8"})
		aadd(_aMarProc,{"EL","CompanyToken: 1591fa9c-9299-11e9-8d26-02f1851eb498","ApplicationToken: 6e3bd5b2-91d3-11e9-9c46-0a91e39ebfa8"})
	endif

	For _nCtGpMarca := 1 to Len(_aMarProc)
		aHeader := {}
		_cGrpMarca := _aMarProc[_nCtGpMarca][1]
		Aadd(aHeader, _aMarProc[_nCtGpMarca][2])
		Aadd(aHeader, _aMarProc[_nCtGpMarca][3])
		Aadd(aHeader, "Content-Type: application/json")
		if !lAuto
			PxMerFam()
		endif


	Next _nCtGpMarca

Return()


