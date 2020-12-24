require 'matrix'
require 'pry'

input = IO.read('./input').strip.split("\n")
# input = IO.read('./input_small').strip.split("\n")

class NavigationComputer
  # Directions as (x, y) vector
  DIRECTION_VECTORS = {
    north: Vector[0, 1],
    south: Vector[0, -1],
    west: Vector[-1, 0],
    east: Vector[1, 0],
  }
  DIR_VECTORS_TO_DIRECTIONS = DIRECTION_VECTORS.invert
  DIRECTIONS = {
    'N' => :north,
    'S' => :south,
    'W' => :west,
    'E' => :east,
    'L' => :left,
    'R' => :right,
    'F' => :forward,
  }
  # Order of directions when turning in specified direction
  DIRECTIONS_LEFT = [:north, :west, :south, :east]
  DIRECTIONS_RIGHT = [:north, :east, :south, :west]

  def initialize(input)
    @input = input
  end

  def part1
    current_dir_vector = DIRECTION_VECTORS[:east]
    current_position = Vector[0, 0]

    @input.each do |instruction|
      dir, value = parse_instruction(instruction)

      case dir
      when :north
        current_position += DIRECTION_VECTORS[:north] * value
      when :south
        current_position += DIRECTION_VECTORS[:south] * value
      when :west
        current_position += DIRECTION_VECTORS[:west] * value
      when :east
        current_position += DIRECTION_VECTORS[:east] * value
      when :left
        current_dir_vector = turn(:left, current_dir_vector, value)
      when :right
        current_dir_vector = turn(:right, current_dir_vector, value)
      when :forward
        current_position += current_dir_vector * value
      else
        raise "Invalid dir: #{dir}"
      end
    end

    # Manhattan distance from 0,0
    current_position.map(&:abs).sum
  end

  def part2
    current_position = Vector[0, 0]
    waypoint = Vector[10, 1]

    @input.each do |instruction|
      dir, value = parse_instruction(instruction)

      case dir
      when :north
        waypoint += DIRECTION_VECTORS[:north] * value
      when :south
        waypoint += DIRECTION_VECTORS[:south] * value
      when :west
        waypoint += DIRECTION_VECTORS[:west] * value
      when :east
        waypoint += DIRECTION_VECTORS[:east] * value
      when :left
        waypoint = rotate_waypoint(:left, waypoint, value)
      when :right
        waypoint = rotate_waypoint(:right, waypoint, value)
      when :forward
        current_position += waypoint * value
      else
        raise "Invalid dir: #{dir}"
      end
    end

    # Manhattan distance from 0,0
    current_position.map(&:abs).sum
  end

  private

  # Given an instruction, output a direction and value
  def parse_instruction(instruction)
    return DIRECTIONS[instruction[0]], instruction[1..].to_i
  end

  # Given current direction and degrees to turn, and which direction,
  # return a new direction vector representing the new direction.
  def turn(direction, current_dir_vector, degrees)
    directions = direction == :left ? DIRECTIONS_LEFT : DIRECTIONS_RIGHT

    turns = degrees / 90
    direction = DIR_VECTORS_TO_DIRECTIONS[current_dir_vector]

    new_index = (directions.index(direction) + turns) % directions.size
    new_direction = directions[new_index]

    DIRECTION_VECTORS[new_direction]
  end

  # Assumptions: Degrees is one of: [90, 180, 270]
  def rotate_waypoint(direction, current_waypoint, degrees)
    raise "Invalid degrees: #{degrees}" unless [90, 180, 270].include?(degrees)
    return rotate_waypoint(:right, current_waypoint, 360 - degrees) if direction == :left

    (degrees / 90).times { current_waypoint = rotate90(current_waypoint) }
    current_waypoint
  end

  # Rotate right 90 degrees
  # e.g. (10, 4) => (4, -10) => (-10, -4), (-4, 10) => (10, 4)
  def rotate90(current_waypoint)
    x, y = *current_waypoint
    Vector[y, -x]
  end
end


computer = NavigationComputer.new(input)

part1 = computer.part1
puts "Part 1: #{part1}" # 1710


part2 = computer.part2
puts "Part 2: #{part2}" # 62045
