require 'pry'

input = IO.read('./input').strip.split(',')
# input = "s1,x3/4,pe/b".split(',') # test

class PermutationPromenade
  def initialize(input)
    @moves = input
    @programs = 'abcdefghijklmnop'.chars
    # @programs = 'abcde'.chars #test
  end

  def dance!
    @moves.map { |m| parse_move(m) }.each do |move|
      send(move[:command], *move[:args])
    end
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
