#!/usr/bin/ruby

require_relative 'simulator'

simulator = Simulator.new 1000, MaxRateList.new, Printer.new
simulator.run
