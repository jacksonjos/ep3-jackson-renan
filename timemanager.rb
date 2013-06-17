# -*- coding: utf-8 -*-
require 'rubygems'
require 'time'
require 'priority_queue'

require './monitoraliases.rb'
require './pote.rb'

# Neste EP cada unidade de tempo t gasta pelas das threads para realizar
# as tarefas que lhes cabem equivale a um segundo.
# Assim, há algumas atividades realizadas pelas threads que ao invés de
# esperar um certo tempo são executadas imediatamente. Para que seja
# contabilizado o tempo que elas levariam teoricamente para executar uma
# tarefa são realizados saltos (skips) no tempo do TimeManager. Tais saltos
# são executados em métodos cujos nomes começam por skip.

# A bilbioteca (gem) priority_queue é uma simples fila de prioridades
# que implementa uma fila em que os objetos são ordenados com prioridades
# crescentes. No caso a prioridade consiste de valores crescentes.

# O método to_i devolve o valor inteiro de uma variável/objeto.

class TimeManager  
  
  # Inicializa contagem do
  def initialize 
    @startTime = Time.now
  end
  
  
    
  # Retorna o tempo simbólico atual
  def current_time
    currentTime = Time.now.to_i - @startTime.to_i
    return currentTime
  end
  
  def espera_abelha id, t
    sleep t
  end

  # Método que faz a contagem do tempo gasto pela thread urso para esvaziar
  # o buffer (pote de mel)
  def espera_urso t
    sleep t
  end

  # Encerra execução da thread
  def encerra
  end

  # Define que os métodos abaixo desta cláusula são do tipo privados na classe
  private

  # Salto de tempo 
  def skip_time t
    sleep t
  end
  
end
