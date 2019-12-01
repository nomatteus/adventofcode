require 'set'

frequency_changes = IO.read('./input').strip.split("\n").map(&:to_i)

part1 = frequency_changes.sum
puts "Part 1: #{part1}"


freq = 0
frequencies_seen = Set.new
duplicate_freq = nil

frequency_changes.cycle do |change|
  freq += change

  if frequencies_seen.include?(freq)
    duplicate_freq = freq
    break
  else
    frequencies_seen << freq
  end
end

puts "Part 2: #{duplicate_freq}"
