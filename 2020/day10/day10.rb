require 'set'
require 'pry'

input = IO.read('./input').strip.split("\n").map(&:to_i)
# input = IO.read('./input_small').strip.split("\n").map(&:to_i)

input_sorted = input.sort
differences = input_sorted.map.with_index do |num, i| 
  prev = i.zero? ? 0 : input_sorted[i - 1]
  num - prev
end
# always 3 diff at the end (adapter)
differences << 3

part1 = differences.count { |diff| diff == 1 } * differences.count { |diff| diff == 3 }
puts "Part 1: #{part1}" # 2450


# NOTE: Solved part 2 manually.
# 
# Initial notes:
# - Whenever we remove an adapter, we add the difference to the next number.
# - This implies that we cannot remove any adapter with a difference of 3, 
#   nor any adapter directly before a 3 (as both of these would end up with diffs > 3)
# 
# General idea is to identify which adapters optional & then partition the list
# into sets of optional adapters & calculate the options for each. We end up
# with repeated patterns, so can compute the total possible configurations. 
# 
# e.g. sample input, with required adapters marked with *:
# [1, 1, 1, 1, 3, 1, 1, 1, 1, 3, 3, 1, 1, 1, 3, 1, 1, 3, 3, 1, 1, 1, 1, 3, 1, 3, 3, 1, 1, 1, 1, 3]
#           *  *           *  *  *        *  *     *  *  *           *  *  *  *  *           *  *
# 
# We're left with the following optional adapters:
# [1, 1, 1,  ,  , 1, 1, 1,  ,  ,  , 1, 1,  ,  , 1,  ,  ,  , 1, 1, 1,  ,  ,  ,  ,  , 1, 1, 1,  ,  ]
# 
# From this, can calculate how many possibilies each pattern of optional adapters supports:
# [1, 1, 1] => 7
# [1, 1]    => 4
# [1]       => 2
# 
# Then calculate the total possibilities:
# [1, 1, 1,  ,  , 1, 1, 1,  ,  ,  , 1, 1,  ,  , 1,  ,  ,  , 1, 1, 1,  ,  ,  ,  ,  , 1, 1, 1,  ,  ]
#    7        *     7         *      4      *   2     *      7               *        7
# = 7^4 * 4^1 * 2^1 
# = 19208

# See comment above for background.
# number of consecutive optional adapters => potential combinations
potential_combinations = {
  3 => 7,
  2 => 4,
  1 => 2,
}

# result e.g.: [[1, 1, 1], [1, 1, 1], [1, 1], [1], [1, 1, 1], [], [1, 1, 1], []]
chunks = differences.slice_when { |x, y| x == 1 && y == 3 }.to_a.map { |a| a - [3] }.map { |a| a.drop(1) }
answer = chunks.map(&:size).reject(&:zero?).map { |num| potential_combinations[num] }.reduce(:*)

part2 = answer
puts "Part 2: #{part2}" # 32396521357312
