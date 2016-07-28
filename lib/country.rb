class Country
  attr_accessor :name, :iso, :tep, :nep, :nuclear_energy_share, :reactors

  @@all = []

  def initialize(country_data) #country_data is a hash that NuclearPowerReactors class will produce by scraping data
    @reactors = []  #an array of all the reactors in the country
    country_data.each do |attribute, value|
      self.send(("#{attribute}="), value)
    end
    @@all << self
  end

  def add_reactor(reactor)
    @reactors << reactor
  end

  def reactors
    @reactors
  end

  def self.all
    @all
  end
end
