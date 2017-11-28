require File.expand_path("../board", __FILE__)
require File.expand_path("../code_setter", __FILE__)
require File.expand_path("../ai", __FILE__)
require File.expand_path("../game", __FILE__)
require 'colorize'


game = Game.new
game.start_game
