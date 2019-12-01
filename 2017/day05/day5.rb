require_relative '../common/input'

class JumpProgram
  attr_reader :num_steps

  def initialize(jumps)
    @jumps = jumps.dup
  end

  def run
    @num_steps = 0
    current_instruction = 0

    while inside_list?(current_instruction) do
      next_jump = @jumps[current_instruction]
      @jumps[current_instruction] += post_jump_offset(next_jump)
      current_instruction += next_jump
      @num_steps += 1
    end
    self
  end

  def inside_list?(instruction)
    instruction >= 0 && instruction < @jumps.size
  end

  def post_jump_offset(jump_value)
    1
  end
end

class StrangeJumpProgram < JumpProgram
  def post_jump_offset(jump_value)
    jump_value >= 3 ? -1 : 1
  end
end

input = IntegerLineReader.new('./input').values

part1 = JumpProgram.new(input).run
puts "Part 1: #{part1.num_steps} steps"

part2 = StrangeJumpProgram.new(input).run
puts "Part 1: #{part2.num_steps} steps"
