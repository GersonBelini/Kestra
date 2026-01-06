#Include 'Protheus.ch'
#Include 'TopConn.ch'

/*/{Protheus.doc} imprOP

Seleciona o tipo da impressão da OP.
	
@author André Oquendo
@since 12/06/2015

/*/

User Function imprOP()

	DO CASE
		CASE SC2->C2_ZZLAYRE == '1'
			u_imprER()
		CASE SC2->C2_ZZLAYRE == '2'
			u_imprAT()
		CASE SC2->C2_ZZLAYRE == '3'
			u_imprPes()
		CASE SC2->C2_ZZLAYRE == '4'
			u_imprCor()
		OTHERWISE
			msgAlert("Layout não cadastrado!")
	ENDCASE

Return

