require 'matrix'
require 'set'
require 'pry'
# Day 9 Intcode works as-is for this problem, so use that
require_relative '../day09/intcode_day9'

input = IO.read('input')
program = Intcode::Helpers.parse_program(input)

class PaintingRobot
  attr_reader :painted_panels

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

  def initialize(program:, starting_color:)
    @program = program
    @robot = Intcode::Computer.new(program: program, debug: false)

    # Store panel as a hash where key is a Vector and value is current color
    # All panels start as black, so set that as default.
    @panel_grid = Hash.new(BLACK)

    @current_location = Vector[0, 0]
    @current_direction = UP

    # Set initial color
    @panel_grid[@current_location] = starting_color

    # Track all panels that have been painted at least once
    @painted_panels = Set.new
  end

  def run!
    while !@robot.terminated? do
      panel_color = @panel_grid[@current_location]

      # Input: 0 if over black panel, 1 if over white panel
      @robot.add_input(panel_color)

      # Output 1: First, it will output a value indicating the color to paint the
      # panel the robot is over: 0 means to paint the panel black, and 1 means to
      # paint the panel white.
      new_color = @robot.run
      break if new_color.nil? # program has terminated
      @panel_grid[@current_location] = new_color

      @painted_panels << @current_location

      # Output 2: Second, it will output a value indicating the direction the robot
      # should turn: 0 means it should turn left 90 degrees, and 1 means it should turn right 90 degrees.
      direction = @robot.run
      if direction == OUTPUT_LEFT
        # Turn left 90 degress
        @current_direction = case @current_direction
        when UP then LEFT
        when LEFT then DOWN
        when DOWN then RIGHT
        when RIGHT then UP
        end
      else
        # Turn right 90 degrees
        @current_direction = case @current_direction
        when UP then RIGHT
        when RIGHT then DOWN
        when DOWN then LEFT
        when LEFT then UP
        end
      end

      # Move forward one space
      @current_location += @current_direction
    end
  end

  # Output grid of panels
  def to_s
    # Calculate boundaries
    left = @painted_panels.map { |panel| panel[0] }.min
    right = @painted_panels.map { |panel| panel[0] }.max
    top = @painted_panels.map { |panel| panel[1] }.max
    bottom = @painted_panels.map { |panel| panel[1] }.min

    top.downto(bottom).map do |col|
      left.upto(right).map do |row|
        @panel_grid[Vector[row, col]] == WHITE ? '⬜' : '⬛'
      end.join
    end.join("\n")
  end
end

part1_robot = PaintingRobot.new(program: program, starting_color: PaintingRobot::BLACK)
part1_robot.run!
# Part 1: 2226
puts "Part 1: #{part1_robot.painted_panels.size} painted panels."

# Part 2: HBGLZKLF
puts "Part 2:"
part2_robot = PaintingRobot.new(program: program, starting_color: PaintingRobot::WHITE)
part2_robot.run!
puts part2_robot
