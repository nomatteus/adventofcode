lines = IO.read('./input').strip.split("\n")

class Layer
  attr_accessor :depth

  def initialize(depth)
    @depth = depth
  end

  def step
    # noop
  end

  def has_scanner?
    false
  end
end

class ScannerLayer < Layer
  attr_accessor :range, :scanner_position

  def initialize(depth, range)
    super(depth)
    @range = range

    # All layers start at position 0
    @scanner_position = 1

    # Scanner direction: 1 is "down", -1 is "up"
    @direction = 1
  end

  def step
    # Change direction?
    @direction = -1 if @direction == 1 && @scanner_position == range
    @direction = 1 if @direction == -1 && @scanner_position == 1

    # Inc/dec-rement scanner
    @scanner_position += 1 * @direction
  end

  def has_scanner?
    true
  end

  def severity
    depth * range
  end
end

class Firewall
  attr_accessor :layers

  def initialize
    @layers = []
  end

  def add_layer(depth, range)
    # Note that Ruby will auto-resize the array to fit given incides, and fill any in-between elements with nil
    layers[depth] = ScannerLayer.new(depth, range)

    # Fill in any nil layers (not the most efficient way but we have <100 layers)
    layers.each_with_index do |layer, i|
      next unless layer.nil?
      layers[i] = Layer.new(i)
    end
  end

  # As defined in part 1
  # Delay implements a delay of X steps (picoseconds) before starting the journey
  def packet_journey!(delay=0)
    severity = 0

    # Delay by given number of steps by executing the steps without travelling through layers
    delay.times { layers.each(&:step) }

    # Outer loop, journey to each layer
    layers.each do |current_layer|
      if current_layer.has_scanner? && current_layer.scanner_position == 1
        severity += current_layer.severity
      end

      # Setup for next iteration
      layers.each(&:step)
    end
    severity
  end
end


firewall = Firewall.new

lines.each do |line|
  depth, range = line.split(': ').map(&:to_i)
  firewall.add_layer(depth, range)
end
severity = firewall.packet_journey!

puts "Part 1: #{severity}"


# Part 2: Find necessary delay to make it through the firewall
delay_needed = 0

loop do
  caught = firewall.layers.detect do |layer|
    if layer.has_scanner?
      # Offset is how many steps (including the delay) to get to given layer
      offset = delay_needed + layer.depth
      iteration_length = (layer.range * 2 - 2)

      # Check offset against number of iterations for layer to return to position 1, if 0 then it's "caught"
      offset % iteration_length == 0
    else
      # Never caught on a layer with no scanner
      false
    end
  end
  break if !caught
  delay_needed += 1
end


puts "Part 2: #{delay_needed}"
