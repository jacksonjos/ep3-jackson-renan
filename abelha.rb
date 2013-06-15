# -*- coding: utf-8 -*-

require "monitor.rb"

def abelha t
  
  while true #TODO: definir condição de parada
    Monitor.abelha_request
    #espera t
    #monitor.adicionaMel #  <-- talvez. Acho que aqui seria melhor, mas podemos
    # mudar o algoritmo do monitor agora?
    Monitor.abelha_free
  end
end
  
