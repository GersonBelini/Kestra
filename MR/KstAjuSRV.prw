#INCLUDE "TOTVS.CH"

User Function KstAjuSRV()

	Local aVetor := {}
	PRIVATE _aVerbas := {}
	PRIVATE lMsErroAuto := .F.
	PRIVATE _cQuery := ""

	KsCarga(@_aVerbas)

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	// Abertura do ambiente
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	// Função para duplicar verbas, devido a mudanças no e-social em 16/05/2018
	// Gerson Belini
	ConOut(Repl("-",80))
	ConOut(PadC(OemToAnsi("Inclusão de verbas da folha"),80))
	//PREPARE ENVIRONMENT EMPRESA '99' FILIAL '01' USER 'Administrador' PASSWORD '' MODULO "EST" TABLES "SB7"
	For _nCount := 1 to Len(_aVerbas)
		DbSelectArea('SRV')
		DbSetOrder(2)
		if !MsSeek(SRV->RV_FILIAL+_aVerbas[_nCount][2])
			DbSetOrder(2)
			if MsSeek(SRV->RV_FILIAL+_aVerbas[_nCount][1])
				_cQuery := ""
				aStruSRV  := ("SRV")->(dbStruct())
				aEval(aStruSRV,{|x| _cQuery += ","+AllTrim(x[1])})

				_cQuery := "SELECT "+SubStr(_cQuery,2)
				_cQuery += " FROM "
				_cQuery += RetSqlName("SRV")+" SRV "
				_cQuery += " WHERE SRV.D_E_L_E_T_ = ' '"
				_cQuery += " AND SRV.RV_FILIAL = '"+SRV->RV_FILIAL+"'"
				_cQuery += " AND SRV.RV_CODFOL = '"+SRV->RV_CODFOL+"'"
				_cQuery += " ORDER BY SRV.RV_FILIAL,SRV.RV_CODFOL"
				_cQuery := ChangeQuery(_cQuery)
				DbUseArea(.T., "TOPCONN", TCGENQRY(,,_cQuery), 'TRT', .F., .T.)
				For nX :=  1 To Len(aStruSRV)
					If aStruSRV[nX][2] <> "C"
						TcSetField("TRT",aStruSRV[nX][1],aStruSRV[nX][2],aStruSRV[nX][3],aStruSRV[nX][4])
					EndIf
				Next nX
				// Verificar a última verba e adicionar 1
				DbSelectArea("SRV")
				DbSetOrder(1)
				DbGoBottom()
				//Dbskip(-1)
				if Substr(SRV->RV_COD,2,2) == '99'
					_cCodVerba := Soma1(Substr(SRV->RV_COD,1,1))+'01'
				else
					_cCodVerba := Substr(SRV->RV_COD,1,1)+Soma1(Substr(SRV->RV_COD,2,2))
				endif
				DbSelectArea("TRT")
				while !Eof()
					RecLock("SRV",.T.)
					dbSelectArea("TRT")
					For I := 1 to fCount()
						_cCampoO  := "TRT->"+Alltrim(FieldName(I))
						_cCampoD  := "SRV->"+Alltrim(FieldName(I))
						if Alltrim(FieldName(I)) == "RV_COD"
							SRV->RV_COD := _cCodVerba
						elseif Alltrim(FieldName(I)) == "RV_CODFOL"
							SRV->RV_CODFOL := _aVerbas[_nCount][2]
						elseif Alltrim(FieldName(I)) == "RV_DESC"
							SRV->RV_DESC := _aVerbas[_nCount][3]
						elseif Alltrim(FieldName(I)) == "RV_DESCDET"
							SRV->RV_DESCDET := _aVerbas[_nCount][3]
						else
							&_cCampoD := &_cCampoO
						endif
					Next
					MsUnLock("SRV")
					DbSelectArea("TRT")
					DbSkip()
				End
				DbSelectArea("TRT")
				DbCloseArea("TRT")
			endif
		endif
	Next
Return Nil

Static Function KsCarga(_aVerbas)

