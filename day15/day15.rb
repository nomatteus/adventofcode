require 'pry'

input_gena_start = 516
input_genb_start = 190

GENA_FACTOR = 16807
GENB_FACTOR = 48271
MODVAL = 2147483647
# Mask out the bits we want to compare
COMPARE_MASK = 65535

# Test
# input_gena_start = 65
# input_genb_start = 8921

class Generator
  def initialize(start, factor)
    @value = start
    @factor = factor
  end

  def next_value
    @value = (@value * @factor) % MODVAL
  end
end

gena = Generator.new(input_gena_start, GENA_FACTOR)
genb = Generator.new(input_genb_start, GENB_FACTOR)

num_matches = 0
40000000.times do
  vala = gena.next_value
  valb = genb.next_value

  compare_vala = vala & COMPARE_MASK
  compare_valb = valb & COMPARE_MASK

  num_matches += 1 if compare_vala == compare_valb
end

puts "Part 1: #{num_matches} matches"
