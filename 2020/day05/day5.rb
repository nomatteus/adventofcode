require 'pry'

input = IO.read('./input').strip.split("\n")

# Which direction to search
LEFT = ['F', 'L']
RIGHT = ['B', 'R']

def find_num(chars)
  lower = 0
  upper = (2 ** chars.size) - 1

  chars.each do |char|
    if LEFT.include?(char)
      # Go left: reduce upper bound
      upper = upper - (upper - lower) / 2 - 1
    else
      # Go right: increase lower bound
      lower = lower + (upper - lower) / 2 + 1
    end
  end

  # Sanity check
  raise "lower != upper" if lower != upper

  lower
end

def seat_id(boarding_pass)
  row = find_num(boarding_pass[0..6].chars)
  col = find_num(boarding_pass[-3..].chars)

  row * 8 + col
end

seat_ids = input.map do |boarding_pass|
  id = seat_id(boarding_pass)
  # puts "Boarding Pass #{boarding_pass} has Seat ID: #{id}"
  id
end

part1 = seat_ids.max

puts "Part 1: #{part1}" # 885


part2 = (seat_ids.min..seat_ids.max).to_a - seat_ids
puts "Part 2: #{part2.first}" # 623
