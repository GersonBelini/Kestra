#INCLUDE "totvs.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMT241TOK  บ Autor ณ ANTONIO SANTOS     บ Data ณ  17/10/11   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ VALIDACAO ORBIGA USUARIO INFORMAR NO. OP OU NO. CC         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ MOVIMENTOS INTERNOS                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function MT241TOK()
	Local nI		:= 0
	Local nPosNumOP	:= 	aScan(aHeader, {|x| AllTrim(Upper(x[2])) == "D3_OP"})
	Local nPosConta	:= 	aScan(aHeader, {|x| AllTrim(Upper(x[2])) == "D3_CONTA"})
	Local lRet		:= .T.
	Local lCCtp 	:= Alltrim(Posicione("CTT",1,xFilial("CTT") + cCC, "CTT_CRGNV1"))

	if lCCtp == "D"
		alert("Aten็ใo," + CRLF + CRLF + 'Centro de Custo ' + cCC + ' DIRETO ' + CRLF + ' nใo pode ter requisi็ใo.' + CRLF + 'Verifique!')
		lRet = .F.
	Endif	
	
	for nI := 1 to len(aCols)
		if empty(cCC)
			if empty(aCols[nI, nPosNumOP])						// Os dois campos vazios nao podem.
				alert("Aten็ใo," + CRLF + CRLF + 'Informar Centro de Custos ou OP.' + CRLF + 'Verifique!')
				lRet := .F.
				Exit
			endIf
		else
			if !Empty(aCols[nI, nPosNumOP])						// Os dois campos preenchidos nao podem.
				alert("Aten็ใo," + CRLF + CRLF + 'Informar Centro de Custos ou OP.' + CRLF + 'Verifique!')
				lRet := .F.
				Exit
			endIf			
		endIf
	next nI
Return(lRet)
