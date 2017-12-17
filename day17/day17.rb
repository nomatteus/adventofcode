input = 355

def spinlock(num_values, num_steps)
  buffer = [0]
  cur_pos = 0

  1.upto(num_values).each do |num|
    cur_pos = (cur_pos + num_steps) % buffer.size
    insert_at = cur_pos + 1
    if insert_at >= buffer.size
      buffer.push(num)
    else
      buffer.insert(insert_at, num)
    end
    cur_pos = insert_at
    num += 1
  end
  buffer
end

# We'll go through the the motions for this one, but don't need to actually
# track any values.
def spinlock_val_at_1(num_values, num_steps)
  buffer = [0]
  cur_pos = 0
  buffer_size = 1

  val_at_1 = nil
  1.upto(num_values).each do |num|
    cur_pos = (cur_pos + num_steps) % buffer_size
    insert_at = cur_pos + 1

    # Only track if the val at position 1 changes
    val_at_1 = num if insert_at == 1

    cur_pos = insert_at
    num += 1
    buffer_size += 1
  end
  val_at_1
end

part1_buffer = spinlock(2017, input)
part1i = part1_buffer.index(2017) + 1
puts "Part 1: #{part1_buffer[part1i]}"

part2 = spinlock_hash(50000000, input)
puts "Part 2: #{part2}"

