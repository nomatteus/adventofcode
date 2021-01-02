require 'set'
require 'pry'

input = IO.read('./input').strip.split("\n")
# input = IO.read('./input_small').strip.split("\n")
# input = IO.read('./input_small2').strip.split("\n")

class DecoderChip
  DEBUG = true

  def initialize
    @memory = {}
    @ones_mask = 0
    @zeros_mask = 0
  end 

  def run(program, version: 1)
    program.each do |command|
      case command[:op]
      when :set_mask
        set_mask(command[:mask])
      when :set_value
        if version == 1
          set_value_v1(command[:memory_address], command[:value])
        else
          set_value_v2(command[:memory_address], command[:value])
        end
      else
        raise "Invalid op: #{command[:op]}"
      end
    end

    # Result: sum of all values left in memory
    @memory.values.sum
  end
  
  private

  def set_mask(mask)
    @mask = mask
  end

  # Return masked value (as integer)
  # value: integer
  def masked_value_v1(value)
    # Int masks for one and zero chars
    ones_mask = @mask.chars.map { |c| c == "1" ? "1" : "0" }.join.to_i(2)
    zeros_mask = @mask.chars.map { |c| c == "0" ? "1" : "0" }.join.to_i(2)

    result = (ones_mask | value) & ~zeros_mask

    if DEBUG
      puts "         Mask: #{@mask}" 
      puts "    Ones Mask: #{padded_binary_string(ones_mask)}" 
      puts "   Zeros Mask: #{padded_binary_string(zeros_mask)}" 
      puts "Initial value: #{padded_binary_string(value)} (decimal #{value})"
      puts " Masked value: #{padded_binary_string(result)} (decimal #{result})"
    end

    result
  end

  def set_value_v1(memory_address, value)
    @memory[memory_address] = masked_value_v1(value)

    if DEBUG
      puts "--- Set value (v1)"
      puts "memory[#{memory_address}] = #{padded_binary_string(@memory[memory_address])} (decimal #{@memory[memory_address]})"
    end
  end

  def padded_binary_string(mask_int)
    mask_int.to_i.to_s(2).rjust(36, '0')
  end

  def set_value_v2(memory_address, value)
    memory_address_binary = memory_address.to_s(2).rjust(36, '0')

    # Apply mask to memory address (build array of all possible addresses)
    addresses = [""]
    0.upto(35).each do |pos|
      if @mask[pos] == "X"
        # Double size of array, as bit can be 0 or 1
        addresses = addresses.map { |a| a + "0" } + addresses.map { |a| a + "1" }
      elsif @mask[pos] == "0"
        # Unchanged
        addresses.map.with_index { |a, i| addresses[i] += memory_address_binary[pos] }
      else
        # Bitmask is 1, so write a 1
        addresses.map.with_index { |a, i| addresses[i] += "1" }
      end
    end

    # Set value at addresses
    addresses.map do |a|
      @memory[a.to_i(10)] = value
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

commands = parse_input(input)

decoder_chip = DecoderChip.new
result_part1 = decoder_chip.run(commands, version: 1)

decoder_chip2 = DecoderChip.new
result_part2 = decoder_chip2.run(commands, version: 2)

part1 = result_part1
puts "Part 1: #{part1}" # 16003257187056

part2 = result_part2
puts "Part 2: #{part2}" # 3219837697833


