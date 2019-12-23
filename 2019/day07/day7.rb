require 'pry'
require './intcode_day7'

input = IO.read('input')

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

    inputB = outputA
    ampB = Intcode::Computer.new(@program, [@phaseB, inputB])
    outputB = ampB.run

    inputC = outputB
    ampC = Intcode::Computer.new(@program, [@phaseC, inputC])
    outputC = ampC.run

    inputD = outputC
    ampD = Intcode::Computer.new(@program, [@phaseD, inputD])
    outputD = ampD.run

    inputE = outputD
    ampE = Intcode::Computer.new(@program, [@phaseE, inputE])
    outputE = ampE.run
  end
end

program1 = Intcode::Helpers.parse_program(input)
# Find max value by checking all permutations
max = -1
[0, 1, 2, 3, 4].permutation.to_a.each do |phase_settings|
  amps = AmplifierArrayPart1.new(program1, phase_settings)
  signal = amps.run
  max = signal if signal > max
end

puts "Part 1: max value: #{max}" # 368584

############ PART 2

class AmplifierArrayPart2
  # program: Program that will be run on all amplifiers.
  # phase_settings: Array of 5 digits from 5-9 (no repeats)
  def initialize(program, phase_settings)
    @program = program
    @phaseA, @phaseB, @phaseC, @phaseD, @phaseE = phase_settings

    # Initialize computers with their phase settings.
    @ampA = Intcode::Computer.new(@program, [@phaseA])
    @ampB = Intcode::Computer.new(@program, [@phaseB])
    @ampC = Intcode::Computer.new(@program, [@phaseC])
    @ampD = Intcode::Computer.new(@program, [@phaseD])
    @ampE = Intcode::Computer.new(@program, [@phaseE])

    # Initialize Output values
    @outputA = nil
    @outputB = nil
    @outputC = nil
    @outputD = nil
    # first input to ampA is 0
    @outputE = 0
  end

  def run
    running = true

    while running
      # Store the last output value, as if program is terminated,
      # it does not output a value.
      @last_output = @outputE

      @ampA.add_input(@outputE)
      @outputA = @ampA.run

      @ampB.add_input(@outputA)
      @outputB = @ampB.run

      @ampC.add_input(@outputB)
      @outputC = @ampC.run

      @ampD.add_input(@outputC)
      @outputD = @ampD.run

      @ampE.add_input(@outputD)
      @outputE = @ampE.run

      # Detect last run
      running = false if @ampE.terminated?
    end

    @last_output
  end
end

program2 = Intcode::Helpers.parse_program(input)
# Find max value by checking all permutations
max = -1
[5, 6, 7, 8, 9].permutation.to_a.each do |phase_settings|
  amps = AmplifierArrayPart2.new(program2, phase_settings)
  signal = amps.run
  max = signal if signal > max
end

puts "Part 2: max value: #{max}" # 35993240
