# -*- coding: utf-8 -*-
require 'rubygems'
require 'time'
require 'priority_queue'

# Neste EP cada unidade de tempo t gasta pelas das threads para realizar
# as tarefas que lhes cabem equivale a um segundo

# A bilbioteca (gem) priority queue é uma simples fila de prioridades
# que implementa uma fila em que os objetos são ordenados com prioridades
# crescentes. No caso a prioridade consiste de valores crescentes.

# O método to_i devolve o valor inteiro de uma variável/objeto.

class TimeManager
  
  @skippedTime = 0
  @pq = PriorityQueue.new

  def init
    # Time.new inicializa uma variável com o tempo corrente
    @startTime = Time.new
    # Como a unidade de tempo implementada foi de 1 segundo o sleep é implementado
    # para que a thread faça a checagem da fila uma vez por segundo. Afinal, quando
    # há diferença entre a prioridade (tempo) entre os objetos ela será medida entre
    # segundos.
    manager = Thread.new{

      sleep(1)
      while @pq.min_priority <= Time.now
        wake @pq.pop
      end
    }
  end
  
  def skipAteEvento
    skipTime @pq.min_priority - Time.now
  end

  def adicionaEvento t, priority
    @pq.push t, t.to_i
  end

  def curTime
    currentTime = Time.new - @startTime + @skippedTime
    return currentTime
  end
  
  def skipTime t
    @skippedTime += t
  end
  
  def encerra
    while !@pq.empty?
      wake @pq.pop
    end
    Thread.kill manager
  end
end
