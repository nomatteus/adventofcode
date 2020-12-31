require 'set'
require 'pry'

input = IO.read('./input').strip
# input = "939\n7,13,x,x,59,x,31,19"

timestamp, *bus_ids = *input.scan(/\d+/).map(&:to_i)

def calculate_part1(timestamp, bus_ids)
  (timestamp..).each do |time| 
    # Find bus ID we could take at this time, if possible
    bus_id = bus_ids.find { |id| time.divmod(id)[1].zero? } 

    return (time - timestamp) * bus_id unless bus_id.nil?
  end
end

input_part2 = input.split("\n")[1].split(",")

# Use Chinese Remainder Theorem
# See: https://www.dave4math.com/mathematics/chinese-remainder-theorem/
def calculate_part2(input_part2)
  # Parse out numbers into a list
  nums = []
  input_part2.each_with_index do |val, i|
    next unless val.match?(/\d+/)
    nums << {
      num: val.to_i, 
      offset: i
    }
  end

  # Perform calculations to find result (see link above)
  _N = nums.map { |val| val[:num] }.reduce(:*)
  
  x_result = nums.sum do |val| 
    # Note that our input numbers are all prime, so they are all relatively prime.
    n_i = val[:num] 
    a_i = -val[:offset]
    nbar_i = _N / n_i

    u_i = 1.upto(nbar_i).find { |u| (nbar_i * u).modulo(n_i) == 1 }

    a_i * nbar_i * u_i
  end

  x_result.modulo(_N)
end


part1 = calculate_part1(timestamp, bus_ids)
puts "Part 1: #{part1}" # 102


part2 = calculate_part2(input_part2)
puts "Part 2: #{part2}" # 327300950120029
