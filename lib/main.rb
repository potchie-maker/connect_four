require_relative 'connect_four'

game = ConnectFour.new

game.play(Player.new('Player 1', 'red'), Player.new('Player 2', 'black'))