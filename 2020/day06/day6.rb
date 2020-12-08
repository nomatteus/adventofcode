require 'set'
require 'pry'

input = IO.read('./input').strip.split("\n\n")

part1 = input.map { |answers| answers.tr("\n", "").chars.to_set.size }.sum
puts "Part 1: #{part1}" # 6549

part2 = input.map { |answers| answers.split.map(&:chars).map(&:to_set).reduce(:&).size }.sum
puts "Part 2: #{part2}" # 3466
