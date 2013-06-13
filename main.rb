
require "rubygems"

require "abelha.rb"
require "urso.rb"
require "monitor.rb"

N = ARGV[0].to_i
B = ARGV[1].to_i
H = ARGV[2].to_i
t = ARGV[3].to_i
T = ARGV[4].to_i

threadsAbelha = []
threadsUrso = []

#Inicializa monitor (H)

1..N.each{
  threadsAbelha << Thread.new {abelha t}
}

1..B.each{
  threadsUrso << Thread.new {urso T}
}


threadsAbelha.each{ |thr| thr.join }
threadsUrso.each{ |thr| thr.join }
