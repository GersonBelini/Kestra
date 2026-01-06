#INCLUDE "TOTVS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³KSCusVlMov ºAutor  ³Gerson Belini      º Data ³  13/03/2018 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Verificar inconsistências nas movimentações de estoque.     ±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Kestra                                                     º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function KSSlEsDat()
	Local _cProduto    := ""
	Local _cLocal      := ""
	Local _dData       := stod('20191026')
	Local aSaldo       := {}
	Private _aProdutos := {}

	Carrega(@_aProdutos)

	_cArqLog := "D:\TMP\SALDOS_ESTOQUE_"+Substr(Dtos(dDataBase),7,2)+Substr(Dtos(dDataBase),5,2)+Substr(Dtos(dDataBase),1,4)+Substr(Time(),1,2)+Substr(Time(),4,2)+Substr(Time(),7,2)+".LOG"
	_nHandle  := 0
	_nHandle  := fCreate(_cArqLog,0)
	fClose(_nHandle)
	_nHandle := fOpen(_cArqLog,2)
	FWrite(_nHandle,"FILIAL;CODIGO;LOCAL;DATA;QUANTIDADE;TOTAL;CUSTO;"+CHR(13)+CHR(10))

	For _nCount := 1 to Len(_aProdutos)
		_cProduto := _aProdutos[_nCount][1]
		DbSelectArea("SB2")
		DbSetOrder(1)
		DbSeek(xFilial("SB2")+_cProduto)
		While !Eof() .and. SB2->B2_FILIAL == xFilial("SB2").and. AllTrim(SB2->B2_COD) == AllTrim(_cProduto)
			aSaldo := CalcEst( SB2->B2_COD,SB2->B2_LOCAL,_dDAta,SB2->B2_FILIAL )
			_cBuffers := ""
			_cBuffers += AllTrim(SB2->B2_FILIAL)+";"
			_cBuffers += AllTrim(SB2->B2_COD)+";"
			_cBuffers += AllTrim(SB2->B2_LOCAL)+";"
			_cBuffers += AllTrim(dtoc(_dData))+";"
			_cBuffers += AllTrim(cValToChar(aSaldo[1]))+";"
			_cBuffers += AllTrim(cValToChar(aSaldo[2]))+";"
			_cBuffers += AllTrim(cValToChar(aSaldo[8]))+";"
			_cBuffers += CHR(13)+CHR(10)
			FWrite(_nHandle,_cBuffers)
			DbSelectArea("SB2")
			DbSkip()
		End
	Next _nCount
	fClose(_nHandle)
Return()

Static Function Carrega(_aProdutos)

	AADD(_aProdutos,{'50500352'})
	AADD(_aProdutos,{'10900220'})
	AADD(_aProdutos,{'83830183'})
	AADD(_aProdutos,{'50500611'})
	AADD(_aProdutos,{'10900239'})
	AADD(_aProdutos,{'83830446'})
	AADD(_aProdutos,{'50501570'})
	AADD(_aProdutos,{'50508728'})
	AADD(_aProdutos,{'50501775'})
	AADD(_aProdutos,{'50501776'})
	AADD(_aProdutos,{'50503336'})
	AADD(_aProdutos,{'83830805'})
	AADD(_aProdutos,{'50503415'})
	AADD(_aProdutos,{'10900081'})
	AADD(_aProdutos,{'83830110'})
	AADD(_aProdutos,{'50503510'})
	AADD(_aProdutos,{'10900263'})
	AADD(_aProdutos,{'83830463'})
	AADD(_aProdutos,{'50503810'})
	AADD(_aProdutos,{'50505181'})
	AADD(_aProdutos,{'50506722'})
	AADD(_aProdutos,{'83830887'})
	AADD(_aProdutos,{'50507081'})
	AADD(_aProdutos,{'10900181'})
	AADD(_aProdutos,{'83830354'})
	AADD(_aProdutos,{'50507582'})
	AADD(_aProdutos,{'83831522'})
	AADD(_aProdutos,{'50508338'})
	AADD(_aProdutos,{'10900210'})
	AADD(_aProdutos,{'83831217'})
	AADD(_aProdutos,{'50508340'})
	AADD(_aProdutos,{'10900218'})
	AADD(_aProdutos,{'83831219'})
	AADD(_aProdutos,{'50508342'})
	AADD(_aProdutos,{'10900216'})
	AADD(_aProdutos,{'83830346'})
	AADD(_aProdutos,{'50508347'})
	AADD(_aProdutos,{'10900212'})
	AADD(_aProdutos,{'83831227'})
	AADD(_aProdutos,{'50508642'})
	AADD(_aProdutos,{'10900205'})
	AADD(_aProdutos,{'83831222'})
	AADD(_aProdutos,{'83830110'})
	AADD(_aProdutos,{'10900081'})
	AADD(_aProdutos,{'50503415'})
	AADD(_aProdutos,{'83830152'})
	AADD(_aProdutos,{'10900112'})
	AADD(_aProdutos,{'50503433'})
	AADD(_aProdutos,{'83830166'})
	AADD(_aProdutos,{'10900106'})
	AADD(_aProdutos,{'50503508'})
	AADD(_aProdutos,{'83830340'})
	AADD(_aProdutos,{'10900185'})
	AADD(_aProdutos,{'83830363'})
	AADD(_aProdutos,{'10900183'})
	AADD(_aProdutos,{'83830371'})
	AADD(_aProdutos,{'10900158'})
	AADD(_aProdutos,{'83830402'})
	AADD(_aProdutos,{'10900166'})
	AADD(_aProdutos,{'83830408'})
	AADD(_aProdutos,{'10900201'})
	AADD(_aProdutos,{'83830409'})
	AADD(_aProdutos,{'10900202'})
	AADD(_aProdutos,{'83830412'})
	AADD(_aProdutos,{'10900079'})
	AADD(_aProdutos,{'83830766'})
	AADD(_aProdutos,{'10900527'})
	AADD(_aProdutos,{'83830870'})
	AADD(_aProdutos,{'10900157'})
	AADD(_aProdutos,{'83830879'})
	AADD(_aProdutos,{'10900667'})
	AADD(_aProdutos,{'83831330'})
	AADD(_aProdutos,{'10900272'})
	AADD(_aProdutos,{'83831386'})
	AADD(_aProdutos,{'10900173'})
	AADD(_aProdutos,{'83831393'})
	AADD(_aProdutos,{'10900198'})

Return()