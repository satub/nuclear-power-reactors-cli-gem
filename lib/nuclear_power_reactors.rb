require_relative "../lib/npr_scraper.rb"
require_relative "../lib/country.rb"
require_relative "../lib/reactor.rb"
require 'pry'

class NuclearPowerReactors

  # country and reactor key hashes will link the country and reactor names together with their ids that are used to pull out the right page
  attr_accessor :country_hash, :reactor_hash, :npr

  def initialize
    @npr = NPRScraper.new
    @country_hash = @npr.scrape_available_countries
    @reactor_hash = @npr.scrape_available_reactors
  end

  def list_all_countries
    column_width = @country_hash.keys.max_by {|country_name| country_name.length}.length + 4
    columns = 3
    @country_hash.keys.each_with_index do |country_name, i|
      if country_name.match(/\,/).nil?
        format_name = "#{i+1}. #{country_name}"
      else
        format_name= "#{i+1}. #{country_name.split(", ").reverse.join(" ")}"
      end
      if (i+1) % columns == 0
        puts "#{format_name.strip}"
      else
        (column_width - format_name.length).times do
          format_name << " "
        end
        print "#{format_name}"
      end
    end
    puts
  end


  #Showing all reactors (there are over 660 of them currently) will require heavy formatting. method TBA
  def list_all_reactors
  end

  def list_reactors_in(country)
  end

  def show_reactor_details
  end


end

reactors = NuclearPowerReactors.new
reactors.list_all_countries
# puts reactors.reactor_hash
