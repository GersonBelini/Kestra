#include "totvs.ch"

User Function MA261LIN

Local lRet 			:= .T.
Local nLin			:= PARAMIXB[1]
Local nPosProdOri	:= aScan(aHeader, {|x| x[2] == "D3_COD" } )
Local nPosProdDest	:= aScan(aHeader, {|x| x[2] == "D3_COD" }, nPosProdOri+1 )
Local nPosLoteOri	:= aScan(aHeader, {|x| x[2] == "D3_LOTECTL" } )
Local nPosLoteDest	:= aScan(aHeader, {|x| x[2] == "D3_LOTECTL" }, nPosLoteOri+1 )
Local cCodUser		:= RetCodUsr()
Local aGrupos		:= UsrRetGrp(,cCodUser)
Local cUserOK		:= GetMV("ZZ_USERTRA",,"000000/000005") // Admin e TOTVS
Local lGrpAdmin		:= .F.
Local nX			:= 0

If Len(aGrupos) >= 1
	For nX := 1 To Len(aGrupos)
		If aGrupos[nX] == "000000"
			lGrpAdmin := .T.
		Endif
	Next nX
Endif

If !(cCodUser $ cUserOK .or. lGrpAdmin)
	If aCols[nLin, nPosProdOri] <> aCols[nLin, nPosProdDest] .or. Iif(!Empty(aCols[nLin, nPosLoteDest]), aCols[nLin, nPosLoteOri] <> aCols[nLin, nPosLoteDest], .F. )
		lRet := .F.
		MsgStop("Usuário não autorizado a realizar transferência entre produtos e/ou lotes diferentes." + CRLF + CRLF + "[Parâmetro ZZ_USERTRA]" )
	Endif
Endif

If lRet
	lRet := u_validMov(RetCodUsr(),aCols[N,GdFieldPos("D3_LOCAL")])		
EndIf
Return lRet