require 'pry'
require 'matrix'
require 'set'
require_relative '../day13/intcode_day13'

input = IO.read('input')
program = Intcode::Helpers.parse_program(input)

class Map
  attr_reader :current_location,
    :oxygen_found,
    :oxygen_location,
    :starting_location

  TILES = {
    wall: '#',
    open: '.',
    oxygen: 'O',

    droid: 'D',

    unknown: ' ',
  }

  # Which tiles are considered "open", i.e. we can walk through them
  OPEN_TILES = [:open, :oxygen]

  DIRECTION_VECTORS = {
    north: Vector[0, 1],
    south: Vector[0, -1],
    east: Vector[1, 0],
    west: Vector[-1, 0],
  }
  VECTOR_TO_DIRECTION_COMMAND = DIRECTION_VECTORS.invert

  def initialize
    # Key is a location, and value is tile key
    @points = Hash.new(:unknown)

    # Init droid at starting location
    @starting_location = Vector[0, 0]
    @current_location = @starting_location
    @points[@current_location] = :open

    @oxygen_found = false
    @oxygen_location = nil
  end

  # Get location in given direction
  def next_location(direction)
    @current_location + DIRECTION_VECTORS[direction]
  end

  def visited?(loc)
    @points.has_key?(loc)
  end

  def hit_wall(direction)
    loc = next_location(direction)
    @points[loc] = :wall
  end

  def moved(direction)
    loc = next_location(direction)
    @points[loc] = :open

    update_current_location(loc)
  end

  def found_oxygen(direction)
    loc = next_location(direction)
    @points[loc] = :oxygen

    update_current_location(loc)

    @oxygen_location = loc
    @oxygen_found = true
  end

  # Find a path from first location to second location
  # Returns: a list of locations, with loc1 as the first location in the list,
  # and loc2 as the last location
  def find_path(start, goal)
    raise "loc1 must not be the same as loc2" if start == goal

    # Note that we will find shortest path on map as we currently
    #   know it... there may be a shorter undiscovered path.
    # Using A* path-finding algorithm
    # See pseudocode here: https://en.wikipedia.org/wiki/A*_search_algorithm
    open_set = Set.new([start])
    came_from = {}

    # Default value of "Infinity", but we can just use nil
    g_score = {}
    g_score[start] = 0

    # f_score = g_score[node] + h_score[node]
    # This uses both current best path (g score) aka similar to Djikstra's algorithm,
    # plus the heuristic score.
    f_score = {}
    # g_score[start] is 0, so not included here
    f_score[start] = h_score(start, goal)

    # Note that we add d_score as the weight of the edge, but in our
    # case, we consider all edges equally, so harcode 1
    d_score = 1

    until open_set.empty? do
      # Node in open set with lowest f score (would ideally use PriorityQueue)
      current = open_set.min_by { |node| f_score[node] }

      if current == goal
        return reconstruct_path(came_from, current)
      end

      open_set.delete(current)

      # For each neighbour that we can visit (i.e. is :open or :oxygen)
      valid_neighbours = DIRECTION_VECTORS.values
        .map { |dir_vec| current + dir_vec }
        .select { |loc| OPEN_TILES.include?(@points[loc]) }

      valid_neighbours.each do |neighbour_loc|
        tentative_g_score = g_score[current] + d_score
        if g_score[neighbour_loc].nil? || tentative_g_score < g_score[neighbour_loc]
          # This path to neighbor is better than any previous one. Record it!
          came_from[neighbour_loc] = current
          g_score[neighbour_loc] = tentative_g_score
          f_score[neighbour_loc] = g_score[neighbour_loc] + h_score(neighbour_loc, goal)
          if !open_set.include?(neighbour_loc)
            open_set << neighbour_loc
          end
        end
      end
    end

    raise "error, no path found!"
  end

  # For A*, this is our heuristic score, i.e. best guess of how close we
  # are to the goal from this location.
  # Use manhattan distance for now, though it's not always accurate
  def h_score(loc, goal)
    (goal[0] - loc[0]).abs + (goal[1] - loc[1]).abs
  end

  def reconstruct_path(came_from, current)
    total_path = [current]
    while came_from.has_key?(current) do
      current = came_from[current]
      # unshift in ruby => prepend
      total_path.unshift(current)
    end
    total_path
  end

  # Similar to find_path, but outputs a list of direction commands
  # that should be executed in order to get from loc1 to loc2
  def find_path_commands(loc1, loc2)
    path_locations = find_path(loc1, loc2)
    prev_location = nil
    commands = []
    path_locations.each do |location|
      if prev_location
        # Calculate vector from prev to current location
        vec = location - prev_location
        # turn that into a command
        commands << VECTOR_TO_DIRECTION_COMMAND[vec]
      end

      prev_location = location
    end
    commands
  end

  def display
    puts to_s
    puts "-----------------"
  end

  def to_s
    minx = @points.keys.map{ |p| p[0] }.min
    maxx = @points.keys.map{ |p| p[0] }.max
    miny = @points.keys.map{ |p| p[1] }.min
    maxy = @points.keys.map{ |p| p[1] }.max

    maxy.downto(miny).map do |y|
      minx.upto(maxx).map do |x|
        pos = Vector[x, y]
        if @current_location == pos
          TILES[:droid]
        else
          tile_key = @points[pos]
          TILES[tile_key]
        end
      end.join
    end.join("\n")
  end

  private

  def update_current_location(loc)
    @current_location = loc
  end
