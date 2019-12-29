require 'pry'
require 'set'
require 'matrix'
require 'victor'

input_file = 'input'
# input_file = 'input_small2'
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


class MoonSimulation
  attr_reader :dim_sets

  def initialize(input:, debug: false)
    @moons = input.map do |moon_str|
      x, y, z = moon_str.scan(/\-?\d+/).map(&:to_i)
      Moon.new(position: Vector[x, y, z])
    end
    @debug = debug
  end

  def run_part1(num_steps:)
    log_debug("After 0 steps:")
    log_debug(@moons)
    log_debug("-----")

    num_steps.times do |i|
      apply_gravity!
      update_velocity!

      log_debug("After #{i + 1} steps:")
      log_debug(@moons)
      log_debug("-----")
    end
  end

  def run_part2
    @dim_sets = [Set.new, Set.new, Set.new]
    dim_sets_found = false

    until dim_sets_found do
      apply_gravity!
      update_velocity!
      dim_sets_found = track_dimension_sets!
    end

    # Now that we know how long it takes each dimension to repeat,
    # we can find when they all repeat by finding the least common multiple.
    @dim_sets.map(&:size).reduce(:lcm)
  end

  def total_energy
    @moons.sum(&:total_energy)
  end

  private

  # Apply Gravity to every pair of moons
  def apply_gravity!
    @moons.permutation(2).each do |(moon1, moon2)|
      moon1.apply_gravity(moon2)
    end
  end

  def update_velocity!
    @moons.each(&:update_velocity)
  end

  # For each dimension, we are tracking the set of positions seen,
  # so we can detect when they repeat.
  # Returns: boolean to indicate when we have found the sets for all dimensions
  def track_dimension_sets!
    xinfo = dimension_info(X)
    yinfo = dimension_info(Y)
    zinfo = dimension_info(Z)

    dim_sets_found = @dim_sets[X].include?(xinfo) && @dim_sets[Y].include?(yinfo) && @dim_sets[Z].include?(zinfo)

    @dim_sets[X] << xinfo
    @dim_sets[Y] << yinfo
    @dim_sets[Z] << zinfo

    dim_sets_found
  end

  # Position & velocity info across one dimension for all moons
  def dimension_info(dim)
    positions = @moons.map { |moon| moon.position[dim] }
    velocities = @moons.map { |moon| moon.velocity[dim] }
    { pos: positions, vel: velocities }
  end

  def log_debug(msg)
    puts msg if @debug
  end
end

simulator1 = MoonSimulation.new(input: input)
simulator1.run_part1(num_steps: 1000)
puts "Part 1: Total Energy: #{simulator1.total_energy}" # 8960

# Part 2
simulator2 = MoonSimulation.new(input: input)
part2 = simulator2.run_part2
puts "Part 2: #{part2} steps" # 314917503970904
