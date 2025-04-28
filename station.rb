require_relative 'modules/instance_counter'
require_relative 'modules/validator'

class Station
  include InstanceCounter
  include Validator

  attr_reader :title, :trains

  TITLE_FORMAT = /^[a-zа-я0-9\s\-]+$/i

  @@stations = []

  class << self
    def all
      @@stations
    end
  end

  def initialize(title)
    @title = title
    @trains = []

    validate!

    @@stations << self
    register_instance
  end

  def add_train(train)
    @trains << train
  end

  def depart_train(train)
    @trains.delete(train)
  end

  def trains_by_type(type)
    @trains.count { |train| train.type == type }
  end

  def each_train(&block)
    @trains.each(&block)
  end

  private

  def validate!
    errors = []
    errors << "Название не может отсутствовать" if title.to_s.strip.empty?
    errors << "Название станции слишком короткое (минимум 2 символа)" if title.length < 2
    errors << "Название станции слишком длинное (максимум 50 символов)" if title.length > 50
    errors << "Название станции содержит недопустимые символы" unless title !~ TITLE_FORMAT

    raise errors.join("\n") unless errors.empty?
  end
end