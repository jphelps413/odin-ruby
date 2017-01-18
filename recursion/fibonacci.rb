#!/usr/bin/env ruby
# -*- mode: ruby -*
# vi: set ft=ruby :
#
# Sum of the two preceding numbers: 0, 1, 1, 2, 3, 5, 8, 13 ...
#
# Solution #1 is iterative.
def fibs n
  fibs = [0,1,1]
  2.upto(n) {fibs << fibs[-2] + fibs[-1]}
  n == 0 ? [] : fibs[0..n-1]
end

# Solution #2 is recursive.
def fibs_rec n, fibs = [0,1]
  return fibs.slice(0,n) if n < 2
  n == 2 ? fibs : (fibs_rec n-1, (fibs << fibs[-2] + fibs[-1]))
end

# Test away! Note that requesting 0 or 1 number in the sequence are
# special cases.
{
  0 => [],
  1 => [0],
  2 => [0,1],
  5 => [0,1,1,2,3],
 13 => [0,1,1,2,3,5,8,13,21,34,55,89,144],
}.each do |n,fibers|
  printf "Iterative %2s: %s\n", n, fibs(n)     === fibers ? "PASS":"FAIL"
  printf "Recursive %2s: %s\n", n, fibs_rec(n) === fibers ? "PASS":"FAIL"
end
