require 'pry'
require 'matrix'
require 'set'

input = IO.read('./input').strip.split("\n")
# input = IO.read('./input_small').strip.split("\n")

Point = Struct.new(:coord, :elevation)

# Top left is 0,0
LEFT = Vector[-1, 0]
RIGHT = Vector[1, 0]
UP = Vector[0, -1]
DOWN = Vector[0, 1]

class Grid
  def initialize(input)
    @points = {}
    @min_x = @min_y = @max_x = @max_y = 0
    input.each.with_index do |row, y|
      row.chars.each.with_index do |value, x|
        elevation = case value
        when 'S'
          @start_position = Vector[x, y]
          'a'
        when 'E'
          @target_position = Vector[x, y]
         'z'
        else value
        end

        @points[Vector[x, y]] = Point.new(Vector[x, y], elevation)
        @max_x = [@max_x, x].max
        @max_y = [@max_y, y].max
      end
    end
  end

  def find_shortest_path!
    find_shortest_path(@start_position, @target_position)
  end

  def find_shortest_path(start_pos, end_pos, current_path=[], visited=Set.new)
    puts "!! find_shortest_path(#{start_pos}, #{end_pos}, #{current_path.size}, #{visited.size})" if visited.size % 100 == 0
    # binding.pry
    visited = visited.dup

    # ???
    # return [] if visited.include?(start_pos)

    return current_path if start_pos == end_pos
    # return nil if current_path

    visited << start_pos

    reachable_neighbours = [
      start_pos + LEFT,
      start_pos + RIGHT,
      start_pos + UP,
      start_pos + DOWN,
    ].select { |neighbour| is_valid_coord?(neighbour) && !visited.include?(neighbour) && can_reach?(start_pos, neighbour) }

    # No path
    return nil if reachable_neighbours.empty?

    # binding.pry if visited.size > 100

    visited.merge(reachable_neighbours)
    reachable_neighbours.map do |neighbour|
      find_shortest_path(neighbour, end_pos, current_path.dup.push(neighbour), visited)
    end.compact.min_by { |path| path.size }
  end

  # Valid coord means in bounds of grid
  def is_valid_coord?(coord)
    coord[0] >= @min_x && coord[0] <= @max_x && coord[1] >= @min_y && coord[1] <= @max_y
  end

  def can_reach?(from_coord, to_coord)
    from_elevation = @points[from_coord].elevation
    to_elevation = @points[to_coord].elevation

    # Can only reach same or next elevation (e.g. from 'a' can reach 'a' or 'b')
    from_elevation == to_elevation || from_elevation.next == to_elevation
  end
end

grid = Grid.new(input)
shortest_path = grid.find_shortest_path!

part1 = shortest_path.size
part2 = 

puts "Part 1: #{part1}"
puts "Part 2: #{part2}"
