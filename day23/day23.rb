input = IO.read('./input').strip.split("\n")

class Program
  attr_accessor :registers, :num_mul_ops

  def initialize(instructions)
    @instructions = parse_instructions(instructions)
    @next_instruction = 0

    # Set default value of all registers to 0
    @registers = Hash.new(0)

    @num_mul_ops = 0
  end

  def run_next_instruction
    send(*@instructions[@next_instruction])
  end

  # Is next instruction in bounds?
  def in_bounds?
    @next_instruction >= 0 && @next_instruction < @instructions.size
  end

private

  def set(x, y)
    @registers[x] = get_value(y)
    @next_instruction += 1
  end

  def sub(x, y)
    @registers[x] -= get_value(y)
    @next_instruction += 1
  end

  def mul(x, y)
    @registers[x] *= get_value(y)
    @num_mul_ops += 1
    @next_instruction += 1
  end

  def jnz(x, y)
    if get_value(x) != 0
      @next_instruction += get_value(y)
    else
      @next_instruction += 1
    end
  end

  # If a character, return value at given register, otherwise just return the int value
  def get_value(x)
    is_register?(x) ? @registers[x] : x
  end

  # Determine if a given value represents a register or not
  def is_register?(val)
    val.to_s.match(/[a-z]/)
  end

  def parse_instructions(instructions)
    instructions.collect do |instruction|
      instruction, val1, val2 = instruction.split
      # If not a lowercase single letter, then assume it is an integer if present
      val1 = val1.to_i unless val1.nil? || is_register?(val1)
      val2 = val2.to_i unless val2.nil? || is_register?(val2)
      raise if instruction.nil? || val1.nil?
      [instruction, val1, val2].compact
    end
  end
end

program = Program.new(input)

# Program runner
program_running = true
while program_running do
  program.run_next_instruction

  # Check for program termination: out of bounds
  program_running = false unless program.in_bounds?
end

puts "Part 1: #{program.num_mul_ops}"
# puts "Part 2: "


