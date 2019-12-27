require 'pry'
require 'matrix'

input_file = 'input'
# input_file = 'input_small'
input = IO.read(input_file).split("\n")

X = 0
Y = 1
Z = 2

class Moon
  attr_reader :position, :velocity

  def initialize(position:)
    @position = position

    @velocity = Vector[0, 0, 0]
  end

  def potential_energy
    @position.map(&:abs).sum
  end

  def kinetic_energy
    @velocity.map(&:abs).sum
  end

  def total_energy
    potential_energy * kinetic_energy
  end

  # Note that we only apply gravity when other moon's position is greater
  def apply_gravity(other_moon)
    apply_gravity_to_dimension(X, other_moon)
    apply_gravity_to_dimension(Y, other_moon)
    apply_gravity_to_dimension(Z, other_moon)
  end

  # To update velocity, add velocity of moon to its position
  def update_velocity
    @position += @velocity
  end

  def to_s
    position_str = "pos=<x=#{position[X]}, y=#{position[Y]}, z=#{position[Z]}>"
    velocity_str = "vel=<x=#{velocity[X]}, y=#{velocity[Y]}, z=#{velocity[Z]}>"
    [position_str, velocity_str].join(", ")
  end

  private

  # Note that if equal, we do not change velocity
  def apply_gravity_to_dimension(dimension, other_moon)
    if other_moon.position[dimension] > @position[dimension]
      @velocity[dimension] += 1
    elsif other_moon.position[dimension] < @position[dimension]
      @velocity[dimension] -= 1
    end
  end
end

moons = input.map do |moon_str|
  x, y, z = moon_str.scan(/\-?\d+/).map(&:to_i)
  Moon.new(position: Vector[x, y, z])
end

num_steps = 1000

puts "After 0 steps:"
puts moons
puts "-----"

num_steps.times do |i|
  # Apply Gravity to every pair of moons
  moons.permutation(2).each do |(moon1, moon2)|
    moon1.apply_gravity(moon2)
  end

  # Update Velocity
  moons.each(&:update_velocity)

  puts "After #{i + 1} steps:"
  puts moons
  puts "-----"
end

total_energy = moons.sum(&:total_energy)
puts "Part 1: Total Energy: #{total_energy}" # 8960
