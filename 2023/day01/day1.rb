require 'pry'

input = IO.read('./input').strip.split


result1 = input.map do |line|
  nums = line.scan(/\d/)
  (nums.first + nums.last).to_i
end


numbers = ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine"]

# Create hash of string num to value: {"one"=>1, "two"=>2, ... , "nine"=>9}
number_values = numbers.map.with_index { |n, i| [n, i + 1] }.to_h

regex = /\d|one|two|three|four|five|six|seven|eight|nine/

result2 = input.map do |line|
  num1 = line.scan(regex).first
  
  # Search from end of string to acocunt for overlaps, e.g. "oneight"
  found = false
  num2 = nil
  i = line.size - 1
  until found do 
    find_match = line[i..].scan(regex)
    if !find_match.empty?
      found = true
      num2 = find_match.first
    end
    i -= 1
  end

  int1 = number_values[num1] || num1
  int2 = number_values[num2] || num2

  calibration_value = "#{int1}#{int2}".to_i
  calibration_value
end

part1 = result1.sum
part2 = result2.sum

puts "Part 1: #{part1}" # 54159
puts "Part 2: #{part2}" # 53866
