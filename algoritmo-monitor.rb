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




#-----------------------------------------------------------------------------




# Algoritmo que possui apenas um monitor. O monitor controla o uso do pote de
# mel pelas abelhas e pelo urso

# Os nomes das variáveis e métodos foram escolhidos de forma a evitar encher
# o código de comentários 
# Classes possuem nome começando com letra maiúscula seguido de ':'
# Nome de métodos começam com letra minúscula seguidos de ':'

InfoAbelha:
  ursosAcordados
  estado

InfoUrso:
  numVezesAcordado

# Arrays globais que possuem informações úteis a serem conferidas pelo programa
# sem depender da situação das threads 
infoAbelha[N]
infoUrso[B]


Monitor:
  # variáveis do monitor
  Mel
  numAbelhas

  # variáveis de condição
  cond entraUrso
  cond entraAbelha

  abelhaRequest:
    infoAbelha[i].estado = voando
    entraAbelha.wait(numAbelhas < 100 && nenhumUrso && poteNaoCheio)
    infoAbelha[i].estado = depositando
    Mel++
    if MeioCheio
      # se abelha->rodando é verdade, entao enchendo pote, else, esperando vaga
      avisaMeioCheio
    numAbelhas++

  abelhaFree:
    numAbelhas--
    if poteCheio && numAbelhas == 0
      # se abelha->rodando é verdade, enchendo pote, else, esperando vaga
      avisaCheio
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