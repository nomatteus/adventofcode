require 'pry'

input_digits = IO.read('input').strip.split('').map(&:to_i)

class FFT
  BASE_PATTERN = [0, 1, 0, -1]

  def initialize(digits:)
    @digits = digits
    @num_digits = digits.size
    @current_phase = 1

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

    @current_phase += 1
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

fft = FFT.new(digits: input_digits)
result = fft.run_n_phases(100)

puts "Part 1: #{result}" # 84487724

