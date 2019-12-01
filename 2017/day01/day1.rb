require 'pry'

input_chars = IO.read('./input').strip.chars

sum = 0
prev = input_chars.last
input_chars.each do |char|
  sum += char.to_i if char == prev
  prev = char
end

puts "Part 1: #{sum}"


halfway = input_chars.size / 2
sum = 0
input_chars.each_with_index do |char, i|
  halfi = (i + halfway) % input_chars.size
  sum += char.to_i if input_chars[halfi] == char
end

puts "Part 2: #{sum}"
