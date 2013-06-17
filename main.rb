# encoding: utf-8

require "rubygems"

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

# Inicializa monitor que controla o acesso de urso e abelhas ao pote
$monitor = ControladorAcesso.new(N, B)
$gerenciadorTempo = TimeManager.new(N)
$pote = Pote.new(H)
# Inicializando N threads abelha e B threads urso

1..N.each{
  threadsAbelha << Thread.new {abelha = Abelha.new(t) abelha.trabalhe}
}

1..B.each{
  threadsUrso << Thread.new {urso = Urso.new(T) urso.durma_e_coma}
}

# O método join garante que o script finaliza apenas quando a execução
# de todas as threads na lista thr é encerrada 
threadsAbelha.each{ |thr| thr.join }
threadsUrso.each{ |thr| thr.join }
