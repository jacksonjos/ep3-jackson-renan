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


# renomeando nome de métodos do ruby para os nomes exigidos no EP

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

  
  # new_cond é um método do monitor que cria a variável de condição
  def initialize h
    @pote = Pote.new(h)
    @entraUrso =  new_cond
    @entraAbelha = new_cond
  end

  def abelha_request
    
    synchronize do
      infoAbelha[i].estado = :voando     #
      while !(numAbelhas < 100 && nenhumUrso && !@pote.cheio)
        wait(@entraAbelha) #
      end
      infoAbelha[i].estado = :depositando #

      @pote.mel += 1
      if @pote.meio_cheio?
        # se abelha->rodando é verdade, entao enchendo @pote, else, esperando vaga
        avisaMeioCheio
      end
      
      numAbelhas += 1
    end
  end
  
  def abelha_free
    
    synchronize do
      numAbelhas -= 1
      if @pote.cheio? && numAbelhas == 0
        # se abelha->rodando é verdade, enchendo @pote, else, esperando vaga
        avisaCheio
        infoAbelha[i].ursosAcordados += 1
        signal(@entraUrso)
        
      elsif !@pote.cheio?
        signal(@entraAbelha)
      end
      
      infoAbelha[i].estado = :buscandoMel
    end
  end

  def urso_request

    synchronize do
      wait(@entraUrso)
      ursoInfo[i].numVezesAcordado += 1  
    end
  end

  def urso_free
    
    synchronize do
      @pote.mel = 0
      signal_all(@entraAbelha)
    end
  end 
end
