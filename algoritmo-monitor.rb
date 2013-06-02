requestPote
freePote
#incrementaMel
comeMel

array global-> contagem de vezes que cada abelha acorda um urso
               contagem de vezes que cada urso é acordado

Var -> Mel
        numAbelhas

condVar -> entraUrso
           entraAbelha

abelhaRequest:
  infoAbelha[i].estado = voando
  entraAbelha.wait_until(numAbelhas < 100 && nenhumUrso && poteNaoCheio)
  infoAbelha[i].estado = depositando
  Mel++
  if MeioCheio
    avisaMeioCheio; # se abelha->rodando, entao enchendo pote, else, esperando vaga
  numAbelhas++

abelhaFree:
  numAbelhas--;
  if poteCheio && numAbelhas == 0
    avisaCheio # se abelha->rodando, enchendo pote, else, esperando vaga
    infoAbelha[i].ursosAcordados++
    entraUrso.signal
  else if poteNaoCheio
    entraAbelha.signal
  infoAbelha[i].estado = buscando mel

ursoRequest:
  entraUrso.wait()
  ursoInfo[i].numVezesAcordado++  

ursoFree:
  Mel = 0
  entraAbelha.signal_all()

-----------

abelha:
  requestPote;
  enrola;
  freePote; 