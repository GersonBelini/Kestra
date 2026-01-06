#INCLUDE "totvs.ch"

User Function A680MOD

Local nQtdRet	:= PARAMIXB

If SH1->H1_ZZFORNO == "S"
	nQtdRet := SH6->H6_QTDPROD
Endif

Return nQtdRet