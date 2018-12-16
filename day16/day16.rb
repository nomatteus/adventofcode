require 'set'
require 'pry'

input = IO.read('./input')

first_input, second_input = input.split("\n\n\n").map(&:strip)

# This class implements operations of device
class WatchDevice
  VALID_OPS = [
    :addr, :addi, :mulr, :muli, :banr, :bani, :borr, :bori, :setr, :seti,
    :gtir, :gtri, :gtrr, :eqir, :eqri, :eqrr
  ]

  # initial_registers is expected to be a 4-element array
  def initialize(initial_registers=[0, 0, 0, 0])
    @registers = Hash.new(0)
    initial_registers.each_with_index do |v, i|
      @registers[i] = v
    end
  end

  # Returns 4-element array with register values
  def registers
    @registers.values
  end

  # addr (add register) stores into register C the result of adding register A and register B.
  def addr(a, b, c)
    @registers[c] = @registers[a] + @registers[b]
  end

  # addi (add immediate) stores into register C the result of adding register A and value B.
  def addi(a, b, c)
    @registers[c] = @registers[a] + b
  end

  # mulr (multiply register) stores into register C the result of multiplying register A and register B.
  def mulr(a, b, c)
    @registers[c] = @registers[a] * @registers[b]
  end

  # muli (multiply immediate) stores into register C the result of multiplying register A and value B.
  def muli(a, b, c)
    @registers[c] = @registers[a] * b
  end

  # banr (bitwise AND register) stores into register C the result of the bitwise AND of register A and register B.
  def banr(a, b, c)
    @registers[c] = @registers[a] & @registers[b]
  end

  # bani (bitwise AND immediate) stores into register C the result of the bitwise AND of register A and value B.
  def bani(a, b, c)
    @registers[c] = @registers[a] & b
  end

  # borr (bitwise OR register) stores into register C the result of the bitwise OR of register A and register B.
  def borr(a, b, c)
    @registers[c] = @registers[a] | @registers[b]
  end

  # bori (bitwise OR immediate) stores into register C the result of the bitwise OR of register A and value B.
  def bori(a, b, c)
    @registers[c] = @registers[a] | b
  end

  # setr (set register) copies the contents of register A into register C. (Input B is ignored.)
  def setr(a, b, c)
    @registers[c] = @registers[a]
  end

  # seti (set immediate) stores value A into register C. (Input B is ignored.)
  def seti(a, b, c)
    @registers[c] = a
  end

  # gtir (greater-than immediate/register) sets register C to 1 if value A is greater than register B. Otherwise, register C is set to 0.
  def gtir(a, b, c)
    @registers[c] = a > @registers[b] ? 1 : 0
  end

  # gtri (greater-than register/immediate) sets register C to 1 if register A is greater than value B. Otherwise, register C is set to 0.
  def gtri(a, b, c)
    @registers[c] = @registers[a] > b ? 1 : 0
  end

  # gtrr (greater-than register/register) sets register C to 1 if register A is greater than register B. Otherwise, register C is set to 0.
  def gtrr(a, b, c)
    @registers[c] = @registers[a] > @registers[b] ? 1 : 0
  end

  # eqir (equal immediate/register) sets register C to 1 if value A is equal to register B. Otherwise, register C is set to 0.
  def eqir(a, b, c)
    @registers[c] = a == @registers[b] ? 1 : 0
  end

  # eqri (equal register/immediate) sets register C to 1 if register A is equal to value B. Otherwise, register C is set to 0.
  def eqri(a, b, c)
    @registers[c] = @registers[a] == b ? 1 : 0
  end

  # eqrr (equal register/register) sets register C to 1 if register A is equal to register B. Otherwise, register C is set to 0.
  def eqrr(a, b, c)
    @registers[c] = @registers[a] == @registers[b] ? 1 : 0
  end
end

# Store a list of valid operations, given the before/after values and op input, for the given input index
@valid_ops = {}

first_input.split("\n\n").each_with_index do |test_case, i|
  before, ops, after = test_case.split("\n")
  before_registers = before.scan(/\d+/).map(&:to_i)
  opcode, a, b, c = ops.scan(/\d+/).map(&:to_i)
  after_registers = after.scan(/\d+/).map(&:to_i)
  key = {i: i, op: opcode}
  @valid_ops[key] = [] #init

  # Test all possible operations to see which ones are valid for this input/output
  WatchDevice::VALID_OPS.each do |op|
    device = WatchDevice.new(before_registers)
    device.send(op, a, b, c)
    if device.registers == after_registers
      @valid_ops[key] << op
    end
  end
end
part1 = @valid_ops.values.collect(&:size).count { |size| size >= 3 }
puts "Part 1: #{part1}" # 570


############################################################## PART 2


# First, we build a mapping of opcodes and a list of all possible operations for
# that code. Then, we will try to find a solution that works for all opcodes.
possible_op_mapping = {}
@valid_ops.each do |(key, opnames)|
  opcode = key[:op]
  possible_op_mapping[opcode] ||= Set.new
  possible_op_mapping[opcode] += opnames
end

# Use backtracking algorithm to satisfy contraints of possible op mapping
def find_solution(currently_satisfied, remaining_mappings)
  currently_satisfied = currently_satisfied.dup
  # Note that we will not be modifying the Sets that are the values of remaining_mappings so dup will work well enough
  remaining_mappings = remaining_mappings.dup

  # Base case:
  if remaining_mappings.size.zero?
    return currently_satisfied
  end

  target_opcode, target_opnames = remaining_mappings.sort_by { |k, v| v.size }.first

  opname_options = target_opnames - currently_satisfied.values
  # If no opname options left (and still have remaining mappings), then this branch is not valid
  if opname_options.size.zero?
    return false
  end

  # Try out each opname that is not currently in use
  opname_options.each do |opname|
    currently_satisfied[target_opcode] = opname
    remaining_mappings.delete(target_opcode)

    # Result will be false if there is no solution
    result = find_solution(currently_satisfied, remaining_mappings)
    return result if result
  end

  false
end

opcode_to_op_mapping = find_solution({}, possible_op_mapping)
# puts opcode_to_op_mapping

device2 = WatchDevice.new
second_input.split("\n").each do |inst_str|
  opcode, a, b, c, = inst_str.scan(/\d+/).map(&:to_i)
  device2.send(opcode_to_op_mapping[opcode], a, b, c)
end

part2 = device2.registers[0]

puts "Part 2: #{part2}" # 503
