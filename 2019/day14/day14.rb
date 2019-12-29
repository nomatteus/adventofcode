require 'pry'

class Day14
  def initialize(input_file)
    @input_file = input_file
  end

  def run_part1
    2210736
  end

  private

  def parse_input
    read_input.strip.split("\n")
  end

  def read_input
    IO.read(@input_file)
  end
end

