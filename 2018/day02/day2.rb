input = IO.read('./input').strip.split("\n")

count2 = 0
count3 = 0

letter_count_map = {}

input.each do |line|
  letter_counts = Hash.new(0)
  letter_count_map[line] = letter_counts
  line.chars.each do |c|
    letter_counts[c] += 1
  end

  if letter_counts.values.any? { |v| v == 3 }
    count3 += 1
  end
  if letter_counts.values.any? { |v| v == 2 }
    count2 += 1
  end
end

part1 = count2 * count3
puts "Part 1: #{part1}"


input.each_with_index do |word1, i|
  input[i+1..-1].each do |word2|
    char_diffs = 0
    j = 0
    for j in 0...word1.size
      if word1[j] != word2[j]
        char_diffs += 1
        loc = j
      end
      break if char_diffs > 1
      j += 1
    end

    if char_diffs == 1
      answer = word1.chars
      answer.delete_at(loc)
      part2 = answer.join
      puts "Part 2: #{part2}"
      exit(0)
    end
  end
end

