LIST_MAX = 255
NUM_ELEMENTS = LIST_MAX + 1

class SparseHash
  def initialize(lengths)
    @lengths = lengths
    @circle = 0.upto(LIST_MAX).to_a
    @current_pos = 0
    @skip_size = 0
  end

  def hash(num_rounds=1)
    num_rounds.times { execute_hash_round }
    @circle
  end

private

  def execute_hash_round
    @lengths.each do |length|
      # Integer division to figure out how many swaps we need to perform
      num_swaps = length / 2

      # One pointer at beginning of list, and one at the end, to perform our swaps
      p_start = @current_pos
      p_end = (p_start + length - 1) % NUM_ELEMENTS

      # Will perform swaps in-place
      num_swaps.times do
        tmp_start = @circle[p_start]
        @circle[p_start] = @circle[p_end]
        @circle[p_end] = tmp_start

        # (Inc|Dec)rement pointers
        p_start = (p_start + 1) % NUM_ELEMENTS
        p_end = (p_end - 1) % NUM_ELEMENTS
      end

      @current_pos = (@current_pos + length + @skip_size) % NUM_ELEMENTS
      @skip_size += 1
    end

    @circle
  end
end

class DenseHash
  def initialize(sparse_hash)
    @sparse_hash = sparse_hash
  end

  def hash
    # Run the hash function to determine the hash bytes
    hash_bytes = []
    (0..LIST_MAX).step(16).each do |group_start|
      group = @sparse_hash.slice(group_start, 16)
      hash_bytes << group.reduce(:^)
    end

    # Convert to hex for output
    hash_bytes.map { |byte| byte.to_s(16).rjust(2, '0') }.join
  end
end

# ========== PART 1 ==========
lengths_part1 = IO.read('./input').strip.split(',').map(&:to_i)
hash_p1 = SparseHash.new(lengths_part1).hash
result_p1 = hash_p1[0] * hash_p1[1]
puts "Part 1: #{result_p1}"

# ========== PART 2 ==========

lengths_part2 = IO.read('./input').strip.chars.map(&:ord)
# Add the extra lengths as defined by the problem
lengths_part2 += [17, 31, 73, 47, 23]

sparse_hash_p2 = SparseHash.new(lengths_part2).hash(64)
dense_hash_p2 = DenseHash.new(sparse_hash_p2).hash

puts "Part 2: #{dense_hash_p2}"

