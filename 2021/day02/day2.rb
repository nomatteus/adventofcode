require 'pry'
require 'matrix'

input = IO.read('./input').strip.split("\n")
# input = IO.read('./input_small').strip.split("\n")

# command => [horizontal position, depth]
COMMANDS1 = {
  "forward" => Vector[1, 0],
  "down" => Vector[0, 1],
  "up" => Vector[0, -1],
}

position = Vector[0, 0]

commands = input.map do |line|
  command, m = line.split
  amount = m.to_i

  position += COMMANDS1[command] * amount  
end

part1 = position[0] * position[1]

puts "Part 1: #{part1}"

# Part 2

aim = 0
position = Vector[0, 0]

commands = input.map do |line|
  command, m = line.split
  amount = m.to_i

  case command
  when "down"
    aim += amount
  when "up"
    aim -= amount
  when "forward"
    position += Vector[amount, aim * amount] 
  end
end

part2 = position[0] * position[1]

puts "Part 2: #{part2}"
