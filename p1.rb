#!/usr/bin/ruby

# Represents a rate index and a rate
class MaxRate
  attr_accessor :index
  attr_accessor :rate

  def initialize(index, rate)
    @index = index
    @rate = rate
  end
end

# First class Max Rate collection
class MaxRateList
  def initialize
    @max_rates = []
    @index = 0
  end

  def set(index, rate)
    @max_rates.push(MaxRate.new(index, rate))
  end

  def get(packet_index)
    next_rate_change = @max_rates[@index + 1].index unless @index + 1 >= size
    return @max_rates[size - 1].rate if next_rate_change.nil?
    rate = if packet_index < next_rate_change
             @max_rates[@index].rate
           else
             @max_rates[@index + 1].rate
             @index += 1
           end
    rate
  end

  def decrease_rate
    @index -= 1 unless @index.zero?
  end

  def size
    @max_rates.size
  end
end

# Printer for printing successes, failures, and summary
class Printer
  def initialize
    @successes = 0
    @failures = 0
    @index = 1
  end

  def print_success
    @successes += 1
    puts "#{@index}: Success\n\n"
    @index += 1
  end

  def print_failure
    @failures += 1
    puts "#{@index}: Failure\n\n"
    @index += 1
  end

  def print_summary
    puts '========================='
    puts "Failures: #{@failures}"
    puts "Successes: #{@successes}"
    puts "Total packets: #{@failures + @successes}"
  end
end

# Represents a persistent datarate
class Rate
  def initialize(printer)
    @success_threshold = 3
    @failure_threshold = 2
    @current_success = 0
    @current_failure = 0
    @printer = printer
  end

  def reset
    @current_success = 0
    @current_failure = 0
  end

  def succeed
    @printer.print_success
    @current_failure = 0
    @current_success += 1
    check_success_threshold
  end

  def fail
    @printer.print_failure
    @current_success = 0
    @current_failure += 1
    check_failure_threshold
  end

  def increase_success_threshold
    @success_threshold += 1
  end

  private

  def check_success_threshold
    return true if @current_success >= @success_threshold
    false
  end

  def check_failure_threshold
    increase_success_threshold if brand_new?
    return true if @current_failure >= @failure_threshold
    false
  end

  def brand_new?
    @current_failure.zero? && @current_success.zero?
  end
end

# First class rate collection
class RateList
  def initialize(max_rate_list, printer)
    @max_rate_list = max_rate_list
    @rate_list = []
    @max_rate_list.size.times do
      @rate_list.push Rate.new(printer)
    end
    @rate_index = 0
    @current_rate = @rate_list[@rate_index]
  end

  def try(packet_index)
    success = try_packet packet_index
    update_current_rate
    success
  end

  private

  def try_packet(packet_index)
    max_rate = @max_rate_list.get packet_index
    success = @rate_index <= max_rate
    @should_go_up = @should_go_down = false
    @should_go_up = @current_rate.succeed if success
    @should_go_down = @current_rate.fail unless success
    success
  end

  def update_current_rate
    maybe_increase_rate
    maybe_decrease_rate
  end

  def maybe_increase_rate
    return unless @should_go_up
    @current_rate.reset
    @rate_index += 1
    @current_rate = @rate_list[@rate_index]
  end

  def maybe_decrease_rate
    return unless @should_go_down
    @current_rate.reset
    @rate_index -= 1
    @current_rate = @rate_list[@rate_index]
    @current_rate.increase_success_threshold
  end
end

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

  def run
    @n.times do |i|
      @rate_list.try i
    end
    @printer.print_summary
  end

  # def run
  #   i = 0
  #   while @successes < @needed_successes
  #     success = @rate_list.try i
  #     @successes += 1 if success
  #   end
  #   @printer.print_summary
  # end
end

simulator = Simulator.new 1000, MaxRateList.new, Printer.new
simulator.run
