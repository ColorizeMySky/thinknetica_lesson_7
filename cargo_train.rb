class CargoTrain < Train
  def initialize(number)
    super(number, 'cargo')
  end

  def add_wagon(wagon)
    return unless wagon.type == 'cargo'
    super
  end
end