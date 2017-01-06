#!/usr/bin/env ruby
# -*- mode: ruby -*
# vi: set ft=ruby :

class Board
  #
  #  1 | 2 | 3    Win Rows: [1,2,3],[4,5,6],[7,8,9]
  # ---+---+---
  #  4 | 5 | 6    Win Cols: [1,4,7],[2,5,8],[3,6,9]
  # ---+---+---
  #  7 | 8 | 9    Win Diag: [1,5,9],[3,5,7]
  #
  # Started off tinkering with ways to generate these values on the fly
  # just to have a reason to play with Matrix. However, since we don't
  # need flexibility, hand jamming the values in seemes to be simpler.
  Winners= [[1,2,3],[4,5,6],[7,8,9], # Rows
            [1,4,7],[2,5,8],[3,6,9], # Cols
            [1,5,9],[3,5,7]]         # Diag

  def initialize
    reset
  end

  def reset
    # We use a 10 cell array to avoid mapping our 1-9 choices to 0-8 and
    # back again. The "zeroth" element is simply ignored.
    @cells    = Array.new(10,' ')
    @cells[0] = '*' # mark it unusable
  end

  def place piece, cell
    if cell < 1 || cell > 9
      puts 'Sorry, choice must be in the range from 1 to 9 - try again!'
    elsif @cells[cell] != ' '
      puts 'Sorry, that spot is already occupied - try again!'
    elsif piece.scan(/[xo]/i).empty?
      puts 'Sorry, I only accept X\'s and O\'s - try again!'
    else
      @cells[cell] = piece.upcase
      return true
    end
    false
  end

  def show
    # Use heredoc syntax to keep it simple.
    puts <<-EOB

     1 | 2 | 3      #{@cells[1]} | #{@cells[2]} | #{@cells[3]}
    ---+---+---    ---+---+---
     4 | 5 | 6      #{@cells[4]} | #{@cells[5]} | #{@cells[6]}
    ---+---+---    ---+---+---
     7 | 8 | 9      #{@cells[7]} | #{@cells[8]} | #{@cells[9]}

    EOB
  end

  def win_or_draw?
    return 'X' if check_for_win 'X'
    return 'O' if check_for_win 'O'
    return 'D' if @cells.none? {|c| c == ' '} # Draw on no spaces left
    nil
  end

  private
  def check_for_win piece
    Winners.each do |win|
      return true if win.select{|i| @cells[i] == piece}.count == 3
    end
    false
  end

end
