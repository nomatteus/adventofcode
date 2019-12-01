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

class RegionFinder
  def initialize(grid)
    @grid = grid
    @next_region = 1
  end

  def find_regions
    # We need to track all visited squares and which region they belong to
    @visited = {}

    # We will iterate through every element, however will do a DFS to find each
    # contiguous area so only do that for squares we haven't visited yet
    @grid.each_with_index do |row, i|
      row.each_with_index do |val, j|
        visit(i, j)
      end
    end

    # Return the number of regions found
    @visited.values.compact.max
  end

private

  def next_region_number
    region_num = @next_region
    @next_region += 1
    region_num
  end

  def visited?(i, j)
    @visited.has_key?([i, j])
  end

  # Check adjacent squares to see if this square is connected to an existing region
  # Returns a region number, or nil if no region found
  def existing_region(i, j)
    @visited[[i-1, j]] || @visited[[i+1, j]] || @visited[[i, j-1]] || @visited[[i, j+1]]
  end

  def visit(i, j)
    # Base case: Already visited
    return if visited?(i, j)
    # Out of bounds
    return if i < 0 || j < 0 || i >= @grid.size || j >= @grid.first.size

    val = @grid[i][j]
    key = [i, j]
    if val == 1
      region = existing_region(i, j) || next_region_number
      @visited[key] = region

      # Visit adjacent regions
      visit(i+1, j)
      visit(i-1, j)
      visit(i, j+1)
      visit(i, j-1)
    else
      # Val is 0, so mark as visited but no region.
      @visited[key] = nil
    end
  end
end

# Convert to array of 0s and 1s
grid_array = grid.map{ |r| r.chars.map(&:to_i) }

region_finder = RegionFinder.new(grid_array)
num_regions = region_finder.find_regions

puts "Part 2: #{num_regions} regions"

