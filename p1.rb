#!/usr/bin/ruby

require_relative 'simulator'

iterations = 1000
simulator = Simulator.new iterations, MaxRateList.new, Printer.new
simulator.run
