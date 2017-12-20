require 'pry'
require_relative '../day10/hashes'

input = "xlqgujun"
# input = "flqrgnkx" #test

grid = []

0.upto(127).each do |row|
  hash_input = "#{input}-#{row}"
  dense_hash = DenseHash.new(hash_input).hash
  hash_bits = dense_hash.chars.map{ |c| c.to_i(16) }.map{ |o| o.to_s(2).rjust(4, '0') }.join
  grid << hash_bits
end

part1 = grid.flatten.join.chars.select { |c| c == '1' }.size

puts "Part 1: #{part1} squares used"
