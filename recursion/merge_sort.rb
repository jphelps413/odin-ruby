#!/usr/bin/env ruby
# -*- mode: ruby -*
# vi: set ft=ruby :

def divide a
  a.each_slice( (a.size/2.0).round ).to_a
end

def conquer b,c
  m = []
  m << (b[0] < c[0] ? b.shift : c.shift) until b.size == 0 || c.size == 0
  (m << b << c).flatten
end

def merge_sort a
  if a.size > 1
    l,r = divide(a)
    a = conquer( merge_sort(l), merge_sort(r) )
  end
  a
end

# Run Tests!
puts "Expect 4 PASSing tests"
[
  [ 9, 1, 4, 7 ],
  [ 3, 4, 9, 12, 87, 34, 99, 13 ],
  [ 1, 2, 3, 4, 5, 6, 7, 8, 9 ],
  Array.new(99) { rand(-100..100) },
].each do |test_array|
  printf "%s\n", merge_sort(test_array) === test_array.sort ? "PASS":"FAIL"
end

