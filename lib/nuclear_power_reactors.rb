require 'pry'
require 'nokogiri'
require 'open-uri'

class NuclearPowerReactors
  attr_accessor :current_page
  attr_reader :home_page, :path_to_country_data

  

  def initialize(country_iso_alpha_2_code = "US") #default country set to US
    @home_page = "https://www.iaea.org"
    @path_to_country_data = "/PRIS/CountryStatistics/CountryDetails.aspx?current="
    @current_page = "#{@home_page}#{@path_to_country_data}#{country_iso_alpha_2_code}"
  end

  def scrape_available_countries
    raw_text = Nokogiri::HTML(open(@current_page))
    countries = []
    relative_addresses = []
    raw_text.css(".sidebar").css("li").css("a").each {|country| countries << country.text}
    raw_text.css(".sidebar").css("li").css("a").each {|address| relative_addresses << address.values[1]}
    binding.pry
    # countries.delete_if {|country| country == ""}
    countries
  end

  def scrape_available_reactors
  end

end
puts npr_list = NuclearPowerReactors.new.scrape_available_countries
#the above line is for preliminary tests only until the bin/nuclear-power-reactors file or testing specs are built
