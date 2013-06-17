# -*- coding: utf-8 -*-

require "monitor"

class Pote < Monitor
  # Aqui vale o mesmo que foi explicado para o método accessor com a diferença
  # de que é criado apenas um método getter para @mel. Assim é possível saber o
  # número de mel executando pote.mel sendo que pote é um objeto da classe Pote.
  attr_reader :mel

  def initialize h
    @capacidadePote = h
  end

  # Método que executa a adição de uma porção de mel por uma dada abelha
  def adiciona_mel
    synchronize do
      @mel += 1
      if @pote.meio_cheio?
        # se abelha->rodando é verdade, entao enchendo @pote, else, esperando vaga
        avisaMeioCheio # Falta implementar
      end
    end
  end

  def esvazia_pote
    synchronize do
      @mel = 0
    end
  end

  def cheio?
    synchronize do
      @mel == @capacidadePote
    end
  end

  def vai_encher? n
    synchronize do
      @mel + n >= @capacidadePote
    end
  end

  private
  def meio_cheio?
    @mel == (@capacidadePote / 2).floor
  end

end
