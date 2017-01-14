#!/usr/bin/env ruby
# -*- mode: ruby -*
# vi: set ft=ruby :

require 'json'

# We only support the notion of one save file, which gets deleted if the
# word is guessed or a new game is started.
#
class Hangman

  SaveFile = '.saved_game'

  def initialize new_game = true
    new_game ? reset : deserialize
  end

  def reset
    File.delete SaveFile if File.exists? SaveFile
    words = Array.new
    File.foreach('5desk.txt') do |word|
      word.chomp!
      words << word if word.length >= 5 &&
        word.length <= 12 &&
        word.scan(/^[A-Z]/).length == 0 # no proper nouns
    end

    @the_word = words.sample
    @answer   = @the_word.split('')
    @hints    = Array.new(@answer.length,'_')
    @guesses  = Array.new
    @turns    = 10
  end

  def serialize
    {'the_word' => @the_word,
     'hints'    => @hints,
     'guesses'  => @guesses,
     'turns'    => @turns,
    }.to_json
  end

  def deserialize
    # Just reset if a save file does not exist
    if !File.exists?(SaveFile)
      reset
      return
    end

    JSON.load(File.open(SaveFile, 'r').read).each do |var,val|
      self.instance_variable_set '@'+var,val
    end
    @answer = @the_word.split('')
  end

  def save_and_quit
    File.open(SaveFile, 'w') {|save| save.write(serialize)}
    Process.exit
  end

  def show_progress
    printf "\n Used: #{@guesses.sort.join(' ')}\n"
    printf " Hint: #{@hints.join(' ')}\n"
    if @answer == @hints
      puts "\nWe have a winner, the word was #{@the_word}!\n\n"
      File.delete SaveFile if File.exists? SaveFile
      Process.exit
    end
    printf "#{@turns} misses left - your next guess or ! to save and quit? "
  end

  def not_a_loser
    return true if @turns > 0
    puts "\nThe word was #{@the_word}, you lose!\n\n"
    false
  end

  def run
    while not_a_loser do
      show_progress
      guess = gets.chomp.downcase
      next if guess == ''
      next if @guesses.include?(guess)
      save_and_quit if guess == '!'
      hits = @answer.each_index.select {|i| guess == @answer[i]}
      if hits.length > 0
        hits.each {|i| @hints[i] = guess}
      else
        @turns -= 1
      end
      @guesses << guess
    end
  end

end

printf 'Welcome to Hangman! Play a New game or restart a Saved? [N/S]:'

case gets.chomp.upcase
when 'N' then Hangman.new.run
when 'S' then Hangman.new(false).run
else
  puts "\nNot sure what to do with that selection.\n\n"
end

