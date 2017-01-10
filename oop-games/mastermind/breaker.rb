#!/usr/bin/env ruby
# -*- mode: ruby -*
# vi: set ft=ruby :

class Breaker # try varying approaches

  def initialize board
    @board = board
  end

  def random
    while @board.running?
      @board.guess Peg.randomize.join
      sleep 1.0 # act like we're thinking...
    end
  end

  def methodical
    solutions = %w(R G Y B M C).repeated_permutation(4)
    puts "Someday, I will implement this..."
  end

  def solve
    print 'Random or Methodical guesses? [R/M]: '
    case gets.chomp.upcase
    when 'R' then random
    when 'M' then methodical
    else
      puts 'You had one job...'
      return
    end
  end

end
