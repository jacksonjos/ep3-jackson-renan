# encoding: utf-8

require "rubygems"
require "monitor"

class Pote
  attr_accessor :mel

  def initialize h
    @capacidadePote = h
  end

  def cheio?
    mel == @capacidadePote
  end

  def meio_cheio?
    mel == (@capacidadePote / 2).floor
  end
end


class Monitor
  attr_reader :numAbelhas

  entraUrso = ConditionVariable.new
  entraAbelha = ConditionVariable.new

  abelha_request
    infoAbelha[i].estado = voando
    entraAbelha.wait(numAbelhas < 100 && nenhumUrso && poteNaoCheio)
    infoAbelha[i].estado = depositando
    mel += 1
    if MeioCheio
      # se abelha->rodando é verdade, entao enchendo pote, else, esperando vaga
      avisaMeioCheio
    numAbelhas += 1

  abelha_free
    numAbelhas -= 1
    if poteCheio && numAbelhas == 0
      # se abelha->rodando é verdade, enchendo pote, else, esperando vaga
      avisaCheio
      infoAbelha[i].ursosAcordados += 1
      entraUrso.signal
    else if poteNaoCheio
      entraAbelha.signal
    infoAbelha[i].estado = buscando mel

  urso_request
    entraUrso.wait()
    ursoInfo[i].numVezesAcordado += 1  

  urso_free
    Mel = 0
    entraAbelha.signal_all()
end


def wait mayProceed
  mayProceed.true?
  if self.locked?
    self.unlock
  end
end 