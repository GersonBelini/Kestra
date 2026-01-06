#Include "totvs.ch"

User Function M710BUT

Local aRet := {}

aadd(aRet ,{'CONSUMO',{|| MaComViewSM(SB1->B1_COD) }, "Consumos médios"})

Return aRet