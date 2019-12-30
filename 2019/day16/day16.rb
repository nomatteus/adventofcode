require 'pry'

input_digits = IO.read('input').strip.split('').map(&:to_i)

class FFT1
  BASE_PATTERN = [0, 1, 0, -1]

  def initialize(digits:)
    @digits = digits
    @num_digits = digits.size

    # Cache patterns
    @patterns_for_positions = {}
  end

  def run_phase
    output_digits = []

    1.upto(@num_digits).map do |pos|
      # Build the full pattern we need for all digits (add 1 since we drop first one)
      pattern = build_pattern(pos).cycle.take(@num_digits + 1).drop(1)

      # Pattern digits calculation.
      pattern_calc_sum = pattern.zip(@digits).map { |pair| pair.reduce(:*) }.sum

      # We only want the 10s digit, so extract that.
      # (Note that .digits method returns digits in reverse order)
      new_digit = pattern_calc_sum.abs.digits.first

      output_digits << new_digit
    end

    @digits = output_digits
  end

  # Part 1
  def run_n_phases(num)
    num.times { run_phase }

    # Return final result (note that we only need the first 8 digits)
    @digits.first(8).map(&:to_s).join
  end

  # Where position is the position we are calculating for.
  # To build the pattern:
  #   - Repeat each element in the base pattern by the position num.
  def build_pattern(position)
    if !@patterns_for_positions.has_key?(position)
      # e.g. if we have position = 2, then
      #   BASE_PATTERN => [0, 1, 0, -1]
      #     Array.new => [[0, 0], [1, 1], [0, 0], [-1, -1]]
      #     flatten   => [0, 0, 1, 1, 0, 0, -1, -1]  (final result)
      pattern = BASE_PATTERN.map { |i| Array.new(position, i)  }.flatten
      @patterns_for_positions[position] = pattern
    end

    @patterns_for_positions[position]
  end
end

fft = FFT1.new(digits: input_digits)
result = fft.run_n_phases(100)
puts "Part 1: #{result}" # 84487724


# Part 2
class FFT2
  def initialize(digits:)
    @all_digits = digits

    # 5975053
    @offset = @all_digits.first(7).map(&:to_s).join('').to_i
    # binding.pry

    # This solution depends on the offset being in the 2nd half of digits, so check assumption.
    raise "Uh oh! This solution won't work." if @offset < (@all_digits.size / 2)

    # Now, we only need to consider the digits after the offset
    # Size: 524,947 digits
    @digits = @all_digits.slice(@offset, @all_digits.size - @offset)
  end

  # Note that this solution depends on some assumptions/observations:
  # - In second half of digit array, the pattern will include only 0s and 1s
  # - Each digit in the second half of the array only depends on the digit
  #   at that position and after in the rest of the array.
  # - So, we can speed up calculations to find the solution without generating the
  #   full transform for all digits.
  # - Furthermore, we can build the sum starting from the last digit, to avoid having
  #   to do a bunch of recalculations.
  def run_phase
    new_digits = []
    running_sum = 0
    @digits.reverse.each do |digit|
      # We only care about the last digit in all sums
      running_sum = (running_sum + digit) % 10

      # Note that new digits will be in reverse order, so will reverse again after
      new_digits << running_sum
    end
    @digits = new_digits.reverse
  end

  def run_n_phases(num)
    num.times { run_phase }

    # Return final result (note that we only need the first 8 digits)
    # Also, we've already accounted for the offset
    @digits.first(8).map(&:to_s).join
  end
end

# Build up input for part 2 (input repeated 10,000 times)
digits_part2 = []
10000.times { input_digits.each { |digit| digits_part2 << digit } }

fft2 = FFT2.new(digits: digits_part2)
result = fft2.run_n_phases(100)

puts "Part 2: #{result}" # 84692524

