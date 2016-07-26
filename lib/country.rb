class Country
  attr_accessor :name, :relative_web_address

  def initialize(country_data) #country_data is a has that NuclearPowerReactors class will produce by scraping data
    @reactors = []  #an array of all the reactors (this is an object) in the country
    @name = country_data[:name]
    @relative_web_address = country_data[:web]
  end

  def add_reactor(reactor)
    @reactors << reactor
  end

  def reactors
    @reactors
  end
end
