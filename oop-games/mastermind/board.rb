#!/usr/bin/env ruby
# -*- mode: ruby -*
# vi: set ft=ruby :

require './peg'

class Board

  @@max_pegs  = 4 # Need more logic if we want to make this 4,6 or 8
  @@max_turns = 12

  attr_reader :pegs # allow getting for test/debug

  def initialize
    reset
    @debugging = !ENV['MM_CHEAT'].nil?
    puts "*** DEBUG ENABLED ***" if @debugging
  end

  def reset preset = nil
    @solved  = false
    @guesses = Array.new
    @pegs    = preset.nil? ? Peg.randomize : preset.upcase.split(//)

    # Use pmax to limit the number of times a peg can be reported per turn.
    @pmax = Hash.new 0
    @pegs.each {|p| @pmax[p] += 1}
    self # supports method daisy chaining
  end

  def running?
    !@solved && (@guesses.length < @@max_turns)
  end

  def solved?
    @solved
  end

  def get_code
    Peg.colorize(@pegs)
  end

  def prompt
    puts  "  Solution [#{get_code}]" if @debugging
    print "Your guess [#{Peg::choices}]? \e[0J"
    gets.chomp.upcase.gsub(/\s+/,'') # Upcase and squeeze white space
  end

  def guess guessed
    return [] if guessed.length != @@max_pegs
    guesses = (guessed.is_a? Array) ? guessed : guessed.split(//)
    return [] if guesses.any? {|p| !Peg.valid? p}

    exactly, nearly = quality_of guesses

    # Insert these guesses at the front of the array with the turn number.
    @guesses.unshift [ @guesses.length+1, exactly, nearly, guesses ]
    show
    @solved = exactly == @@max_pegs
  end

  # Busting this logic out to make it easier to test against (see below)
  def quality_of guesses
    pcnt = Hash.new 0 # tracks number of times a peg tallies

    # Look for exact matches first.
    guesses.zip(@pegs).each {|guess,peg| pcnt[peg] += 1 if peg == guess}
    exactly = pcnt.values.reduce(:+) || 0 # use stuff we learnt

    # Now count close matches.
    guesses.each {|peg| pcnt[peg] += 1 if (@pegs.include? peg) &&
                                          (pcnt[peg] < @pmax[peg])}
    nearly = pcnt.length == 0? 0 : pcnt.values.reduce(:+) - exactly

    [exactly, nearly]
  end

  def show clear_screen = false
    puts "\e[2J" if clear_screen
    puts "\e[0;0f"
    printf "\n+----+-----------+-------+\n"
    (@@max_turns-@guesses.length).times {puts '|    |           |       |'}
    @guesses.each do |turn,exact,near,guesses|
      printf "| %2d |  %7s  |  %s  |\n",
             turn, Peg.colorize(guesses), color_score(exact,near)
    end
    printf "+----+-----------+-------+\n\n"
    self
  end

  private
  def color_score e, n
    "\e[1;31m#{e}\e[0m.#{n}"
  end

end

# Only run the embedded guess quality testing here.
if __FILE__ == $0
  board = Board.new.reset 'BCBY'

  puts "\n#{board.get_code} <= Answer\n\n"
  [
    ['MMGG', 0, 0],
    ['BBYY', 2, 1],
    ['BBGG', 1, 1],
    ['CCCC', 1, 0],
    ['YYYG', 0, 1],
    ['BCBG', 3, 0],
    ['YBCB', 0, 4],
  ].each do |guess_str,exactly,nearly|
    guess = guess_str.split(//)
    (qExactly, qNearly) = board.quality_of guess
    printf "#{Peg.colorize(guess)} #{qExactly}.#{qNearly} == #{exactly}.#{nearly} ? %s\n",
      (exactly == qExactly && nearly == qNearly ? "PASS" : "FAIL")
  end
  puts
end
