#!/usr/bin/env ruby
# -*- mode: ruby -*
# vi: set ft=ruby :

class MyNewfangledClass

  attr_reader :read_it
  attr_writer :write_it
  attr_accessor :both_it

  def initialize
  end

end

# Only run the embedded guess quality testing here.
if __FILE__ == $0

  def pass_fail cdx
    cdx ? 'PASS':'FAIL'
  end
  puts
  [
    # Build test array here
  ].each do |name,test|
    printf "Testing %-16s: %s\n", name, pass_fail(test)
  end
  puts
end
