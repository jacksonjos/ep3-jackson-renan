# encoding: utf-8

require "rubygems"
require "monitor"

$infoAbelha = []
$infoUrso = []

class Pote < Monitor
  attr_reader :mel

  def initialize h
    @capacidadePote = h
  end

  def adiciona_mel
    synchronize do
      mel += 1
      if @pote.meio_cheio?
        # se abelha->rodando é verdade, entao enchendo @pote, else, esperando vaga
        avisaMeioCheio
      end
    end
  end

  def esvazia_pote
    synchronize do
      mel = 0
    end
  end

  def cheio?
    synchronize do
      mel == @capacidadePote
    end
  end

  
  private: def meio_cheio?
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

class ControladorAcesso < Monitor
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
      while !(numAbelhas < 100 && nenhumUrso && !@pote.cheio) #TODO: pode ser que uma abelha entre quando o tiver n abelhas enchendo o pote e h - n de mel no pote. Arrumar.
        wait(@entraAbelha) #
      end
      infoAbelha[i].estado = :depositando #
      
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
      signal_all(@entraAbelha)
    end
  end 
end
