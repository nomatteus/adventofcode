require 'pry'

LIST_MAX = 255
NUM_ELEMENTS = LIST_MAX + 1

lengths = IO.read('./input').strip.split(',').map(&:to_i)

current_pos = 0
skip_size = 0

circle = 0.upto(LIST_MAX).to_a

lengths.each do |length|
  # Integer division to figure out how many swaps we need to perform
  num_swaps = length / 2

  # One pointer at beginning of list, and one at the end, to perform our swaps
  p_start = current_pos
  p_end = (p_start + length - 1) % NUM_ELEMENTS

  # Will perform swaps in-place
  num_swaps.times do
    tmp_start = circle[p_start]
    circle[p_start] = circle[p_end]
    circle[p_end] = tmp_start

    # (Inc|Dec)rement pointers
    p_start = (p_start + 1) % NUM_ELEMENTS
    p_end = (p_end - 1) % NUM_ELEMENTS
  end

  current_pos = (current_pos + length + skip_size) % NUM_ELEMENTS
  skip_size += 1
end

result_p1 = circle[0] * circle[1]

puts "Part 1: #{result_p1}"
