#!/usr/bin/env ruby
# -*- mode: ruby -*
# vi: set ft=ruby :

SPAN = 'Z'.ord - 'A'.ord + 1 # Determine the ASCII distance for modulo term.

def caesar_cipher( input, rot )
  crypt = ''
  input.scan(/./) do |c|
    if !(c =~ /[A-Za-z]/).nil? # Only crypt the alphas.
      base_ord = c.match(/[A-Z]/).nil? ? 'a'.ord : 'A'.ord
      c = (((c.ord - base_ord + rot) % SPAN ) + base_ord).chr()
    end
    crypt << c
  end
  crypt
end

# Test case results were verified with http://www.xarg.org/tools/caesar-cipher/
#
# Only run the embedded guess quality testing here.
if __FILE__ == $0

  def pass_fail cdx
    cdx ? 'PASS':'FAIL'
  end
  puts "\nExpect three to PASS, and one to FAIL.\n"
  [
    [  5, 'What a string!',
          'Bmfy f xywnsl!'
    ],
    [ 13, 'The quick brown fox jumps over the lazy dog, 13 times!?!',
          'Gur dhvpx oebja sbk whzcf bire gur ynml qbt, 13 gvzrf!?!',
    ],
    [
       0, 'I better remain unscathed ,!@#$%123456',
          'I better remain unscathed ,!@#$%123456',
    ],
    [ 30, 'Purposely fail',
          'this one, m\'k?',
    ],
  ].each do |rot,clear,cipher|
    printf "Test Rot %2d: %s\n",
                 rot, pass_fail( caesar_cipher( clear, rot ) === cipher )
  end
  puts
end
