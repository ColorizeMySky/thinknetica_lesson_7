require_relative 'train'
require_relative 'passenger_train'
require_relative 'cargo_train'
require_relative 'station'
require_relative 'route'
require_relative 'wagon'
require_relative 'modules/menu'

class Main
  include Menu

  def initialize
    @stations = []
    @trains = []
    @routes = []
    @wagons = []
  end

  def start
    loop do
      show_menu
      choice = get_choice
      take_action(choice)
    end
  end

  private

  def create_station
      puts "Введите название станции: "
      name = gets.chomp
      @stations << Station.new(name)
    rescue => e
      puts "Ошибка: #{e.message}"
    retry
  end

  def create_train
      puts "Введите номер поезда: "
      number = gets.chomp
      puts "Выберите тип (1 - пассажирский, 2 - грузовой): "
      type = gets.chomp.to_i

      train =  if type == 1
        PassengerTrain.new(number)
      else
        CargoTrain.new(number)
      end

      @trains << train
      puts "Создан поезд №#{number} (#{train.type})"
    rescue => e
      puts "Ошибка: #{e.message}"
    retry
  end

  def create_route
      puts "Введите номер начальной станции: "
      first_index = gets.chomp.to_i - 1
      puts "Введите номер конечной станции: "
      last_index = gets.chomp.to_i - 1

      route = Route.new(@stations[first_index], @stations[last_index])
      @routes << route

    rescue => e
      puts "Ошибка: #{e.message}"
    retry
  end

  def create_wagon
      puts "Выберите тип вагона (1 - пассажирский, 2 - грузовой): "
      type = gets.chomp.to_i

      if type == 1
        puts "Введите количество мест: "
        seats = gets.chomp.to_i
        wagon = PassengerWagon.new(seats)
      else
        puts "Введите объем вагона: "
        volume = gets.chomp.to_f
        wagon = CargoWagon.new(volume)
      end

      @wagons << wagon
    rescue => e
      puts "Ошибка: #{e.message}"
      retry
  end

  def add_station_to_route
    select_entity(@routes)
    puts "Введите номер станции для добавления: "
    station_index = gets.chomp.to_i - 1
    puts "Введите позицию (по умолчанию предпоследняя): "
    position = gets.chomp.to_i

    @selected_route.add_station(@stations[station_index], position)
  end

  def remove_station_from_route
    select_entity(@routes)
    puts "Введите номер станции для удаления: "
    station_index = gets.chomp.to_i - 1

    @selected_route.remove_station(@selected_route.stations[station_index])
  end

  def assign_route_to_train
    select_entity(@trains)
    select_entity(@routes)
    @selected_train.assign_route(@selected_route)
  end

  def add_wagon_to_train
    select_entity(@trains)
    wagon = Wagon.new(@selected_train.type)
    @selected_train.add_wagon(wagon)
    @wagons << wagon
  end

  def remove_wagon_from_train
    select_entity(@trains)
    return if @selected_train.wagons.empty?

    wagon = @selected_train.wagons.last
    @selected_train.remove_wagon(wagon)
  end

  def occupy_space_in_wagon
    select_entity(@trains)
    puts "Номер вагона: "
    wagon = @selected_train.wagons[gets.to_i - 1]

    if wagon.type == :passenger
      wagon.take_seat
      puts "Занято одно место"
    else
      volume = gets.to_f
    wagon.take_volume(volume)
      puts "Занято #{volume} объёма"
    end

    rescue => e
      puts "Ошибка: #{e.message}"
  end

  def move_train
    select_entity(@trains)
    puts "Выберите направление (1 - вперед, 2 - назад): "
    direction = gets.chomp.to_i

    if(direction == 1)
      @selected_train.go_forward
    else
      @selected_train.go_backward
    end
  end

  def show_info
    @stations.each do |station|
      puts "\nСтанция #{station.title}:"
      station.trains.empty? ? puts "- Поездов нет" : show_trains(station)
    end
  end
  end

  def select_entity(collection)
    case collection
    when @stations
      puts "Выберите станцию: "
    when @trains
      puts "Выберите поезд: "
    when @routes
      puts "Выберите маршрут: "
    end
    entity_index = gets.chomp.to_i - 1
    @selected_entity = collection[entity_index]
  end

  def show_trains(station)
    station.each_train do |train|
      puts "- Поезд №#{train.number} (#{train.type}), вагонов: #{train.wagons.size}"
      train.each_wagon { |wagon| show_wagon_info(train.type, wagon) }
    end
  end

  def show_wagon_info(train_type, wagon)
    wagon_info = train_type == :passenger ?
      "свободно мест: #{wagon.free_seats}, занято: #{wagon.occupied_seats}" :
      "свободный объем: #{wagon.free_volume}, занято: #{wagon.occupied_volume}"

    puts "-- Вагон #{wagon.object_id}: #{wagon_info}"
  end
end