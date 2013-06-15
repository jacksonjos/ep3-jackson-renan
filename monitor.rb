# encoding: utf-8

require "rubygems"
require "monitor"

$infoAbelha = []
$infoUrso = []

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


def wait(condvar)
  condvar.wait
end

def signal(condvar)
  condvar.signal
end

def signal_all(condvar)
  condvar.broadcast
end

class Monitor
  attr_reader :numAbelhas

  # renomeando nome de métodos do ruby para os nomes exigidos no EP
  alias :signal_all() :broadcast()
  
  # new_cond é um método do monitor que cria a variável de condição
  def initialize h
    @pote = Pote.new(h)
    @entraUrso =  new_cond
    @entraAbelha = new_cond
  end

  def abelha_request

    infoAbelha[i].estado = :voando     #
    @entraAbelha.wait(numAbelhas < 100 && nenhumUrso && !@pote.cheio) #
    infoAbelha[i].estado = :depositando #

    @pote.mel += 1
    if @pote.meio_cheio?
      # se abelha->rodando é verdade, entao enchendo @pote, else, esperando vaga
      avisaMeioCheio
    end

    numAbelhas += 1
  end

  def abelha_free

    numAbelhas -= 1
    if @pote.cheio? && numAbelhas == 0
      # se abelha->rodando é verdade, enchendo @pote, else, esperando vaga
      avisaCheio
      infoAbelha[i].ursosAcordados += 1
      @entraUrso.signal

    elsif !@pote.cheio?
      @entraAbelha.signal
    end

    infoAbelha[i].estado = :buscandoMel
  end

  def urso_request
    @entraUrso.wait(true)
    ursoInfo[i].numVezesAcordado += 1  
  end

  def urso_free
    @pote.mel = 0
    @entraAbelha.signal_all()
  end
end 
