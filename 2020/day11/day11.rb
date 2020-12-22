require 'set'
require 'matrix'
require 'pry'

input = IO.read('./input').strip.split("\n")
# input = IO.read('./input_small').strip.split("\n")

CLEAR = "\e[H\e[2J"

class Grid
  attr_accessor :points

  VALUES = {
    floor: '.',
    empty: 'L',
    occupied: '#',
  }
  CHAR_TO_VALUE = VALUES.invert
  DISPLAY_CHARS = {
    floor: '⬜',
    empty: '🟩',
    occupied: '🟥',
  }

  def initialize
    @points = {}
    # Track dimensions (assume we have min of 0,0)
    @max_col = 0
    @max_row = 0
  end

  def set_value(point , value)
    @max_col = [@max_col, point[1]].max
    @max_row = [@max_row, point[0]].max
    @points[point] = value
  end

  def value_at(point)
    @points[point]
  end

  def display_grid
    puts CLEAR
    0.upto(@max_col).each do |col|
      0.upto(@max_row).each do |row|
        point = Vector[row, col]
        char = @points[point]
        display_char = DISPLAY_CHARS[CHAR_TO_VALUE[char]]
        print display_char
      end
      print "\n"
    end
  end

  # TODO: Will need this method to help detect when grids
  def ==(other_grid)
    return false if other_grid.nil?

    self.points == other_grid.points
  end
end

class GameOfSeats
  attr_accessor :current_grid

  # All 8 adjacent locations
  DIR_VECTORS = [
    Vector[1, 1],
    Vector[1, 0],
    Vector[1, -1],
    Vector[0, 1],
    Vector[0, -1],
    Vector[-1, 1],
    Vector[-1, 0],
    Vector[-1, -1],
  ]

  def initialize(grid)
    @current_grid = grid
  end

  def part1
    prev_grid = nil

    while @current_grid != prev_grid
      @current_grid.display_grid
      sleep 0.1

      prev_grid = @current_grid
      @current_grid = compute_next_grid
    end

    # Return # of occupied seats in current state
    @current_grid.points.count { |point, value| value == Grid::VALUES[:occupied] }
  end

  private

  def compute_next_grid
    @next_grid = Grid.new

    @current_grid.points.each do |point, current_value|
      adjacent_occupied_count = DIR_VECTORS.count do |dir|
        target_point = point + dir
        @current_grid.value_at(target_point) == Grid::VALUES[:occupied]
      end

      if current_value == Grid::VALUES[:empty] && adjacent_occupied_count.zero?
        # Becomes occupied
        @next_grid.set_value(point, Grid::VALUES[:occupied])
      elsif current_value == Grid::VALUES[:occupied] && adjacent_occupied_count >= 4
        # Becomes empty
        @next_grid.set_value(point, Grid::VALUES[:empty])
      else
        # Seat does not change
        @next_grid.set_value(point, current_value)
      end
    end

    @next_grid
  end
end

def parse_input(input)
  grid = Grid.new
  input.each_with_index do |row_vals, row| 
    row_vals.chars.each_with_index do |col_vals, col| 
      point = Vector[row, col]
      grid.set_value(point, input[row][col])
    end
  end
  grid
end

grid = parse_input(input)
game = GameOfSeats.new(grid)

part1 = game.part1
puts "Part 1: #{part1}"

part2 = 
puts "Part 2: #{part2}"
