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

def choose_country
  puts "Choose a country you want more information on by entering the corresponding two-letter ISO-code."
  puts "For example, enter FI for Finland. Enter exit to quit the program."
  input = gets.chomp
end

def valid_iso_format?(input)
  !input.match(/\b\w{2}\b/).nil? && input.match(/\d+/).nil?
end

#run sequence here
cmd = "go on"
greet
npr = NuclearPowerReactors.new
npr.list_all_countries
until cmd == "exit" do
  country = choose_country
  if valid_iso_format?(country)
    puts "Yay! You succesfully chose a country!"
    npr.create_country(country)
    npr.list_country_data(country)
    
  else
    puts "Pay attention, chap!"
  end
  cmd = "exit"  #to avoid inifinite loop during testing
end
puts "Thank you for using Nuclear Power Reactors CLI! Have an energetic day! :D"
