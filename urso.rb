# -*- coding: utf-8 -*-
def urso T
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

