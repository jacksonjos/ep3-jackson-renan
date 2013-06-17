# -*- coding: utf-8 -*-

require 'rubygems'
require "monitor.rb"
require "timemanager.rb"

class Abelha
  
  attr_acessor :estado

  def initialize t, id
    @t = t
    @id = id
    @numUrsosAcordados += 1
  end

  def trabalhe
    while true #TODO: definir condição de parada
      $monitor.abelha_request
      $gerenciadorTempo.espera_abelha id, t
      $pote.adiciona_mel
      $monitor.abelha_free
    end
  end

  def conta_urso_acordado
    @numUrsosAcordados += 1
  end

end
