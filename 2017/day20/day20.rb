LINE_PATTERN = /p=<(\-?\d+),(\-?\d+),(\-?\d+)>, v=<(\-?\d+),(\-?\d+),(\-?\d+)>, a=<(\-?\d+),(\-?\d+),(\-?\d+)>/

lines = IO.read('./input').strip.split("\n")

class Particle
  attr_accessor :position, :velocity, :acceleration, :num

  def initialize(num, px, py, pz, vx, vy, vz, ax, ay, az)
    @position = [px, py, pz]
    @velocity = [vx, vy, vz]
    @acceleration = [ax, ay, az]
    @num = num
  end

  # Sum of absolute value of particles X,Y,Z position
  def manhattan_distance
    @position.map(&:abs).sum
  end

  def tick
    [0, 1, 2].each do |i|
      @velocity[i] += @acceleration[i]
      @position[i] += @velocity[i]
    end
  end
end

class GPU
  attr_accessor :particles

  def initialize
    @particles = {}
  end

  def add_particle(particle)
    @particles[particle.num] = particle
  end

  # Find the closest particle to <0,0,0> in the long term.
  # Run "ticks" and then find the closest one after a large number of iterations
  def find_closest!
    1000.times { @particles.values.map(&:tick) }
    closest = @particles.values.min { |p1, p2| p1.manhattan_distance <=> p2.manhattan_distance }
  end

  # Remove collisions after every iteration
  def check_collisions!
    1000.times do
      @particles.values.map(&:tick)
      position_groups = @particles.values.group_by(&:position)
      collisions = position_groups.select { |pos, particles| particles.size > 1 }
      collisions.values.flatten.collect(&:num).map { |num| @particles.delete(num) }
    end
    @particles
  end
end

def build_gpu(lines)
  gpu = GPU.new

  lines.each_with_index do |line, i|
    particle_coords = LINE_PATTERN.match(line).to_a[1..-1].map(&:to_i)
    particle = Particle.new(i, *particle_coords)
    gpu.add_particle(particle)
  end
  gpu
end

closest = build_gpu(lines).find_closest!
particles_after_collisions = build_gpu(lines).check_collisions!

puts "Part 1: Closest particle after many iterations: #{closest.num}"
puts "Part 2: Number of particles after collisions: #{particles_after_collisions.size}"
