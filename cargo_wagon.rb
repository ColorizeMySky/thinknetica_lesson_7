class CargoWagon < Wagon
  attr_reader :volume, :volume_busy

  def initialize(volume)
    super('cargo')
    @volume = volume
    @volume_busy = 0
  end

  def take_volume(volume)
    raise 'Вагон полностью заполнен' if @volume_busy == @volume
    raise "В вагоне осталось только #{available_volume}" if volume > available_volume
    @volume_busy += volume
  end

  def available_volume
    @volume - @volume_busy
  end
end