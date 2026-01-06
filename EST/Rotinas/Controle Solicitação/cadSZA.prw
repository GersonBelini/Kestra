#Include "Rwmake.ch"
#Include "TopConn.ch"
#Include 'FWMVCDEF.CH'
#Include 'Protheus.ch'

#DEFINE CAMPOSCAB 'ZA_FILIAL|ZA_CODUSR|ZA_NOMEUSR|'

User Function cadSZA()

	Local oBrowse

	oBrowse := FWMBrowse():New()
	oBrowse:SetDescription( "Usuario x Centro de Custo" )
	oBrowse:SetAlias( 'SZA' )
	oBrowse:Activate()

Return NIL

/****************************************************************************************************************************************************
&& MenuDef
****************************************************************************************************************************************************/
Static Function MenuDef()
	Local aRotina := {}

	ADD OPTION aRotina TITLE 'Visualizar' ACTION 'VIEWDEF.cadSZA' OPERATION 2 ACCESS 0
	ADD OPTION aRotina TITLE 'Incluir'    ACTION 'VIEWDEF.cadSZA' OPERATION 3 ACCESS 0
	ADD OPTION aRotina TITLE 'Alterar'    ACTION 'VIEWDEF.cadSZA' OPERATION 4 ACCESS 0
	ADD OPTION aRotina TITLE 'Excluir'    ACTION 'VIEWDEF.cadSZA' OPERATION 5 ACCESS 0

Return aRotina

/****************************************************************************************************************************************************
&& ViewDef
****************************************************************************************************************************************************/
Static Function ViewDef()
	Local oView
	Local oModel     := FWLoadModel( 'cadSZA' )
	Local oStructCab := FWFormStruct( 2, 'SZA',   { | cCampo |  AllTrim( cCampo ) + '|' $ CAMPOSCAB })
	Local oStructGri := FWFormStruct( 2, 'SZA',   { | cCampo |  !AllTrim( cCampo ) + '|' $ CAMPOSCAB })

	oView := FWFormView():New()
	oView:SetModel( oModel )
	oView:AddField( 'CPM001_CAB' , oStructCab, 'SZAMASTER'  )
	oView:AddGrid(  'CPM001_ITEM', oStructGri, 'SZADETAIL'  )
	
	//Campo Incremental do grid
	//oView:AddIncrementField( 'CPM001_ITEM', 'ZA8_ITEM'  )

	oView:CreateHorizontalBox( 'MASTER', 10 )
	oView:CreateHorizontalBox( 'DETAIL', 90 )

	oView:SetOwnerView( 'CPM001_CAB' , 'MASTER' )
	oView:SetOwnerView( 'CPM001_ITEM', 'DETAIL' )

Return oView

/****************************************************************************************************************************************************
&& ModelDef
****************************************************************************************************************************************************/
Static Function Modeldef()
	Local oModel     := NIL
	// Cria a estrutura a ser usada no Modelo de Dados
	Local oStructCab := FWFormStruct( 1, 'SZA',  { | cCampo |  AllTrim( cCampo ) + '|' $ CAMPOSCAB })
	Local oStructGri := FWFormStruct( 1, 'SZA',/*  { | cCampo |  !AllTrim( cCampo ) + '|' $ CAMPOSCAB }*/)

	// Cria o objeto do Modelo de Dados	com pos validação do modelo
	oModel := MPFormModel():New( 'CPM123',, )

	// Adiciona ao modelo uma estrutura de formulário de edição por campo
	oModel:AddFields( 'SZAMASTER', NIL, oStructCab,, )

	// Adiciona ao modelo uma estrutura de formulário de edição por grid 
	oModel:AddGrid( 'SZADETAIL', 'SZAMASTER' /*cOwner*/, oStructGri, /*bLinePre*/,/*bLinePos*/, /*bPreVal*/, /*bPosVal*/ )

	// Adiciona a descricao do Modelo de Dados
	oModel:SetDescription( "Usuario x Centro de Custo" )
 
	// Adiciona a descricao do Componente do Modelo de Dados
	oModel:GetModel( 'SZAMASTER' ):SetDescription( "Usuario" )
	oModel:GetModel( 'SZADETAIL' ):SetDescription( "Centro de Custo" )
 
	// Liga o controle de nao repeticao de linha
	oModel:GetModel( 'SZADETAIL' ):SetUniqueLine( { 'ZA_CC' } )

	// Faz relaciomaneto entre os compomentes do model
	
	oModel:SetRelation('SZADETAIL', { { 'ZA_FILIAL', "xFilial( 'SZA' )" }, { 'ZA_CODUSR', 'ZA_CODUSR' } }, SZA->(IndexKey(1)) )

	//Chave Primaria
	oModel:SetPrimaryKey( {} )

Return oModel
