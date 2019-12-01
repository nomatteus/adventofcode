require 'set'
require 'pry'

input = IO.read('./input').strip.split("\n")
# input = IO.read('./input_small').strip.split("\n")

class GameOfPlant

  EMPTY_POT = '.'
  PLANT = '#'

  # Initialize with input strings
  def initialize(intial_state, rules)
    @positions_map = Hash.new

    # For info purposes, track generation number we are on
    @generation_num = 0

    parse_initial_state(intial_state)
    parse_rules(rules)
  end

  def next_generation!
    next_gen_positions = get_stored_next_pattern(@positions)

    # If stored position not found, then calculate the next positions
    if next_gen_positions.nil?
      next_gen_positions = Hash.new { '.' }
      # For each iteration, we treat i as the middle of the pattern
      (start_pos(@positions)..end_pos(@positions)).each do |i|
        pattern = (i-2..i+2).collect { |j| @positions[j] }.join
        if @plant_rules.include? pattern
          next_gen_positions[i] = '#'
        else
          next_gen_positions[i] = '.'
        end
      end
      store_pattern_mapping(@positions, next_gen_positions)
    end

    @positions = next_gen_positions
    # trim_positions!

    @generation_num += 1
  end

  # The idea is we want to remove positions that are outside of the range that could be affected.
  def trim_positions!
    first_plant = first_plant_pos(@positions)
    last_plant = last_plant_pos(@positions)
    binding.pry if first_plant.nil? || last_plant.nil?
    @positions.select! { |k, v| k.between?(first_plant - 2, last_plant + 2) }
  end

  def start_pos(positions)
    # [first_plant_pos - 2, @positions.keys.first].min
    first_plant_pos(positions) - 2
  end

  # Similar logic as start position but on the right.
  def end_pos(positions)
    # [last_plant_pos + 2, @positions.keys.last].max
    last_plant_pos(positions) + 2
  end

  def first_plant_pos(positions)
    first_plant, _ = positions.find { |k, v| v == PLANT }
    first_plant
  end

  def last_plant_pos(positions)
    last_plant, _ = positions.select { |k, v| v == PLANT }.keys.sort.last
    last_plant
  end

  # Sum of the position numbers of all pots that have plants
  def plant_sum
    @positions.select { |k, v| v == PLANT }.keys.sum
  end

  def part1
    20.times { self.next_generation! }
    plant_sum
  end

  def part2
    # Based on observation, the pattern repeats at or before 10,000 iterations..
    50000.times { self.next_generation! }
    plant_sum1 = plant_sum
    50000.times { self.next_generation! }
    plant_sum2 = plant_sum

    delta_50000 = plant_sum2 - plant_sum1
    answer = plant_sum1 + (50_000_000_000 - 50_000) / 50_000 * delta_50000
  end

private

  # We will store the pattern mapping in a normalized way (i.e. without positions).
  # We need to make sure that the input string and output string are aligned, i.e.
  # the positions should match up.
  def store_pattern_mapping(input_positions, output_positions)
    # Normalize the input positions so we can compare them
    starti = start_pos(input_positions)
    endi = end_pos(input_positions)
    input_str = []
    output_str = []
    (starti..endi).each do |i|
      input_str << input_positions[i]
      output_str << output_positions[i]
    end

    @positions_map[input_str.join] = output_str.join
  end

  # Check cache for pattern, and return it if we find it, mapping the positions to correct numbers.
  def get_stored_next_pattern(input_positions)
    starti = start_pos(input_positions)
    endi = end_pos(input_positions)
    input_str = []
    (starti..endi).each do |i|
      input_str << input_positions[i]
    end
    key = input_str.join

    return nil unless @positions_map.key? key

    newi = 0

    new_positions = Hash.new { '.' }
    (starti..endi).each do |i|
      new_positions[i] = @positions_map[key][newi]

      newi += 1
    end

    new_positions
  end

  def parse_initial_state(intial_state)
    @positions = Hash.new { '.' }
    intial_state.scan(/[#\.]+/).first.chars.each_with_index do |char, i|
      @positions[i] = char
    end
  end

  def parse_rules(rules)
    # We will only store rules that produce plants
    @plant_rules = Set.new
    rules.each do |rule|
      pattern, replacement = rule.split(' => ')
      next if replacement == EMPTY_POT
      @plant_rules << pattern
    end
  end

end

part1 = GameOfPlant.new(input.first, input[2..-1]).part1
puts "Part 1: #{part1}" # 1987

part2 = GameOfPlant.new(input.first, input[2..-1]).part2
puts "Part 2: #{part2}" # 1150000000358
