#!/usr/bin/env ruby
# -*- mode: ruby -*
# vi: set ft=ruby :

def bubble_sort_by ary
  (ary.length-2).downto(0) do |k|
    swapped = false
    for i in 0..k
      if (yield ary[i], ary[i+1]) > 0
        ary[i], ary[i+1] = ary[i+1], ary[i]
        swapped = true
      end
    end
    break if !swapped
  end
  ary
end

# DRY it out by making this method use the other.
def bubble_sort ary
  bubble_sort_by(ary) {|l,r| l <=> r}
end

# Tests and answers.
puts "\nExpect 4 bubbles to run and PASS\n"
[
  [ 4, 3, 78, 2, 0, 2],
  [ 'z', 'x', 'f', 'a', 't' ],
  [ 9, 8, 7, 6, 5, 4, 3, 2, 1, 0 ],
  Array.new(99) { rand(1..99) },
].each do |test_array|
  printf "%s\n", bubble_sort(test_array) === test_array.sort ? "PASS":"FAIL"
end

# Test the <=> spaceship with our block. It feels like, to me, the block
# should contain the entirety of the test logic, and not just the
# substraction operation. In other words (l.length - r.length > 0)
puts "\nExpect 1 block test to run and PASS\n"
bby = bubble_sort_by(["hi","hello","hey"]) do |left,right|
  left.length - right.length
end
puts bby === ['hi','hey','hello'] ? 'PASS':'FAIL'
