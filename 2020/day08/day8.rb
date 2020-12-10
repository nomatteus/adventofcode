require 'set'
require 'pry'

input = IO.read('./input').strip.split("\n")
# input = IO.read('./input_small').strip.split("\n")

class Computer
  def initialize(instructions)
    @acc = 0
    @instructions = instructions
    @cur_instruction = 0
  end

  def run
    @instructions_run = Set.new

    while true
      # Stop execution if: infinite loop detected or last instruction executed
      if @instructions_run.include?(@cur_instruction)
        return {
          result: :infinite_loop,
          acc: @acc
        }
      elsif @cur_instruction >= @instructions.size
        return {
          result: :terminate,
          acc: @acc
        }
      end

      @instructions_run << @cur_instruction

      instruction = @instructions[@cur_instruction]
      self.send(instruction.op, instruction.arg)
    end

    @acc
  end

  def nop(_arg)
    # Noop: Next instruction
    @cur_instruction += 1
  end

  def acc(arg)
    @acc += arg
    @cur_instruction += 1
  end

  def jmp(arg)
    @cur_instruction += arg
  end
end

Instruction = Struct.new(:op, :arg)

def parse_instruction(instruction_input)
  op, arg = instruction_input.split

  Instruction.new(op.to_sym, arg.to_i)
end

# Part 2: Repair boot code and return result.
def run_part2(instructions)
  # Try modifying each nop/jmp instruction until we find one that works
  0.upto(instructions.size - 1) do |i|
    target_instruction = instructions[i]
    next unless [:nop, :jmp].include?(target_instruction.op)

    modified_instructions = instructions.dup
    # Change nop to jmp or vice-versa
    modified_instructions[i] = Instruction.new(
      target_instruction.op == :nop ? :jmp : :nop,
      target_instruction.arg
    )

    # Try running
    computer = Computer.new(modified_instructions).run

    return computer if computer[:result] == :terminate
  end
end

instructions = input.map { |line| parse_instruction(line) }
computer = Computer.new(instructions)

part1 = computer.run
puts "Part 1: #{part1[:acc]}" # 1384


part2 = run_part2(instructions)
puts "Part 2: #{part2[:acc]}" # 761
