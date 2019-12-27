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

asteroids = {}

grid.each_with_index do |val, x, y|
  if val == ASTEROID
    asteroids[Vector[x, y]] = { vector: Vector[x, y] }
  end
end

asteroids.each do |asteroid, asteroid_info|
  asteroid_transposed = Vector[0, 0]

  angles = asteroids.each_with_object({}) do |(other_asteroid, other_asteroid_info), angles_result|
    next if other_asteroid == asteroid

    # Transpose to have asteroid at 0,0
    other_asteroid_transposed = other_asteroid - asteroid

    x = other_asteroid_transposed[0]
    y = other_asteroid_transposed[1]
    angle = Math.atan2(y, x)

    angles_result[other_asteroid] = angle
  end

  asteroid_info[:angles] = angles
  asteroid_info[:num_asteroids_can_see] = angles.values.uniq.size
end


part1_asteroid = asteroids.max_by { |coords, info| info[:num_asteroids_can_see] }
part1_coords = part1_asteroid[0]
part1_num_can_see = part1_asteroid[1][:num_asteroids_can_see]

# Solution: 326 (at location: Vector[22, 28])
puts "Part 1: #{part1_num_can_see} (at location: #{part1_coords})"
