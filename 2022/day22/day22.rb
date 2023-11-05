require 'pry'
require 'matrix'

input_file = "./input"
input_file = "./input_small"

map_input, moves_input = IO.read(input_file).split("\n\n")
map_lines = map_input.split("\n")

# NOTE: Data.define requires Ruby 3.2+
Point = Data.define(:coords, :type)

# Parse map into grid, where top left is x,y = 1,1 (this problem is 1-based)
# Grid coords
min_x = 1
max_x = map_lines.map(&:size).max
min_y = 1
max_y = map_lines.size

grid = {}
TYPES = {
  empty: ' ',
  open:  '.',
  wall:  '#',
}.freeze
CHAR_TO_TYPE = TYPES.invert.freeze

# Note: `with_index` with offset 1 handles 1-based values
map_lines.each.with_index(1) do |line, y|
  # Track last x seen on this line, so we can fill in the grid with empty spaces
  last_x = 0
  line.chars.each.with_index(1) do |char, x|
    point = Vector[x, y]
    grid[point] = CHAR_TO_TYPE[char]
    last_x = x
  end

  # Fill in the rest of the row (if any) with empty (to maintain grid)
  (last_x+1..max_x).each { |x| grid[Vector[x, y]] = :empty }
end

# Now let's draw the grid to help visualize (and confirm logic is correct)
# TODO: move this all to a grid class...
(min_y..max_y).each do |y|
  (min_x..max_x).each do |x|
    print TYPES[grid[Vector[x, y]]]
  end
  puts ""
end


# binding.pry

part1 = 
part2 = 

puts "Part 1: #{part1}"
puts "Part 2: #{part2}"
