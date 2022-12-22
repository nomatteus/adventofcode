require 'pry'
require 'json'

input_file = "./input"
# input_file = "./input_small"

# Parse input, and use `JSON.load` to convert to arrays
input = IO.read(input_file).strip.split("\n\n").map { |group| group.split("\n").map { |item| JSON.load(item) } }

class Packet
  include Comparable
  attr_reader :value

  def initialize(value)
    @value = value
  end

  def <=>(other_packet)
    puts "-- <=> called with:\n#{value}\n#{other_packet.value}"
    left = 0
    right = 0

    while true
      left_val = value[left]
      right_val = other_packet.value[right]

      if left_val.is_a?(Integer) && right_val.is_a?(Integer)
        # Compare integers
        return -1 if left_val < right_val
        return 1 if left_val > right_val
        # if they're the same value, we'll continue checking
      elsif left_val.nil? && right_val.nil?
        # arrays were the same size and result inconclusive, so keep checking...
        return 0
      elsif left_val.nil?
        # left side ran out of items first, so this is in right order
        return -1
      elsif right_val.nil?
        # right side ran out of items first, so not in right order
        return 1
      else
        # Either both or one of the items is array, so compare as arrays
        result = Packet.new(Array(left_val)) <=> Packet.new(Array(right_val))

        # If result is 0 (inconclusive), then continue checking
        return result unless result.zero?
      end

      left += 1
      right += 1
    end
  end
end

part1 = input.map.with_index do |(left, right), i| 
  result = Packet.new(left) < Packet.new(right)
  puts "pair #{i + 1} is #{!result ? 'NOT ' : ''}in right order\n============================"

  # Sum indexes in right order for part 1
  result ? i + 1 : 0
end.sum


# For part 2, we no longer use pairs, and insert 2 additional divider packets
DIVIDER1 = [[2]]
DIVIDER2 = [[6]]
part2_packets = (input.flatten(1) + [DIVIDER1, DIVIDER2]).map { |p| Packet.new(p) }.sort
# (remember that packet indexes are 1-based, so we add +1)
part2 = (part2_packets.index(Packet.new(DIVIDER1)) + 1) * (part2_packets.index(Packet.new(DIVIDER2)) + 1)

puts "Part 1: #{part1}" # 6272
puts "Part 2: #{part2}" # 22288
