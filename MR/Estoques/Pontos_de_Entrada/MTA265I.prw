#INCLUDE "TOTVS.CH"
/*/
Ponto-de-Entrada: MTA265I - Grava arquivos ou campos do usuário, complementando a inclusão
Versões:	Advanced Protheus 7.10 , Microsiga Protheus 8.11 , Microsiga Protheus 10
Compatível Países:	Todos
Sistemas Operacionais:	Todos
Compatível às Bases de Dados:	Todos
Idiomas:	Espanhol , Inglês
Descrição:
LOCALIZAÇÃO : Function A265Grava (Gravação da Inclusão da Distribuição do Produto).

EM QUE PONTO: Após a gravação de todos os arquivos na Distribuição do Produto, este Ponto de Entrada pode ser utilizado para gravar arquivos ou campos do usuário, complementando a inclusão.

Eventos

 

Programa Fonte
MATA265.PRX
Sintaxe
MTA265I - Grava arquivos ou campos do usuário, complementando a inclusão ( < PARAMIXB> ) --> Nil

Parâmetros:
Nome			Tipo			Descrição			Default			Obrigatório			Referência	
PARAMIXB			Numérico			Recebe como parametro uma variavel numerica contendo o numero da linha do browse que esta sendo utilizada para gravacao.						X				
Retorno
Nil(nulo)
Nil
Observações
/*/
User Function MTA265I()

	Local _aAreaSBF := GetArea()
	DbSelectArea("SBF")
	if !Eof()
		nPos:=aScan(aHeader,{|x| AllTrim(x[2]) == "DB_ZZETIQ"})
		if nPos > 0
			DbSelectArea("SBF")
			DbSetOrder(1)
			if DbSeek(SDB->DB_FILIAL+SDB->DB_LOCAL+SDB->DB_LOCALIZ+SDB->DB_PRODUTO+SDB->DB_NUMSERI+SDB->DB_LOTECTL)
				RecLock("SBF",.F.)
				SBF->BF_ZZETIQ := aCols[ParamIxb[1], nPos]
				MsUnLock()
			endif
		endif

	endif
	
	// Verificar o conteúdo gravado a ajustar o número da etiqueta na tabela SBF
	RestArea(_aAreaSBF)
Return(NIL)