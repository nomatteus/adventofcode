input = IO.read('./input').strip.split("\n")

class Component
  attr_accessor :left_port, :right_port

  def initialize(left_port, right_port)
    @left_port = left_port
    @right_port = right_port
  end

  def has_zero_pin_port?
    left_port.zero? || right_port.zero?
  end

  def strength
    left_port + right_port
  end
end

class ElectromagneticMoat
  attr_accessor :components

  def initialize(input)
    @components = []
    parse_input(input)
  end

  # Starting with the 0-port components, find the one with the max value
  # (Assumes all 0-ports have 0 as the left port, which is true for the given input)
  def find_max_bridge_strength
    # Finds the best bridge strength for each of the starting 0-components
    potential_bridges = zero_components.collect { |c| max_bridge_strength([c], c.right_port, c.strength) }
    potential_bridges.collect { |b| b[:strength] }.max
  end

  # Recursive method to find the maximum bridge strength
  def max_bridge_strength(used_components, next_connector, strength=0)
    next_options = find_unused_components(used_components, next_connector)

    # Base Case: We are at the end of a chain of components, so return the chain and the strength
    return { used_components: used_components, strength: strength } if next_options.empty?

    # Recursive case: Search all possible options from the current component, and return the best one
    next_options.collect do |option|
      max_bridge_strength(used_components + [option[:component]], option[:next_connector], strength + option[:component].strength)
    end.max { |bridge1, bridge2| bridge1[:strength] <=> bridge2[:strength] }
  end

  # Part 2: Find the max bridge length, breaking ties by choosing the max strength
  def find_max_bridge_length
    potential_bridges = zero_components.collect { |c| max_bridge_length([c], c.right_port) }
    potential_bridges.max do |b1, b2|
      # Strength is tiebreaker
      b1.size == b2.size ? b1.sum(&:strength) <=> b2.sum(&:strength) : b1.size <=> b2.size
    end.sum(&:strength)
  end

  # Recursive method to find the maximum bridge length
  def max_bridge_length(used_components, next_connector)
    next_options = find_unused_components(used_components, next_connector)

    # Base case: No more matching components that could make the chain longer, so return the chain
    return used_components if next_options.empty?

    # Recursive Case:
    next_options.collect do |option|
      max_bridge_length(used_components + [option[:component]], option[:next_connector])
    end.max do |b1, b2|
      b1.size == b2.size ? b1.sum(&:strength) <=> b2.sum(&:strength) : b1.size <=> b2.size
    end
  end

  # Finds all unused components that match the given connection port number.
  # Will also return the unused port for each connection
  def find_unused_components(used_components, next_connector)
    @components.collect do |component|
      # We need to return the next_connector, so on the next iteration we will know what to search for (i.e. which port is already used)
      if component.left_port == next_connector
        { component: component, next_connector: component.right_port }
      elsif component.right_port == next_connector
        { component: component, next_connector: component.left_port }
      else
        nil
      end
    end.compact.reject { |match| used_components.include?(match[:component]) }
  end

private

  def zero_components
    @components.select(&:has_zero_pin_port?)
  end

  def parse_input(input)
    input.each do |component|
      left_port, right_port = component.split('/').map(&:to_i)
      @components << Component.new(left_port, right_port)
    end
  end
end

electromagnetic_moat = ElectromagneticMoat.new(input)
puts "Part 1: #{electromagnetic_moat.find_max_bridge_strength}"

part2 = ElectromagneticMoat.new(input)
puts "Part 2: #{electromagnetic_moat.find_max_bridge_length}"

