require 'pry'
input = IO.read('./input').strip.split("\n")
# input = [ #test
#   '0/2',
#   '2/2',
#   '2/3',
#   '3/4',
#   '3/5',
#   '0/1',
#   '10/1',
#   '9/10',
# ]

class Component
  attr_accessor :component_id, :left_port, :right_port

  def initialize(component_id, left_port, right_port)
    @component_id = component_id
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
    @components = {}
    parse_input(input)
  end

  # Starting with the 0-port components, find the one with the max value
  # (Assumes all 0-ports have 0 as the left port, which is true for the given input)
  def find_max_bridge_strength
    zero_components = @components.values.select(&:has_zero_pin_port?)
    potential_bridges = zero_components.collect { |c| max_bridge([c], c.right_port, c.strength) }
    potential_bridges.collect { |b| b[1] }.max
  end

  # Recursive method to find the maximum bridge strength
  def max_bridge(used_components, next_connector, strength=0)
    next_options = find_unused_components(used_components, next_connector)
    return [used_components, strength] if next_options.empty?
    max = next_options.collect do |options|
      next_component, next_next_connector = options
      max_bridge(used_components + [next_component], next_next_connector, strength + next_component.strength)
    end.max { |bridge1, bridge2| bridge1[1] <=> bridge2[1] }
    max
  end

  def find_unused_components(used_components, next_connector)
    matches = @components.values.collect do |component|
      if component.left_port == next_connector
        # Format is the matching component, and next next connector
        [component, component.right_port]
      elsif component.right_port == next_connector
        component
        [component, component.left_port]
      else
        nil
      end
    end.compact
    matches.reject { |match| used_components.include?(match[0]) }
  end

private

  def parse_input(input)
    # Assign each component a unique ID
    component_id = 1
    input.each do |component|
      left_port, right_port = component.split('/').map(&:to_i)
      @components[component_id] = Component.new(component_id, left_port, right_port)
      component_id += 1
    end
  end
end

part1 = ElectromagneticMoat.new(input)
puts "Part 1: #{part1.find_max_bridge_strength}"

