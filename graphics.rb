# encode utf-8

require 'rubygems'
require 'gnuplot'
require ''        # Arquivo onde ficam os vetores globais

#Exemplo de gráfico que serve para o nosso problema

Gnuplot.open do |gp|
  Gnuplot::Plot.new( gp ) do |plot|
  
    plot.title  "Array Plot Example"
    plot.xlabel "x"
    plot.ylabel "x^2"
    
    x = (0..50).collect { |v| v.to_f }
    y = x.collect { |v| v ** 2 }

    plot.data << Gnuplot::DataSet.new( [x, y] ) do |ds|
      ds.with = "linespoints"
      ds.notitle
    end
  end
end