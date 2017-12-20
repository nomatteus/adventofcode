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
  def packet_journey!
    severity = 0

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
