input = IO.read('./input').strip.split.map(&:to_i)
# input = [0, 2, 7, 0]

first_duplicate_seen = false
second_duplicate_seen = false
seen = {}
num_cycles_first = 0
num_cycles_second = 0
duplicate = nil

while !second_duplicate_seen do
  max = input.max
  maxi = input.index(max)

  i = maxi
  input[i] = 0
  distribute = max

  while distribute > 0 do
    i = (i + 1) % input.size
    input[i] += 1
    distribute -= 1
  end

  current = input.dup
  seen[current] ||=  0
  seen[current] += 1

  if !first_duplicate_seen
    num_cycles_first += 1
  else
    num_cycles_second += 1
  end

  if !first_duplicate_seen && seen[current] > 1
    first_duplicate_seen = true
    duplicate = current
  elsif first_duplicate_seen && seen[duplicate] > 2
    second_duplicate_seen = true
  end
end

puts "part 1: #{num_cycles_first}"
puts "part 2: #{num_cycles_second}"
