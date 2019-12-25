require 'pry'
require './intcode_day9'

input = IO.read('input')
program = Intcode::Helpers.parse_program(input)

