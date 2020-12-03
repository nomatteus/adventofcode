require 'set'
require 'pry'

input = IO.read('./input').strip.split("\n")
# input = IO.read('./input_small').strip.split("\n")

def solve(input, right, down)
  current_y = right
  trees = 0
  i = down
  len = input.first.size
  while i < input.size
    trees += 1 if input[i][current_y] == '#'
    current_y = (current_y + right) % len
    i += down
  end

  trees
end

part1 = solve(input, 3, 1)
puts "Part 1: #{part1}"


part2 = solve(input, 1, 1) * solve(input, 3, 1) * solve(input, 5, 1) * solve(input, 7, 1) * solve(input, 1, 2)
puts "Part 2: #{part2}"
