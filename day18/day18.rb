require 'pry'

lines = IO.read('./input').strip.split("\n")
# lines = [ #test
#   'add a 2',
#   'mul a a',
#   'mod a 5',
#   'snd a',
#   'set a 0',
#   'rcv a',
#   'jgz a -1',
#   'set a 1',
#   'jgz a -2',
# ]


class Program
  attr_accessor :registers, :first_recovered_freq

  def initialize(instructions)
    @instructions = parse_instructions(instructions)
    @next_instruction = 0
    # Set default value of all registers to 0
    @registers = Hash.new(0)
    @freq = nil
    @recovered_freq = nil
    @first_recovered_freq = nil
  end

  def run!
    while in_bounds(@next_instruction) && @first_recovered_freq.nil? do
      send(*@instructions[@next_instruction])
    end
  end

  def in_bounds(inst_index)
    inst_index >= 0 && inst_index < @instructions.size
  end

  def set(x, y)
    @registers[x] = get_value(y)
    @next_instruction += 1
  end

  def add(x, y)
    @registers[x] += get_value(y)
    @next_instruction += 1
  end

  def mul(x, y)
    @registers[x] *= get_value(y)
    @next_instruction += 1
  end

  def mod(x, y)
    @registers[x] = @registers[x] % get_value(y)
    @next_instruction += 1
  end

  def snd(x)
    @freq = get_value(x)
    @next_instruction += 1
  end

  def rcv(x)
    unless get_value(x).zero?
      @recovered_freq = @freq
      @first_recovered_freq = @freq if @first_recovered_freq.nil?
    end
    @next_instruction += 1
  end

  def jgz(x, y)
    if get_value(x) > 0
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
      instruction, register, value = instruction.split
      # If not a lowercase single letter, then assume it is an integer if present
      value = value.to_i unless value.nil? || is_register?(value)
      raise if instruction.nil? || register.nil?
      [instruction, register, value].compact
    end
  end
end

program = Program.new(lines)
program.run!

puts "Part 1: #{program.first_recovered_freq} is first recovered frequency"
