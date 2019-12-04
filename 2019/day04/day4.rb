require 'pry'

input_range = 246515..739105

def adjacent_digits_same?(num)
  num_string = num.to_s
  # Start at index 1, as we will do a lookback
  1.upto(num_string.size - 1).any? do |i|
    num_string[i] == num_string[i - 1]
  end
end

def digits_ascending?(num)
  num_string = num.to_s
  1.upto(num_string.size - 1).all? do |i|
    num_string[i] >= num_string[i - 1]
  end
end

# Note that we assume number is 6 digits and in range already.
def valid_password?(num)
  adjacent_digits_same?(num) && digits_ascending?(num)
end

valid_passwords = input_range.select do |num|
  valid_password?(num)
end

puts "Part 1: #{valid_passwords.size}" # 1048
