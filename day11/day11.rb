input = IO.read('./input').strip.split(',')

#        'r
#    _ 1    o
#  _/ \_  0   w
# / \_/ \_  -1  s'
# \_/ \_/ \
#   \_/ \_/
#     \_/
# -1 0 1 2
#   'cols'

# How many steps from origin is col, row
def steps(col, row)
  if (col > 0 && row > 0) || (col < 0 && row < 0)
    col.abs + row.abs
  else
    [col.abs, row.abs].max
  end
end

cur_col = 0
cur_row = 0
max_steps = 0

input.each do |dir|
  case dir
  when 'n'
    cur_row += 1
  when 'ne'
    cur_col += 1
  when 'se'
    cur_col += 1
    cur_row -= 1
  when 's'
    cur_row -= 1
  when 'sw'
    cur_col -= 1
  when 'nw'
    cur_col -= 1
    cur_row += 1
  end

  cur_steps = steps(cur_col, cur_row)
  max_steps = cur_steps if cur_steps > max_steps
end

puts "Part 1: #{steps(cur_col, cur_row)}"
puts "Part 2: #{max_steps} (max steps)"
