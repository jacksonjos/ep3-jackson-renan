# encoding: utf-8

require 'rubygems'
require 'gnuplot'

# Execução de comando no shell
`mkdir graficos`

$mediaVezesAbelhasAcordaramUrsos = []
$mediaVezesUrsosComeram = []
$tempo = []

def cria_graficos
  
  Gnuplot.open do |gp|
    Gnuplot::Plot.new( gp ) do |plot|
      
      plot.title  "Atividade dos ursos"
      plot.output "atividade-dos-ursos"
      plot.terminal 'png'
      plot.xlabel "tempo (s)"
      plot.ylabel "Número médio de vezes que cada urso comeu"
      
      
    plot.data << Gnuplot::DataSet.new( [$tempo, $mediaVezesUrsosComeram] ) do |ds|
        ds.with = "linespoints"
        ds.notitle
      end
    end
  end
  
  Gnuplot.open do |gp|
    Gnuplot::Plot.new( gp ) do |plot|
      
      plot.title  "Atividade das abelhas"
      plot.output "atividade-das-abelhas"
      plot.terminal 'png'
      plot.xlabel "tempo (s)"
      plot.ylabel "Número médio de vezes que cada abelha acordou um urso"
      
      
      plot.data << Gnuplot::DataSet.new( [$tempo, $mediaVezesAbelhasAcordaramUrsos] ) do |ds|
        ds.with = "linespoints"
        ds.notitle
      end
    end
  end
  
  `mv *png graficos`
end
