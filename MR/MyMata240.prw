#INCLUDE "TOTVS.CH"

User Function MyMata240()

	Local aVetor := {}
	PRIVATE aInvent := {}
	PRIVATE lMsErroAuto := .F.

	_cArq := CriaTrab(NIL, .F.)
	if !ExistDir("\Mov_Interno")
		MakeDir("\Mov_Interno")
	endif
	_cArq := "\Mov_Interno\Mov_Interno_"+AllTrim(_cArq)+".txt"
	//_cArq := "D:\TMP\SH\Mov_Interno_"+AllTrim(_cArq)+".txt"
	_nHandle := fCreate(_cArq,0)
	_cBuffers := "PRODUTO;LOCAL;LOTE;LOCALIZACAO;OBSERVACAO;"+CHR(13)+CHR(10)
	FWrite(_nHandle,_cBuffers)

	KsCarga(@aInvent)


	*/
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	// Abertura do ambiente
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	ConOut(Repl("-",80))
	ConOut(PadC(OemToAnsi(" Inclusao de Mov_Interno MATA270"),80))
	//PREPARE ENVIRONMENT EMPRESA '99' FILIAL '01' USER 'Administrador' PASSWORD '' MODULO "EST" TABLES "SB7"
	For _nCount := 1 to Len(aInvent)

		lMsErroAuto := .F.

		// Verificar se o registro já foi carregado
		_cFilial  := xFilial("SD3")
		_cCod     := AllTrim(aInvent[_nCount][2])+Replicate(" ",TamSx3("D3_COD")[1]-Len(AllTrim(aInvent[_nCount][2])))
		_cDoc     := 'AJUSTE'
		_cLocal   := AllTrim(aInvent[_nCount][1])+Replicate(" ",TamSx3("D3_LOCAL")[1]-Len(AllTrim(aInvent[_nCount][1])))
		_dData    := stod('20191031')
		_nValor   := aInvent[_nCount][3]
		cCCusto   := '999999'
		cTPMovimento := '101'

		DbSelectArea("SB1")
		DbSetOrder(1)
		DbSeek(xFilial("SB1")+_cCod)
		DbSelectArea("SB2")
		Dbsetorder(1)
		if DbSeek(xFilial("SB2")+_cCod+_cLocal)

			PARAMIXB1   := {}
			PARAMIXB2   := 3
			lMsErroAuto := .F.
			Begin Transaction
				ExpA1 := {}
				ExpN2 := 3
				aadd(ExpA1,{"D3_TM",'101',})
				aadd(ExpA1,{"D3_COD",_cCod,})
				aadd(ExpA1,{"D3_UM",SB1->B1_UM,})
				aadd(ExpA1,{"D3_LOCAL",_cLocal,})
				aadd(ExpA1,{"D3_CUSTO1",_nValor,})
				aadd(ExpA1,{"D3_EMISSAO",_dData,})
				aadd(ExpA1,{"D3_CC",cCCusto,})
				MSExecAuto({|x,y| mata240(x,y)},ExpA1,ExpN2)
				If !lMsErroAuto
					ConOut("Incluido com sucesso! "+cTPMovimento)
				Else
					MostraErro()
					ConOut("Erro na inclusao!")
				EndIf
				ConOut("Fim  : "+Time())
			End Transaction
		end

	Next
	fClose(_nHandle)
Return Nil

Static Function KsCarga(aInvent)

