require 'pry'
require 'set'

input_range = 246515..739105

def adjacent_digits_same?(num)
  num_string = num.to_s
  # Start at index 1, as we will do a lookback
  1.upto(num_string.size - 1).any? do |i|
    num_string[i] == num_string[i - 1]
  end
end

# Part 2: Note that more than 2 adjacent digits are OK, as long
# as there is *at least* one set of exactly 2 adjacent digits.
# General approach:
#   - Count all numbers of adjacent digits in the input.
#   - If there is at least one with exactly 2 adjacent digits, return true.
def has_exactly_two_adjacent_digits_same?(num)
  num_string = num.to_s
  # We will track the same char. initialize using first char
  same_char = num_string[0]
  same_char_count = 1
  # Track counts
  char_counts = Set.new()
  for i in (1..num_string.size - 1) do
    char = num_string[i]
    if char == same_char
      same_char_count += 1
    else
      # Track
      char_counts << same_char_count
      # Reset
      same_char = char
      same_char_count = 1
    end
  end
  # Track final string of chars
  char_counts << same_char_count

  char_counts.include?(2)
end

def digits_ascending?(num)
  num_string = num.to_s
  1.upto(num_string.size - 1).all? do |i|
    num_string[i] >= num_string[i - 1]
  end
end

# Note that we assume number is 6 digits and in range already.
def valid_password_part1?(num)
  adjacent_digits_same?(num) && digits_ascending?(num)
end

def valid_password_part2?(num)
  has_exactly_two_adjacent_digits_same?(num) && digits_ascending?(num)
end

valid_passwords_part1 = input_range.select do |num|
  valid_password_part1?(num)
end

puts "Part 1: #{valid_passwords_part1.size}" # 1048

valid_passwords_part2 = input_range.select do |num|
  valid_password_part2?(num)
end

puts "Part 2: #{valid_passwords_part2.size}" # 677
