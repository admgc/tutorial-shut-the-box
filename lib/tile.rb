
class Tile

  # Class to define the behavior of a 'tile' in the 'shut the box' game.

  # Instance variables
  @id       # integer identifier
  @open     # boolean open or closed

  # Instance methods

  def initialize(id)
    # Class constructor
    @id = id
    @open = true
  end # method

  attr_reader :id
  attr_reader :status

  def close
    # Changes status of tile to closed
    @open = false
  end # method

  def open
    # Changes status of tile to open
    @open = true
  end # method

  def open?
    # Returns boolean status of tile
    @open
  end # method

  def closed?
    # Returns boolean status of tile
    !@open
  end # method

end # class
