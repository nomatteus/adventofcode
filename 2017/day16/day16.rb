INITIAL_PROGRAMS = 'abcdefghijklmnop'

input = IO.read('./input').strip.split(',')

class PermutationPromenade
  def initialize(input)
    @moves = input
    @parsed_moves = @moves.map { |m| parse_move(m) }
    @programs = INITIAL_PROGRAMS.chars
  end

  def dance!
    @parsed_moves.each do |move|
      send(move[:command], *move[:args])
    end
    self
  end

  def to_s
    @programs.join
  end

private

  # Move X programs from the end to the front
  def spin(num)
    spun_programs = @programs.slice!(-num, num)
    @programs = spun_programs + @programs
  end

  # Given 2 positions, swap the values at those positions
  def exchange(pos1, pos2)
    tmp = @programs[pos1]
    @programs[pos1] = @programs[pos2]
    @programs[pos2] = tmp
  end

  # Find positions of 2 partners, then swap
  def partner(prog1, prog2)
    exchange(@programs.index(prog1), @programs.index(prog2))
  end

  def parse_move(move)
    _, command, val1, _, val2 = /([xps])([\da-p]+)(\/([\da-p]+))?/.match(move).to_a

    case command
    when 's'
      { command: :spin, args: [val1.to_i] }
    when 'x'
      { command: :exchange, args: [val1.to_i, val2.to_i] }
    when 'p'
      { command: :partner, args: [val1, val2] }
    end
  end
end

part1 = PermutationPromenade.new(input).dance!
puts "Part 1: #{part1}"

# Figure out how many dances until the input repeats, then we can use that
# to figure out the values after any number of dances using mod without a ton of calculation.
test = PermutationPromenade.new(input).dance!
num_dances_until_repeat = 1
while test.to_s != INITIAL_PROGRAMS
  test.dance!
  num_dances_until_repeat += 1
end

part2 = PermutationPromenade.new(input)
(1000000000 % num_dances_until_repeat).times { part2.dance! }
puts "Part 2: #{part2}"

