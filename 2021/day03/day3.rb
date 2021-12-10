require 'pry'
require 'matrix'

input = IO.read('./input').strip.split
# input = IO.read('./input_small').strip.split

counts = Array.new(input.first.size, 0)

total_nums = input.size

input.each do |line|
  line.chars.each_with_index do |c, i|
    counts[i] += 1 if c == "1"
  end
end

gamma_rate = ""
epsilon_rate = ""
counts.each_with_index do |count, i|
  ones = count
  zeros = total_nums - count

  gamma_rate << (ones >= zeros ? "1" : "0")
  epsilon_rate << (ones >= zeros ? "0" : "1")
end

part1 = gamma_rate.to_i(2) * epsilon_rate.to_i(2)

puts "Part 1: #{part1}"


# Part 2

part2 = 

puts "Part 2: #{part2}"
