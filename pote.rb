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
        evento_especial "Pote na metade enquanto as abelhas estão enchendo:" # Falta implementar
      end
    end
  end

  def esvazia_pote
    synchronize do
      @mel = 0
    end
    evento_especial "Pote vazio:"
  end

  def cheio?
    synchronize do
      if @mel == @capacidadePote
        evento_especial "Pote cheio:"
        return true
      end
    end
  end

  def pronto?
    synchronize do
      self.cheio? && @numAbelhas == 0
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
  def evento_especial tipo_de_evento
    puts tipo_de_evento
    $abelhas.each {|abelha| print "#{abelha.estado}\n"}
    $abelhas.each {|abelha| print "#{abelha.numUrsosAcordados}\n"}
    $ursos.each {|urso| print "#{urso.numVezesAcordado}\n"}
    print "\n\n"
  end

  private
  def meio_cheio?
    @mel == (@capacidadePote / 2).floor
  end

end
