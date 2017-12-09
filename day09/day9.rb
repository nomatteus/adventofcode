input = IO.read('./input').strip.chars

# states = [:GROUP, :GARBAGE, :IGNORENEXT]

cur_score = 0
sum_score = 0
cur_state = :GROUP

input.each do |c|
  case cur_state
  when :GROUP
    case c
    when '{'
      cur_score += 1
      sum_score += cur_score
    when '}'
      cur_score -= 1
    when '<'
      cur_state = :GARBAGE
    when ','
      #noop
    else
      # error
    end
  when :GARBAGE
    case c
    when '>'
      cur_state = :GROUP
    when '!'
      cur_state = :IGNORENEXT
    else
      #noop (consume char)
    end
  when :IGNORENEXT
    cur_state = :GARBAGE
  end
end

puts "part 1: #{sum_score}"
