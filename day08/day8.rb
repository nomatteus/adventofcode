require 'pry'

input = IO.read('./input').strip.split("\n")
# input = IO.read('./input_test').strip.split("\n")

registers = {}
max_ever = 0

input.each do |line|
  reg, op, val, _if, reg_check, condition_op, val_check = line.split
  val = val.to_i
  val_check = val_check.to_i

  # Init to 0 the first time we encounter registers
  registers[reg] = 0 unless registers.key? reg
  registers[reg_check] = 0 unless registers.key? reg_check

  reg_val_check = registers[reg_check]

  # evaluate condition
  condition_result = reg_val_check.send(condition_op, val_check)
  if condition_result
    sign = op == 'dec' ?  -1 : 1
    registers[reg] += val * sign

    max_ever = registers[reg] if registers[reg] > max_ever
  end
end

puts "part 1: #{registers.values.max}"
puts "part 2: #{max_ever}"


