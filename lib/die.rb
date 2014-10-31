
class Die

  # Class to define the behavior of a physical die.

  # Instance variables

  @id     # Integer id
  @value  # Face value (1-6)

  # Instance methods

  def initialize(id)
    # Class constructor
    @id = id
    @value = 0  # not yet rolled
  end

  attr_reader :value
  attr_reader :id

  def reset
    @value = 0
  end # method

  def roll
    @value = rand 1..6
  end # method

end # class
