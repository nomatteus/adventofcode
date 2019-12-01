input_rows = IO.read('./input').strip.split("\n")

sum = 0
input_rows.each do |row|
  values = row.split.collect(&:to_i)
  sum += values.max - values.min
end

puts "Part 1: #{sum}" # 42299

sum = 0
input_rows.each do |row|
  values = row.split.collect(&:to_i)
  maxi = values.size - 1
  row_result = 0
  i = 0
  while row_result == 0 do
    val1 = values[i]
    for j in (i+1)..maxi do
      val2 = values[j]
      if val2.divmod(val1)[1].zero?
        row_result = val2 / val1
      elsif val1.divmod(val2)[1].zero?
        row_result = val1 / val2
      end
    end
    i += 1
  end
  sum += row_result
end

puts "Part 2: #{sum}" # 277
