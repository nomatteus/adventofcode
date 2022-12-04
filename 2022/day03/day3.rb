require 'pry'
require 'set'

input = IO.read('./input').strip.split
# input = IO.read('./input_small').strip.split

ITEM_TYPES = ('a'..'z').to_a + ('A'..'Z').to_a

# { "a" => 1, ..., "z" => 26, "A" => 27, ..., "Z" => 52 }
POINT_VALUES = ITEM_TYPES.zip(1..52).to_h

# Part 1 
part1 = input.sum do |contents| 
  left, right = contents.chars.each_slice(contents.size / 2).to_a
  common_item = (left.to_set & right.to_set).first

  POINT_VALUES[common_item]
end

# Part 2

part2 = input.each_slice(3).sum do |(group1, group2, group3)|
  key = group1.chars.find { |k| group2.chars.include?(k) && group3.chars.include?(k) }

  POINT_VALUES[key]
end

puts "Part 1: #{part1}" # 7691
puts "Part 2: #{part2}" # 2508
