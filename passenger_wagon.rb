class PassengerWagon < Wagon
  attr_reader :seats, :seats_busy

  def initialize(seats)
    super('passenger')
    @seats = seats
    @seats_busy = 0
  end

  def take_seat
    raise 'В вагоне не осталось свободных мест' unless @seats_busy <= @seats
    @seats_busy += 1
  end

  def available_seats
    @seats - @seats_busy
  end
end