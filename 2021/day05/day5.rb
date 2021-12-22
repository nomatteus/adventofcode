require 'pry'
require 'matrix'

input = IO.read('./input').strip.split("\n")
# input = IO.read('./input_small').strip.split("\n")

Point = Struct.new(:x, :y)
Line = Struct.new(:p1, :p2)

# Input parsing
lines = input.map do |line| 
  p1, p2 = line.split(" -> ").map do |coord| 
    x, y = coord.split(",").map(&:to_i)
    Point.new(x, y)
  end
  Line.new(p1, p2)
end

# Given lines with beginning/end points, calculate the rest of the points on the lines
def calculate_points(lines)
  points = lines.map do |line|
    if line.p1.x == line.p2.x
      ys = Range.new(*[line.p1.y, line.p2.y].sort).to_a
      xs = [line.p1.x] * ys.size
    elsif line.p1.y == line.p2.y
      xs = Range.new(*[line.p1.x, line.p2.x].sort).to_a
      ys = [line.p1.y] * xs.size
    else
      # Diagonal line
      # Sort by x axis
      p1, p2 = [line.p1, line.p2].sort_by(&:x)
      xs = Range.new(*[p1.x, p2.x]).to_a
      if p1.y > p2.y 
        # negative slope (reverse so we can still use range)
        ys = Range.new(*[p2.y, p1.y]).to_a.reverse
      else
        # positive slope
        ys = Range.new(*[p1.y, p2.y]).to_a
      end
    end
    xs.zip(ys).map { |c| Point.new(*c) }
  end
end

# Part 1 (horizontal/vertical only)
lines_part1 = lines.select { |l| l.p1.x == l.p2.x || l.p1.y == l.p2.y }
points_part1 = calculate_points(lines_part1)
part1 = points_part1.flatten.tally.count { |point, count| count >= 2 }

puts "Part 1: #{part1}" # 6461

# Part 2 (incl. diagonal lines)
points_part2 = calculate_points(lines)
part2 = points_part2.flatten.tally.count { |point, count| count >= 2 }

puts "Part 2: #{part2}" # 18065
