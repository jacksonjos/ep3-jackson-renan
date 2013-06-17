# -*- coding: utf-8 -*-

require 'rubygems'
require "./meumonitor.rb"
require "./timemanager.rb"
require "./pote.rb"
#require "./main.rb"

class Abelha
  
  # attr_accessor é um método do ruby que cria métodos setter e getter
  # pras variáveis que são escritas logo depois dele antes de ':'.
  # Assim, quando se quiser manipular a variável estado de um objeto
  # 'Abelha' basta fazer abelha.estado = estado sendo abelha
  # um objeto do tipo Abelha. No caso abaixo as variáveis definidas
  # como attr_accessor são variáveis de instância, ou seja, :estado é 
  # interpretado como @estado dentro de Abelha que é como se define
  # uma variável de instância.

  attr_accessor :estado

  def initialize t, id
    @t = t
    @id = id
    @numUrsosAcordados = 0
    print "Abelha #{id} inicializada, @id = #{@id}\n"
  end

  def trabalhe
    while true #TODO: definir condição de parada
      print "Abelha #{@id} vai pedir pra entrar\n"
      $monitor.abelha_request @id
      print "Abelha #{@id} vai enrolar agora\n"
      $gerenciadorTempo.espera_abelha @id, @t
      print "Abelha #{@id} vai adicionar mel finalmente\n"
      $pote.adiciona_mel
      $monitor.abelha_free
    end
  end

  def conta_urso_acordado
    @numUrsosAcordados += 1
  end

end
