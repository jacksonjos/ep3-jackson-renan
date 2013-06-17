# encoding: utf-8

require "rubygems"

require "./monitoraliases.rb"
require "./pote.rb"


class ControladorAcesso < Monitor
  
  # new_cond é um método do monitor que cria a variável de condição
  def initialize 
    # Número de abelhas depositando mel no pote
    @numAbelhas = 0
    # Boolean que é usado para saber se há um urco comendo o mel do pote ou não
    @nenhumUrso = true
    # Variáveis de condição
    @entraUrso =  new_cond
    @entraAbelha = new_cond
  end

  def abelha_request
    
    synchronize do
      $abelhas[i].estado = :voando_esperando_espaco_para_depositar_mel
      while !(@nenhumUrso && $pote.pode_entrar?)
        if !@nenhumUrso
          $abelhas[i].estado = :parada_esperando_urso_comer_mel
        end
        wait(@entraAbelha) #
      end
      $abelhas[i].estado = :depositando_mel_no_pote
      
      $pote.insere_abelha
    end
  end
  
  def abelha_free
    
    synchronize do
      $pote.remove_abelha
      if $pote.pronto?
        # se abelha->rodando é verdade, enchendo @pote, else, esperando vaga
        $abelhas[i].conta_urso_acordado
        signal(@entraUrso)
        
      elsif !$pote.cheio?
        signal(@entraAbelha)
        $abelhas[i].estado = :buscando_mel
      end
      
    end
  end

  # Thread urso recebe permissão para executar (comer mel do pote)
  def urso_request
    
    synchronize do
      wait(@entraUrso)
    end
  end

  # Thread urso avisa as threads abelha que elas podem voltar a executar
  # (encher o pote)
  def urso_free
    
    synchronize do
      signal_all(@entraAbelha)
    end
  end 
end
