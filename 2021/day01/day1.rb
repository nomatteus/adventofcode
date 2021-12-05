require 'pry'

input = IO.read('./input').strip.split.map(&:to_i)
# input = IO.read('./input_small').strip.split.map(&:to_i)

prev = nil
increased_count = 0

input.each do |num|
  increased_count += 1 if !prev.nil? && num > prev
  prev = num
end

puts "Part 1: #{increased_count}" # 1448

# Part 2
nums = [nil, nil, nil]
sum = prev_sum = nil
increased_count = 0

input.each do |num|
  nums[2] = nums[1]
  nums[1] = nums[0]
  nums[0] = num

  next if nums.any?(&:nil?)

  sum = nums.sum

  increased_count += 1 if !prev_sum.nil? && sum > prev_sum

  prev_sum = sum
end

puts "Part 2: #{increased_count}" # 1471
