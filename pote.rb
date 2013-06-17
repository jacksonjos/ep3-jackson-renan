# -*- coding: utf-8 -*-

require "rubygems"
require "monitor"
require "./graphics.rb"

class Pote < Monitor
  
  def initialize h
    @capacidadePote = h
    @numAbelhas = 0
    @mel = 0
    super
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
        # evento_especial "Pote na metade enquanto as abelhas estão enchendo:" # Falta implementar
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
      if @mel >= @capacidadePote
        evento_especial "Pote cheio:"
        return true
      end
    end
  end

  # Método que avisa se já é possível liberar o pote para o urso comer o mel
  # e que executa um evento especial como definido no enunciado do EP
  def pronto?
    synchronize do
      if @mel >= @capacidadePote && @numAbelhas == 0
        evento_especial "Pote Cheio:"
      end
    end
  end

  def pode_entrar?
    synchronize do
      @numAbelhas < 100 && @numAbelhas + @mel < @capacidadePote
    end
  end

  # O método executa um evento especial como definido no EP e armazena nos vetores apropriados
  # os valores necessários para produzir os gráficos pedidos no enunciado do EP
  def evento_especial tipo_de_evento
    somaNumVezesAbelhaAcordouUrsos = 0
    somaNumVezesUrsosComeram = 0
    print "#{tipo_de_evento}\n"
    $abelhas.each {|abelha| print "#{abelha.estado}\n"}
    $abelhas.each {|abelha| print "#{abelha.numUrsosAcordados}\n"
                  somaNumVezesAbelhaAcordouUrsos += abelha.numUrsosAcordados}
    $mediaVezesAbelhasAcordaramUrsos  <<  (somaNumVezesAbelhaAcordouUrsos / $abelhas.length).to_f
    $ursos.each {|urso| print "#{urso.numVezesAcordado}\n"
                  somaNumVezesUrsosComeram += urso.numVezesAcordado}
    $mediaVezesUrsosComeram  << (somaNumVezesUrsosComeram / $ursos.length).to_f
    $tempo << $gerenciadorTempo.current_time.to_i - $gerenciadorTempo.startTime.to_i 
    print "\n\n"
  end


  def meio_cheio?
    if @mel == (@capacidadePote / 2).floor
      evento_especial "Pote Meio Cheio:"
    end
  end

end
