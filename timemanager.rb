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

# A bilbioteca (gem) priority queue é uma simples fila de prioridades
# que implementa uma fila em que os objetos são ordenados com prioridades
# crescentes. No caso a prioridade consiste de valores crescentes.

# O método to_i devolve o valor inteiro de uma variável/objeto.

class TimeManager 
  
  @skippedTime = 0
  @pq = PriorityQueue.new
  @numAbelhas = 0
  
  include MonitorMixin
  
  # Inicializa contagem do
  def initialize 
    # Time.new inicializa uma variável com o tempo corrente
    @startTime = Time.new
    @signalAbelhas = []
    super
  end
  
  def init n
    for i in 1..n
      @signalAbelhas << new_cond
    end
    @manager = Thread.new{
      
      # Como a unidade de tempo implementada foi de 1 segundo o sleep é implementado
      # para que a thread faça a checagem da fila uma vez por segundo. Afinal, quando
      # há diferença entre a prioridade (tempo) entre os objetos ela será medida entre
      # segundos.
      
      while true
        sleep(1)
        synchronize do
          while @pq.min_priority <= current_time
            signal @pq.pop
          end
        end
      end
    }
    
  end
  
    
    
  # Retorna o tempo simbólico atual
  def current_time
    currentTime = Time.now.to_i - @startTime.to_i + @skippedTime.to_i
    return currentTime
  end
  
  def espera_abelha id, t
    synchronize do
      if @signalAbelhas[id].nil?
        print "wat\n"
      end
      adiciona_evento @signalAbelhas[id], current_time + t
      if !$pote.pode_entrar?
        skip_ate_evento
      end
      wait @signalAbelhas[id]
      @numAbelhas -= 1
    end
  end

  # Método que faz a contagem do tempo gasto pela thread urso para esvaziar
  # o buffer (pote de mel)
  def espera_urso t
    synchronize do
      skip_time t
    end
  end
  
  # Encerra execução da thread
  def encerra
    while !@pq.empty?
      signal @pq.pop
    end
    Thread.kill @manager
  end
  
  # Define que os métodos abaixo desta cláusula são do tipo privados na classe
  private

  # Salto de tempo 
  def skip_time t
    @skippedTime += t
  end

  # salto de tempo realizado para que seja possível passar do evento corrente
  # para outro que está esperando para poder executar
  def skip_ate_evento
    skip_time (@pq.min_priority - current_time)
  end
  

  def adiciona_evento e, priority
    @pq.push e, priority.to_i
  end
end
