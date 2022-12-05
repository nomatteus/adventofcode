require 'pry'

parts = IO.read('./input').split("\n\n")
# parts = IO.read('./input_small').split("\n\n")

initial_state_str = parts[0].split("\n").reverse
moves_str = parts[1].split("\n")


class Stack
  def initialize(initial_state_str, moves_str)
    num_stacks = (initial_state_str.first.size + 1) / 4
    # Use 1-based indexing so need extra array element
    @stacks = Array.new(num_stacks + 1) { [] }

    # Skip first line (indexes)
    initial_state_str.drop(1).each.with_index do |line, i|
      # Will have crate letter if present, or space " " if not
      crates = line.chars.each_slice(4).to_a.map { |c| c[1] }

      crates.each.with_index do |crate_val, stacki|
        next if crate_val == " "
        # convert stack index to be 1-based to match problem
        @stacks[stacki + 1].push(crate_val)
      end
    end

    # Parse moves
    @moves = moves_str.map { |move_str| move_str.scan(/\d+/).map(&:to_i) }
  end

  def execute_moves!(move_type)
    # Now execute crate moves
    @moves.each do |quantity, from, to|
      # Part 1: Move single crate at a time
      if move_type == :single
        quantity.times do 
          crate = @stacks[from].pop
          @stacks[to].push(crate)
        end
      else      
        # Part 2: Move multiple crates at a time
        crates = @stacks[from].pop(quantity)
        @stacks[to].push(*crates)
      end
    end
  end

  def stack_tops
    @stacks.collect(&:last).compact.join
  end
end

stack1 = Stack.new(initial_state_str, moves_str)
stack1.execute_moves!(:single)

stack2 = Stack.new(initial_state_str, moves_str)
stack2.execute_moves!(:multiple)

part1 = stack1.stack_tops
part2 = stack2.stack_tops

puts "Part 1: #{part1}" # VQZNJMWTR
puts "Part 2: #{part2}" # NLCDCLVMQ
