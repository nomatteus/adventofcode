require 'pry'
require 'matrix'

# input = IO.read('./input').strip.split(",").map(&:to_i)
input = IO.read('./input_small').strip.split(",").map(&:to_i)


def lanternfish_simulate(nums, number_of_days)
  current_nums = nums
  number_of_days.times do
    result = current_nums.map { |num| one_day(num) }.flatten
    current_nums = result
  end
  current_nums
end

# Simulate a day for a single fish, returns a list of laternfish
# (size 1 if no new fish generated, size 2 othersize)
def one_day(num)
  # Reset to 6 and generate a new fish with timeer 8
  return [6, 8] if num.zero?

  # Otherwise just decrement timer by 1
  [num - 1]
end

binding.pry

part1_result = lanternfish_simulate(input, 80)
part1 = part1_result.size

puts "Part 1: #{part1}" # 355386


# Part 2

part2_result = lanternfish_simulate(input, 256)
part2 = part2_result.size

puts "Part 2: #{part2}"
