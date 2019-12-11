module Intcode
  module Helpers
    def self.parse_program(str)
      str.strip.split(",").map(&:to_i)
    end
  end

  class Computer
    attr_accessor :program

    # Map of opcodes to how many params each accepts
    OPCODES = {
      1  => { num_params: 3 },
      2  => { num_params: 3 },
      99 => { num_params: 0 },
    }

    # Opcodes (day 2)
    # 1: add 2 numbers, store in 3rd position
    # 2: multiple 2 numbers, store in 3rd position
    # 99: halt the program
    def initialize(program, noun, verb)
      @original_program = program.dup
      @noun = noun
      @verb = verb
      reset!
    end

    # Set initial values
    def reset!
      @program = @original_program.dup
      @running = false

      # Current Instruction
      @current_inst = 0

      @program[1] = @noun
      @program[2] = @verb
    end

    # Input:
    #   program: An array of integers.
    def run
      reset!
      @running = true

      while @running
        # Read next instruction
        instruction = next_instruction
        params = read_params(instruction)

        case instruction
        when 1 then add(*params)
        when 2 then multiply(*params)
        when 99 then quit(*params)
        else
          raise "Invalid Opcode #{instruction}"
        end
      end
    end

    private

    def next_instruction
      inst = @program[@current_inst]
      @current_inst += 1
      inst
    end

    # Given an opcode, read and return the params for this instruction
    def read_params(opcode)
      num_params = OPCODES[opcode][:num_params]
      num_params.times.map { next_instruction }
    end

    # Opcode: 1
    # Adds 2 numbers, and stores
    def add(num1, num2, pos)
      @program[pos] = @program[num1] + @program[num2]
    end

    # Opcode: 2
    # Multiplies 2 numbers, and stores
    def multiply(num1, num2, pos)
      @program[pos] = @program[num1] * @program[num2]
    end

    # Opcode: 99
    def quit
      @running = false
    end


  end
end

input = IO.read('input')
program = Intcode::Helpers.parse_program(input)

# Part 1: hardcoded noun/verb
computer1 = Intcode::Computer.new(program, 12, 2)
computer1.run

puts "Part 1: #{computer1.program[0]}" # 3790689


result2 = ((0..100).to_a * 2).permutation(2).to_a.find do |noun, verb|
  computer2 = Intcode::Computer.new(program, noun, verb)
  computer2.run
  output = computer2.program[0]

  output == 19690720
end

puts "Part 2 (100 * noun + verb): #{100 * result2[0] + result2[1]}" # 6533
