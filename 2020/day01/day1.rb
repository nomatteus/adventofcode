require 'pry'
require 'set'

input = IO.read('./input').strip.split.map(&:to_i)


def find_2020sum2(numbers)
  numbers_set = Set.new(numbers)

  numbers_set.each do |number|
    target = 2020 - number
    return number, target if numbers_set.include?(target)
  end
end

n1, n2 = find_2020sum2(input)
puts "Numbers found: #{n1} & #{n2}. Part 1: #{n1 * n2}" # 870331


def find_2020sum3(numbers)
  numbers_set = Set.new(numbers)

  # Generate combinations of 2 and check for existence of 3rd
  numbers.combination(2).each do |two_nums|
    sum = two_nums.sum
    next if sum > 2020

    target = 2020 - sum
    return target, *two_nums if numbers_set.include?(target)
  end
end


n1, n2, n3 = find_2020sum3(input)
puts "Numbers found: #{n1}, #{n2}, & #{n3}. Part 2: #{n1 * n2 * n3}" # 283025088
