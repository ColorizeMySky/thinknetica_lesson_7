require_relative 'modules/manufacturing_companies'
require_relative 'modules/validator'

class Wagon
  include ManufacturingCompanies
  include Validator

  attr_reader :type

  def initialize(type)
    @type = type

    validate!
  end

  private

  def validate!
    raise "Тип вагона не может отсутствовать" if type.to_s.strip.empty?
    raise "Неизвестный тип вагона. Допустимые значения: 'cargo', 'passenger'" unless ['cargo', 'passenger'].include?(type)
  end
end