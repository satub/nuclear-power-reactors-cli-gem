#!/usr/bin/env ruby

require_relative "../lib/nuclear_power_reactors.rb"
# require_relative "../lib/npr_scraper.rb"
# require_relative "../lib/country.rb"
# require_relative "../lib/reactor.rb"

def greet
  puts "Welcome to Nuclear Power Reactors Command Line!"
  puts "This gem allows you to browse data on nuclear power reactors in multiple countries."
  puts "The data presented is scraped from IAEA's Power Reactor Information System site at https://www.iaea.org/PRIS/home.aspx"
  puts "Data is currently available for the following countries:"
end



#run sequence here
greet
npr = NuclearPowerReactors.new
npr.list_all_countries
