#!/usr/bin/env ruby
# -*- mode: ruby -*
# vi: set ft=ruby :

require 'erb'
require 'json'
require 'pry-byebug'
require 'socket'
require 'time' # needed for httpdate

class ClientHandler

  CRLF = "\r\n"

  def initialize client
    @client = client

    # This should probably use PEEK to analyze what is out on the socket
    # before desctructively consuming it, but this is a "controlled" env.
    @head, @body = @client.recv(1024).split CRLF+CRLF,2
    return if @head.nil? # client disconnected without sending data?

    @hdrs = hash_hdrs @head.split(CRLF)
    @this = Thread.new { run }
  end

  def hash_hdrs heads
    # The first must always be method/path/version
    @method, @path, @version = heads.shift.split(' ')
    hashes = {}
    heads.each do |h|
      key,val = h.split(/\:\s*/)
      hashes[key] = val
    end
    hashes
  end

  # http://www.restapitutorial.com/httpstatuscodes.html - Net::HTTP most
  # likely has status codes, but I wanted to do these by hand.
  HTTP_Status = {
    200 => 'OK',
    400 => 'Bad Request',
    403 => 'Forbidden',
    404 => 'Not Found',
    500 => 'Internal Server Error',
  }

  def http_status status
    return http_status(500) if HTTP_Status[status].nil?
    "HTTP/1.0 #{status} #{HTTP_Status[status]}" + CRLF
  end

  def http_close
    'Connection: close' + CRLF
  end

  def http_date
    "Date: #{Time.now.httpdate}" + CRLF
  end

  def http_length len
    "Content-Length: #{len}" + CRLF
  end

  def http_path
    @path[0] == '/' ? @path[1..-1] : @path
  end

  # This is just quick and dirty and INCOMPLETE
  HTTP_Content = {
    'html' => 'text/html',
    'png'  => 'image/png',
    'txt'  => 'text/plain',
  }

  def http_type ht
    puts "UNDER CONSTRUCTION" if HTTP_Content[ht].nil?
    'Content-Type: ' + HTTP_Content[ht] + CRLF
  end

  def get
    binding.pry if ENV['PRY_BIND']
    if File.exists? http_path
      @client.puts (
        http_status(200) +
        http_date +
        http_type('html') +
        http_length(File.size(http_path)) +
        http_close +
        CRLF +
        File.open(http_path,'r').read
      )
    else
      @client.puts (http_status(404) + http_date + http_close + CRLF)
    end
  end

  def params= json
    @params = JSON.parse(json, {:symbolize_names => true})
  end

  def render_thanks
    ERB.new(File.read 'thanks.html.erb').result(binding)
  end

  def post
    binding.pry if ENV['PRY_BIND']
    if @hdrs['Content-Length'].nil? ||
       @hdrs['Content-Length'].to_i != @body.chomp.length
      @client.puts (http_status(400) + http_date + http_close + CRLF)
    else
      # Just assume it is a registration/thanks POST
      self.params= @body
      thanks = self.render_thanks { # Could add logic to handle multiples
          "<li>Name: #{@params[:viking][:name]}</li> <li>Email: #{@params[:viking][:email]}</li>"
      }
      @client.puts (
        http_status(200) +
        http_date +
        http_type('html') +
        http_length(thanks.length) +
        CRLF +
        thanks
      )
    end
  end

  def run # the thread runner
    case @method
    when 'GET'  then get
    when 'POST' then post
    else
      @client.puts (http_status(500) + http_date + http_close + CRLF)
    end
    @client.close
  end
end

class Server

  def initialize port
    puts "\nServer listening on port #{port}\n\n"
    @server = TCPServer.open(port)
  end

  def run
    loop { ClientHandler.new @server.accept }
  end
end

Server.new(8080).run
