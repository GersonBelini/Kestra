#Include 'Protheus.ch'

User Function TK271ROTM()
	Local aRet		:= {}
	Local aAux		:= {}
	Local cLibPV	:= ""
	
		
	
	aAdd( aAux, { 'Impressão' 	,'u_impTmk'	, 0 , 7 })
	If Posicione("SU7",4,xFilial("SU7")+RetCodUsr(),"U7_ZZLIBPV") == "S"
		aAdd( aAux, { 'Lib. Pedido' ,'MATA440', 0 , 7 })
	EndIf		
	aAdd( aAux, { 'Estoque' 			,'MATR425'		, 0 , 7 })
	aAdd( aAux, { 'Consulta Estoque' 	,'u_KSTEST01'	, 0 , 7 })	
	aAdd( aAux, { 'Consulta Historico' 	,'u_KSTHST02'	, 0 , 7 })	
	
	
	aAdd( aRet, { 'Kestra' 	,aAux, 0 , 7 })
	
Return aRet