require_relative "../lib/npr_scraper.rb"
require_relative "../lib/country.rb"
require_relative "../lib/reactor.rb"
require 'pry'

class NuclearPowerReactors

  # country and reactor key hashes will link the country and reactor names together with their ids that are used to pull out the right page
  attr_accessor :country_keys, :reactor_keys, :npr

  def initialize
    @npr = NPRScraper.new
    @country_keys = @npr.scrape_available_countries
    @reactor_keys = @npr.scrape_available_reactors
  end

  def list_all_countries
  end

  def list_all_reactors
  end

  def list_reactors_in(country)
  end

  def show_reactor_details
  end


end

reactors = NuclearPowerReactors.new
puts reactors.country_keys
# puts reactors.reactor_keys
