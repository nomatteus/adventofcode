require 'pry'

input = IO.read('./input').strip.split("\n\n")

groups = input.map { |i| i.split.map(&:to_i).sum }

part1 = groups.max

part2 = groups.sort.last(3).sum

puts "Part 1: #{part1}" # 72017
puts "Part 2: #{part2}" # 212520
