require 'set'

input_lines = IO.read('./input').strip.split("\n")

valid_count = 0
input_lines.each do |line|
  words = line.split
  valid_count += 1 if words.size == words.to_set.size
end

puts "Part 1: #{valid_count}"

# Part 2

valid_count = 0
input_lines.each do |line|
  word_chars = line.split.map { |w| w.chars.sort }
  valid_count += 1 if word_chars.size == word_chars.to_set.size
end

puts "Part 2: #{valid_count}"
