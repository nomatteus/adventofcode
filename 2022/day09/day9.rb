require 'pry'
require 'matrix'
require 'set'

input_file = './input'
# input_file = './input_small'

Move = Struct.new(:direction, :num_steps)

DIRECTION_VECTORS = {
  'U' => Vector[0, 1],
  'D' => Vector[0, -1],
  'L' => Vector[-1, 0],
  'R' => Vector[1, 0],
}

# Parse into a series of Moves
moves = IO.read(input_file).strip.split("\n").map do |line|
  dir, num = line.split

  Move.new(dir, num.to_i)
end


#### PART 1

# Arbitrary starting position at 0,0
head_position = Vector[0, 0]
tail_position = Vector[0, 0]

# Track unique positions tail has visited
tail_visited_positions = Set.new
tail_visited_positions << tail_position

moves.each do |move|
  dir_vector = DIRECTION_VECTORS[move.direction]

  move.num_steps.times do 
    head_position += dir_vector
    # Now figure out how the tail follows...
    # binding.pry
    x_diff = head_position[0] - tail_position[0]
    y_diff = head_position[1] - tail_position[1]

    if x_diff.abs <= 1 && y_diff.abs <= 1
      # tail is already touching head (same pos or 1 away in any direction), so does not move
      # noop (refactor this later)
    else
      if x_diff == 0 && y_diff.abs == 2
        # tail is 2 positions above or below head, so move 1 space towards head
        tail_position += Vector[0, y_diff/y_diff.abs]
      elsif x_diff.abs == 2 && y_diff == 0
        # tail is 2 positions left or right head, so move 1 space towards head
        tail_position += Vector[x_diff/x_diff.abs, 0]
      elsif x_diff > 0 && y_diff < 0
        # top left; move diagonally towards head
        tail_position += Vector[1, -1] # TODO: check this
      elsif x_diff < 0 && y_diff < 0
        # top right; move diagonally towards head
        tail_position += Vector[-1, -1] # TODO: check this
      elsif x_diff > 0 && y_diff > 0
        # bottom left; move diagonally towards head
        tail_position += Vector[1, 1]
      elsif x_diff < 0 && y_diff > 0
        # bottom right; move diagonally towards head
        tail_position += Vector[-1, 1]
      else
        puts "error... unexpected condition. x_diff: #{x_diff}, y_diff: #{y_diff}"
      end
    end
    tail_visited_positions << tail_position
  end
end



#### PART 2

# Arbitrary starting position at 0,0
head_position = Vector[0, 0]
knot_positions = Array.new(9) { Vector[0, 0] }

# Track unique positions tail has visited
tail_visited_positions2 = Set.new
tail_visited_positions2 << knot_positions.last

moves.each do |move|
  dir_vector = DIRECTION_VECTORS[move.direction]

  move.num_steps.times do 
    head_position += dir_vector
    
    # Now figure out how the rest of the knots follow
    knot_positions.each.with_index do |knot_position, i|
      prev_position = (i == 0) ? head_position : knot_positions[i - 1]

      x_diff = prev_position[0] - knot_position[0]
      y_diff = prev_position[1] - knot_position[1]

      if x_diff.abs <= 1 && y_diff.abs <= 1
        # tail is already touching head (same pos or 1 away in any direction), so does not move
        # noop (refactor this later)
      else
        if x_diff == 0 && y_diff.abs == 2
          # tail is 2 positions above or below head, so move 1 space towards head
          knot_positions[i] += Vector[0, y_diff/y_diff.abs]
        elsif x_diff.abs == 2 && y_diff == 0
          # tail is 2 positions left or right head, so move 1 space towards head
          knot_positions[i] += Vector[x_diff/x_diff.abs, 0]
        elsif x_diff > 0 && y_diff < 0
          # top left; move diagonally towards head
          knot_positions[i] += Vector[1, -1] # TODO: check this
        elsif x_diff < 0 && y_diff < 0
          # top right; move diagonally towards head
          knot_positions[i] += Vector[-1, -1] # TODO: check this
        elsif x_diff > 0 && y_diff > 0
          # bottom left; move diagonally towards head
          knot_positions[i] += Vector[1, 1]
        elsif x_diff < 0 && y_diff > 0
          # bottom right; move diagonally towards head
          knot_positions[i] += Vector[-1, 1]
        else
          puts "error... unexpected condition. x_diff: #{x_diff}, y_diff: #{y_diff}"
        end
      end
      # only track last knot's position for part 2 answer
      tail_visited_positions2 << knot_positions[i] if i == 8
    end
  end
end


part1 = tail_visited_positions.size
part2 = tail_visited_positions2.size

puts "Part 1: #{part1}" # 6337
puts "Part 2: #{part2}" # 2455
