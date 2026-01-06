#include "totvs.ch"

User Function MT680GREST()

Local cMod	:= ""
Local i := 0

Private cModCif := ""

aCCCif := u_GetCCCif( AprModRec( SH6->H6_RECURSO ) )

For i:= 1 To Len(aCCCif)
	cModCif := aCCCif[i]
	cMod:=APrModRec(SH6->H6_RECURSO)
	SD3->(dbSetOrder(1))
	SD3->(dbSeek(xFilial("SD3")+SH6->H6_OP+cMod))
	While SD3->(!EOF()) .And. SD3->D3_FILIAL+SD3->D3_OP+AllTrim(SD3->D3_COD) == xFilial("SD3")+SH6->H6_OP+AllTrim(cMod)
		If SD3->D3_IDENT == SH6->H6_IDENT
			a240DesAtu()
			Exit
		EndIf
		SD3->(dbSkip())
	EndDo
Next

Return