#!/usr/bin/env ruby
# -*- mode: ruby -*
# vi: set ft=ruby :

require 'awesome_print'
require 'json'
require 'socket'
require 'pry-byebug'

CRLF = "\r\n"

TinyHost = 'localhost'
TinyPort = 8080
TinyPath = '/index.html'

socket   = TCPSocket.open(TinyHost, TinyPort)

printf "tiny browser GET or POST [G/P]? "
action = gets.chomp.upcase

if action != 'P' # assume a GET
  request = "GET #{TinyPath} HTTP/1.0" + CRLF + CRLF
else
  printf "Your name? " ; name  = gets.chomp
  printf "Your email? "; email = gets.chomp
  viking = {
    :viking => {
      :name  => name,
      :email => email,
    }
  }.to_json

  request =
    "POST / HTTP/1.0"                  + CRLF +
    "Content-Type: application/json"   + CRLF +
    "Content-Length: #{viking.length}" + CRLF +
    CRLF + viking + CRLF
end
puts "#{TinyHost}:#{TinyPort} #{request}\n\n"
socket.print(request)
response = socket.read

headers, body = response.split(CRLF+CRLF, 2)
print "-- Headers BEGIN --\n#{headers}\n-- Headers END --\n\n"
print "-- Body BEGIN --\n#{body}-- Body END --\n\n"
