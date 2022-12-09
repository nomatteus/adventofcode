require 'pry'
require 'matrix'
require 'set'

input_file = './input'
# input_file = './input_small'

Move = Struct.new(:direction, :num_steps)

# Parse into a series of Moves
moves = IO.read(input_file).strip.split("\n").map do |line|
  dir, num = line.split

  Move.new(dir, num.to_i)
end

class KnotSimulator
  STARTING_POSITION = Vector[0, 0]

  DIRECTION_VECTORS = {
    'U' => Vector[0, 1],
    'D' => Vector[0, -1],
    'L' => Vector[-1, 0],
    'R' => Vector[1, 0],
  }

  # num_knots: how many knots (not counting head knot)
  def initialize(num_knots)
    @num_knots = num_knots
    @head_position = STARTING_POSITION
    @knot_positions = Array.new(num_knots) { STARTING_POSITION } 
    @tail_knot_i = @knot_positions.size - 1
  end

  def run!(moves)
    tail_visited_positions = Set.new
    tail_visited_positions << @knot_positions.last

    moves.each do |move|
      dir_vector = DIRECTION_VECTORS[move.direction]

      move.num_steps.times do 
        @head_position += dir_vector
        
        # Now figure out how the rest of the knots follow
        @knot_positions.each.with_index do |knot_position, i|
          prev_position = (i == 0) ? @head_position : @knot_positions[i - 1]

          x_diff = prev_position[0] - knot_position[0]
          y_diff = prev_position[1] - knot_position[1]

          # tail is already touching head (same pos or 1 away in any direction), so does not move
          next if x_diff.abs <= 1 && y_diff.abs <= 1
          
          # Figure out how to move tail knot
          if x_diff == 0 && y_diff.abs == 2
            # tail is 2 positions above or below head, so move 1 space towards head
            @knot_positions[i] += Vector[0, y_diff/y_diff.abs]
          elsif x_diff.abs == 2 && y_diff == 0
            # tail is 2 positions left or right head, so move 1 space towards head
            @knot_positions[i] += Vector[x_diff/x_diff.abs, 0]
          elsif x_diff > 0 && y_diff < 0
            # top left; move diagonally towards head
            @knot_positions[i] += Vector[1, -1]
          elsif x_diff < 0 && y_diff < 0
            # top right; move diagonally towards head
            @knot_positions[i] += Vector[-1, -1]
          elsif x_diff > 0 && y_diff > 0
            # bottom left; move diagonally towards head
            @knot_positions[i] += Vector[1, 1]
          elsif x_diff < 0 && y_diff > 0
            # bottom right; move diagonally towards head
            @knot_positions[i] += Vector[-1, 1]
          else
            puts "error... unexpected condition. x_diff: #{x_diff}, y_diff: #{y_diff}"
          end

          # only track tail (last knot's) position
          tail_visited_positions << @knot_positions[i] if i == @tail_knot_i
        end
      end
    end
    # Return number of unique positions tail knot visited (puzzle solution)
    tail_visited_positions.size
  end
end

part1 = KnotSimulator.new(1).run!(moves)
part2 = KnotSimulator.new(9).run!(moves)

puts "Part 1: #{part1}" # 6337
puts "Part 2: #{part2}" # 2455
