# Move to its own file, so we can re-use these classes for day 14
LIST_MAX = 255
NUM_ELEMENTS = LIST_MAX + 1

class SparseHash
  def initialize(bytes)
    @bytes = bytes
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
    @bytes.each do |byte|
      # Integer division to figure out how many swaps we need to perform
      num_swaps = byte / 2

      # One pointer at beginning of list, and one at the end, to perform our swaps
      p_start = @current_pos
      p_end = (p_start + byte - 1) % NUM_ELEMENTS

      # Will perform swaps in-place
      num_swaps.times do
        tmp_start = @circle[p_start]
        @circle[p_start] = @circle[p_end]
        @circle[p_end] = tmp_start

        # (Inc|Dec)rement pointers
        p_start = (p_start + 1) % NUM_ELEMENTS
        p_end = (p_end - 1) % NUM_ELEMENTS
      end

      @current_pos = (@current_pos + byte + @skip_size) % NUM_ELEMENTS
      @skip_size += 1
    end

    @circle
  end
end

class DenseHash
  def initialize(string)
    hash_input = string.chars.map(&:ord)
    # Extra lengths as defined by problem
    hash_input += [17, 31, 73, 47, 23]

    @sparse_hash = SparseHash.new(hash_input).hash(64)
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
