class Reactor
  attr_accessor :name, :location, :status, :Type, :Model, :NetCapacity,
  :DesignNetCapacity, :GrossCapacity, :ThermalCapacity, :ConstructionStartDate,
  :FirstCriticality, :ConstrSuspendedDate, :ConstrRestartDate, :GridConnectionDate,
  :CommercialOperationDate, :LongTermShutdownDate, :RestartDate, :PermanentShutdownDate,
  :Generation, :EAF, :OperatingFactor, :EUL, :LoadFactor, :LifetimePerformanceYear

  @@all = []

  def initialize(reactor_data) #reactor_data is a hash that NuclearPowerReactors class will produce by scraping data
    reactor_data.each do |attribute, value|
      self.send(("#{attribute}="), value)
    end
    @@all << self
  end

  #dummy menthod for now
  def assign_country(country)
  end

  def self.all
    @@all
  end

end
