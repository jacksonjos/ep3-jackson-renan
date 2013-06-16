
class TimeManager
  
  skippedTime = 0
  pq = PriorityQueue.new

  def init
    startTime = curSystemTime
    Thread.new{
      sleep(dt)
      while pq.minRank <= curTime
        wake pq.remove
      end
    }
  end
  
  def skipAteEvento
    skipTime pq.minRank - curTime
  end

  def adicionaEvento t, rank
    pq.adiciona t, rank
  end

  def curTime
    return curSystemTime - startTime + skippedTime
  end
  
  def skipTime t
    skippedTime += t
  end
  
  def encerra
    while !pq.empty
      wake pq.remove
    end
    #mata a thread que ele cria?
  end
end
