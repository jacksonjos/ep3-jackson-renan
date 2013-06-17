# encoding: utf-8

require "rubygems"

require "./abelha.rb"
require "./urso.rb"
require "./meumonitor.rb"
require "./pote.rb"
require "./timemanager.rb"

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

pog = []

# Inicializa monitor que controla o acesso de urso e abelhas ao pote
$monitor = ControladorAcesso.new
$gerenciadorTempo = TimeManager.new
$gerenciadorTempo.init N
$pote = Pote.new
$pote.init(H)

# Inicializando N threads abelha e B threads urso

for id in 0..N-1
  
  pog << id
  $abelhas[id] = Abelha.new(t, pog[id])
  tmpThread = Thread.new{
    threadsAbelha << Thread.new {$abelhas[pog[id]].trabalhe}
  }
  tmpThread.join
end

pog = []

for id in 0..B-1
  pog << id
  $ursos[id] =  Urso.new(T, id)
  tmpThread = Thread.new{
    threadsUrso << Thread.new {$ursos[pog[id]].durma_e_coma}
  }
  tmpThread.join
end


# O método join garante que o script finaliza apenas quando a execução
# de todas as threads na lista thr é encerrada 
threadsAbelha.each{ |thr| thr.join }
threadsUrso.each{ |thr| thr.join }
