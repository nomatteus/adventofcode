require 'set'
require 'pry'

input = IO.read('./input').strip.chars#.map(&:to_i)
# input = IO.read('./input_small').strip.chars#.map(&:to_i)

# input is an array of chars
# remove is a char to remove -- we will remove all types (upper and lower case) of provided char
def polymer_reaction(input, remove=nil)
  input_hash = {}
  input.each_with_index do |char, i|
    # Skip over any character that we want to remove
    next if !remove.nil? && char.downcase == remove.downcase
    input_hash[i] = char
  end

  loop do
    something_deleted = false
    skips = 0
    prev_char = nil
    prev_i = nil

    input_hash.each do |i, char|

      # NOTE that if we deleted chars, then prev_char/prev_i will be invalid
      # Therefore, we want to skip ahead, but do not check for a match.
      if skips > 0
        # We skip but still set prev char/i
        skips -= 1
      elsif !prev_char.nil? && (char.downcase == prev_char.downcase && char != prev_char)
        # remove i and previous i
        input_hash.delete(i)
        input_hash.delete(prev_i)

        something_deleted = true

        # skip the next 2 chars so we have valid chars to check again.
        skips = 2
      end

      prev_char = char
      prev_i = i
    end

    break unless something_deleted
  end

  input_hash
end

part1_result = polymer_reaction(input)
puts "Part 1: #{part1_result.size}" # 10250

part2_best = nil
('a'..'z').each do |letter|
  part2_result = polymer_reaction(input, letter)
  part2_size = part2_result.size
  part2_best = part2_size if part2_best.nil? || part2_size < part2_best
end

puts "Part 2: #{part2_best}"
