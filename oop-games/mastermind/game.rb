#!/usr/bin/env ruby
# -*- mode: ruby -*
# vi: set ft=ruby :

require './board'
require './breaker'

class Game

  def initialize
    @board = Board.new
  end

  def show_results
    printf "\n\n\n%s\n\n", @board.solved? ? 'We have a winner!!!' :
        "You lose, the code was [#{@board.get_code}], try again!"
  end

  # Computer generates pegs and the player guesses
  def breaker
    @board.reset.show true
    while @board.running?
      user_guess = @board.prompt
      return if user_guess == 'Q'
      @board.guess user_guess
    end
    show_results
  end

  # A random board is generated and the computer attempts to solve
  def maker
    @board.reset.show true
    Breaker.new(@board).solve
    show_results
  end

  def run
    print "Are duplicate pegs allowed [y/N]? "
    Peg.duplicates = (gets.chomp.upcase == 'Y')

    print "Do you want to be the code Breaker or code Maker [B/M]? :"
    case gets.chomp.upcase
    when 'B' then breaker
    when 'M' then maker
    else
      puts "\nUnknown selection - exiting...\n\n"
    end
  end
end

Game.new.run
