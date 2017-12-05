require 'pry'

jumps = IO.read('./input').strip.split("\n").map(&:to_i)

current_instruction = 0
num_steps = 0

while current_instruction >= 0 && current_instruction < jumps.size do
  next_jump = jumps[current_instruction]
  jumps[current_instruction] += 1
  current_instruction += next_jump
  num_steps += 1
end

puts "Part 1: #{num_steps} steps"


# jumps = [0, 3, 0, 1, -3] # test
jumps = IO.read('./input').strip.split("\n").map(&:to_i)
current_instruction = 0
num_steps = 0

while current_instruction >= 0 && current_instruction < jumps.size do
  next_jump = jumps[current_instruction]
  jumps[current_instruction] += (next_jump >= 3 ? -1 : 1)
  current_instruction += next_jump
  num_steps += 1
end

puts "Part 2: #{num_steps} steps"
