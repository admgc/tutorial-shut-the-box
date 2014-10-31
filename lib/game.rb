
class Game

  # Class to define an instance of the shut the box game

  require_relative 'die.rb'
  require_relative 'tile.rb'

  # Instance variables

  @over    # Boolean for game over or not
  @dice    # Array of n die objects
  @tiles   # Array of m tile objects

  # Instance methods

  def initialize( num_dice=2, num_tiles=9 )
    # Class constructor
    @over = false
    @dice = Array.new(num_dice){ |i| Die.new(i+1) }
    @tiles = Array.new(num_tiles){ |i| Tile.new(i+1) }
    puts "\nWelcome to Shut the Box. Type 'quit' at any time to exit.\n"
    self.roll_dice   # Must roll to initialize game before first 'game over' check
  end # method

  # Tile methods

  def open_tiles
    # Array of open tile objects
    @tiles.map{ |t| t if t.open? }.compact
  end # method

  def open_tile_ids
    # Array of open tile ids
    @tiles.map{ |t| t.id if t.open? }.compact
  end # method

  def open_tile_sum
    # Sums value of open tiles
    self.open_tile_ids.inject(0, :+)
  end

  def open_tile_combination_sums
    # Returns every possible sum of currently-open tiles. Used to determine if game is over.
    # e.g. if tiles 1, 2, & 7 are open, returns [ 1, 2, 7, 3, 8, 9, 10 ]
    sums  = Array.new
    depth = self.open_tiles.length
    while depth > 0
      combos = self.open_tiles.combination( depth ).to_a
      combos.each{ |combo| sums << combo.inject(0){ |total, t| total + t.id } }
      depth -= 1
    end # while
    sums.uniq.sort
  end # method

  # Dice methods

  def dice_to_roll
    # Returns array of dice to roll. Roll die 1&2 only if tile 7, 8, or 9 is open
    self.open_tiles.any?{ |t| t.id > 6 } ? @dice : @dice.select{ |d| d if d.id==1 }
  end # method

  def dice_total
    # Sums face value of dice
    @dice.inject(0){ |total, d| total + d.value }
  end # method

  def roll_dice
    @dice.each{ |d| d.reset }
    self.dice_to_roll.each{ |d| d.roll }
  end # method

  # Game methods

  def turn
    # Logic for a game turn

    # Roll dice
    puts "\nRolling dice for next round..."
    self.roll_dice
    self.print_dice_state

    # Check if the game is over
    self.compute_game_over
    return if self.over?

    # Get player input
    choices = self.get_player_choices

    # Close some tiles
    choices.each{ |c| @tiles.select{ |t| t.id==c }.first.close }

  end # method

  def compute_game_over
    # Logic to see if game is over or not. Game is over if roll_total is not
    # contained in open tile value combinations
    @over = ! open_tile_combination_sums.include?(dice_total)
  end # method

  def print_dice_state
    # Displays value for each die and the total
    puts ""
    @dice.each{ |d| puts "Die #{d.id}: #{ d.value != 0  ? d.value : 'N/A' }" }
    puts "Roll total: #{self.dice_total}"
    puts ""
  end # method

  def get_player_choices

    # Returns an array of user-selected tiles to close

    choices = Array.new

    puts "Please select a tile from the following to close: #{ open_tiles.map{ |t| t.id }.join(', ') }"

    while choice = gets.chomp  # loop while getting user input, remove carriage return

      # Quit maybe
      if choice == 'quit'
        @over = true
        break
      end

      # Reprompt if user input can't be cast to an integer
      next unless Integer(choice) rescue false

      # User input can be cast
      choice = choice.to_i
      chosen_tile = @tiles.select{ |t| t.id==choice }.first

      # Make sure tile selected can be closed.
      if chosen_tile.nil? || chosen_tile.closed?
        puts "\nHmm. That tile is already closed or invalid. Please select again:"
        next
      end

      # Make sure the user hasn't already chosen to close that tile this round
      if choices.include?(choice)
        puts "\nHmm. You've already asked to close that tile this round. Please select again:"
        next
      end

      # User input okay, make note of it
      choices << choice.to_i
      sum_choices = choices.inject(0, :+)

      # See if we need another choice
      if sum_choices == self.dice_total
        puts "\nSuper, thanks!"
        break
      else
        puts "\nOkay, great. Please pick another tile to close."
      end # if

      # Check if user has requested too many tiles
      if sum_choices > self.dice_total
        choices.clear
        puts "\nHmm. You've selected too many tiles (selections must sum to #{self.dice_total}). Let's try again."
        puts "Please select a tile from the following to close: #{ open_tiles.map{ |t| t.id }.join(', ') }"
        self.print_dice_state
        next
      end # if

    end # while

    return choices

  end # method

  def status
    # Logic for whether the box is shut or not
    self.open_tiles.empty? ? 'shut' : 'open'
  end # method

  def open?
    # Returns boolean for if box is open
    self.status == 'open'
  end # method

  def over?
    # Returns boolean for if game is over or not
    @over == true
  end # method

  def print_game_over
    # Prints end game outcome
    puts self.open? ? "Game over! Open tile ids: #{ self.open_tile_ids.join(', ') }. Final score: #{self.open_tile_sum}." : "You shut the box! Winner!"
  end # method

end # class
