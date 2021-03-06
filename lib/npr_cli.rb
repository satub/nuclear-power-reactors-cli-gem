require_relative 'nuclear_power_reactors.rb'
require 'pry'

class NPRCLI
  def greet
    puts "Welcome to Nuclear Power Reactors Command Line!"
    puts "This gem allows you to browse data on nuclear power reactors in multiple countries."
    puts "The data presented is scraped from IAEA's Power Reactor Information System site at https://www.iaea.org/PRIS/home.aspx"
    puts "Data is currently available for the following countries:"
  end

  def get_input
    puts "Enter a command:"
    input = gets.chomp
  end

  def goodbye
    puts "Thank you for using Nuclear Power Reactors CLI! Have an energetic day! :D"
  end

  def choose_country
    cmd = "none"
    until valid_iso_format?(cmd) || cmd == "exit"
      puts "Choose a country you want more information on by entering the corresponding two-letter ISO-code."
      puts "For example, enter FI for Finland, or enter exit to quit the program:"
      cmd = gets.chomp
    end
    cmd.upcase
  end

  def choose_reactor
    cmd = "none"
    until valid_reactor_id?(cmd) || cmd == "exit"
      puts "Choose a reactor you want more information on by entering the corresponding id number (number in parenthesis), or enter exit to quit the program:"
      cmd = gets.chomp
    end
    cmd
  end

  def list_options
    puts "Available commandline options: 'help' for this info, 'list' to list all countries, 'country' to choose another country, 'reactor' to choose another reactor, or 'exit' to exit the program."
    get_input
  end

  def valid_iso_format?(cmd)
    !cmd.match(/\b\w{2}\b/).nil? && cmd.match(/\d+/).nil?
  end

  def valid_reactor_id?(cmd)
    cmd.match(/\D/).nil?  #this input should only consist of digits
  end

  #run sequence here
  def run
    greet
    npr = NuclearPowerReactors.new
    npr.list_all_countries
    cmd = "country"
    until cmd == "exit" do
      case cmd
      when "country"
        cmd = choose_country
        if cmd == "EXIT"
          goodbye
          exit
        end
        if npr.country_exists?(cmd)
          npr.find_country(cmd).nil? ? npr.create_country(cmd) : npr.find_country(cmd)
          npr.list_country_data(cmd)
          cmd = "reactor"
        else
          puts "No country with code = #{cmd} exists."
          cmd = "list"
        end
      when "reactor"
        cmd = choose_reactor
        if cmd == "exit"
          goodbye
          exit
        end
        if npr.find_reactor(cmd).nil? && npr.reactor_exists?(cmd)
          puts "Reactor #{cmd} not located in this country. Find and display data anyway? (y/n)"
          if get_input.downcase == "y"
            npr.create_reactor(cmd)
            npr.show_reactor_details(cmd)
          end
        elsif npr.find_reactor(cmd).nil? && !npr.reactor_exists?(cmd)
          puts "No reactor with id = #{cmd} exists."
        else
          npr.show_reactor_details(cmd)
        end
        cmd = list_options
      when "list"
        npr.list_all_countries
        cmd = "country"
      when "exit"
        exit
      else
        cmd = list_options
      end
    end
    goodbye
  end

end
