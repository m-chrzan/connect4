#!/bin/ruby
require './lib/connect4'

def next_turn game
    move = gets.to_i

    begin
        game.drop(move)
    rescue ColumnFilled
        puts game
        print "Column filled. #{pretty_player(game)}, try again: "
        next_turn game
    rescue ColumnOutOfBoard
        puts game
        print "That's not a column. #{pretty_player(game)}, try again: "
        next_turn game
    end
end

def pretty_player game
    if game.current_player == :player1
        "Player 1"
    else
        "Player 2"
    end
end

if $0 == __FILE__
    game = Game.new

    loop do
        break if game.status != :continue

        puts game
        print "#{pretty_player(game)}'s turn: "

        next_turn game
    end

    puts game
    case(game.status)
    when :player1won
        puts "Player 1 won!"
    when :player2won
        puts "Player 2 won!"
    when :draw
        puts "Draw."
    end
end
