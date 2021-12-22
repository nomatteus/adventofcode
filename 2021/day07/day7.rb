require 'pry'
require 'matrix'

input = IO.read('./input').strip.split(",").map(&:to_i)
# input = IO.read('./input_small').strip.split(",").map(&:to_i)
input_sorted = input.sort

# Note that input size is even
median = (input_sorted[input.size / 2] + input_sorted[input.size / 2 - 1]) / 2 
part1 = input_sorted.sum { |num| (num - median).abs }

puts "Part 1: #{part1}" # 340056



# Part 2

# Calculate costs at each point
costs = Array.new(input_sorted.size)
costs.each_with_index do |cost, i|
  # Calculate cost to move to current target space
  costs[i] = input_sorted.sum { |num| n = (num - i).abs; n * (n+1) / 2 } 
end

part2 = costs.min

puts "Part 2: #{part2}" # 96592275
