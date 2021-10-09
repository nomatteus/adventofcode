require 'set'
require 'pry'

PART2_MAX_DISTANCE = 10000
input = IO.read('./input').strip.split("\n")

# test input
# PART2_MAX_DISTANCE = 32
# input = IO.read('./input_small').strip.split("\n")

class Coord < Struct.new(:x, :y, :name)
  # Input: String "275, 276"
  # Output: Coord with x: 275, y: 276
  def self.from_str(coord_str, name)
    x, y = coord_str.scan(/\d+/).map(&:to_i)
    self.new(x, y, name)
  end
end

class Grid
  LOCATION_STATES = {
    undefined: 0,
    coord: 1,
    has_winner: 2,
    has_tie: 3,
    # Used to define the region in part2
    part2_region: 4,
  }

  TIE = '.'

  DEFAULT_POINT_DATA = {
    state: LOCATION_STATES[:undefined],
    coord: nil,
    winner: '?',
  }

  def initialize(coords)
    @coords = coords
    @max_x = @coords.max_by(&:x).x
    @max_y = @coords.max_by(&:y).y

    # Store grid as nested hash, with X's as first key, and Y's as second.
    # Use hash default values to keep the grid flexible
    @grid = Hash.new do |hash, key|
      # Create hash for Y coordinate, with default state of undefined
      hash[key] = Hash.new { DEFAULT_POINT_DATA.merge({}) }
    end

    @coords.each do |coord|
      @grid[coord.x][coord.y] = @grid[coord.x][coord.y].merge(coord: coord.name, state: LOCATION_STATES[:coord])
    end
  end

  def part1
    # Calculate distances to find the closest coords to each point
    0.upto(@max_x).map do |x|
      row = 0.upto(@max_y).map do |y|
        min_distance = nil
        distances = @coords.map do |coord|
          manhattan_distance = (x - coord.x).abs + (y - coord.y).abs
          min_distance = manhattan_distance if min_distance.nil? || manhattan_distance < min_distance
          {
            coord: coord,
            manhattan_distance: manhattan_distance,
          }
        end

        winners = distances.select { |inst| inst[:manhattan_distance] == min_distance }

        result = winners.size > 1 ? TIE : winners.first[:coord].name

        @grid[x][y] = @grid[x][y].merge(
          state: result == TIE ? LOCATION_STATES[:has_tie] : LOCATION_STATES[:has_winner],
          winner: result,
        )
      end
    end

    # Find the coord with max non-infinite area
    coord_areas = @coords.map { |coord| [coord, area(coord)] }.to_h
    winner_coord, winner_area = coord_areas.reject { |coord, area| area == Float::INFINITY }.max_by { |coord, area| area }

    # return area as result
    winner_area
  end

  def part2
    0.upto(@max_x).map do |x|
      row = 0.upto(@max_y).map do |y|
        distances = @coords.map do |coord|
          manhattan_distance = (x - coord.x).abs + (y - coord.y).abs
          {
            coord: coord,
            manhattan_distance: manhattan_distance,
          }
        end

        total_distance = distances.sum { |distance| distance[:manhattan_distance] }

        is_in_region = total_distance < PART2_MAX_DISTANCE

        # Use same grid but only care about the part2_region state
        @grid[x][y] = @grid[x][y].merge(
          state: is_in_region ? LOCATION_STATES[:part2_region] : LOCATION_STATES[:undefined],
          winner: is_in_region ? '#' : '?',
        )
      end
    end

    all_coords.count { |grid_coord| grid_coord[:state] == LOCATION_STATES[:part2_region] }
  end


  # Calculate the area for a given coord.
  # If ininite, will return Float::INFINITY. Otherwise, return the integer area.
  def area(coord)
    # Note that if coord appears on the "edge" of our grid, it continues infinitely
    area_is_infinite = grid_edge_coords.any? { |edge_coord| edge_coord[:state] == LOCATION_STATES[:has_winner] && edge_coord[:winner] == coord.name }
    return Float::INFINITY if area_is_infinite

    # Otherwise, we just count the winners (which includes the coord itself) as the area
    all_coords.count { |grid_coord| grid_coord[:state] == LOCATION_STATES[:has_winner] && grid_coord[:winner] == coord.name }
  end

  def all_coords
    @grid.values.map(&:values).flatten
  end

  # Return all coords on edges. Note that this will return corners twice, 
  # but that's fine for what this is used for
  def grid_edge_coords
    @grid[0].values +
      @grid.map { |loc, cols| cols[0] } +
      @grid[@max_x].values +
      @grid.map { |loc, cols| cols[@max_y] }
  end

  # Output grid, for debugging (only useful for small version)
  def to_s
    0.upto(@max_x).map do |x|
      row = 0.upto(@max_y).map do |y|
        @grid[x][y][:coord].nil? ? @grid[x][y][:winner] : @grid[x][y][:coord]
      end.join
      row.concat("\n")
    end
  end
end

# ruby can create sequence of a string via `.next` method
name = 'A'
coords = input.map do |s|
  c = Coord.from_str(s, name)
  name = name.next
  c
end

grid1 = Grid.new(coords)
part1 = grid1.part1

grid2 = Grid.new(coords)
part2 = grid2.part2

puts "Part 1: #{part1}" # 5333
puts "Part 2: #{part2}"
