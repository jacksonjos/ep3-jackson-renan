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

pog = []

# Inicializa monitor que controla o acesso de urso e abelhas ao pote
$monitor = ControladorAcesso.new
$gerenciadorTempo = TimeManager.new
$gerenciadorTempo.init N
$pote = Pote.new
$pote.init(H)
# Inicializando N threads abelha e B threads urso

for id in 0..N-1
  print "Criar abelha #{id}\n"
  
  pog << id
  print "<- LAST HOPE bee\n"
  $abelhas[id] = Abelha.new(t, pog[id])
  print "Abelha #{id} criada, mandar rodar\n"
  tmpThread = Thread.new{
    threadsAbelha << Thread.new {$abelhas[pog[id]].trabalhe}
  }
  tmpThread.join
  print "Abelha #{id} rodando\n"
end

pog = []

for id in 0..B-1
  pog << id
  print pog[id]
  print "<- LAST HOPE urso\n"
  $ursos[id] =  Urso.new(T, id)
  tmpThread = Thread.new{
    threadsUrso << Thread.new {$ursos[pog[id]].durma_e_coma}
  }
  tmpThread.join
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
