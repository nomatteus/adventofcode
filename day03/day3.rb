# Include common code (reading input, and outputting answer) that is used all the time.

require 'set'
require 'pry'

GRID_SIZE = 1001
# GRID_SIZE = 11

input = IO.read('./input').strip.split("\n")#.map(&:to_i)
# input = IO.read('./input_small').strip.split("\n")

grid = Array.new(GRID_SIZE)
grid.each_with_index do |col, i|
  grid[i] = Array.new(GRID_SIZE, 0)
end

input.each do |claim|
  id, x, y, w, h = claim.scan(/\d+/).map(&:to_i)
  for i in x...(x+w)
    for j in y...(y+h)
      grid[i][j] += 1
    end
  end
end

overlaps = 0
0.upto(GRID_SIZE-1).each do |x|
  0.upto(GRID_SIZE-1).each do |y|
    if grid[x][y] >= 2
      overlaps += 1
    end
  end
end

puts "Part 1: #{overlaps}"


input.each do |claim|
  id, x, y, w, h = claim.scan(/\d+/).map(&:to_i)
  intact = true
  for i in x...(x+w)
    for j in y...(y+h)
      if grid[i][j] > 1
        intact = false
      end
    end
  end

  puts "claim id #{id} is intact" if intact
end


# puts "Part 2: #{part2}"
