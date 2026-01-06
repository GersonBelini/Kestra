#include "protheus.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณSA1SXB    บAutor  ณDonizete            บ Data ณ  03/07/06   บฑฑ
ฑฑAlterado                      ณMarcondes           บ Data ณ  13/03/09   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Por uma caracterํstica do sistema, pontos de entrada nใo   บฑฑ
ฑฑบ          ณ sใo disparados quando o usuแrio cadastra um item a partir  บฑฑ
ฑฑบ          ณ de um F3 (Cliente    por exemplo). Neste sentido temos que บฑฑ
ฑฑบ          ณ intervir neste processamento e chamar as duas rotinas, ca- บฑฑ
ฑฑบ          ณ dastro padrใo AXINCLUI e o ponto de entrada. Este programa บฑฑ
ฑฑบ          ณ deve ser colocado no SXB, no campo XB_CONTEM no XB_TIPO=3. บฑฑ
ฑฑบ          ณ Sintaxe da chamada #U_SA1SXB .                             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ No SXB, campo XB_CONTEM do registro XB_TIPO=="3".         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

User Function SA1SXB()
	If AxInclui("SA1",0,3) == 1 // O usuแrio incluiu o registro, neste caso o ponto de entrada deve ser executado.
		U_M030INC()
	EndIf
Return