#!/usr/bin/env ruby
# -*- mode: ruby -*
# vi: set ft=ruby :

require './board'
require './player'

class Game

  def initialize
    @board  = Board.new
    @player = Array.new
    @player << Player.new << Player.new
    @turn_idx = 0

    puts "\nPlayer #{@player[0].name_piece} and #{@player[1].name_piece}"
  end

  def play
    @board.show
    while true
      name = @player[@turn_idx].name # just for readability
      piece= @player[@turn_idx].piece

      printf "Place your #{piece}, #{name}: "
      if @board.place piece, gets.chomp.to_i
        @board.show
        case @board.win_or_draw?
        when nil
          @turn_idx = (@turn_idx == 0 ? 1 : 0) # next_turn
        when 'D'
          puts "\nThe game is a draw.\n\n"
          break
        else
          puts "\n#{name} wins!\n\n"
          break
        end
      end
    end
  end

end

# The Main Game Loop

Game.new.play
