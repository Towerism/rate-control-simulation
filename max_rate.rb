# Represents a rate index and a rate
class MaxRate
  attr_accessor :index
  attr_accessor :rate

  def initialize(index, rate)
    @index = index
    @rate = rate
  end
end
