require 'set'
require 'pry'

require_relative './watch_device'

input = IO.read('./input')

first_input, second_input = input.split("\n\n\n").map(&:strip)

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
