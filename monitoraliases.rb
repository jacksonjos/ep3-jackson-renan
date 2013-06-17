# -*- coding: utf-8 -*-

require 'rubygems'
require "monitor"

class Monitor
  # renomeando nome de métodos do ruby para os nomes exigidos no EP

  def wait(condvar)
    condvar.wait
  end

  def signal(condvar)
    condvar.signal
  end

  def signal_all(condvar)
    condvar.broadcast
  end
end
