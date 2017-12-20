require_relative './hashes'

# ========== PART 1 ==========
lengths_part1 = IO.read('./input').strip.split(',').map(&:to_i)
hash_p1 = SparseHash.new(lengths_part1).hash
result_p1 = hash_p1[0] * hash_p1[1]
puts "Part 1: #{result_p1}"

# ========== PART 2 ==========

hash_input_string = IO.read('./input').strip
dense_hash_p2 = DenseHash.new(hash_input_string).hash

puts "Part 2: #{dense_hash_p2}"

