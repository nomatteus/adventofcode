require 'set'
require 'pry'

input = 846601

def part1(input)
  scores = {
    0 => 3,
    1 => 7
  }
  i = 2

  # Elf positions
  elf1 = 0
  elf2 = 1

  while scores.size < (input + 10) do
    sum = scores[elf1] + scores[elf2]
    sum.digits.reverse.each do |digit|
      scores[i] = digit
      i += 1
    end
    elf1 = (elf1 + scores[elf1] + 1) % scores.size
    elf2 = (elf2 + scores[elf2] + 1) % scores.size
  end

  part1_result = []
  (input...input+10).each do |i|
    part1_result << scores[i]
  end

  part1_result.join
end


puts "Part 1: #{part1(input)}" # 3811491411

######################################################### Part 2


def part2(input)
  scores = {
    0 => 3,
    1 => 7
  }
  i = 2

  # Elf positions
  elf1 = 0
  elf2 = 1

  input_digits = input.digits
  num_digits = input_digits.size

  match_found = false
  until match_found do
    sum = scores[elf1] + scores[elf2]
    sum.digits.reverse.each do |digit|
      scores[i] = digit

      match_found = true
      # Note that input_digits are reversed (least significant first)
      input_digits.each_with_index do |digit, j|
        if digit != scores[i - j]
          match_found = false
          break
        end
      end
      if match_found
        result_part2 = i - num_digits + 1
        return result_part2
      end

      i += 1

      # puts i if i % 1000000 == 0
    end

    elf1 = (elf1 + scores[elf1] + 1) % scores.size
    elf2 = (elf2 + scores[elf2] + 1) % scores.size
  end
end

puts "Part 2: #{part2(input)}" # 20408083
