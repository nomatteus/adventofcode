# Messy solution for day 2
input = IO.read('input')
# input = "1,0,0,0,99"

nums = input.split(",").map(&:to_i)

# only for my input:
nums[1] = 12
nums[2] = 2

res = nil
i = 0

while res != :done do
  op, num1, num2, pos = nums.slice(i, 4)

  # puts "op: #{op}, num1: #{num1}, num2: #{num2}, pos: #{pos}, "

  res = case op
  when 1 then nums[num1] + nums[num2]
  when 2 then nums[num1] * nums[num2]
  when 99 then :done # done
  else raise "error! invalid opcode: #{op}"
  end

  if res != :done
    nums[pos] = res
  end

  # puts nums.join(",")

  i += 4
end


puts "Part 1:"
puts nums[0]


######################################################################################


input = IO.read('input')
# input = "1,0,0,0,99"

nums_input = input.split(",").map(&:to_i)


0.upto(100).each do |noun|
  0.upto(100).each do |verb|
    # Use original input on each iteration
    nums = nums_input.dup

    # only for my input:
    nums[1] = noun
    nums[2] = verb

    res = nil
    i = 0

    while res != :done do
      op, num1, num2, pos = nums.slice(i, 4)

      # puts "op: #{op}, num1: #{num1}, num2: #{num2}, pos: #{pos}, "

      res = begin
        case op
        when 1 then nums[num1] + nums[num2]
        when 2 then nums[num1] * nums[num2]
        when 99 then :done # done
        else raise "invalid opcode" # invalid opcode
        end
      rescue => exception
        # invalid opcode or invalid reference
        break
      end

      if res != :done
        nums[pos] = res
      end

      i += 4
    end

    if nums[0] == 19690720
      puts "Part 2:"
      puts "noun: #{noun}, verb: #{verb}"
      puts "100 * noun + verb = #{100 * noun + verb}"
      break
    end
  end
end
