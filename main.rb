# encoding: utf-8

require "rubygems"

require "abelha.rb"
require "urso.rb"
require "monitor.rb"
require "pote.rb"
require "timemanager.rb"

# Argumentos passados pela linha de comando

N = ARGV[0].to_i
B = ARGV[1].to_i
H = ARGV[2].to_i
t = ARGV[3].to_i
T = ARGV[4].to_i

threadsAbelha = []
threadsUrso = []

$abelhas = []
$ursos = []

# Inicializa monitor que controla o acesso de urso e abelhas ao pote
$monitor = ControladorAcesso.new(N, B)
$gerenciadorTempo = TimeManager.new(N)
$pote = Pote.new(H)
# Inicializando N threads abelha e B threads urso

1..N.each{ |id|
  $abelhas << Abelha.new(t, id)
  threadsAbelha << Thread.new {$abelhas[id].trabalhe}
}

1..B.each{ |id|
  $ursos << Urso.new(T, id)
  threadsUrso << Thread.new {urso = $ursos[id].durma_e_coma}
}

# O método join garante que o script finaliza apenas quando a execução
# de todas as threads na lista thr é encerrada 
threadsAbelha.each{ |thr| thr.join }
threadsUrso.each{ |thr| thr.join }
