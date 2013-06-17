# encoding: utf-8

require "rubygems"

require "./abelha.rb"
require "./urso.rb"
require "./meumonitor.rb"
require "./pote.rb"
require "./timemanager.rb"

# Argumentos passados pela linha de comando

N = ARGV[0].to_i
print "N = #{N}\n"
B = ARGV[1].to_i
print "B = #{B}\n"
H = ARGV[2].to_i
print "H = #{H}\n"
t = ARGV[3].to_i
print "t = #{t}\n"
T = ARGV[4].to_i
print "T = #{T}\n"

threadsAbelha = []
threadsUrso = []

$abelhas = []
$ursos = []

# Inicializa monitor que controla o acesso de urso e abelhas ao pote
$monitor = ControladorAcesso.new
$gerenciadorTempo = TimeManager.new
$gerenciadorTempo.init N
$pote = Pote.new
$pote.init(H)
# Inicializando N threads abelha e B threads urso

for id in 0..N-1
  $abelhas[id] =  Abelha.new(t, id)
  threadsAbelha << Thread.new {$abelhas[id].trabalhe}
end

for id in 0..B-1
  $ursos << Urso.new(T, id)
  threadsUrso << Thread.new {$ursos[id].durma_e_coma}
end

Thread.new{
  while true
    pizza = 1
  end
}

# O método join garante que o script finaliza apenas quando a execução
# de todas as threads na lista thr é encerrada 
threadsAbelha.each{ |thr| thr.join }
threadsUrso.each{ |thr| thr.join }
