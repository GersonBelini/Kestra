#INCLUDE "PROTHEUS.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ SPDFIS001º Autor ³ Ricardo Bataglia   º Data ³  25/04/2011 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Ponto de entrada disponibilizado para tratar tipos de prod ³±±
±±³          ³ uto criados pelo usuario, relacionando-os com os tipos des ³±±
±±³          ³ critos no registro 0200 do Ato Cotepe 09/2008.             ³±±
±±³          ³ Ponto de entrada chamado a cada produto novo a ser lancado ³±±
±±³          ³ no registro 0200.                                          º±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ SPDFIS001(< PARAMIXB >)                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ aTipo - Array of Record - Array com os tipos de produto pa ³±±
±±³          ³ drão do sistema.                                           ³±±
±±³          ³ É passado como parametro um array (aTipo) contendo o relac ³±±
±±³          ³ ionamento dos tipos de produto que o sistema tem por padra ³±±
±±³          ³ o, e a sua correspondencia com a tabela de tipos do SPED F ³±±
±±³          ³ iscal.                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Array com os tipos de produto padrão do sistema acrescidos ³±±
±±³          ³ dos tipos criados pelo usuario                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Protheus 10 > SIGAFIS                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Analista  ³ Data    ³ Motivo                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³         ³                                                  ³±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function SPDFIS001()
Local aArea		:= GetArea()
Local aReturn	:= {}

	aAdd (aReturn,{"AI","08"})
	aAdd (aReturn,{"AT","08"})
	aAdd (aReturn,{"BN","09"})
	aAdd (aReturn,{"EL","03"})
	aAdd (aReturn,{"EM","02"})
	aAdd (aReturn,{"GG","07"})
	aAdd (aReturn,{"MA","05"})
	aAdd (aReturn,{"MC","07"})
	aAdd (aReturn,{"ME","01"})
	aAdd (aReturn,{"MO","99"})
	aAdd (aReturn,{"MP","01"})
	aAdd (aReturn,{"OI","10"})
	aAdd (aReturn,{"PA","04"})
	aAdd (aReturn,{"PI","03"})
	aAdd (aReturn,{"PP","03"})
	aAdd (aReturn,{"PV","07"})
	aAdd (aReturn,{"RC","99"})
	aAdd (aReturn,{"RE","99"})
	aAdd (aReturn,{"SL","99"})
	aAdd (aReturn,{"SP","09"})
	aAdd (aReturn,{"ST","09"})
	aAdd (aReturn,{"RV","00"})
	aAdd (aReturn,{"SV","09"})
	aAdd (aReturn,{"MT","99"})
	aAdd (aReturn,{"OU","99"})
	
	RestArea(aArea)
	
Return (aReturn)

/*/

Tipos existentes na SX5

AI	ATIVO IMOBILIZADO
BN	BENEFICIAMENTO
EM	EMBALAGEM
GG	GASTOS GERAIS
MC	MATERIAL DE CONSUMO
ME	MERCADORIA
MO	MAO DE OBRA
MP	MATERIA PRIMA
OI	OUTROS INSUMOS
PA	PRODUTO ACABADO
PI	PRODUTO INTERMEDIARIO
SP	SERVICO PRESTADO
ST	SERVICO DE TERCEIROS
RV	REVENDA
MA	MATERIAL AUXILIAR
MT	MATERIAL DE TERCEIROS
OU	OUTROS


EFD tipo do item – Atividades Industriais, Comerciais e 
Serviços: 
00 – Mercadoria para Revenda; 
01 – Matéria-Prima; 
02 – Embalagem; 
03 – Produto em Processo; 
04 – Produto Acabado; 
05 – Subproduto; 
06 – Produto Intermediário; 
07 – Material de Uso e Consumo; 
08 – Ativo Imobilizado; 
09 – Serviços; 
10 – Outros insumos; 
99 – Outras 

/*/

