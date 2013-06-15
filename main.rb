# encoding: utf-8

require "rubygems"
require "monitor"

require "abelha.rb"
require "urso.rb"
require "monitor.rb"

# Argumentos passados pela linha de comando

N = ARGV[0].to_i
B = ARGV[1].to_i
H = ARGV[2].to_i
t = ARGV[3].to_i
T = ARGV[4].to_i

threadsAbelha = []
threadsUrso = []

#Inicializa monitor
monitor = Monitor.new(H, N, B)

# Inicializando N threads abelha e B threads urso

1..N.each{
  threadsAbelha << Thread.new {abelha t}
}

1..B.each{
  threadsUrso << Thread.new {urso T}
}

# o método join garante que o script finaliza apenas quando a execução
# de todas as threads na lista thr é encerrada 
threadsAbelha.each{ |thr| thr.join }
threadsUrso.each{ |thr| thr.join }
