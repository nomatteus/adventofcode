require 'pry'
require 'matrix'

input = IO.read('./input').strip.split
#input = IO.read('./input_small').strip.split

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

puts "Part 1: #{part1}" # 2743844 


# Part 2
num_bits = input.first.size

# Pos is the position we are checking
# rating: :oxygen_generator or :co2_scrubber
def calculate_rating(rating, input, i=0)
  # Base case - single number (return decimal version of number)
  return input.first.to_i(2) if input.size == 1

  grouped = input.group_by { |n| n[i] }
  num0s = (grouped["0"] || []).size
  num1s = (grouped["1"] || []).size
  #binding.pry
  winning_group = case rating
  when :oxygen_generator
    num1s >= num0s ? grouped["1"] : grouped["0"]
  when :co2_scrubber
    num0s <= num1s ? grouped["0"] : grouped["1"]
  end

  # Recursive call to check next digit
  calculate_rating(rating, winning_group, i+1)
end



part2 = calculate_rating(:oxygen_generator, input) * calculate_rating(:co2_scrubber, input)

puts "Part 2: #{part2}" # 6677951
