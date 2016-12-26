#!/usr/bin/env ruby
# -*- mode: ruby -*
# vi: set ft=ruby :

def substrings words, dictionary
  hits = Hash.new
  dictionary.each do |lookup|
    hits[lookup] = words.scan(/#{lookup}/i).length
  end
  hits.delete_if {|k,v| v == 0} # squeeze out the empties
end

# Tests and answers.
dictionary = ["below","down","go","going","horn","how","howdy","it","i",
              "low","own","part","partner","sit" ]

puts "\nExpect 2 tests to run and PASS\n"
[
  [ "below",
   {"below"=>1, "low"=>1},
  ],
  [ "Howdy partner, sit down! How's it going?",
   {"down"=>1, "how"=>2, "howdy"=>1,"go"=>1, "going"=>1,
    "it"=>2, "i"=> 3, "own"=>1,"part"=>1,"partner"=>1,"sit"=>1}
  ],
].each do |words,expected|
  printf "%s\n", substrings(words,dictionary) === expected ? "PASS":"FAIL"
end
puts
