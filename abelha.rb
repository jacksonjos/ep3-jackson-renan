# -*- coding: utf-8 -*-

require "monitor.rb"

def abelha t
  
  while true #TODO: definir condição de parada
    ControladorAcesso.abelha_request
    #espera t
    Pote.adiciona_mel #  <-- talvez. Acho que aqui seria melhor, mas podemos
    # mudar o algoritmo do monitor agora?
    ControladorAcesso.abelha_free
  end
end
  
