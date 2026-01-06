#include "totvs.ch"

User function getCCCif(cCodigo)

Local aRet := {}
Local cCod := strTran(cCodigo,"MOD","")

ZZ3->(dbSetOrder(1))
If ZZ3->( dbSeek(xFilial("ZZ3")+cCod ))
	While ZZ3->ZZ3_CCDIR == cCod
		aAdd(aRet, ZZ3->ZZ3_CCCIF)
		ZZ3->(dbSkip())
	EndDo
Endif

return aRet
