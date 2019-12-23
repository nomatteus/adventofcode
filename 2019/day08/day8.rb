require 'pry'

input = IO.read('input').strip.split(//).map(&:to_i)

class ImageParser
  # Pixel color values
  BLACK = 0
  WHITE = 1
  TRANSPARENT = 2

  # How to output each pixel
  STR_OUTPUT_VAL = {
    0 => '⬛',
    1 => '⬜',
  }

  attr_reader :layers

  # Input:
  #   pixels: array of all pixels
  #   width/height: dimensions of image
  def initialize(pixels:, width:, height:)
    @pixels = pixels
    @width = width
    @height = height

    @pixels_per_layer = width * height
    @layers = []
    @num_layers = pixels.size / @pixels_per_layer

    generate_layers!
    generate_image!
  end

  # Generate all layers given the input pixels and dimensions
  def generate_layers!
    @layers = @num_layers.times.map do |layer_i|
      offset = layer_i * @pixels_per_layer
      layer_pixels = @pixels.slice(offset, @pixels_per_layer)
    end
  end

  def generate_image!
    # Calculate each pixel value
    pixel_values = @pixels_per_layer.times.map.with_index do |i|
      # Find first non-transparent pixel
      value = @layers.find { |layer| layer[i] != TRANSPARENT }[i]
    end

    # Reshape to image output size
    @image = pixel_values.each_slice(@width).to_a
  end

  def to_s
    @image.map do |row|
      row.map { |pixel| STR_OUTPUT_VAL[pixel] }.join
    end.join("\n")
  end
end

image = ImageParser.new(pixels: input, width: 25, height: 6)
# Test image...
# image = ImageParser.new(pixels: [0,2,2,2,1,1,2,2,2,2,1,2,0,0,0,0], width: 2, height: 2)

# To make sure the image wasn't corrupted during transmission, the Elves
# would like you to find the layer that contains the fewest 0 digits.
part1_layer = image.layers.min_by { |layer| layer.count(0) }
# On that layer, what is the number of 1 digits multiplied by the number of 2 digits?
part1 = part1_layer.count(1) * part1_layer.count(2)

puts "Part 1: #{part1}"   # 2375
puts "Part 2:\n#{image}"  # RKHRY
