diagram = IO.read('./input').split("\n").map(&:chars)

# Initial starting position
row = 0
col = diagram.first.index('|')
dir = :down
letters_seen = []
steps = 1

loop do
  case dir
  when :up
    row = row - 1
  when :down
    row = row + 1
  when :left
    col = col - 1
  when :right
    col = col + 1
  end

  case diagram[row][col]
  when '+' # Change Direction (no backtracking)
    # Logic is a bit messy, but handles truncated spaces (i.e. treat nil as blank space)
    if (row-1) >= 0 && !diagram[row-1][col].nil? && diagram[row-1][col] != ' ' && dir != :down
      dir = :up
    elsif (row+1) < diagram.size && !diagram[row+1][col].nil? && diagram[row+1][col] != ' ' && dir != :up
      dir = :down
    elsif (col-1) >=0 && !diagram[row][col-1].nil? && diagram[row][col-1] != ' ' && dir != :right
      dir = :left
    elsif (col+1) < diagram[row].size && !diagram[row][col+1].nil? && diagram[row][col+1] != ' ' && dir != :left
      dir = :right
    end
  when /^([A-Z])/
    letters_seen << diagram[row][col]
  when '|', '-'
    # Do nothing. Keep going in same direction
  else
    # We are at the end.
    break
  end

  steps += 1
end

puts "Part 1: Letters Seen: #{letters_seen.join}"
puts "Part 2: Steps Taken: #{steps}"
