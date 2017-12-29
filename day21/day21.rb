ON = '#'
OFF = '.'

STARTING_MATRIX = [
  ['.', '#', '.'],
  ['.', '.', '#'],
  ['#', '#', '#']
]

# Rotate by 90 degrees: Transpose, then reverse the elements in each row
def rotate(matrix, num_rotations=1)
  num_rotations.times.inject(matrix) { |result, transpose| result.transpose.map(&:reverse) }
end

# Treat rows as row vectors and just reverse the order?
def flip_vertical(matrix)
  matrix.reverse
end

# Reverse entries in each row
def flip_horizontal(matrix)
  matrix.map(&:reverse)
end

def print_matrix(matrix)
  puts matrix.collect(&:join).join("\n")
end

# Load in the rules
rules_strings = IO.read('./input').strip.split("\n")
rules = {}
rules_strings.each do |rule|
  find, replace = rule.split(' => ')

  replace = replace.split('/').map(&:chars)
  find = find.split('/').map(&:chars)

  # Add all rotations and possible flipped matrices to the hash of rules
  (0..3).collect { |num_rotations| rotate(find, num_rotations) }.each do |rotation|
    rules[rotation] = replace
    rules[flip_vertical(rotation)] = replace
    rules[flip_horizontal(rotation)] = replace
  end
end

# Iterate through the steps
matrix = STARTING_MATRIX
5.times do
  size = matrix.size
  if size % 2 == 0
    pattern_size = 2
  elsif size % 3 ==0
    pattern_size = 3
  end

  new_size = size + size/pattern_size
  new_matrix = Array.new(new_size) { Array.new(new_size) }

  block_offsets = (0...size).step(pattern_size)
  block_offsets.each_with_index do |offset_row, rowi|
    block_offsets.each_with_index do |offset_col, coli|
      # Find pattern for this block, to load the replacement
      pattern_range_row = (0+offset_row)...(pattern_size+offset_row)
      pattern_range_col = (0+offset_col)...(pattern_size+offset_col)
      pattern = pattern_range_row.collect do |row|
        pattern_range_col.collect do |col|
          matrix[row][col]
        end
      end
      replacement = rules[pattern]
      raise "replacement not found for pattern: #{pattern}" if replacement.nil?

      # Copy the replacement to the correct place in the new matrix
      (0...replacement.size).each do |replacement_row|
        (0...replacement.size).each do |replacement_col|
          replace_row = replacement_row + offset_row + rowi
          replace_col = replacement_col + offset_col + coli
          new_matrix[replace_row][replace_col] = replacement[replacement_row][replacement_col]
        end
      end
    end
  end

  matrix = new_matrix
end

puts "Part 1: #{matrix.flatten.select { |v| v == ON }.size}"
