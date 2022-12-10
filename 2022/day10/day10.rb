require 'pry'

input = IO.read('./input').strip.split("\n")
# input = IO.read('./input_small').strip.split("\n")


class CPU
  attr_accessor :signal_strengths

  SIGNAL_STRENGTH_CYCLES = [20, 60, 100, 140, 180, 220]

  CRT_ROWS = 6
  CRT_COLS = 40
  CRT_ON = '#'
  CRT_OFF = '.'

  def initialize
    @cycle = 0

    # register X
    @X = 1

    # Track for part 1
    @signal_strengths = []

    # screen pixels (initialize to off value)
    @crt = Array.new(CRT_ROWS) { Array.new(CRT_COLS) { CRT_OFF } } 
  end

  def run!(instructions)
    instructions.each { |instruction| step!(instruction) } 
  end

  def to_s
    @crt.map { |rows| rows.join }.join("\n")
  end

  private

  # Increment cycle
  def incr_cycle
    @cycle += 1

    draw!

    # Track signal strenght?
    @signal_strengths << (@cycle * @X) if SIGNAL_STRENGTH_CYCLES.include?(@cycle)
  end

  # Draw at current position according to cycle: "#" if the sprite appears, and "." otherwise
  # @X register stores the middle position of the 3x1 sprite.
  # (We always draw at horizontal position of current row according to cycle)
  def draw!
    col_index = (@cycle - 1) % CRT_COLS
    row_index = (@cycle - 1) / CRT_COLS

    # Check whether the value is on or off
    value = [@X - 1, @X, @X + 1].include?(col_index) ? CRT_ON : CRT_OFF

    @crt[row_index][col_index] = value
  end

  def step!(instruction)
    inst, num_str = instruction.split

    case inst
    when "addx"
      addx(num_str.to_i)
    when "noop"
      noop
    else
      raise "Unknown instruction: #{inst} #{num_str}"
    end
  end

  def addx(num)
    # Increment cycle by 2
    incr_cycle
    incr_cycle
    @X += num
  end

  def noop
    incr_cycle
  end
end

cpu = CPU.new 
cpu.run!(input)

part1 = cpu.signal_strengths.sum

puts "Part 1: #{part1}" # 12640
puts "Part 2: " # EHBZLRJR
puts cpu.to_s
