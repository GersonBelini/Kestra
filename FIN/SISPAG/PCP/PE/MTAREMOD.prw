#include "totvs.ch"

User Function MTAREMOD()

Local cRecurso := PARAMIXB[1]
Local cMod := ""
Local cModInd := ""

If Type("cModCif") == "C"
	cModInd := cModCif
Endif

If !Empty(cModInd)
	cMod	:= "MOD" + cModInd
Else
	cMod	:= "MOD"+Posicione("SH1",1,xFilial("SH1") + cRecurso, "H1_CCUSTO")
Endif

Return cMod