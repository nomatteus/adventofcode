require 'pry'
require 'matrix'

ASTEROID = 1
EMPTY = 0

def transform_val(val)
  val == '#' ? ASTEROID : EMPTY
end

input_file = 'input'
# input_file = 'input_small'
input = IO.read(input_file).strip.split.map { |row| row.split('').map { |val| transform_val(val) } }

# Use columns, as we want to access via x, y coords (where default for matrix is row, col)
grid = Matrix.columns(input)

# Note that keyword_init requires Ruby 2.5+
OtherAsteroidInfo = Struct.new(:asteroid, :angle, :distance, keyword_init: true)

class Asteroid
  # other_asteroids is a list of OtherAsteroidInfo objects
  attr_accessor :position, :other_asteroids

  def initialize(x, y)
    @position = Vector[x, y]
  end

  def num_asteroids_can_see
    @num_asteroids_can_see ||= other_asteroids.map(&:angle).uniq.size
  end

  def ==(other)
    self.position == other.position
  end
end

asteroids = []

grid.each_with_index do |val, x, y|
  if val == ASTEROID
    asteroids << Asteroid.new(x, y)
  end
end

asteroids.each do |asteroid|
  asteroid_transposed = Vector[0, 0]

  other_asteroids = asteroids.map do |other_asteroid|
    next if other_asteroid == asteroid

    # Transpose to have asteroid at 0,0
    other_asteroid_transposed = other_asteroid.position - asteroid.position

    x = other_asteroid_transposed[0]
    y = other_asteroid_transposed[1]
    angle_rad = Math.atan2(y, x)
    # Note that we add 90 degrees so that the positive y axis is 0 degrees (makes part 2 simpler)
    # And then use modulus to ensure we have a positive angle
    angle_degrees = (angle_rad * 180 / Math::PI + 90) % 360

    OtherAsteroidInfo.new(
      asteroid: other_asteroid,
      angle: angle_degrees,
      distance: other_asteroid_transposed.magnitude
    )
  end.compact

  asteroid.other_asteroids = other_asteroids
end


station_asteroid = asteroids.max_by(&:num_asteroids_can_see)

# Solution: 326 (at location: Vector[22, 28])
puts "Part 1: #{station_asteroid.num_asteroids_can_see} (at location: #{station_asteroid.position})"


# Part 2:

# Build a hash of all the other asteroids, sorted by degree, where
# the value is a list of other asteroids at that degree, sorted by distance.
other_asteroids_sorted = station_asteroid.other_asteroids.sort_by(&:angle).group_by(&:angle)
other_asteroids_sorted.each do |degree, asteroids_info|
  asteroids_info.sort_by!(&:distance)
end

# Then, we will iterate through this list and vaporize the first asteroid in the
# list for each angle (and remove it from the list). We will keep a list of the
# vaporized asteroids, and use the 200th one to calculate our answer for part 2.
vaporized_asteroids = []

while other_asteroids_sorted.values.any? { |ai| ai.size > 0 } do
  other_asteroids_sorted.each do |degree, asteroids_info|
    next if asteroids_info.empty?

    vaporized_asteroids << asteroids_info.shift
  end
end

part2_200th_vaporized = vaporized_asteroids[199].asteroid
part2 = part2_200th_vaporized.position[0] * 100 + part2_200th_vaporized.position[1]

puts "Part 2: #{part2}"
