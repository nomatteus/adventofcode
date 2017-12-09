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
