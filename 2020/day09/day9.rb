require 'set'
require 'pry'

input = IO.read('./input').strip.split("\n").map(&:to_i)
# input = IO.read('./input_small').strip.split("\n").map(&:to_i)

PREAMBLE_SIZE = 25 # Actual Input
# PREAMBLE_SIZE = 5  # Sample Input

def find_sum(values, target_num)
  values_set = values.to_set
  values_set.each do |val|
    other_val = target_num - val
    return [val, other_val] if val != other_val && values_set.include?(other_val)
  end

  nil
end


def find_notsum(input)
  PREAMBLE_SIZE.upto(input.size - 1).each do |i|
    preamble_values = input[i - PREAMBLE_SIZE..i]
    current_num = input[i]

    sum = find_sum(preamble_values, current_num)

    return current_num if sum.nil?
  end
end

part1 = find_notsum(input)
puts "Part 1: #{part1}" # 177777905


def solve_part2(input, target_num)
  # Sliding sum between 2 pointers
  left = 0
  right = 1
  sum = input[left] + input[right]

  while sum != target_num
    # puts "[while] left: #{left}, right: #{right}, sum: #{sum} (target_num: #{target_num})"
    raise "Invalid index" if left > input.size || right > input.size
    if sum > target_num
      # advance left pointer; remove from sum
      sum -= input[left]
      left += 1
    else
      # advance right pointer; add to sum
      right += 1
      sum += input[right]
    end
  end

  range = input[left..right]
  # puts "range found. left: #{left}, right: #{right}, values: #{range.inspect}"

  range.min + range.max
end


part2 = solve_part2(input, part1)
puts "Part 2: #{part2}" # 23463012
