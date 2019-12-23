module Intcode
  module Helpers
    # Input:
    #   Comma-separated list of integers
    # Ouput:
    #   Array of integers
    def self.parse_program(str)
      str.strip.split(",").map(&:to_i)
    end
  end

  class Param
    attr_reader :mode, :value

    MODES = [:position, :immediate]

    def initialize(mode: :position, value:)
      raise "Invalid mode" unless MODES.include?(mode)

      @mode = mode
      @value = value
    end

    def to_s
      "Param<value: #{@value}, mode: #{mode}>"
    end
  end

  class Computer
    attr_accessor :program

    # Map of opcodes to how many params each accepts
    OPCODES = {
      1  => { num_params: 3, method: :add },
      2  => { num_params: 3, method: :multiply },
      3  => { num_params: 1, method: :input },
      4  => { num_params: 1, method: :output },
      5  => { num_params: 2, method: :jump_if_true },
      6  => { num_params: 2, method: :jump_if_false },
      7  => { num_params: 3, method: :less_than },
      8  => { num_params: 3, method: :equals },
      99 => { num_params: 0, method: :quit },
    }

    def initialize(program, input=[])
      @original_program = program.dup
      @program = program.dup
      # Input is an array of values
      @input = Array(input)

      # We output one value at a time (must call run again to continue)
      @output = nil

      @running = false
      # Now that we support resuming execution, we will track when the
      # program is actually terminated (i.e. a 99-quit command is executed)
      @terminated = false

      # Current Instruction
      @current_inst = 0
    end

    # Input:
    #   program: An array of integers.
    def run
      @running = true

      while @running
        # Read next instruction
        instruction = next_instruction
        opcode, params = read_opcode_and_params(instruction)

        execute_instruction(opcode, params)

        # Stop running the program if we have something to output
        @running = false if @output
      end

      # Output one integer at a time, or nil if terminated
      output_value
    end

    def terminated?
      @terminated
    end

    # Add a new input value
    def add_input(value)
      @input << value
    end

    # Returns current output value & resets output to nil
    def output_value
      return nil if terminated?
      raise "No output value!" if @output.nil?
      output = @output
      @output = nil
      output
    end

    private

    # Returns next instruction as-is in the program.
    # (Parsing of instruction, if necessary, is done elsewhere)
    def next_instruction
      inst = @program[@current_inst]
      @current_inst += 1
      inst
    end

    # Given an instruction, read and return the opcode & params
    # Input:
    #   Instruction, where rightmost 2 digits are opcode, and the
    #     rest of the digits give the parameter mode (or 0 as default if missing)
    # Output:
    #   Opcode: A valid opcode
    #   Params: A list of Param objects, or empty list if none.
    def read_opcode_and_params(instruction)
      # since digits is reversed, modes, is in order from param 1 to n
      opcode_digit2, opcode_digit1, *modes = instruction.digits
      opcode = "#{opcode_digit1}#{opcode_digit2}".to_i

      raise "Invalid Opcode: #{opcode}" unless OPCODES.key?(opcode)
      num_params = OPCODES[opcode][:num_params]

      param_modes = num_params.times.map.with_index { |i| modes[i] || 0 }
      param_vals = num_params.times.map { next_instruction }

      params = param_vals.map.with_index do |val, i|
        mode = param_modes[i] == 1 ? :immediate : :position
        Param.new(mode: mode, value: val)
      end
      return opcode, params
    end


    def execute_instruction(opcode, params)
      method = OPCODES[opcode][:method]
      raise "Invalid Opcode: #{opcode}" if method.nil?

      self.send(method, *params)
    end

    # Opcode: 1
    # Adds 2 numbers, and stores
    def add(param1, param2, pos)
      @program[pos.value] = param_val(param1) + param_val(param2)
    end

    # Opcode: 2
    # Multiplies 2 numbers, and stores
    def multiply(param1, param2, pos)
      @program[pos.value] = param_val(param1) * param_val(param2)
    end

    # Opcode: 3
    # Store input at given position
    def input(pos)
      raise "No input found!" if @input.nil? || @input.size.zero?
      @program[pos.value] = @input.shift
    end

    # Opcode: 4
    # Save output, will be returned when program runs.
    def output(pos)
      @output = param_val(pos)
    end

    # opcode 5
    def jump_if_true(param1, param2)
      return if param_val(param1).zero?

      @current_inst = param_val(param2)
    end

    # opcode 6
    def jump_if_false(param1, param2)
      return unless param_val(param1).zero?

      @current_inst = param_val(param2)
    end

    # opcode 7
    def less_than(param1, param2, pos)
      val = param_val(param1) < param_val(param2) ? 1 : 0

      @program[pos.value] = val
    end

    # opcode 8
    def equals(param1, param2, pos)
      val = param_val(param1) == param_val(param2) ? 1 : 0

      @program[pos.value] = val
    end

    # Opcode: 99
    def quit
      @running = false
      @terminated = true
    end

    def param_val(param)
      # Get param value, depending on mode
      param.mode == :immediate ? param.value : @program[param.value]
    end
  end
end
