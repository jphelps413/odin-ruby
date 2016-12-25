#!/usr/bin/env ruby
# -*- mode: ruby -*
# vi: set ft=ruby :

def stock_picker prices
  best = [0,0,0] # delta, buy, sell
  last = prices.length-1
  (1..last).each do |i|
    today = i-1
    (i..last).each do |future|
      delta = prices[future]-prices[today]
      best  = [delta,today,future] if delta > best[0]
    end
  end
  best[1..2]
end

# Tests and answers. All should pass.
puts "\nExpect 5 tests to run and PASS\n"
[
  [[17,3,6,9,15,8,6,1,10],
   [1,4]
  ],
  [[1,2,3,4,1,6,7,8,9,10,9,8,7,4,5,16,7,8,19],
   [0,18]
  ],
  [[17,3,6,9,15,8,6,10,1,16],
   [8,9]
  ],
  [[1,2,3,4,5,6,7,8,9,10,11,12,13],
   [0,12]
  ],
  [[10,9,8,7,6,5,4,3,2,1],
   [0,0]
  ],
].each do |prices,expected|
  printf "[ %2d, %2d ] %s #{prices}\n", expected[0], expected[1],
    (stock_picker(prices) === expected ? "PASS" : "FAIL")
end
puts
