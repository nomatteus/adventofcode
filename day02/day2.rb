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
    diff = letter_count_map[word1].to_a - letter_count_map[word2].to_a

    if diff.size == 1 && diff.first[1] == 1
      # Verify solution by checking to make sure words differ by only one letter in one position
      char_diffs = 0
      0.upto(word1.size - 1).each do |i|
        char_diffs += 1 unless word1[i] == word2[i]
      end

      if char_diffs == 1
        part2 = (word1.chars - [diff.first[0]]).join
        puts "Part 2: #{part2}"
      end
    end
  end
end
