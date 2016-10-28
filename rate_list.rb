require_relative 'rate'

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
