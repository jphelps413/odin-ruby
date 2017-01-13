#!/usr/bin/env ruby
# -*- mode: ruby -*
# vi: set ft=ruby :

require 'csv'

def clean_phone_number dirty
  clean = dirty.gsub(/[^\d]/,'')
  return clean if clean.length == 10
  return clean[1..-1] if clean.length == 11 && clean[0] == '1'
  nil
end

contents = CSV.open 'event_attendees.csv', headers: true,
                                           header_converters: :symbol
reg_hours = Hash.new 0
reg_wdays = Hash.new 0

contents.each do |row|
  dts = DateTime.strptime(row[:regdate], "%m/%d/%Y %H:%M")
  reg_hours[dts.hour] += 1
  reg_wdays[dts.wday] += 1
  printf "%-10s %-10s %10s %8s %5s\n", row[:last_name], row[:first_name],
                                       clean_phone_number(row[:homephone]),
                                       dts.strftime("%H:%M"), dts.strftime('%A')
end
puts
puts "Most popular hour: #{reg_hours.key reg_hours.values.max}"
puts "Most popular day:  #{Date::DAYNAMES[reg_wdays.key reg_wdays.values.max]}\n\n"
