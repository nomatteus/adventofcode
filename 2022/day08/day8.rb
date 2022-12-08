require 'pry'

input_file = "./input"
# input_file = "./input_small"

Tree = Struct.new(:x, :y, :visible)

grid = IO.read(input_file).strip.split.map { |row| row.chars.map(&:to_i) }

max_y = grid.size - 1
max_x = grid.first.size - 1

visible = Array.new(grid.size) { Array.new(grid.first.size) }

# Part 1
grid.each.with_index do |row, y|
  row.each.with_index do |col, x|
    tree_val = grid[y][x]
    tree_visible = false

    # edges always visible
    if x == 0 || y == 0 || x == max_x || y == max_y # note: will work without this check
      tree_visible = true
    elsif 0.upto(x - 1).all? { |x_left| grid[y][x_left] < tree_val }
      tree_visible = true
    elsif (x+1).upto(max_x).all? { |x_right| grid[y][x_right] < tree_val }
      tree_visible = true
    elsif 0.upto(y - 1).all? { |y_top| grid[y_top][x] < tree_val }
      tree_visible = true
    elsif (y+1).upto(max_y).all? { |y_bottom| grid[y_bottom][x] < tree_val }
      tree_visible = true
    end
    visible[y][x] = tree_visible
  end
end

# Part 2
scenic_scores = Array.new(grid.size) { Array.new(grid.first.size) }

grid.each.with_index do |row, y|
  row.each.with_index do |col, x|
    tree_val = grid[y][x]
    # Init with 1 since we're multiplying final score
    scenic_score = 1

    # binding.pry
    # Generate list of coords in all directions (left, right, top, bottom)
    coord_ranges = [
      0.upto(x - 1).map { |x_left| [y, x_left] }.reverse,
      (x + 1).upto(max_x).map { |x_right| [y, x_right] },
      0.upto(y - 1).map { |y_top| [y_top, x] }.reverse,
      (y + 1).upto(max_y).map { |y_bottom| [y_bottom, x] },
    ]
    
    coord_ranges.each do |coord_range|
      limit_reached = false
      viewing_distance = 0

      coord_range.map do |coord|
        # we cannot see any more trees
        next if limit_reached

        next_val = grid[coord[0]][coord[1]]
        
        if next_val >= tree_val
          # We can see this tree but it blocks the rest of the view
          limit_reached = true
        end
        
        viewing_distance += 1
      end
      scenic_score *= viewing_distance
    end

    scenic_scores[y][x] = scenic_score
  end
end

part1 = visible.flatten.count { |vis| vis }
part2 = scenic_scores.flatten.max

puts "Part 1: #{part1}" # 1820
puts "Part 2: #{part2}" # 385112
