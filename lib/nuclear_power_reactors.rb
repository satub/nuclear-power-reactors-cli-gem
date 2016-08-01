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
  ######TBA !!!write a helper method for choosing color


  def list_all_countries
    column_width = @country_hash.values.max_by {|name| name.length}.length + 4
    columns = 3
    organizer = 1
    @country_hash.each do |key, value|
        name = "(#{key}) #{format_name(value)}"
      if organizer % columns == 0
        puts "#{name}".colorize(:blue)
      else
        (column_width - name.length).times do
          name << " "
        end
        print "#{name}".colorize(:blue)
      end
      organizer += 1
    end
    puts
  end

  #Showing all reactors (there are over 660 of them currently) will require heavy formatting. method TBA
  def list_all_reactors
  end

  def find_country(country_iso)
    Country.all.detect { |country|  country.iso == country_iso }
  end

  def country_exists?(country_iso)
    @country_hash.has_key?(country_iso)
  end

  def find_reactor(reactor_id)
    Reactor.all.detect {|reactor| reactor.id == reactor_id}
  end

  def reactor_exists?(reactor_id)
    @reactor_hash.has_key?(reactor_id)
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
    number_of_reactors = country_data[:reactors].size
    puts "#{@country_hash[country_iso]}".colorize(:blue) + " has #{number_of_reactors} reactors. Gathering data..."
    #empty country_data[:reactors] array from strings
    country_data[:reactors].clear
    #create and shovel in reactors
    counter = 0
    country_data[:reactors] = reactor_ids.collect do |id|
      counter += 1
      if counter % 20 == 0
        print "#{counter} reactors read. #{number_of_reactors - counter} reactors to go. Please wait... "
      end
      reactor = create_reactor(id)
    end
    country = Country.new(country_data)
    #WOOT!
  end


  def create_reactor(reactor_id)
    reactor_data = @npr.scrape_reactor_data(reactor_id)
    reactor_data[:name] = @reactor_hash[reactor_id]
    reactor_data[:id] = reactor_id
    find_reactor(reactor_id).nil? ? reactor = Reactor.new(reactor_data) : find_reactor(reactor_id)
  end


  def list_country_data(country_iso)
     country = find_country(country_iso)
     header = "Country: #{country.name}".colorize(:blue)
     summary_line_2 = "Total Electricity Production: #{country.total_electricity}...Nuclear Electricity Production: #{country.nuclear_electricity}...Nuclear Electricity Share: #{country.nuclear_e_share}"
     summary_line_1 = "Reactors: Operational: #{country.operational}".colorize(:green) + "...Under Construction: #{country.under_construction}".colorize(:cyan) + "...In Long-term Shutdown: #{country.long_term}".colorize(:yellow) + "...In Permanent Shutdown: #{country.permanent_shutdown}".colorize(:red)
     puts header
     puts summary_line_1
     puts summary_line_2
     country.reactors.each_with_index do |reactor, i|
       color = :black
       case reactor.status
        when "Operational"
         color = :green
       when "Under Construction"
         color = :cyan
       when "Permanent Shutdown"
         color = :red
       when "Long-term Shutdown"
         color = :yellow
       else
         color = :black
       end
       puts "#{reactor.name}  (#{reactor.id})  #{reactor.status}".colorize(color)
     end
  end


  #attribute 'property' reserved for later implementations to query only after 1 specific property
  def show_reactor_details(reactor_id, property = "all")
    reactor = find_reactor(reactor_id)
    #use colorize here?
    header = "Country: #{reactor.location}".colorize(:blue) + "...Reactor: #{reactor.name}...Status: #{reactor.status}"
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

#Test this!
 # reactors = NuclearPowerReactors.new
#reactors.list_all_countries
 # country = reactors.create_country("FI")
# binding.pry
# reactors.find_country("FI")
# reactors.find_country("DE")
# reactors.list_country_data("FI")
# reactors.show_reactor_details("157")
# binding.pry
