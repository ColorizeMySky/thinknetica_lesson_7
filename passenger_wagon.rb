class PassengerWagon < Wagon
  alias_method :busy_seats, :used_place
  alias_method :total_seats, :total_place
  public :busy_seats, :total_seats

  def initialize(seats)
    super('passenger', seats)
  end

  def take_seat
    take_place(1)
  end
end