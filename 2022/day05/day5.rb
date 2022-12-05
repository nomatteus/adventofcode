require 'pry'

parts = IO.read('./input').split("\n\n")
# parts = IO.read('./input_small').split("\n\n")
initial_state_str = parts[0].split("\n").reverse
moves_str = parts[1].split("\n")


num_stacks = (initial_state_str.first.size + 1) / 4
stacks = Array.new(num_stacks + 1) { [] }

# Skip first line (indexes)
initial_state_str.drop(1).each.with_index do |line, i|
  # Will have crate letter if present, or space " " if not
  crates = line.chars.each_slice(4).to_a.map { |c| c[1] }

  crates.each.with_index do |crate_val, stacki|
    next if crate_val == " "
    # convert stack index to be 1-based to match problem
    stacks[stacki + 1].push(crate_val)
  end
end


# Now execute crate moves
moves_str.each do |move_str|
  quantity, from, to = move_str.scan(/\d+/).map(&:to_i)

  # part 1 
  # quantity.times do 
  #   crate = stacks[from].pop
  #   stacks[to].push(crate)
  # end
  # Part 2
  crates = stacks[from].pop(quantity)
  stacks[to].push(*crates)
end

part1 = stacks.collect(&:last).compact.join
part2 = stacks.collect(&:last).compact.join

puts "Part 1: #{part1}" # VQZNJMWTR
puts "Part 2: #{part2}" # NLCDCLVMQ
