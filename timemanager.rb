# -*- coding: utf-8 -*-
require 'rubygems'
require 'time'
require 'priority_queue'
require 'monitor'

require 'monitoraliases.rb'

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

class TimeManager < Monitor
  
  @skippedTime = 0
  @pq = PriorityQueue.new
  @numAbelhas = 0

  @signalAbelhas = []

  # Inicializa contagem do
  def initialize N
    # Time.new inicializa uma variável com o tempo corrente
    @startTime = Time.new
    # Como a unidade de tempo implementada foi de 1 segundo o sleep é implementado
    # para que a thread faça a checagem da fila uma vez por segundo. Afinal, quando
    # há diferença entre a prioridade (tempo) entre os objetos ela será medida entre
    # segundos.

    1..N.each{
      @signalAbelhas << new_cond
    }
    
    @totalAbelhas = N

    @manager = Thread.new{

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
    currentTime = Time.now - @startTime + @skippedTime
    return currentTime
  end
  
  def espera_abelha id, t
    synchronize do
      @numAbelhas += 1
      adiciona_evento @signalAbelhas[id], current_time + t
      if false #TODO: alterar para verificar se nao vai entrar mais abelhas
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
      wake @pq.pop
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
