require 'pry'

input = IO.read('./input').strip.chars
input = IO.read('./input_small').strip.chars

found = false
# Starting index of end of first group of 4
i = 3

until found do
  if input[i-3..i].uniq.size == 4
    found = true
  end
  i += 1
end

found = false
# Starting index of end of first group of 14
j = 13
until found do
  if input[j-13..j].uniq.size == 14
    found = true
  end
  j += 1
end

part1 = i
part2 = j

puts "Part 1: #{part1}" # 1275
puts "Part 2: #{part2}" # 3605
