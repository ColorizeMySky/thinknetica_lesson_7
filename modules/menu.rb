module Menu
  MENU_CONFIG = [
  {id: 1, title: 'Создать станцию', action: :create_station},
  {id: 2, title: 'Создать поезд', action: :create_train},
  {id: 3, title: 'Создать маршрут', action: :create_route},
  {id: 4, title: 'Добавить станцию в маршрут', action: :add_station_to_route},
  {id: 5, title: 'Удалить станцию из маршрута', action: :remove_station_from_route},
  {id: 6, title: 'Назначить маршрут поезду', action: :assign_route_to_train},
  {id: 7, title: 'Добавить вагон к поезду', action: :add_wagon_to_train},
  {id: 8, title: 'Отцепить вагон от поезда', action: :remove_wagon_from_train},
  {id: 9, title: 'Переместить поезд по маршруту', action: :move_train},
  {id: 10, title: 'Просмотреть список станций и поездов', action: :show_info},
  {id: 0, title: 'Выход', action: :exit_interface}
].freeze

  def show_menu
    MENU_CONFIG.each { |item| puts "#{item[:id]}. #{item[:title]}" }
  end

  def get_choice
    puts "Выберите действие: "
    gets.chomp.to_i
  end

  def take_action(choice)
    item = MENU_CONFIG.find { |menu_item| menu_item[:id] == choice }
    send(item[:action]) if item
  end

  def exit_interface
    exit
  end

end