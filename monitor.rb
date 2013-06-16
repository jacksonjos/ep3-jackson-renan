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

  def acorda
    @numVezesAcordados += 1
  end
end


class Pote < Monitor
  attr_reader :mel

  def initialize h
    @capacidadePote = h
  end

  def adiciona_mel
    synchronize do
      @mel += 1
      if @pote.meio_cheio?
        # se abelha->rodando é verdade, entao enchendo @pote, else, esperando vaga
        avisaMeioCheio
      end
    end
  end

  def esvazia_pote
    synchronize do
      @mel = 0
    end
  end

  def cheio?
    synchronize do
      @mel == @capacidadePote
    end
  end

  def vai_encher? n
    synchronize do
      @mel + n >= @capacidadePote
    end
  end

  private
  def meio_cheio?
    @mel == (@capacidadePote / 2).floor
  end

end


class Monitor
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
end


class ControladorAcesso < Monitor
  
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
    
    synchronize do
      $infoAbelha[i].estado = :voando     #
      while !(@numAbelhas < 100 && @nenhumUrso && !@pote.vai_encher? @numAbelhas)
        wait(@entraAbelha) #
      end
      $infoAbelha[i].estado = :depositando #
      
      @numAbelhas += 1
    end
  end
  
  def abelha_free
    
    synchronize do
      @numAbelhas -= 1
      if @pote.cheio? && @numAbelhas == 0
        # se abelha->rodando é verdade, enchendo @pote, else, esperando vaga
        avisaCheio
        $infoAbelha[i].acordaUrso
        signal(@entraUrso)
        
      elsif !@pote.cheio?
        signal(@entraAbelha)
      end
      
      $infoAbelha[i].estado = :buscandoMel
    end
  end

  def urso_request

    synchronize do
      wait(@entraUrso)
      $infoUrso[i].acorda
    end
  end

  def urso_free
    
    synchronize do
      signal_all(@entraAbelha)
    end
  end 
end
