require 'pry'
require 'nokogiri'
require 'open-uri'

class NPRScraper
  attr_accessor :country_page, :reactor_page
  attr_reader :home_page, :pris_home, :path_to_country_data, :path_to_reactor_data

  #Possibly move all scraping functions to a separate class and leave only call display, list and object creation here?

  def initialize #default country set to US, default reactor to ANO-1 -- maybe remove the defaults?
    @home_page = "https://www.iaea.org"
    @pris_home = "#{@home_page}/PRIS/home.aspx"  #page to draw available countries and reactors from together with their codes
    @path_to_country_data = "/PRIS/CountryStatistics/CountryDetails.aspx?current="
    @path_to_reactor_data = "/PRIS/CountryStatistics/ReactorDetails.aspx?current="
    @country_page = "#{@home_page}#{@path_to_country_data}US"
    @reactor_page = "#{@home_page}#{@path_to_reactor_data}652"
  end

  def scrape_available_countries
    #scrapes the PRIS home page and returns a hash of country data that has the name & iso code for all available countries
    raw_text = Nokogiri::HTML(open(@pris_home))
    selection_list = raw_text.css(".box-content.shortCutBox").css("#MainContent_ddlCountry").css("option")
    selection_list.each_with_object({}) do |country, scraped_country_ids|
      scraped_country_ids[country.text] = country.values[0] unless country.text == ""
      #Builds a hash: scraped_country_ids = {country1_name => iso1, country2_name => iso2, ...}
    end
  end

  def scrape_available_reactors
    #scrapes the PRIS home page and returns a has of reactor data that has the name and id for all available reactors
    raw_text = Nokogiri::HTML(open(@pris_home))
    selection_list = raw_text.css(".box-content.shortCutBox").css("#MainContent_ddlReactors").css("option")
    selection_list.each_with_object({}) do |reactor, scraped_reactor_ids|
      scraped_reactor_ids[reactor.text] = reactor.values[0] unless reactor.text == ""
      #Builds a hash:  scraped_reactor_ids = {reactor1_name => id1, reactor2_name => id2, ...}
    end
  end

  def scrape_country_data(@country_page)

  end

end
puts npr_list = NPRScraper.new.scrape_available_reactors
#the above line is for preliminary tests only until the bin/nuclear-power-reactors file or testing specs are built
