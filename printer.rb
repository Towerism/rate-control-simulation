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
