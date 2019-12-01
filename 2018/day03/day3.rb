GRID_SIZE = 1001

input = IO.read('./input').strip.split("\n")

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
(0...GRID_SIZE).each do |x|
  (0...GRID_SIZE).each do |y|
    if grid[x][y] >= 2
      overlaps += 1
    end
  end
end

puts "Part 1: #{overlaps}"

# Check the grid again: if all squares are 1 for any claim, then that means
# it is still intact
intact_id = nil
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

  intact_id = id if intact
end

puts "Part 2: #{intact_id}"
