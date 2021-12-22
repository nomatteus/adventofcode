require 'pry'
require 'matrix'

input = IO.read('./input').strip.split(",").map(&:to_i)
# input = IO.read('./input_small').strip.split(",").map(&:to_i)

def lanternfish_simulate(nums, number_of_days)
  # Store a tally of lanternfish num => count, e.g.:
  #   {3=>2, 4=>1, 1=>1, 2=>1}
  # We'll use this for more efficient simulation calculations
  current_tally = Hash.new(0).merge(nums.tally)
  number_of_days.times do
    new_tally = Hash.new(0)

    # Save this as we'll overwrite in the loop
    num_new_laternfish = current_tally[0]

    # No new laternfish, just decrement our counts
    1.upto(8).each do |num|
      new_tally[num - 1] = current_tally[num]
    end

    # Generate new laternfish
    new_tally[6] += num_new_laternfish
    new_tally[8] += num_new_laternfish

    current_tally = new_tally
  end
  # Count all laternfish to get result
  current_tally.values.sum
end

part1 = lanternfish_simulate(input, 80)
puts "Part 1: #{part1}" # 355386

# Part 2
part2 = lanternfish_simulate(input, 256)
puts "Part 2: #{part2}" # 1613415325809
