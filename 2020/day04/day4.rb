require 'pry'

input = IO.read('./input').strip.split("\n\n")

def has_required_fields?(p)
  ['byr', 'iyr', 'eyr', 'hgt', 'hcl', 'ecl', 'pid'].all? { |str| p.include?("#{str}:") }
end

part1 = input.count { |passport_input| has_required_fields?(passport_input) }
puts "Part 1: #{part1}" # 256

########################################## Part 2

# Validation Rules:
# byr (Birth Year) - four digits; at least 1920 and at most 2002.
# iyr (Issue Year) - four digits; at least 2010 and at most 2020.
# eyr (Expiration Year) - four digits; at least 2020 and at most 2030.
# hgt (Height) - a number followed by either cm or in:
# If cm, the number must be at least 150 and at most 193.
# If in, the number must be at least 59 and at most 76.
# hcl (Hair Color) - a # followed by exactly six characters 0-9 or a-f.
# ecl (Eye Color) - exactly one of: amb blu brn gry grn hzl oth.
# pid (Passport ID) - a nine-digit number, including leading zeroes.
# cid (Country ID) - ignored, missing or not.

def passport_valid?(passport_input)
  return false unless has_required_fields?(passport_input)

  field_inputs = passport_input.split

  field_inputs.all? do |field_input|
    code, value = field_input.split(':')
    case code
    when 'byr'
      value.to_i.between?(1920, 2002)
    when 'iyr'
      value.to_i.between?(2010, 2020)
    when 'eyr'
      value.to_i.between?(2020, 2030)
    when 'hgt'
      unit = value[-2..]
      num = value[0...-2].to_i
      ["cm", "in"].include?(unit) && unit == "cm" ? num.between?(150, 193) : num.between?(59, 76)
    when 'hcl'
      /^#[0-9a-f]{6}$/.match?(value)
    when 'ecl'
      ['amb', 'blu', 'brn', 'gry', 'grn', 'hzl', 'oth'].include?(value)
    when 'pid'
      /^[0-9]{9}$/.match?(value)
    when 'cid'
      true
    else 
      raise "invalid code"
    end
  end
end

part2 = input.count { |passport_input| passport_valid?(passport_input) }
puts "Part 2: #{part2}" # 198
