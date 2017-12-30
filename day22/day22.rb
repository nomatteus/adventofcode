require 'pry'

input_grid = IO.read('./input').strip.split("\n").map { |row| row.split('') }

class GridComputingCluster
  INFECTED  = '#'
  CLEAN     = '.'
  WEAKENED  = 'W'
  FLAGGED   = 'F'

  # Setup direction vectors
  # Note that these are sorted in clockwise order, so we can use ordering to turn right/left
  DIRECTIONS = {
    UP:     [0, 1],
    RIGHT:  [1, 0],
    DOWN:   [0, -1],
    LEFT:   [-1, 0]
  }

  attr_accessor :grid, :current_node

  def initialize(input_grid)
    # Store positions in a hash, since we have an unbounded grid
    @grid = {}
    parse_input(input_grid)

    # Starting State
    @current_node = [0, 0]
    @current_direction = DIRECTIONS[:UP]

    # Count how many bursts caused infection
    @infection_count = 0
  end

  def run_part1!
    10000.times { burst_part1 }
    @infection_count
  end

  def run_part2!
    10000000.times { burst_part2 }
    @infection_count
  end

  # A single "burst" (movement)
  def burst_part1
    if @grid[@current_node] == INFECTED
      turn(:right)
      @grid[@current_node] = CLEAN
    else
      turn(:left)
      @grid[@current_node] = INFECTED
      @infection_count += 1
    end

    move
  end

  # A single burst for part2
  def burst_part2
    case @grid[@current_node]
    when CLEAN, nil
      turn(:left)
      @grid[@current_node] = WEAKENED
    when WEAKENED
      # do not turn
      @grid[@current_node] = INFECTED
      @infection_count += 1
    when INFECTED
      turn(:right)
      @grid[@current_node] = FLAGGED
    when FLAGGED
      reverse
      @grid[@current_node] = CLEAN
    end

    move
  end

  def reverse
    2.times { turn(:right) }
  end

  def turn(direction)
    current_index = DIRECTIONS.values.find_index(@current_direction)
    turn_delta = direction == :left ? -1 : 1
    new_index = (current_index + turn_delta) % DIRECTIONS.size
    @current_direction = DIRECTIONS.values[new_index]
  end

  # Move forward one turn
  def move
    @current_node = @current_node.zip(@current_direction).map(&:sum)
  end

private

  # Parses the input grid and stores in a hash with the center of the grid
  # as the <0,0> coordinate.
  def parse_input(input_grid)
    # Assume always square size input, and also that size is odd
    size = input_grid.size

    # The middle of the grid is 0,0, so we go from -size/2 to size/2
    # Input starts at top left
    y = size/2
    input_grid.each do |row|
      x = -(size/2)
      row.each do |val|
        @grid[[x, y]] = val
        x += 1
      end
      y -= 1
    end
  end

end

part1_grid = GridComputingCluster.new(input_grid)
part1 = part1_grid.run_part1!
puts "Part 1: #{part1}"

part2_grid = GridComputingCluster.new(input_grid)
part2 = part2_grid.run_part2!
puts "Part 2: #{part2}"
