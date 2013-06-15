# encoding: utf-8

require "rubygems"
require "monitor"

# Arrays com informações sobre abelhas e ursos.
# Os arrays abaixo são inicializados dentro do monitor e são do
# tipo das classes de mesmo nome que estão logo abaixo
$infoAbelha = []
$infoUrso = []


class InfoAbelha
  attr_accessor :estado

  def initialize
    @numUrsosAcordados = 0
  end

  def acordaUrso
    @numUrsosAcordados += 1
  end
end

class InfoUrso
   def initialize
    @numVezesAcordados = 0
  end

  def acordaUrso
    @numVezesAcordados += 1
  end
end

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

  # renomeando nome de métodos do ruby para os nomes exigidos no EP
  alias :signal_all() :broadcast()
  alias :wait() :wait_until()

  # new_cond é um método do monitor que cria a variável de condição
  # São geradas N e B objetos de informações sobre abelhas e ursos respectivamente
  def initialize h, N, B
    N.times {$infoAbelha << InfoAbelha.new}
    B.times {$infoUrso << InfoUrso.new}
    @pote = Pote.new(h)
    @numAbelhas = 0
    @nenhumUrso = true
    @entraUrso =  new_cond
    @entraAbelha = new_cond
  end

  def abelha_request

    $infoAbelha[i].estado = :voando
    @entraAbelha.wait(@numAbelhas < 100 && @nenhumUrso && !@pote.cheio) #
    $infoAbelha[i].estado = :depositando

    @pote.mel += 1
    if @pote.meio_cheio?
      # se abelha->rodando é verdade, entao enchendo @pote, else, esperando vaga
      avisaMeioCheio  #
    end

    @numAbelhas += 1
  end

  def abelha_free

    @numAbelhas -= 1
    if @pote.cheio? && numAbelhas == 0
      # se abelha->rodando é verdade, enchendo @pote, else, esperando vaga
      avisaCheio
      $infoAbelha[i].numUrsosAcordados += 1
      @entraUrso.signal_all#

    elsif !@pote.cheio?
      @entraAbelha.signal
    end

    $infoAbelha[i].estado = :buscandoMel
  end

  def urso_request
    @entraUrso.wait(true)
    @nenhumUrso = false
    ursoInfo[i].numVezesAcordado += 1  
  end

  def urso_free
    @pote.mel = 0
    @nenhumUrso = true
    @entraAbelha.signal_all()
  end
end 