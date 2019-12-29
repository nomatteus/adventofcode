# Copied from day 7 & modified
# NOTE: Used for day 11 too, as no modifications were required.
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

    MODES = [:position, :immediate, :relative]

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
    attr_accessor :program, :input_values

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
      9  => { num_params: 1, method: :relative_base },
      99 => { num_params: 0, method: :quit },
    }

    def initialize(program:, input: [], debug: false, input_lambda: nil)
      @original_program = program.dup
      @program = program.dup
      # Input is an array of values
      @input_values = Array(input)
      # Optionally allow for lambda to be specified that will be called when an input value is needed
      @input_lambda = input_lambda

      # We output one value at a time (must call run again to continue)
      @output = nil

      @running = false
      # Now that we support resuming execution, we will track when the
      # program is actually terminated (i.e. a 99-quit command is executed)
      @terminated = false

      # Current Instruction
      @current_inst = 0

      # Relative Base
      @relative_base = 0

      @debug = debug
      log_debug("Starting computer in debug mode...")
    end

    # Input:
    #   program: An array of integers.
    def run
      @running = true

      while @running
        # Read next instruction
        instruction = next_instruction
        log_debug("Instruction: #{instruction}")
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
      @input_values << value
    end

    # Clear all input values
    def clear_input
      @input_values.clear
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
        mode = case param_modes[i]
        when 0 then :position
        when 1 then :immediate
        when 2 then :relative
        else
          raise "Unsupported mode code: #{param_modes[i]}"
        end
        Param.new(mode: mode, value: val)
      end
      return opcode, params
    end

    def execute_instruction(opcode, params)
      method = OPCODES[opcode][:method]
      raise "Invalid Opcode: #{opcode}" if method.nil?

      log_debug("  Executing opcode: #{opcode} with method: #{method} and params: #{params.map(&:to_s)}")

      self.send(method, *params)
    end

    # Opcode: 1
    # Adds 2 numbers, and stores
    def add(param1, param2, pos)
      @program[pos_val(pos)] = param_val(param1) + param_val(param2)
    end

    # Opcode: 2
    # Multiplies 2 numbers, and stores
    def multiply(param1, param2, pos)
      @program[pos_val(pos)] = param_val(param1) * param_val(param2)
    end

    # Opcode: 3
    # Store input at given position
    def input(param)
      input_val = get_input_value

      pos = pos_val(param)
      @program[pos] = input_val

      log_debug("  Input: @program[pos] = #{@program[pos]} (stored at pos: #{pos})")
    end

    # Retrive an input value.
    # Currently, there are 2 ways to get input values:
    # 1. Use input values specified on initialization or added using add_input
    # 2. Use an input callback to get an input value.
    # We will always use @input_values if they exist, then use input callback if exists,
    # then error if neither provides an input value.
    def get_input_value
      if !@input_values.nil? && @input_values.size > 0
        @input_values.shift
      elsif @input_lambda.respond_to? :call
        @input_lambda.call
      else
        raise "No input found!"
      end
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

      @program[pos_val(pos)] = val
    end

    # opcode 8
    def equals(param1, param2, pos)
      val = param_val(param1) == param_val(param2) ? 1 : 0

      @program[pos_val(pos)] = val
    end

    # opcode 9
    def relative_base(param)
      @relative_base += param_val(param)
      log_debug("  relative base is now: #{@relative_base}")
    end

    # Opcode: 99
    def quit
      @running = false
      @terminated = true
    end

    # Input: pos (instance of Param)
    # Output: Integer representing position
    def pos_val(param)
      param.mode == :relative ? param.value + @relative_base : param.value
    end

    def param_val(param)
      # Get param value, depending on mode
      case param.mode
      when :immediate then param.value
      when :position then val_at_position(param.value)
      when :relative then val_at_position(param.value + @relative_base)
      else
        raise "Unsupported param mode: #{param.mode}"
      end
    end

    # Get value at specified position in program.
    # Default for unused positions is 0.
    # negative positions are invalid
    def val_at_position(pos)
      raise "Positions cannot be negative: #{pos}" if pos.negative?

      @program[pos] = 0 if @program[pos].nil?
      @program[pos]
    end

    def log_debug(msg)
      puts msg if @debug
    end
  end
end
