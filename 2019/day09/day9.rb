require 'pry'
require './intcode_day9'

input = IO.read('input')
program = Intcode::Helpers.parse_program(input)
computer = Intcode::Computer.new(program: program, input: [1], debug: true)

while !computer.terminated? do
  puts computer.run
end

# Part 1: 3280416268
