# -*- coding: utf-8 -*-

require "rubygems"
require "monitor"
require "main.rb"

class Pote < Monitor

  def initialize h
    @capacidadePote = h
    @numAbelhas = 0
    @mel = 0
  end

  def insere_abelha
    synchronize do
      @numAbelhas += 1
    end
  end

  def remove_abelha
    synchronize do
      @numAbelhas -= 1
    end
  end

  # Método que executa a adição de uma porção de mel por uma dada abelha
  def adiciona_mel
    synchronize do
      @mel += 1
      # Self se refere ao próprio objeto da classe instanciado
      if self.meio_cheio?
        # se abelha->rodando é verdade, então enchendo @pote, else, esperando vaga
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

  def pronto?
    synchronize do
      @mel == @capacidadePote && @numAbelhas == 0
    end
  end

  def pode_entrar?
    synchronize do
      @numAbelhas < 100 && @numAbelhas + @mel <= @capacidadePote
    end
  end

#  def vai_encher? n
#    synchronize do
#      @mel + n >= @capacidadePote
#    end
#  end

  private
  def meio_cheio?
    @mel == (@capacidadePote / 2).floor
  end

end
