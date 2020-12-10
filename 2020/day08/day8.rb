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

  def run_part1
    @instructions_run = Set.new

    until @instructions_run.include?(@cur_instruction)
      @instructions_run << @cur_instruction

      instruction = @instructions[@cur_instruction]
      puts "[Running instruction: #{@cur_instruction}] #{instruction.to_s}"
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

instructions = input.map { |line| parse_instruction(line) }
computer = Computer.new(instructions)

part1 = computer.run_part1
puts "Part 1: #{part1}" # 1384


part2 = 
puts "Part 2: #{part2}"
