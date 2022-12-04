require 'pry'

input = IO.read('./input').strip.split
# input = IO.read('./input_small').strip.split

part1 = input.select do |line|
  assign1, assign2 = line.split(",")
  start1, end1 = assign1.split("-").map(&:to_i)
  start2, end2 = assign2.split("-").map(&:to_i)

  (start1 <= start2 && end1 >= end2) || (start2 <= start1 && end2 >= end1)
end.count

part2 = input.select do |line|
  assign1, assign2 = line.split(",")
  start1, end1 = assign1.split("-").map(&:to_i)
  start2, end2 = assign2.split("-").map(&:to_i)

  !(start1 > end2 || start2 > end1)
end.count

puts "Part 1: #{part1}" # 540
puts "Part 2: #{part2}" # 872