AADD(_aVerbas,{'0024','0123','Total de Medias em Valor'})
AADD(_aVerbas,{'0024','0124','Total de Medias em Horas'})
AADD(_aVerbas,{'0074','0205','Abono Mes Seguinte'})
AADD(_aVerbas,{'0074','0206','1/3 Abono Mes. Seg.'})
AADD(_aVerbas,{'0074','0207','Dif. Abono Mes. Seg.'})
AADD(_aVerbas,{'0074','0208','Dif. 1/3 Abono Mes. Seg.'})
AADD(_aVerbas,{'0074','0622','Media Horas sobre Abono'})
AADD(_aVerbas,{'0074','0623','Media Valor sobre Abono'})
AADD(_aVerbas,{'0125','0625','1/3 Ferias Proporcionais Rescisão'})
AADD(_aVerbas,{'0074','0633','Media Horas sobre Abono Mes seguinte'})
AADD(_aVerbas,{'0074','0634','Media valor sobre Abono Mes seguinte'})
AADD(_aVerbas,{'0024','1288','ATS 13. Salário'})
AADD(_aVerbas,{'0024','1289','ATS 13. Salário sobre verbas'})
AADD(_aVerbas,{'0024','1290','Periculosidade 13. Salario'})
AADD(_aVerbas,{'0024','1291','Periculosidade 13. Salario sobre verbas'})
AADD(_aVerbas,{'0024','1292','Insalubridade 13. Salario'})
AADD(_aVerbas,{'0024','1293','Insalubridade 13. Salario sobre verbas'})
AADD(_aVerbas,{'0024','1294','Adicional Cargo de Confiança 13.Salário'})
AADD(_aVerbas,{'0024','1295','Adicional Transferencia 13.Salário'})
AADD(_aVerbas,{'0072','1296','ATS Férias Mes'})
AADD(_aVerbas,{'0073','1297','ATS Férias Mês Seguinte'})
AADD(_aVerbas,{'0072','1298','ATS Férias Mês s/verbas'})
AADD(_aVerbas,{'0073','1299','ATS Férias Mês Seg. s/verbas'})
AADD(_aVerbas,{'0072','1300','Periculosidade Férias Mês'})
AADD(_aVerbas,{'0073','1301','Periculosidade Férias Mês Seg.'})
AADD(_aVerbas,{'0072','1302','Periculosidade Férias Mês s/verbas'})
AADD(_aVerbas,{'0073','1303','Periculosidade Férias Mês Seg. s/verbas'})
AADD(_aVerbas,{'0072','1304','Insalubridade Férias Mês'})
AADD(_aVerbas,{'0073','1305','Insalubridade Férias Mês Seg.'})
AADD(_aVerbas,{'0072','1306','Insalubridade Férias Mês s/verbas'})
AADD(_aVerbas,{'0073','1307','Insalubridade Férias Mês Seg. s/verbas'})
AADD(_aVerbas,{'0072','1308','Adic. Cargo Confiança Férias Mes'})
AADD(_aVerbas,{'0073','1309','Adic Cargo Confiança Férias Mês Seg.'})
AADD(_aVerbas,{'0072','1310','Adic. Transferencia Férias Mes'})
AADD(_aVerbas,{'0073','1311','Adic. Transferencia Férias Mês Seg.'})
AADD(_aVerbas,{'0074','1312','ATS Abono Mes'})
AADD(_aVerbas,{'0074','1313','ATS Abono Mês Seg.'})
AADD(_aVerbas,{'0074','1314','ATS Abono Mês s/verbas'})
AADD(_aVerbas,{'0074','1315','ATS Abono Mês Seg. s/verbas'})
AADD(_aVerbas,{'0074','1316','Periculosidade Abono Mês'})
AADD(_aVerbas,{'0074','1317','Periculosidade Abono Mês Seg'})
AADD(_aVerbas,{'0074','1318','Periculosidade Abono Mês s/verbas'})
AADD(_aVerbas,{'0074','1319','Periculosidade Abono Mês Seg. s/verbas'})
AADD(_aVerbas,{'0074','1320','Insalubridade Abono Mês'})
AADD(_aVerbas,{'0074','1321','Insalubridade Abono Mês Seg'})
AADD(_aVerbas,{'0074','1322','Insalubridade Abono Mês s/verbas'})
AADD(_aVerbas,{'0074','1323','Insalubridade Abono Mês Seg. s/verbas'})
AADD(_aVerbas,{'0074','1324','Adic. Cargo Confiança Abonos Mes'})
AADD(_aVerbas,{'0074','1325','Adic. Cargo Confiança Abono Mês Seg.'})
AADD(_aVerbas,{'0074','1326','Adic. Transferencia Abono Mes'})
AADD(_aVerbas,{'0074','1327','Adic. Transferencia Abono Mês Seg.'})
AADD(_aVerbas,{'0287','1420','Valor de afastamento por doença pago pela Previdência'})
AADD(_aVerbas,{'0217','1430','Pro-Labore - Diretores não empregados'})
AADD(_aVerbas,{'0217','1431','Pro-Labore - Proprietários ou sócios'})
AADD(_aVerbas,{'0287','1432','Valor de afastamento por acidente pago pela Previdência'})
AADD(_aVerbas,{'0287','1433','Valor de remuneração a que teria direito (Serviço Militar)'})
AADD(_aVerbas,{'0022','1434','1ª Parc. 13º Sal. Maternidade'})
AADD(_aVerbas,{'0024','1435','Parcela Final 13º Sal Maternidade'})
AADD(_aVerbas,{'0024','1436','Total de Medias em Valor Maternidade'})
AADD(_aVerbas,{'0024','1437','Total de Medias em Horas Maternidade'})
AADD(_aVerbas,{'0024','1438','ATS 13. Salário Maternidade'})
AADD(_aVerbas,{'0024','1439','ATS 13. Salário sobre verbas Maternidade'})
AADD(_aVerbas,{'0024','1440','Periculosidade 13. Salario Maternidade'})
AADD(_aVerbas,{'0024','1441','Periculosidade 13. Salario sobre verbas Maternidade'})
AADD(_aVerbas,{'0024','1442','Insalubridade 13. Salario Maternidade'})
AADD(_aVerbas,{'0024','1443','Insalubridade 13. Salario sobre verbas Maternidade'})
AADD(_aVerbas,{'0024','1444','Adicional Cargo de Confiança 13.Salário Maternidade'})
AADD(_aVerbas,{'0024','1445','Adicional Transferencia 13.Salário Maternidade'})
AADD(_aVerbas,{'0114','1446','13º na Indenizacao Rescisao Maternidade'})
AADD(_aVerbas,{'0251','1447','Media 13º Salario Rescisao Maternidade'})
AADD(_aVerbas,{'0218','1448','Autonomo cooperado'})
AADD(_aVerbas,{'0164','1449','Abonos Pagos Mes Anterior'})
AADD(_aVerbas,{'0074','1450','Dif. Adic. sobre Abono Mes'})
AADD(_aVerbas,{'0074','1451','Dif. Adic. sobre Abono Mes Seg.'})
AADD(_aVerbas,{'0022','1628','1a. Parc.Total Medias em Valor'})
AADD(_aVerbas,{'0022','1629','1a. Parc.Total Medias em Horas'})
AADD(_aVerbas,{'0022','1630','1a. Parc.ATS 13.salario'})
AADD(_aVerbas,{'0022','1631','1a. Parc.ATS 13.salario sobre verbas'})
AADD(_aVerbas,{'0022','1632','1a. Parc.Periculosidade 13.salario'})
AADD(_aVerbas,{'0022','1633','1a. Parc.Periculosidade 13.salario sobre verbas'})
AADD(_aVerbas,{'0022','1634','1a. Parc.Insalubridade 13.salario'})
AADD(_aVerbas,{'0022','1635','1a. Parc.Insalubridade 13.salario sobre verbas'})
AADD(_aVerbas,{'0022','1636','1a. Parc.Adicional Cargo de Confianca 13.salario'})
AADD(_aVerbas,{'0022','1637','1a. Parc.Adicional Transferencia 13.salario'})
AADD(_aVerbas,{'0022','1649','1a. Parc.Pagto Peric.S/Medias 13.salario'})
AADD(_aVerbas,{'0022','1650','1a. Parc.Pagto Insal.S/Medias 13.salario'})


Return(NIL)