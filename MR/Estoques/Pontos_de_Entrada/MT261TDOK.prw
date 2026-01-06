#Include 'Protheus.ch'
 
User Function MA261TRD3()
 
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Recebe os identificadores Recno() gerados na tabela SD3      ³
//³ para que seja feito o posicionamento                         ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
 
Local aRecSD3 := PARAMIXB[1]
Local nX      := 1
Local _cEtiq  := ""
 
For nX := 1 To Len(aRecSD3)
 
    SD3->(DbGoto(aRecSD3[nX][1])) // Requisicao RE4
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Customizacoes de usuario      ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    DbSelectArea("SBF")
    DbSetOrder(1)
    if DbSeek(SD3->(D3_FILIAL+D3_LOCAL+D3_LOCALIZ+D3_COD+D3_NUMSERI+D3_LOTECTL+D3_NUMLOTE)) .and. !Empty(SBF->BF_ZZETIQ)
    	_cEtiq := SBF->BF_ZZETIQ
    endif
     
    SD3->(DbGoto(aRecSD3[nX][2])) // Devolucao DE4
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Customizacoes de usuario      ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
    DbSelectArea("SBF")
    DbSetOrder(1)
    if DbSeek(SD3->(D3_FILIAL+D3_LOCAL+D3_LOCALIZ+D3_COD+D3_NUMSERI+D3_LOTECTL+D3_NUMLOTE))
    	RecLock("SBF",.F.)
    	SBF->BF_ZZETIQ := _cEtiq
    	MsUnLock()
    endif

 
Next nX
 
Return Nil