require 'pry'
require 'json'

input_file = "./input"
# input_file = "./input_small"

# Parse input, and use `JSON.load` to convert to arrays
input = IO.read(input_file).strip.split("\n\n").map { |group| group.split("\n").map { |item| JSON.load(item) } }

def is_right_order?(left_array, right_array)
  puts "-- is_right_order called with:\n#{left_array}\n#{right_array}"
  left = 0
  right = 0

  while true
    left_val = left_array[left]
    right_val = right_array[right]

    if left_val.is_a?(Integer) && right_val.is_a?(Integer)
      # Compare integers
      return true if left_val < right_val
      return false if left_val > right_val
      # if they're the same value, we'll continue checking
    elsif left_val.nil? && right_val.nil?
      # arrays were the same size and result inconclusive, so keep checking...
      return nil
    elsif left_val.nil?
      # left side ran out of items first, so this is in right order
      return true
    elsif right_val.nil?
      # right side ran out of items first, so not in right order
      return false
    else
      # Either both or one of the items is array, so compare as arrays
      result = is_right_order?(Array(left_val), Array(right_val))
      # If result is nil (inconclusive), then continue checking
      return result unless result.nil?
    end

    left += 1
    right += 1
  end
end


part1 = input.map.with_index do |(left, right), i| 
  result = is_right_order?(left, right)
  puts "pair #{i + 1} is #{!result ? 'NOT ' : ''}in right order\n============================"

  # Sum indexes in right order for part 1
  result ? i + 1 : 0
end.sum


# binding.pry

part1 = 
part2 = 

puts "Part 1: #{part1}" # 6272
puts "Part 2: #{part2}"
