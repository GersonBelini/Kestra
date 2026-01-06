#include "rwmake.ch"
#include "Protheus.ch"

// #########################################################################################
// Projeto: Kestra - Gravacao adicional em documentos de entrada
// Modulo : Sigacom
// Fonte  : PE_MT103FIM.PRW
// ----------+-------------------+-----------------------------------------------------------
// Data      | Autor             | Descricao
// ----------+-------------------+-----------------------------------------------------------
// 30/07/2021| Gerson Belini     | Gravação de vendedor no título NCC gerado por devolução de
//           |                   | vendas
// ----------+-------------------+-----------------------------------------------------------
//GB Consultoria|
// Descrição:
// O ponto de entrada MT103FIM encontra-se no final da função A103NFISCAL.
// Após o destravamento de todas as tabelas envolvidas na gravação do documento de entrada, depois de fechar a operação realizada neste.
// É utilizado para realizar alguma operação após a gravação da NFE.

// Programa Fonte:
// MATA103.PRW
// Sintaxe:
// MT103FIM - Operação após gravação da NFE

//Retorno:
//NIL (nulo)

//Local nOpcao := PARAMIXB[1]   // Opção Escolhida pelo usuario no aRotina 
//Local nConfirma := PARAMIXB[2]   // Se o usuario confirmou a operação de gravação da NFECODIGO DE APLICAÇÃO DO USUARIO

User Function MT103FIM()

	Local _aAreaSF1   := GetArea()
	Local nOpcao      := PARAMIXB[1]   // Opção Escolhida pelo usuario no aRotina
	Local nConfirma   := PARAMIXB[2]   // Se o usuario confirmou a operação de gravação da NFECODIGO DE APLICAÇÃO DO USUARIO

// Verificar se é nota fiscal de devolução de vendas


	if SF1->F1_TIPO == "D"

// Posicionar no SD1
		DbSelectArea("SD1")
		DbSetOrder(1)
//D1_FILIAL, D1_DOC, D1_SERIE, D1_FORNECE, D1_LOJA, D1_COD, D1_ITEM, R_E_C_N_O_, D_E_L_E_T_
		if DbSeek(SF1->(F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA)) .and. !Empty(SD1->D1_NFORI)

// Verificar se existe título no contas a receber de devolução de venda para gravar o vendedor
			DbSelectArea("SE1")
			DbSetOrder(1)
//E1_FILIAL, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO, R_E_C_N_O_, D_E_L_E_T_
			if DbSeek(xFilial("SE1")+SF1->(F1_SERIE+F1_DOC)+'01'+'NCC')

// Posicionar na nota fiscal original para pegar o vendedor do documento
				DbSelectArea("SF2")
				DbsetOrder(1)
				if DbSeek(SD1->(D1_FILIAL+D1_NFORI+D1_SERIORI+D1_FORNECE+D1_LOJA)) .and. !Empty(SF2->F2_VEND1)
					RecLock("SE1",.F.)
					SE1->E1_VEND1 := SF2->F2_VEND1
					SE1->E1_VEND2 := SF2->F2_VEND2
					SE1->E1_VEND3 := SF2->F2_VEND3
					SE1->E1_VEND4 := SF2->F2_VEND4
					SE1->E1_VEND5 := SF2->F2_VEND5
					MsUnLock()
				endif

			endif
		endif
	endif

	RestArea(_aAreaSF1)

Return( NIL )


/*SELECT CONCAT('UPDATE SE1010 SET E1_VEND1 = ',CHAR(39),F2_VEND1,CHAR(39),',E1_VEND2 = ',CHAR(39),F2_VEND2,CHAR(39),',E1_VEND3 = ',CHAR(39),F2_VEND3,CHAR(39),',E1_VEND4 = ',CHAR(39),F2_VEND4,CHAR(39),',E1_VEND5 = ',CHAR(39),F2_VEND5,CHAR(39),' WHERE R_E_C_N_O_ = ',SE1010.R_E_C_N_O_,';')
FROM SF1010,
SD1010,
SF4010,
SD2010,
SF2010,
SE1010
WHERE SF1010.D_E_L_E_T_ = ' '
AND SD1010.D_E_L_E_T_ = ' '
AND SF4010.D_E_L_E_T_ = ' '
AND SD2010.D_E_L_E_T_ = ' '
AND SF2010.D_E_L_E_T_ = ' '
AND SE1010.D_E_L_E_T_ = ' '
AND F1_FILIAL = D1_FILIAL
AND F1_DOC = D1_DOC
AND F1_SERIE = D1_SERIE
AND F1_FORNECE = D1_FORNECE
AND F1_LOJA = D1_LOJA
AND F1_TIPO = 'D'
AND D1_TES = F4_CODIGO
AND F4_DUPLIC = 'S'
AND D1_FILIAL = D2_FILIAL
AND D1_FORNECE = D2_CLIENTE
AND D1_LOJA = D2_LOJA
AND D1_NFORI = D2_DOC
AND D1_ITEMORI = D2_ITEM
AND D1_SERIORI = D2_SERIE
AND D2_FILIAL = F2_FILIAL
AND D2_DOC = F2_DOC
AND D2_SERIE = F2_SERIE
AND D2_CLIENTE = F2_CLIENTE
AND D2_LOJA = F2_LOJA
AND D1_DOC = E1_NUM 
AND D1_SERIE = E1_PREFIXO
AND E1_TIPO = 'NCC'
AND E1_VEND1 = ' '
AND (
F2_VEND1 != ' '
OR F2_VEND2 != ' '
OR F2_VEND3 != ' '
OR F2_VEND4 != ' '
OR F2_VEND5 != ' '
)
GROUP BY SE1010.R_E_C_N_O_,
F2_VEND1,
F2_VEND2,
F2_VEND3,
F2_VEND4,
F2_VEND5
ORDER BY SE1010.R_E_C_N_O_,
F2_VEND1,
F2_VEND2,
F2_VEND3,
F2_VEND4,
F2_VEND5
*/
