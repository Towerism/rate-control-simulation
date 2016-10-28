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
