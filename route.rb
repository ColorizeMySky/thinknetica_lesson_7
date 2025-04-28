require_relative 'modules/instance_counter'
require_relative 'modules/validator'

class Route
  include InstanceCounter
  include Validator

  attr_reader :stations

  def initialize(first, last)
    @stations = [first, last]

    validate!

    register_instance
  end

  def add_station(station, position = -2)
    @stations.insert(position, station)
  end

  def remove_station(station)
    @stations.delete(station)
  end

  private

  def validate!
    errors = []
    errors << "Начальная станция не может отсутствовать" if @stations.first.nil?
    errors << "Конечная станция не может отсутствовать" if @stations.last.nil?
    errors << "Начальная и конечная станции не могут совпадать" if @stations.first == @stations.last

    raise errors.join("\n") unless errors.empty?
  end
end