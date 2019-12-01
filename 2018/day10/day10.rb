require 'set'
require 'pry'

input = IO.read('./input').strip.split("\n")
# input = IO.read('./input_small').strip.split("\n")

class Point
  attr_accessor :x, :y, :vx, :vy

  def initialize(x, y, vx, vy)\
    self.x = x
    self.y = y
    self.vx = vx
    self.vy = vy
  end

  # Move one step according to velocity
  def step
    @x = @x + @vx
    @y = @y + @vy
    self
  end

  def reverse_step
    @x = @x - @vx
    @y = @y - @vy
    self
  end
end

class Grid

  def initialize
    @points = []
    # Track whether we need to re-calculate grid points
    @dirty = false
  end

  def add_point(point)
    @dirty = true
    @points << point
  end

  def step
    @dirty = true
    @points.map(&:step)
  end

  def reverse_step
    @dirty = true
    @points.map(&:reverse_step)
  end

  def grid_width
    calculate_boundaries!
    @grid_width
  end

  def grid_width
    calculate_boundaries!
    @grid_width
  end

  def to_s
    calculate_boundaries!

    # Build a grid array initialized to the size of the grid (initialize with empty '.' value)
    @grid_array = Array.new(@grid_height + 1) { Array.new(@grid_width + 1) { '.' } }

    # Now we will add all the points to the grid. Note that we need to translate all points to a
    # 0-based value. Also note that points can be negative. @minx and @miny will be mapped to (0, 0)
    @points.each do |point|
      translated_x = point.x - @minx
      translated_y = point.y - @miny

      @grid_array[translated_y][translated_x] = '#'
    end

    # binding.pry

    @grid_array.collect(&:join).join("\n")
  end

private

  # This will have to be called whenever points change.
  def calculate_boundaries!
    return unless @dirty

    # Init to vals of first point
    # We will do it this way so we only need one iteration
    point = @points.first
    @minx = point.x
    @maxx = point.x
    @miny = point.y
    @maxy = point.y
    @points.each do |point|
      @minx = [@minx, point.x].min
      @maxx = [@maxx, point.x].max
      @miny = [@miny, point.y].min
      @maxy = [@maxy, point.y].max
    end
    @grid_width = @maxx - @minx
    @grid_height = @maxy - @miny

    @dirty = false
  end
end

points = []
grid = Grid.new

input.each do |line|
  x, y, vx, vy = line.scan(/\-?\d+/).map(&:to_i)
  grid.add_point(Point.new(x, y, vx, vy))
end

width = nil
prev_width = nil
seconds = 0

loop do
  width = grid.grid_width

  # An idea: The grid will "converge" at letters, so if the grid size increases, then we were probably at our answer?
  # binding.pry if prev_width.nil? || width.nil?
  if !prev_width.nil? && width > prev_width
    # This grid is larger than the previous one, so the previous one has the answer
    # Back it up a step!
    grid.reverse_step
    seconds -= 1
    puts grid.to_s
    break
  end

  grid.step
  seconds += 1
  prev_width = width
end

# binding.pry

part1 = "see output"
part2 = seconds

puts "Part 1: #{part1}" # EJZEAAPE
puts "Part 2: #{part2} seconds" # 10054
