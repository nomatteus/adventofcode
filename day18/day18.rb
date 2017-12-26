lines = IO.read('./input').strip.split("\n")

class Program
  attr_accessor :registers, :other_program, :is_receiving, :num_values_sent

  def initialize(instructions, program_id)
    @instructions = parse_instructions(instructions)
    @next_instruction = 0

    # Set default value of all registers to 0
    @registers = Hash.new(0)

    # As defined by the problem:
    @registers['p'] = program_id

    # Initiate receiving queue
    @messages_received = Queue.new

    # Counter for our answer
    @num_values_sent = 0
  end

  def run_next_instruction
    send(*@instructions[@next_instruction])
  end

  # Is next instruction in bounds?
  def in_bounds?
    @next_instruction >= 0 && @next_instruction < @instructions.size
  end

  def send_value(val)
    @messages_received << val
  end

private

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
    @other_program.send_value(get_value(x))
    @num_values_sent += 1
    @next_instruction += 1
  end

  def rcv(x)
    @is_receiving = true
    # If queue is empty, then will attempt to run instruction again
    if @messages_received.size > 0
      # Receive the message
      @registers[x] = @messages_received.pop
      @is_receiving = false
      @next_instruction += 1
    end
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
      instruction, val1, val2 = instruction.split
      # If not a lowercase single letter, then assume it is an integer if present
      val1 = val1.to_i unless val1.nil? || is_register?(val1)
      val2 = val2.to_i unless val2.nil? || is_register?(val2)
      raise if instruction.nil? || val1.nil?
      [instruction, val1, val2].compact
    end
  end
end

p0 = Program.new(lines, 0)
p1 = Program.new(lines, 1)
p0.other_program = p1
p1.other_program = p0

# Program runner
p0_running = true
p1_running = true
while p0_running || p1_running do
  p0.run_next_instruction if p0_running
  p1.run_next_instruction if p1_running

  # Check for program termination: out of bounds
  p0_running = false unless p0.in_bounds?
  p1_running = false unless p1.in_bounds?

  # Deadlock detection
  if (p0.is_receiving || !p0_running) && (p1.is_receiving || !p1_running)
    p0_running = p1_running = false
  end
end

# See commit f614898 for part1
puts "Part 1: 7071 is first recovered frequency"
puts "Part 2: p1 sent values #{p1.num_values_sent} times"
