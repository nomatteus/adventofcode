# Part 1
# Note: No real code for this, worked it out on paper and some calculations below.

input = 325489

input_sqrt = Math.sqrt(input)

grid_size = input_sqrt.ceil
grid_size += 1 if grid_size.even?

diff = grid_size**2 - input

midposi = (grid_size - 1) / 2
midposj = (grid_size - 1) / 2

puts "--- Part 1"
puts "The grid size is: #{grid_size}"
puts "Diff: #{diff.to_i} (so our input is at #{(grid_size - diff).to_i}th row)"
puts "Number 1 is at position: (#{midposi}, #{midposj}) [i.e. the center of the grid]"

row_travel = (midposi - 19).to_i
col_travel = (grid_size - midposj).to_i
total_travel = row_travel + col_travel

puts "Therefore must travel #{row_travel} rows and #{col_travel} cols to return to '1', a total travel of #{total_travel} (final answer for part 1)"

# Part 2
puts "\n\n--- Part 2"

DIRECTIONS = {
  left: [-1, 0],
  right: [1, 0],
  up: [0, 1],
  down: [0, -1]
}

class Spiral
  def initialize(num, type=nil)
    @num = num
    @points = {}
    @type = type
    build_spiral
  end

  # Build a spiral. We use (0, 0) as the center point ("1")
  def build_spiral
    # Initial Values
    @points[[0, 0]] = 1

    # Setup for first iteration
    current_coord = [1, 0]
    current_num = 2
    dir = DIRECTIONS[:up]

    while current_num <= @num
      # Store the number as the value unless we are doing sum (part 2)
      @points[current_coord] = @type == :sum ? get_sum(current_coord) : current_num

      # Check for change of direction
      if (current_coord[0].abs == current_coord[1].abs) then
        if current_coord[0] > 0 && current_coord[1] > 0 then # top right
          dir = DIRECTIONS[:left]
        elsif current_coord[0] < 0 && current_coord[1] > 0 then # top left
          dir = DIRECTIONS[:down]
        elsif current_coord[0] < 0 && current_coord[1] < 0 then # bottom left
          dir = DIRECTIONS[:right]
        end
      elsif current_coord[0].abs == (current_coord[1].abs + 1) && current_coord[0] > 0 && current_coord[1] < 0 # case where we are one right from the bottom right, so we need to go up
        dir = DIRECTIONS[:up]
      end

      # Calculate next coord in the current direction
      current_coord = [current_coord[0] + dir[0], current_coord[1] + dir[1]]

      current_num += 1
    end
  end

  def get_sum(coord)
    x, y = coord
    sum = 0
    # Check all possible adjacent points
    for i in -1..1 do
      for j in -1..1 do
        next if i == 0 && j == 0 # Do not add the value of the current square
        adjacent_point = [x + i, y + j]
        sum += @points[adjacent_point] || 0
      end
    end
    sum
  end

  # Note: points are in (x, y) coords
  def to_s
    topleft     = [@points.keys.collect{|k|k[0]}.min, @points.keys.collect{|k|k[1]}.max]
    bottomright = [@points.keys.collect{|k|k[0]}.max, @points.keys.collect{|k|k[1]}.min]

    output = ""
    topleft[1].downto(bottomright[1]).each do |y|
      for x in topleft[0]..bottomright[0] do
        output << "#{@points[[x, y]]}\t"
      end
      output << "\n"
    end
    output
  end
end

grid = Spiral.new(64, :sum) # Answer is: 330785 (viewed in output)
puts grid