AADD(aInvent,{'05','50503943',0.01})
AADD(aInvent,{'05','50503944',0.01})
AADD(aInvent,{'05','50503962',0.01})
AADD(aInvent,{'05','50503963',0.01})
AADD(aInvent,{'05','50503964',0.01})
AADD(aInvent,{'05','50503965',0.01})
AADD(aInvent,{'05','50503966',0.01})
AADD(aInvent,{'05','50503967',0.01})
AADD(aInvent,{'05','50503968',0.01})
AADD(aInvent,{'05','50503969',0.01})
AADD(aInvent,{'05','50503970',0.01})
AADD(aInvent,{'05','50503971',0.01})
AADD(aInvent,{'05','50504034',0.01})
AADD(aInvent,{'05','50504580',0.01})
AADD(aInvent,{'05','50504632',0.01})
AADD(aInvent,{'05','50504695',0.01})
AADD(aInvent,{'05','50504833',0.01})
AADD(aInvent,{'05','50505073',0.01})
AADD(aInvent,{'05','50505245',0.01})
AADD(aInvent,{'05','50505638',0.01})
AADD(aInvent,{'05','50505776',0.01})
AADD(aInvent,{'05','50505799',0.01})
AADD(aInvent,{'05','50505947',0.01})
AADD(aInvent,{'05','50505973',0.01})
AADD(aInvent,{'05','50506404',0.01})
AADD(aInvent,{'05','50506418',0.01})
AADD(aInvent,{'05','50506513',0.01})
AADD(aInvent,{'05','50506536',0.01})
AADD(aInvent,{'05','50506538',0.01})
AADD(aInvent,{'05','50506722',0.01})
AADD(aInvent,{'05','50506840',0.01})
AADD(aInvent,{'05','50506941',0.01})
AADD(aInvent,{'05','50507081',0.01})
AADD(aInvent,{'05','50507119',0.01})
AADD(aInvent,{'05','50507212',0.01})
AADD(aInvent,{'05','50507457',0.01})
AADD(aInvent,{'05','50507582',0.01})
AADD(aInvent,{'05','50508505',0.01})
AADD(aInvent,{'05','50509145',0.01})
AADD(aInvent,{'05','50509146',0.01})
AADD(aInvent,{'05','83830254',0.01})
AADD(aInvent,{'05','83830255',0.01})
AADD(aInvent,{'05','83830256',0.01})
AADD(aInvent,{'05','83830340',0.01})
AADD(aInvent,{'05','83830363',0.01})
AADD(aInvent,{'05','83830371',0.01})
AADD(aInvent,{'05','83830412',0.01})
AADD(aInvent,{'05','83830680',0.01})
AADD(aInvent,{'05','83830742',0.01})
AADD(aInvent,{'05','83830749',0.01})
AADD(aInvent,{'05','83830762',0.01})
AADD(aInvent,{'05','83830763',0.01})
AADD(aInvent,{'05','83830766',0.01})
AADD(aInvent,{'05','83830779',0.01})
AADD(aInvent,{'05','83830780',0.01})
AADD(aInvent,{'05','83830863',0.01})
AADD(aInvent,{'05','83830864',0.01})
AADD(aInvent,{'05','83830866',0.01})
AADD(aInvent,{'05','83830867',0.01})
AADD(aInvent,{'05','83830868',0.01})
AADD(aInvent,{'05','83830869',0.01})
AADD(aInvent,{'05','83830871',0.01})
AADD(aInvent,{'05','83830872',0.01})
AADD(aInvent,{'05','83830873',0.01})
AADD(aInvent,{'05','83830876',0.01})
AADD(aInvent,{'05','83830877',0.01})
AADD(aInvent,{'05','83830878',0.01})
AADD(aInvent,{'05','83830879',0.01})
AADD(aInvent,{'05','83830880',0.01})
AADD(aInvent,{'05','83830881',0.01})
AADD(aInvent,{'05','83830882',0.01})
AADD(aInvent,{'05','83830883',0.01})
AADD(aInvent,{'05','83830884',0.01})
AADD(aInvent,{'05','83830885',0.01})
AADD(aInvent,{'05','83830886',0.01})
AADD(aInvent,{'05','83830888',0.01})
AADD(aInvent,{'05','83830889',0.01})
AADD(aInvent,{'05','83830890',0.01})
AADD(aInvent,{'05','83830891',0.01})
AADD(aInvent,{'05','83830892',0.01})
AADD(aInvent,{'05','83830893',0.01})
AADD(aInvent,{'05','83830894',0.01})
AADD(aInvent,{'05','83830895',0.01})
AADD(aInvent,{'05','83830896',0.01})
AADD(aInvent,{'05','83830898',0.01})
AADD(aInvent,{'05','83830899',0.01})
AADD(aInvent,{'05','83830900',0.01})
AADD(aInvent,{'05','83830902',0.01})
AADD(aInvent,{'05','83830903',0.01})
AADD(aInvent,{'05','83830904',0.01})
AADD(aInvent,{'05','83830911',0.01})
AADD(aInvent,{'05','83830912',0.01})
AADD(aInvent,{'05','83830913',0.01})
AADD(aInvent,{'05','83831330',0.01})
AADD(aInvent,{'05','83831386',0.01})
AADD(aInvent,{'05','83831393',0.01})
AADD(aInvent,{'05','83830870',0.15})
AADD(aInvent,{'05','50500611',0.42})
AADD(aInvent,{'05','50507081',0.42})
AADD(aInvent,{'05','83830402',1.76})
AADD(aInvent,{'05','50501775',2.46})
AADD(aInvent,{'05','50508340',3.77})
AADD(aInvent,{'05','50500352',4.93})
AADD(aInvent,{'05','50503810',13.05})
AADD(aInvent,{'05','50508347',38.59})
AADD(aInvent,{'05','83830152',45.95})
AADD(aInvent,{'05','50503510',46.72})
AADD(aInvent,{'05','83830166',53.82})
AADD(aInvent,{'05','50508642',54.56})
AADD(aInvent,{'05','83830409',55.11})
AADD(aInvent,{'05','83830408',55.11})
AADD(aInvent,{'05','50508342',72.17})
AADD(aInvent,{'05','50508338',87.3})
AADD(aInvent,{'05','50503415',107.89})
AADD(aInvent,{'05','83830110',107.89})
AADD(aInvent,{'05','50509388',1427.15})

Return(NIL)