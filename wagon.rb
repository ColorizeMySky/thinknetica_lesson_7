require_relative 'modules/manufacturing_companies'
require_relative 'modules/validator'

class Wagon
  include ManufacturingCompanies
  include Validator

  attr_reader :type

  def initialize(type, total_place)
    @type = type
    @total_place = total_place
    @used_place = 0

    validate!
  end

  protected

  attr_reader :used_place, :total_place

  def take_place(place)
    raise 'Вагон полностью заполнен' if @used_place == @total_place
    raise "Недостаточно места. Доступно: #{free_place}" if place > free_place
    @used_place += place
  end

  def free_place
    @total_place - @used_place
  end

  private

  def validate!
    raise "Тип вагона не может отсутствовать" if type.to_s.strip.empty?
    raise "Неизвестный тип вагона. Допустимые значения: 'cargo', 'passenger'" unless ['cargo', 'passenger'].include?(type)
  end
end