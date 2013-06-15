# encoding: utf-8

require "rubygems"
require "monitor"

# Arrays com informações sobre abelhas e ursos.
# Os arrays abaixo são inicializados dentro do monitor e são do
# tipo das classes de mesmo nome que estão logo abaixo
$infoAbelha = []
$infoUrso = []

<<<<<<< HEAD

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
=======
class Pote < Monitor
  attr_reader :mel
>>>>>>> 648c2640d21620a59c1618711e4efdec73d538b2

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


<<<<<<< HEAD
class Monitor
=======
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
>>>>>>> 648c2640d21620a59c1618711e4efdec73d538b2

class ControladorAcesso < Monitor
  attr_reader :numAbelhas

  
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
<<<<<<< HEAD

    $infoAbelha[i].estado = :voando
    @entraAbelha.wait(@numAbelhas < 100 && @nenhumUrso && !@pote.cheio) #
    $infoAbelha[i].estado = :depositando

    @pote.mel += 1
    if @pote.meio_cheio?
      # se abelha->rodando é verdade, entao enchendo @pote, else, esperando vaga
      avisaMeioCheio  #
    end

    @numAbelhas += 1
=======
    
    synchronize do
      infoAbelha[i].estado = :voando     #
      while !(numAbelhas < 100 && nenhumUrso && !@pote.cheio) #TODO: pode ser que uma abelha entre quando o tiver n abelhas enchendo o pote e h - n de mel no pote. Arrumar.
        wait(@entraAbelha) #
      end
      infoAbelha[i].estado = :depositando #
      
      numAbelhas += 1
    end
>>>>>>> 648c2640d21620a59c1618711e4efdec73d538b2
  end
  
  def abelha_free
<<<<<<< HEAD

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
=======
    
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
>>>>>>> 648c2640d21620a59c1618711e4efdec73d538b2
