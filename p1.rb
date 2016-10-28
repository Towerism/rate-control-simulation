#!/usr/bin/ruby

require_relative 'max_rate_list'
require_relative 'rate_list'
require_relative 'printer'

# Runs a packet simulation
class Simulator
  def initialize(n, max_rate_list, printer)
    @n = n
    @rate_index = 0
    @successes = 0
    @max_rate_list = max_rate_list
    @printer = printer
    setup_rate_list
  end

  def setup_rate_list
    @max_rate_list.set 0, 1
    @max_rate_list.set 16, 2
    @max_rate_list.set 26, 1
    @max_rate_list.set 30, 2
    @rate_list = RateList.new @max_rate_list, @printer
  end

  # run until @n successes rather than @n attempts
  def set_success_mode
    @success_mode = true
  end

  def run
    return run_normal_mode unless @success_mode
    run_success_mode
  end

  private

  def run_normal_mode
    @n.times do |i|
      @rate_list.try i
    end
    @printer.print_summary
  end

  def run_success_mode
    i = 0
    while @successes < @n
      success = @rate_list.try i
      @successes += 1 if success
    end
    @printer.print_summary
  end
end

simulator = Simulator.new 1000, MaxRateList.new, Printer.new
# simulator.set_success_mode
simulator.run
