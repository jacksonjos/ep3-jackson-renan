
class TimeManager
  
  skippedTime = 0
  
  def init
    startTime = curSystemTime
  end
  
  def curTime
    return curSystemTime - startTime + skippedTime
  end
  
  def skipTime t
    skippedTime += t
  end
end
