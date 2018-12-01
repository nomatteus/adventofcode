require 'pry'
require 'set'

frequency_changes = IO.read('./input').strip.split("\n").map(&:to_i)

part1 = frequency_changes.sum

puts "Part 1: #{part1}"

freq = 0
i = 0
duplicate_found = false
frequencies_seen = Set.new

while !duplicate_found do
  change = frequency_changes[i]
  freq += change

  if frequencies_seen.include? freq
    duplicate_found = true
    duplicate_freq = freq
  else
    frequencies_seen << freq
  end

  i = (i + 1) % frequency_changes.size
end

puts "Part 2: #{duplicate_freq}"
