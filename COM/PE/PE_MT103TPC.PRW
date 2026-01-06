User Function MT103TPC

Local cTes := PARAMIXB[1]// Tratamentos do cliente

cTes += SuperGetMv( "MV_ZZTES1" , .F. ,"",  )
cTes += SuperGetMv( "MV_ZZTES2" , .F. ,"",  )
cTes += SuperGetMv( "MV_ZZTES3" , .F. ,"",  )

Return cTes
