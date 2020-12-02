require 'pry'

input = IO.read('./input').strip.split("\n")

INPUT_LINE_REGEX = /(\d+)-(\d+) ([a-z]): ([a-z]+)/

PasswordEntry = Struct.new(:x, :y, :char, :password)

def parse_line(input_line)
  _, x, y, char, password = *input_line.match(INPUT_LINE_REGEX)

  PasswordEntry.new(x.to_i, y.to_i, char, password)
end

def password_valid_part1?(entry)
  num_chars = entry.password.chars.count { |c| c == entry.char }

  num_chars.between?(entry.x, entry.y)
end

password_entries = input.map { |line| parse_line(line) }

num_valid_passwords1 = password_entries.count { |entry| password_valid_part1?(entry) }
puts "Part 1: #{num_valid_passwords1} Valid Passwords" # 569


def password_valid_part2?(entry)
  c1 = entry.password[entry.x - 1]
  c2 = entry.password[entry.y - 1]

  [c1, c2].count { |c| c == entry.char } == 1
end

num_valid_passwords2 = password_entries.count { |entry| password_valid_part2?(entry) }
puts "Part 2: #{num_valid_passwords2} Valid Passwords" # 346
