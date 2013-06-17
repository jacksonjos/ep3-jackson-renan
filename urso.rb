# -*- coding: utf-8 -*-

require 'rubygems'
require 'monitor.rb'


# Os objetos da classe urso executam como threads que têm a função e consumir dados
# do buffer (mel do pote) de forma mutuamente exclusiva em relação às outras threads
# urso. Logo quando uma thread urso é executada as outras devem estar paradas e mais
# Uma vez no buffer a thread consome toda a informação do buffer fazendo com que as
# outras threads esperem o buffer estar cheio (condição imposta para o EP) para que
# uma outra thread urso possa acessar o buffer e consumir todas as informações
# presentes nele  
class Urso

  def initialize T

  end

  def durma_e_coma
    while true #TODO: definir condição de parada
      ControladorAcesso.urso_request
      #espera T/2
      #anuncia meio pote
      #espera T-T/2 #caso T impar nao ferrar
      Pote.esvazia_pote # <-- fica mais claro. Podemos mudar o algoritmo do
      # monitor?
      ControladorAcesso.urso_free
    end
  end

end