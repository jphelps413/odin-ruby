#!/usr/bin/env ruby
# -*- mode: ruby -*
# vi: set ft=ruby :

require 'socket'

ServerPort = 8080

puts "Server listening on port #{ServerPort}"

server = TCPServer.open(ServerPort)

loop {
  Thread.start(server.accept) do |client|
    puts 'Client connected...'
    client.puts(Time.now.ctime)
    client.puts 'Server says bye-bye!'
    client.close
  end
}
