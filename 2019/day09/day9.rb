require 'pry'
require './intcode_day9'

input = IO.read('input')
program = Intcode::Helpers.parse_program(input)

puts "Part 1:"
computer_testmode = Intcode::Computer.new(program: program, input: [1], debug: false)

while !computer_testmode.terminated? do
  puts computer_testmode.run
end

# Part 1: 3280416268


puts "Part 2:"
computer_sensormode = Intcode::Computer.new(program: program, input: [2], debug: false)

while !computer_sensormode.terminated? do
  puts computer_sensormode.run
end

# Part 2: 80210
