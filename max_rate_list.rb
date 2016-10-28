require_relative 'max_rate'

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
