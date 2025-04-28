require_relative 'modules/instance_counter'
require_relative 'modules/manufacturing_companies'
require_relative 'modules/validator'

class Train
  include InstanceCounter
  include ManufacturingCompanies
  include Validator

  attr_reader :number,  :wagons, :type, :route,:current_station_index, :speed

  NUMBER_FORMAT = /^[a-zа-я0-9]{3}-?[a-zа-я0-9]{2}$/i

  @@trains = []

  class << self
    def find(number)
      @@trains.find { |train| train.number == number }
    end

    def all
      @@trains
    end
  end

  def initialize(number, type)
    @number = number
    @type = type
    @wagons = []
    @speed = 0
    @route = nil
    @current_station_index = nil

    validate!

    @@trains << self
    register_instance
  end

  def stopped?
    self.speed.zero?
  end

  def stop
    self.speed = 0 unless stopped?
  end

  def speed_up(speed = 5)
    self.speed += speed
  end

  def speed_down(speed = 5)
    self.speed = [self.speed - speed, 0].max unless stopped?
  end

  def add_wagon(wagon)
    self.wagons << wagon if stopped?
  end

  def remove_wagon(wagon)
    self.wagons.delete(wagon) if stopped?
  end

  def assign_route(route)
    self.route = route
    self.current_station_index = 0
    current_station.add_train(self)
  end

  def current_station
    self.route.stations[self.current_station_index] if has_route?
  end

  def next_station
    self.route.stations[self.current_station_index + 1] unless last_station
  end

  def previous_station
    self.route.stations[self.current_station_index - 1] unless first_station
  end

  def go_forward
    move_to('forward')
  end

  def go_backward
    move_to('backward')
  end


  private

  # прячем прямой доступ к изменению скорости и количеству вагонов
  attr_writer :speed, :wagons, :route, :current_station_index

  # в спецификации не требуется доступ к этим методам, это внутренная логика
  def has_route?
    self.route
  end

  def last_station?
    has_route? && self.current_station_index == self.route.stations.size - 1
  end

  def first_station?
    has_route? && self.current_station_index == 0
  end

  def move_to(type)
    return if (last_station? && type == 'forward') || (first_station? && type == 'backward')

    current_station.depart_train(self)
    direction = type == 'forward' ? 1 : -1
    self.current_station_index += direction
    current_station.add_train(self)
  end

  def validate!
    errors = []
    errors << "Номер не может отсутствовать" if number.to_s.strip.empty?
    errors << "Номер имеет недопустимый формат" if number !~ NUMBER_FORMAT
    errors << "Тип поезда не может отсутствовать" if type.to_s.strip.empty?
    errors << "Неизвестный тип поезда. Допустимые значения: 'cargo', 'passenger'" unless ['cargo', 'passenger'].include?(type)

    raise errors.join("\n") unless errors.empty?
  end
end