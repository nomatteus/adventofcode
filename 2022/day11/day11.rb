require 'pry'

input = IO.read('./input').strip.split("\n\n")
# input = IO.read('./input_small').strip.split("\n\n")

class Monkey
  attr_reader :index, :items, :inspect_count, :test_val
  attr_accessor :global_test_val_product

  def initialize(input)
    @items = []
    # Track inspection count for part 1
    @inspect_count = 0
    @current_item = nil

    parse_input!(input)
  end

  # Inspect item and return new value and target monkey
  def throw_item(part)
    @current_item = items.shift
    @inspect_count += 1

    new_value = part == :part1 ? calculate_new_value_part1 : calculate_new_value_part2

    target_index = (new_value % @test_val).zero? ? @true_target : @false_target

    return new_value, target_index
  end

  # Catching an item
  def catch_item(value)
    @items.push(value)
  end

  def has_items? = !items.empty?

  def to_s
    "Monkey #{index} inspected #{@inspect_count} items (current items: #{@items.join(', ')})"
  end

  private

  # Handle `old` variable if present; otherwise use int val
  def operand1 = @operand1 == "old" ? @current_item : @operand1.to_i
  def operand2 = @operand2 == "old" ? @current_item : @operand2.to_i

  def calculate_new_value_part1
    val = operand1.send(@operation, operand2)
    val /= 3
  end

  def calculate_new_value_part2
    case @operation
    when '+'
      # When adding, we can set value to modulus of test_val and calculations are still correct
      (operand1 + operand2) % @global_test_val_product
    when '*'
      # For multiplication, use this property: (ab mod 𝑚)=((a mod 𝑚)(b mod 𝑚)) mod 𝑚
      ((operand1 % @global_test_val_product) * (operand2 % @global_test_val_product)) % @global_test_val_product
    else
      raise "Unsupported operation: #{@operation}"
    end
  end

  # Input is array of monkeys, with each being a string in the format:
  # Monkey 0:
  #   Starting items: 80
  #   Operation: new = old * 5
  #   Test: divisible by 2
  #     If true: throw to monkey 4
  #     If false: throw to monkey 3
  def parse_input!(input)
    lines = input.split("\n")
    @index = lines[0].scan(/\d+/).first.to_i
    
    starting_items = lines[1].scan(/\d+/).map(&:to_i)
    @items.push(*starting_items)

    operation_str = lines[2].split(" = ").last
    @operand1, @operation, @operand2 = operation_str.split

    @test_val = lines[3].scan(/\d+/).first.to_i
    @true_target = lines[4].scan(/\d+/).first.to_i
    @false_target = lines[5].scan(/\d+/).first.to_i
  end
end

class KeepAwayGame
  attr_reader :monkeys

  def initialize(input, part)
    # (Can assume that monkeys are in index order, starting with 0)
    @monkeys = input.map { |m_input| Monkey.new(m_input) }
    @part = part
    @global_test_val_product = @monkeys.map(&:test_val).reduce(:*)
    @monkeys.each { |monkey| monkey.global_test_val_product = @global_test_val_product }
  end

  def play_round!
    @monkeys.each do |monkey|
      while monkey.has_items?
        new_value, target_i = monkey.throw_item(@part)
        @monkeys[target_i].catch_item(new_value)
      end
    end
  end

  # Debug: 
  def to_s
    @monkeys.map(&:to_s)
  end
end

game1 = KeepAwayGame.new(input, :part1)
20.times.with_index do |i|
  # puts "--- Round #{i + 1}"
  game1.play_round!
  # puts game.to_s
end

game2 = KeepAwayGame.new(input, :part2)
10000.times.with_index do |i|
  # puts "--- Round #{i + 1}"
  game2.play_round!
  # puts game2.to_s
end

part1 = game1.monkeys.map(&:inspect_count).sort.last(2).reduce(:*)
part2 = game2.monkeys.map(&:inspect_count).sort.last(2).reduce(:*)

puts "Part 1: #{part1}" # 100345
puts "Part 2: #{part2}" # 28537348205
