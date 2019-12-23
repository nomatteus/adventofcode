require 'pry'

input = IO.read('input').strip.split(//).map(&:to_i)

class ImageParser
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
  end

  # Generate all layers given the input pixels and dimensions
  def generate_layers!
    @layers = @num_layers.times.map do |layer_i|
      offset = layer_i * @pixels_per_layer
      layer_pixels = @pixels.slice(offset, @pixels_per_layer)
    end
  end
end

image_part1 = ImageParser.new(pixels: input, width: 25, height: 6)
image_part1.generate_layers!
# To make sure the image wasn't corrupted during transmission, the Elves
# would like you to find the layer that contains the fewest 0 digits.
part1_layer = image_part1.layers.min_by { |layer| layer.count(0) }
# On that layer, what is the number of 1 digits multiplied by the number of 2 digits?
part1 = part1_layer.count(1) * part1_layer.count(2)

puts "Part 1: #{part1}"
