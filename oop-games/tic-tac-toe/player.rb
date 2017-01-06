#!/usr/bin/env ruby
# -*- mode: ruby -*
# vi: set ft=ruby :

class Player

  # This is a little overkill but wanted to use as many of the concepts
  # introduced in the Odin ruby OOP section as possible.
  @@player_number = 0

  # The piece should probably be a notion provided by the Board class, but
  # I stuffed it in here to make this more than a simple name wrapper. Yes,
  # this is a bit contrived.
  attr_reader :name
  attr_reader :piece

  def initialize
    @@player_number += 1
    setup
  end

  def setup
    printf "Enter player #{@@player_number}'s name: "
    @name  = gets.chomp.capitalize
    @piece = @@player_number % 2 == 1 ? 'X':'O'
  end

  def name_piece
    "#{name} is #{piece}'s"
  end
end
