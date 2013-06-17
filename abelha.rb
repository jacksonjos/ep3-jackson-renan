# -*- coding: utf-8 -*-

require 'rubygems'
require "monitor.rb"

class Abelha

  def initialize t

  end

  def trabalhe
    while true #TODO: definir condição de parada
      ControladorAcesso.abelha_request
      #espera t
      Pote.adiciona_mel #  <-- talvez. Acho que aqui seria melhor, mas podemos
      # mudar o algoritmo do monitor agora?
      ControladorAcesso.abelha_free
    end
  end

end