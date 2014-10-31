
# Ruby tutorial via a simple game of shut-the-box
# http://en.wikipedia.org/wiki/Shut_the_Box

require_relative 'lib/game.rb'

sbgame = Game.new

# Make a turn until the game is over
while ! sbgame.over?
  sbgame.turn
end

# If here, game is over
sbgame.print_game_over
