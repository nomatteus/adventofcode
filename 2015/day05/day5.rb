input_lines = IO.read("./input").split("\n")

VOWELS = 'aeiou'.chars
NAUGHTY_STRINGS = ['ab', 'cd', 'pq', 'xy']

nice_count = 0
input_lines.each do |line|
  vowel_count = line.chars.select{ |c| VOWELS.include? c }.size

  prev_char = nil
  has_repeat = false  #does the same letter appear twice in a row?
  has_naughty_string = false # does it have one of the naughty strings: ab, cd, pq, xy
  line.chars.each do |char|
    has_repeat = true if char == prev_char
    check_naughty = "#{prev_char}#{char}"
    has_naughty_string = true if NAUGHTY_STRINGS.include? check_naughty
    prev_char = char
  end
  nice_count += 1 if vowel_count >= 3 && has_repeat && !has_naughty_string
end

puts "Part 1 nice count: #{nice_count}"

## PART 2

nice_count = 0
input_lines.each do |line|

  # Store start index of letter pairs
  letter_pairs = {}

  line_chars = line.chars
  # repeat char with exactly one letter between
  has_repeat_sandwich = false
  line_chars.each_with_index do |char, i|
    # check letter pairs condition
    if i > 0
      pair = "#{line_chars[i-1]}#{char}"
      letter_pairs[pair] ||= []
      # check for an overlapping pair
      if !letter_pairs[pair].include?(i-1)
        letter_pairs[pair] << i
      end
    end

    # check for "repeat "sandwich"
    has_repeat_sandwich = true if i > 1 && char == line_chars[i-2]
  end

  has_pair_of_letter_pairs = letter_pairs.values.collect(&:size).any? { |s| s > 1 }
  nice_count += 1 if has_pair_of_letter_pairs && has_repeat_sandwich
end

puts "Part 2 nice count: #{nice_count}"
