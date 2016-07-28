require 'pry'
require 'nokogiri'
require 'open-uri'

class NPRScraper
  attr_accessor :country_page, :reactor_page
  attr_reader :home_page, :pris_home, :path_to_country_data, :path_to_reactor_data

  def initialize #default country set to FI, default reactor to LOVIISA-1 -- maybe remove the defaults?
    @home_page = "https://www.iaea.org"
    @pris_home = "#{@home_page}/PRIS/home.aspx"  #page to draw available countries and reactors from together with their codes
    @path_to_country_data = "/PRIS/CountryStatistics/CountryDetails.aspx?current="
    @path_to_reactor_data = "/PRIS/CountryStatistics/ReactorDetails.aspx?current="
    # @country_page = "#{@home_page}#{@path_to_country_data}FI"
    # @reactor_page = "#{@home_page}#{@path_to_reactor_data}157"
  end

  def scrape_available_countries
    #scrapes the PRIS home page and returns a hash of country data that has the name & iso code for all available countries
    raw_text = Nokogiri::HTML(open(@pris_home))
    selection_list = raw_text.css(".box-content.shortCutBox").css("#MainContent_ddlCountry").css("option")
    selection_list.each_with_object({}) do |country, scraped_country_ids|
      scraped_country_ids[country.values[0]] = country.text unless country.text == ""
      #Builds a hash: scraped_country_ids = {country1_name => iso1, country2_name => iso2, ...}
    end
  end

  def scrape_available_reactors
    #scrapes the PRIS home page and returns a hash of reactor data that has the name and id for all available reactors
    raw_text = Nokogiri::HTML(open(@pris_home))
    selection_list = raw_text.css(".box-content.shortCutBox").css("#MainContent_ddlReactors").css("option")
    selection_list.each_with_object({}) do |reactor, scraped_reactor_ids|
      scraped_reactor_ids[reactor.values[0]] = reactor.text unless reactor.text == ""
      #Builds a hash:  scraped_reactor_ids = {reactor1_name => id1, reactor2_name => id2, ...}
    end
  end

  def scrape_country_data(country_iso)
    #scrapes the PRIS country_page and returns a hash of country data that lists the energy production and the names of reactors in that country
    @country_page = "#{@home_page}#{@path_to_country_data}#{country_iso}"
    raw_text = Nokogiri::HTML(open(@country_page))

    summary_data_keys = raw_text.css(".box-content").css("td").css("label")
    summary_data = raw_text.css(".box-content").css("td").css("h2")
    reactor_table = raw_text.css(".tablesorter").css("td").css("a")

    country = {}
    country[:iso] = country_iso
    summary_data_keys.each_with_index do |key, i|
      key_string = key.text.strip!.downcase!.match(/\b"?(\w+)\-?\s?(\w+)?\b/).captures
      if key_string[1].nil?
        country[key_string[0].to_sym] = summary_data[i].text.strip!
      else
        country[key_string.join("_").to_sym] = summary_data[i].text.strip!
      end
    end

    #calculate the share of energy produced with nuclear power vs total energy produced
    nep = country[:nuclear_electricity].gsub(/\sGW\.h/, "").to_f
    tep = country[:total_electricity].gsub(/\sGW\.h/, "").to_f
    country[:nuclear_energy_share] = "#{((nep/tep)*100).round(2)}%"

    #find reactors
    country[:reactors] = reactor_table.collect {|reactor| reactor.text}
    country
  end

  def scrape_reactor_data(reactor_id)
    #scrapes the PRIS reactor_page and returns a hash of reactor data
    @reactor_page = "#{@home_page}#{@path_to_reactor_data}#{reactor_id}"
    raw_text = Nokogiri::HTML(open(@reactor_page))
    country_name = raw_text.css(".sidebar").css("#MainContent_litCaption").text.strip!
    reactor_data = raw_text.css(".box-content").css("span")

    reactor = {}
    reactor[:location] = country_name
    reactor[:status] = raw_text.css("#MainContent_MainContent_lblReactorStatus").text
    #add rest of the data with keys
    reactor_data.each do |data|
      reactor[data.values[0].match(/MainContent_MainContent_lbl(\w*)/).captures[0].to_sym] = data.text
    end
     reactor
  end

end
# test this
  # npr = NPRScraper.new
  # country = npr.scrape_country_data("FI")
#  puts reactor
