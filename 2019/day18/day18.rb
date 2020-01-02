require 'pry'
require 'matrix'

# Copied & modified map from day 15
class Map
  attr_reader :current_location,
    :starting_location,
    :points

  TILES = {
    wall: '#',
    open: '.',
    entrance: '@',
    key: 'k',
    door: 'D',
  }

  # TODO: Note that while key spaces are open, we need to handle them a bit differently.
  # i.e. if we ever pass through it, we need to collect the key
  OPEN_TILES = [:open, :entrance, :key]

  DIRECTION_VECTORS = {
    north: Vector[0, 1],
    south: Vector[0, -1],
    east: Vector[1, 0],
    west: Vector[-1, 0],
  }
  VECTOR_TO_DIRECTION_COMMAND = DIRECTION_VECTORS.invert

  def self.from_input(input)
    points = {}
    # keys: map from pos to key letter
    keys = {}
    # doors: map from pos to door letter
    doors = {}
    input.strip.split.each.with_index do |row, y|
      row.split('').each.with_index do |val, x|
        pos = Vector[x, y]

        tile = case val
        when '#' then :wall
        when '.' then :open
        when '@' then :entrance
        when /[a-z]/ then
          keys[pos] = val
          :key
        when /[A-Z]/ then
          doors[pos] = val
          :door
        else
          raise "Unsupported value: #{val}"
        end
        points[pos] = tile
      end
    end
    Map.new(points: points, keys: keys, doors: doors)
  end

  def initialize(points:, keys:, doors:)
    # Hash of position => itle
    @points = points
    # Hash of position => letter
    @keys = keys
    # Hash of position => letter
    @doors = doors
  end

  # Get location in given direction
  def next_location(direction)
    @current_location + DIRECTION_VECTORS[direction]
  end

  # Find a path from first location to second location
  # Returns: a list of locations, with loc1 as the first location in the list,
  # and loc2 as the last location
  def find_path(start, goal)
    raise "loc1 must not be the same as loc2" if start == goal

    # Using A* path-finding algorithm
    # See pseudocode here: https://en.wikipedia.org/wiki/A*_search_algorithm
    # https://www.redblobgames.com/pathfinding/a-star/introduction.html
    # NOTE that this is overkill for this problem...
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
    # case, we consider all edges equally, so hardcode 1
    d_score = 1

    until open_set.empty? do
      # Node in open set with lowest f score (would ideally use PriorityQueue)
      current = open_set.min_by { |node| f_score[node] }

      if current == goal
        return reconstruct_path(came_from, current)
      end

      open_set.delete(current)

      valid_neighbours(current).each do |neighbour_loc|
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

  # Returns a list of all valid neighbours (i.e. locations that can be visited: :open or :oxygen)
  def valid_neighbours(current)
    DIRECTION_VECTORS.values
      .map { |dir_vec| current + dir_vec }
      .select { |loc| OPEN_TILES.include?(@points[loc]) }
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
        tile_key = @points[pos]
        TILES[tile_key]
      end.join
    end.join("\n")
  end

  private

  def update_current_location(loc)
    @current_location = loc
  end
end

input_file = 'input'
input = IO.read(input_file)
map = Map.from_input(input)

puts map.to_s
