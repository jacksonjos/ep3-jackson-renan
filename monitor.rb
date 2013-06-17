# encoding: utf-8

require "rubygems"

require "monitoraliases.rb"
require "pote.rb"

# Arrays com informações sobre abelhas e ursos.
# Os arrays abaixo são globais, inicializados dentro do monitor e são do
# tipo das classes de mesmo nome que estão logo abaixo
$infoAbelha = []
$infoUrso = []


class InfoAbelha
  # áttr_accessor é um método do ruby que cria métodos setter e getter
  # pras variáveis que são escritas logo depois dele antes de ':'.
  # Assim, quando se quiser manipular a variável estado de um objeto
  # 'InfoAbelha' basta fazer infoAbelha.estado = estado sendo infoAbelha
  # um objeto do tipo InfoAbelha. No caso abaixo as variáveis definidas
  # como attr_accessor são variáveis de instância, ou seja, :estado é 
  # interpretado como @estado dentro de InfoAbelha que é como se define
  # uma variável de instância.
  attr_accessor :estado

  def initialize
    @numUrsosAcordados = 0
  end

  def acorda_urso
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


class ControladorAcesso < Monitor
  
  # new_cond é um método do monitor que cria a variável de condição
  # São geradas N e B objetos de informações sobre abelhas e ursos respectivamente
  def initialize N, B
    N.times {$infoAbelha << InfoAbelha.new}
    B.times {$infoUrso << InfoUrso.new}
    # $pote = Pote.new(h)
    # Número de abelhas depositando mel no pote
    @numAbelhas = 0
    # Boolean que é usado para saber se há um urco comendo o mel do pote ou não
    @nenhumUrso = true
    # Variáveis de condição
    @entraUrso =  new_cond
    @entraAbelha = new_cond
  end

  def abelha_request
    
    synchronize do
      $infoAbelha[i].estado = :voando
      while !(@numAbelhas < 100 && @nenhumUrso && !@pote.vai_encher? @numAbelhas)
        wait(@entraAbelha) #
      end
      $infoAbelha[i].estado = :depositando
      
      @numAbelhas += 1
    end
  end
  
  def abelha_free
    
    synchronize do
      @numAbelhas -= 1
      if $pote.cheio? && @numAbelhas == 0
        # se abelha->rodando é verdade, enchendo @pote, else, esperando vaga
        avisaMeioCheio # Falta implementar
        $infoAbelha[i].acorda_urso
        signal(@entraUrso)
        
      elsif !$pote.cheio?
        signal(@entraAbelha)
      end
      
      $infoAbelha[i].estado = :buscandoMel
    end
  end

  # Thread urso recebe permissão para executar (comer mel do pote)
  def urso_request

    synchronize do
      wait(@entraUrso)
      $infoUrso[i].acorda
    end
  end

  # Thread urso avisa as threads abelha que elas podem voltar a executar
  # (encher o pote)
  def urso_free
    
    synchronize do
      signal_all(@entraAbelha)
    end
  end 
end
