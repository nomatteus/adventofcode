require 'matrix'
require 'set'
require 'pry'

input_file = 'input'
# input_file = 'input_small'

STARTING_POINT = Vector[0, 0]
DIRECTION_VECTORS = {
  'U' => Vector[0, 1],
  'D' => Vector[0, -1],
  'L' => Vector[-1, 0],
  'R' => Vector[1, 0],
}

# Input: instruction, e.g. "R323"
# Output: Direction vector & distance, e.g. { dir_vector: Vector[1,0], distance: 323}
def parse_instruction(instruction)
  dir, num = instruction.scan(/([UDLR])(\d+)/).first
  {
    dir_vector: DIRECTION_VECTORS[dir],
    num: num.to_i,
  }
end

# Input: List of instructions for wire.
# Output: Set of points (as Vectors)
def calculate_wire_set(wire_instructions)
  current_point = STARTING_POINT
  point_set = Set.new(current_point)
  wire_instructions.each do |instruction_str|
    instruction = parse_instruction(instruction_str)

    # We want to add all points from current point to num points
    instruction[:num].times do
      current_point += instruction[:dir_vector]
      point_set << current_point
    end
  end
  point_set
end

# Since we set starting point to 0,0, this is easy
def manhattan_distance(point)
  point.map(&:abs).sum
end

# Parse into 2 lists of instructions, in format "D245"
wire_strings = IO.read(input_file).split("\n")
wires = wire_strings.map { |wire_str| wire_str.split(",") }

# Calculate set of points that each wire
wire1_set = calculate_wire_set(wires[0])
wire2_set = calculate_wire_set(wires[1])

# Starting point does not count as a crossed point (by problem definition)
crossed_points = wire1_set & wire2_set - STARTING_POINT

# Find smallest manhattan distance
closest_point = crossed_points.min_by { |point| manhattan_distance(point) }

part1 = manhattan_distance(closest_point)
puts "Part 1: #{part1}"

