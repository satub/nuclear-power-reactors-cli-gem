require 'pry'
require 'nokogiri'
require 'open-uri'

class NuclearPowerReactors
  attr_accessor :country_page, :country_iso_alpha_2_code, :reactor_page, :reactor_code
  attr_reader :home_page, :pris_home, :path_to_country_data, :path_to_reactor_data

  # @@countries_with_reactors = []
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
    selection_list.each_with_object({}) do |country, scraped_country_data|
      scraped_country_data[country.text] = country.values[0] unless country.text == ""
      #Builds a hash like this: scraped_country_data = {country1_name => iso1, country2_name => iso2, ...}
    end
  end

  def scrape_available_reactors #this should return an array of reactor data hashes that have the name and id of the reactor
    raw_text = Nokogiri::HTML(open(@pris_home))
    # reactors = []
    # reactor_ids = []
    raw_text.css(".box-content.shortCutBox").css("#MainContent_ddlReactors").css("option")[1].values[0]  #1st reactor id
    raw_text.css(".box-content.shortCutBox").css("#MainContent_ddlReactors").css("option")[1].text #1st reactor name

  end

end
puts npr_list = NuclearPowerReactors.new.scrape_available_countries
#the above line is for preliminary tests only until the bin/nuclear-power-reactors file or testing specs are built
