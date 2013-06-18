# -*- coding: utf-8 -*-

require 'rubygems'

require './meumonitor.rb'
require './timemanager.rb'
#require "./main.rb"


# Os objetos da classe urso executam como threads que têm a função e consumir dados
# do buffer (mel do pote) de forma mutuamente exclusiva em relação às outras threads
# urso. Logo quando uma thread urso é executada as outras devem estar paradas e mais
# Uma vez no buffer a thread consome toda a informação do buffer fazendo com que as
# outras threads esperem o buffer estar cheio (condição imposta para o EP) para que
# uma outra thread urso possa acessar o buffer e consumir todas as informações
# presentes nele  
class Urso

  attr_accessor :numVezesAcordado

  def initialize t, id
    @T = t
    @id = id
    @numVezesAcordado = 0
  end

  def durma_e_coma
    while  true # $gerenciadorTempo.current_time <= $duracao
      $monitor.urso_request
      @numVezesAcordado += 1
      $gerenciadorTempo.espera_urso (@T/2).floor
      $pote.evento_especial "Pote Meio Vazio:"
      $gerenciadorTempo.espera_urso (@T/2).ceil #caso T impar nao ferrar
      $pote.esvazia_pote
      $monitor.urso_free
    end
  end

  def print_estado
    print "Urso #{@id}\t#{@numVezesAcordado}\n"
  end

end
