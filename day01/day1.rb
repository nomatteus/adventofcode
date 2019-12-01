input = IO.read('input')

nums = input.split("\n").map(&:to_i)

puts "Part 1:"
puts nums.sum { |n| (n / 3.0).floor - 2 }

def fuel(n)
  req = (n / 3.0).floor - 2
  if req <= 0
    return 0
  else
    return req + fuel(req)
  end
end

puts "Part 2:"
puts nums.sum { |n| fuel(n) }
