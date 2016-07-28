require_relative "../lib/npr_scraper.rb"
require_relative "../lib/country.rb"
require_relative "../lib/reactor.rb"
require 'colorize'
require 'pry'

class NuclearPowerReactors

  # country and reactor key hashes will link the country and reactor names together with their ids that are used to pull out the right page
  attr_accessor :country_hash, :reactor_hash, :npr

  def initialize
    @npr = NPRScraper.new
    @country_hash = @npr.scrape_available_countries
    @reactor_hash = @npr.scrape_available_reactors
  end

  #some country names are given with a comma, eg 'Korea, Republic of'. This helper method formats them
  def format_name(name)
    name.match(/\,/).nil? ? name : "#{name.split(", ").reverse.join(" ")}"
  end

  def list_all_countries
    column_width = @country_hash.values.max_by {|name| name.length}.length + 4
    columns = 3
    @country_hash.values.each_with_index do |name, i|
        indexed_name = "#{i+1}. #{format_name(name)}"
      if (i+1) % columns == 0
        puts "#{indexed_name}"
      else
        (column_width - indexed_name.length).times do
          indexed_name << " "
        end
        print "#{indexed_name}"
      end
    end
    puts
  end

  #Showing all reactors (there are over 660 of them currently) will require heavy formatting. method TBA
  def list_all_reactors
  end

  def create_country(country_iso)  #input is country iso code
    country_data = @npr.scrape_country_data(country_iso)
    country_data[:name] = @country_hash[country_iso]
    ####country_data[:reactors] now has the reactors as an array of names only, not objects. create reactor objects with theses before creating countries!
    ####get reactor ids based on the names, clear country_data[:reactors],
    ####create reactors based on those ids, and push them into country_data[:reactors]
    ####then create country :D

    #fetch reactor_ids in the country
    reactor_ids = country_data[:reactors].collect do |reactor_name|
      reactor_id = @reactor_hash.key(reactor_name)
    end
    #empty country_data[:reactors] array from strings
    country_data[:reactors].clear
    #create and shovel in reactors
    country_data[:reactors] = reactor_ids.collect do |id|
      reactor = create_reactor(id)
    end
    country = Country.new(country_data)
    #WOOT!
  end


  def create_reactor(reactor_id)
    reactor_data = @npr.scrape_reactor_data(reactor_id)
    reactor_data[:name] = @reactor_hash[reactor_id]
    reactor_data[:id] = reactor_id
    reactor = Reactor.new(reactor_data)
  end


  def list_country_data(country_iso)
     country = Country.all.detect { |country|  country.iso == country_iso }
     header = "Country: #{country.name}"
     summary_line_2 = "Total Electricity Production: #{country.total_electricity}...Nuclear Electricity Production: #{country.nuclear_electricity}...Nuclear Electricity Share: #{country.nuclear_e_share}"
     summary_line_1 = "Reactors: Operational: #{country.operational}...Under Construction: #{country.under_construction}...In Long-term Shutdown: #{country.long_term}...In Permanent Shutdown: #{country.permanent_shutdown}"
     puts header
     puts summary_line_1
     puts summary_line_2
     country.reactors.each_with_index {|reactor, i| puts "#{i+1}. #{reactor.name}  #{reactor.status}"}
  end


  #attribute 'property' reserved for later implementations to query only after 1 specific property
  def show_reactor_details(reactor_id, property = "all")
    reactor = Reactor.all.detect {|reactor| reactor.id == reactor_id}
    #use colorize here?
    header = "Name: #{reactor.name}...Location: #{reactor.location}...Status: #{reactor.status}"
    puts header
    if property == "all"
      column_width = reactor.instance_variables.max_by {|name| name.length}.length

      data = reactor.instance_variables.each do |variable|
         field = "#{(variable.to_s).gsub(/@/,"")}"
         (column_width - field.length).times do
           field << "."
         end
         puts "#{field} #{reactor.instance_variable_get(variable)}" if !field.match(/^[A-Z]/).nil?
      end
    end
  end


end

reactors = NuclearPowerReactors.new
#reactors.list_all_countries
country = reactors.create_country("FI")
# binding.pry
reactors.list_country_data("FI")
reactors.show_reactor_details("157")
# binding.pry
