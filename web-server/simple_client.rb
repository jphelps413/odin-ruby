#!/usr/bin/env ruby
# -*- mode: ruby -*
# vi: set ft=ruby :

require 'socket'

SimplePort = 8080

puts "\nClient connecting to port #{SimplePort}\n\n"
sock = TCPSocket.open 'localhost', SimplePort

while line = sock.gets
  puts line.chop
end

sock.close
