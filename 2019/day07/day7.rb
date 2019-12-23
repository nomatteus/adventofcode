require 'pry'
require './intcode_day7'

input = IO.read('input')
program = Intcode::Helpers.parse_program(input)

class AmplifierArrayPart1
  # program: Program that will be run on all amplifiers.
  # phase_settings: Array of 5 digits from 0-4 (no repeats)
  def initialize(program, phase_settings)
    @program = program
    @phaseA, @phaseB, @phaseC, @phaseD, @phaseE = phase_settings
  end

  # Runs all 5 amps in sequence, passing output from each amp
  # to the next one.
  # Returns: Output value of last amp (signal sent to thrusters)
  def run
    inputA = 0
    ampA = Intcode::Computer.new(@program, [@phaseA, inputA])
    outputA = ampA.run

    inputB = outputA.first
    ampB = Intcode::Computer.new(@program, [@phaseB, inputB])
    outputB = ampB.run

    inputC = outputB.first
    ampC = Intcode::Computer.new(@program, [@phaseC, inputC])
    outputC = ampC.run

    inputD = outputC.first
    ampD = Intcode::Computer.new(@program, [@phaseD, inputD])
    outputD = ampD.run

    inputE = outputD.first
    ampE = Intcode::Computer.new(@program, [@phaseE, inputE])
    outputE = ampE.run
  end
end

# Find max value by checking all permutations
max = -1
[0, 1, 2, 3, 4].permutation.to_a.each do |phase_settings|
  amps = AmplifierArrayPart1.new(program, phase_settings)
  signal = amps.run.first
  max = signal if signal > max
end

puts "Part 1: max value: #{max}" # 368584
