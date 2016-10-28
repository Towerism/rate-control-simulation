# Printer for printing successes, failures, and summary
class Printer
  def initialize
    @successes = 0
    @failures = 0
    @index = 1
  end

  def print_success(rate_index)
    @successes += 1
    puts "#{@index}: Success, Rate: #{rate_index}\n\n"
    @index += 1
  end

  def print_failure(rate_index)
    @failures += 1
    puts "#{@index}: Failure, Rate: #{rate_index}\n\n"
    @index += 1
  end

  def print_summary
    puts '========================='
    puts "Failures: #{@failures}"
    puts "Successes: #{@successes}"
    puts "Total packets: #{@failures + @successes}"
  end
end
