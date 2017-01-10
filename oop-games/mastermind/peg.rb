#!/usr/bin/env ruby
# -*- mode: ruby -*
# vi: set ft=ruby :

class Peg

  ColorCode = {
    :red    => 'R',
    :green  => 'G',
    :yellow => 'Y',
    :blue   => 'B',
    :magenta=> 'M',
    :cyan   => 'C',
  }

  attr_reader :color

  # Controls whether or not a colored peg may be used more than once in a
  # code, or if they must remain unique (easier).
  @@duplicates = false

  def self.duplicates= dups
    @@duplicates = dups
  end

  # The color indicator can be a symbol or a character as dictated by the
  # ColorCode hash.
  def initialize cid
    @color = self.class.to_sym(cid)
  end

  def self.choices
    self.colorize ColorCode.values.sort
  end

  def self.randomize pegs = 4
    if @@duplicates
      pegs.times.map { Peg::ColorCode.values.sample }
    else
      Peg::ColorCode.values.sample(pegs)
    end
  end

  def self.to_sym cid
    case cid
    when Symbol #already a symbol, just validate it
      ColorCode[cid].nil? ? nil : cid
    when String
      ColorCode.key(cid.upcase)
    else
      nil
    end
  end

  def self.valid? cid
    ! self.to_sym(cid).nil?
  end

  # Play around with ANSI color just for fun!
  #
  # See this for more info => https://en.wikipedia.org/wiki/ANSI_escape_code
  ColorANSI = {
    'R' => '31',
    'G' => '32',
    'Y' => '33',
    'B' => '34',
    'M' => '35',
    'C' => '36',
  }

  def self.colorize pegs
    pretty_pegs = ""
    pegs.each do |p|
      pretty_pegs += "\e[1;#{ColorANSI[p]}m#{p}\e[0m "
    end
    pretty_pegs.strip
  end

end
