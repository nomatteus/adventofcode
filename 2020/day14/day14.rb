require 'set'
require 'pry'

input = IO.read('./input').strip.split("\n")
# input = IO.read('./input_small').strip.split("\n")

class DecoderChip
  DEBUG = true

  def initialize
    @memory = {}
    @ones_mask = 0
    @zeros_mask = 0
  end 

  def run_part1(program)
    program.each do |command|
      case command[:op]
      when :set_mask
        set_mask(command[:mask])
      when :set_value
        set_value(command[:memory_address], command[:value])
      else
        raise "Invalid op: #{command[:op]}"
      end
    end

    # Result for part 1: sum of all values left in memory
    @memory.values.sum
  end

  private

  def set_mask(mask)
    # Int masks for one and zero chars
    @ones_mask = mask.chars.map { |c| c == "1" ? "1" : "0" }.join.to_i(2)
    @zeros_mask = mask.chars.map { |c| c == "0" ? "1" : "0" }.join.to_i(2)

    if DEBUG
      puts "--- Set mask"
      puts "    Ones Mask: #{@ones_mask.to_s(2).rjust(36, '0')}" 
      puts "   Zeros Mask: #{@zeros_mask.to_s(2).rjust(36, '0')}" 
    end
  end

  def set_value(memory_address, value)
    masked_value = (@ones_mask | value) & ~@zeros_mask
    @memory[memory_address] = masked_value

    if DEBUG
      puts "--- Set value"
      puts "Initial value: #{value.to_s(2).rjust(36, '0')} (decimal #{value})"
      puts " Masked value: #{masked_value.to_s(2).rjust(36, '0')} (decimal #{masked_value})"
    end
  end
end

def parse_input(input)
  input.map do |line|
    if line.match?(/mask =/) 
      mask = line.scan(/[X10]{36}/).first
      { op: :set_mask, mask: mask }

    else
      memory_address, value = line.scan(/\d+/).map(&:to_i)
      { op: :set_value, memory_address: memory_address, value: value }
    end
  end
end

decoder_chip = DecoderChip.new
commands = parse_input(input)
result_part1 = decoder_chip.run_part1(commands)

part1 = result_part1
puts "Part 1: #{part1}" # 16003257187056

binding.pry

part2 = 
puts "Part 2: #{part2}" # 


