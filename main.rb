# encoding: utf-8

require "rubygems"

require "./abelha.rb"
require "./urso.rb"
require "./meumonitor.rb"
require "./pote.rb"
require "./timemanager.rb"
require "./graphics.rb"

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

$duracao = 60


# Inicializa monitor que controla o acesso de urso e abelhas ao pote
$monitor = ControladorAcesso.new
$gerenciadorTempo = TimeManager.new
$pote = Pote.new H

# Inicializando N threads abelha e B threads urso

for id in 0..N-1
  tmpThr = Thread.new {
    $abelhas[id] = Abelha.new(t, id)
    #Gambiarra para rodar o objeto certo
    i = id.to_s.clone.to_i
    threadsAbelha << Thread.new {$abelhas[i].trabalhe}
  }
  tmpThr.join
end

for id in 0..B-1
  tmpThr = Thread.new {
    $ursos[id] =  Urso.new(T, id)
    i = id.to_s.clone.to_i
    threadsUrso << Thread.new {$ursos[i].durma_e_coma}
  }
  tmpThr.join
end


#Se nao tem threads ativas, o ruby acha que entrou em deadlock
pogThread = Thread.new{
  while true
    pog = 1
  end
}

sleep $duracao

# O método join garante que o script finaliza apenas quando a execução
# de todas as threads na lista thr é encerrada 
threadsAbelha.each{ |thr| Thread.kill(thr) }
threadsUrso.each{ |thr| Thread.kill(thr) }
Thread.kill (pogThread)

cria_graficos
