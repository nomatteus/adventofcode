require 'matrix'
require 'set'
require 'pry'
# Day 9 Intcode works as-is for this problem, so use that
require_relative '../day09/intcode_day9'

input = IO.read('input')
program = Intcode::Helpers.parse_program(input)
robot = Intcode::Computer.new(program: program, debug: false)

# Color values
BLACK = 0
WHITE = 1

# Output codes
OUTPUT_LEFT = 0
OUTPUT_RIGHT = 1

# Direction vectors
UP = Vector[0, 1]
DOWN = Vector[0, -1]
LEFT = Vector[-1, 0]
RIGHT = Vector[1, 0]

# Store panel as a hash where key is a Vector and value is current color
# All panels start as black, so set that as default.
panel_grid = Hash.new(BLACK)

current_location = Vector[0, 0]
current_direction = UP

# Track all panels that have been painted at least once
painted_panels = Set.new

while !robot.terminated? do
  panel_color = panel_grid[current_location]

  # Input: 0 if over black panel, 1 if over white panel
  robot.add_input(panel_color)

  # Output 1: First, it will output a value indicating the color to paint the
  # panel the robot is over: 0 means to paint the panel black, and 1 means to
  # paint the panel white.
  new_color = robot.run
  panel_grid[current_location] = new_color

  painted_panels << current_location

  # Output 2: Second, it will output a value indicating the direction the robot
  # should turn: 0 means it should turn left 90 degrees, and 1 means it should turn right 90 degrees.
  direction = robot.run
  if direction == OUTPUT_LEFT
    # Turn left 90 degress
    current_direction = case current_direction
    when UP then LEFT
    when LEFT then DOWN
    when DOWN then RIGHT
    when RIGHT then UP
    end
  else
    # Turn right 90 degrees
    current_direction = case current_direction
    when UP then RIGHT
    when RIGHT then DOWN
    when DOWN then LEFT
    when LEFT then UP
    end
  end

  # Move forward one space
  current_location += current_direction
end

puts "Part 1: #{painted_panels.size} painted panels." # 2226