end

class DroidController
  MOVE_COMMANDS = {
    north: 1,
    south: 2,
    west: 3,
    east: 4,
  }

  RESULT_CODES = {
    # 0: The repair droid hit a wall. Its position has not changed.
    0 => :hit_wall,
    # 1: The repair droid has moved one step in the requested direction.
    1 => :moved,
    # 2: The repair droid has moved one step in the requested direction;
    # its new position is the location of the oxygen system.
    2 => :found_oxygen,
  }

  def initialize(program:, debug: false)
    @computer = Intcode::Computer.new(program: program, debug: debug)

    @map = Map.new
    @map.display
  end

  # Part 1: Find shortest number of commands to get from starting point
  # to oxygen.
  def start_to_oxygen_commands
    discover_map
    @map.find_path_commands(@map.starting_location, @map.oxygen_location)
  end

  # Discover the map
  def discover_map
    # A location is a position + a direction
    # Note that the position will always be open (i.e. not a wall)
    # Start with our initial set
    unvisited_locations = Set.new([
      [@map.current_location, :north],
      [@map.current_location, :south],
      [@map.current_location, :east],
      [@map.current_location, :west],
    ])
    visited_locations = Set.new()

    while unvisited_locations.size > 0
      # Choose the closest location to avoid having droid go all over the map
      location_key = unvisited_locations.min_by { |(loc, dir)| (loc - @map.current_location).map(&:abs).sum }
      loc, dir = location_key

      # Make sure we are at location
      visit(loc)

      # Attempt to move in given direction to discover
      move(dir)

      unvisited_locations.delete(location_key)
      visited_locations << location_key

      # Note that this may be the same as loc if we hit a wall
      new_loc = @map.current_location

      # Generate each neighbour visit
      [
        [new_loc, :north],
        [new_loc, :south],
        [new_loc, :east],
        [new_loc, :west],
      ].each do |loc_key|
        next if visited_locations.include?(loc_key)

        unvisited_locations << loc_key
      end
    end
  end

  # Execute commands necessary to get to desired location from
  # current location, using path finding method
  def visit(loc)
    return if @map.current_location == loc

    # Get the list of commands that we need to execute to get to the desired location
    commands = @map.find_path_commands(@map.current_location, loc)
    commands.each { |command| move(command) }
  end

  def move(command)
    input_code = MOVE_COMMANDS[command]
    @computer.add_input(input_code)
    result = @computer.run

    case RESULT_CODES[result]
    when :hit_wall
      @map.hit_wall(command)
    when :moved
      @map.moved(command)
    when :found_oxygen
      @map.found_oxygen(command)
    end

    @map.display
  end
end

droid_controller = DroidController.new(program: program)
commands = droid_controller.start_to_oxygen_commands

puts "Part 1: #{commands.size} commands to get from start to oxygen." # 228
