require 'pry'

input = IO.read('./input').strip.split("\n")

# Create empty 1000x1000 grid of lights
lights = Array.new(1000)
lights.each_with_index { |_, i| lights[i] = Array.new(1000, 0) }

input.each do |line|
  operation = line.match(/(on|off|toggle)/)[1]
  from_x, from_y, to_x, to_y = line.scan(/\d+/).map(&:to_i)

  for x in (from_x..to_x) do
    for y in (from_y..to_y) do
      lights[x][y] = case operation
        when 'on'     then 1
        when 'off'    then 0
        when 'toggle' then lights[x][y] ^ 1
        end
    end
  end
end

part1_lights_on = lights.sum { |ls| ls.count { |l| l ==1 } }
puts "Part 1: #{part1_lights_on}" # 30521

############################################################### Part 2
# Copy pasta from part 1, but with values changed.

# Create empty 1000x1000 grid of lights
lights = Array.new(1000)
lights.each_with_index { |_, i| lights[i] = Array.new(1000, 0) }

input.each do |line|
  operation = line.match(/(on|off|toggle)/)[1]
  from_x, from_y, to_x, to_y = line.scan(/\d+/).map(&:to_i)

  for x in (from_x..to_x) do
    for y in (from_y..to_y) do
      lights[x][y] = case operation
        when 'on'     then lights[x][y] + 1
        when 'off'    then [lights[x][y] - 1, 0].max
        when 'toggle' then lights[x][y] + 2
        end
    end
  end
end

part2_brightness = lights.sum(&:sum)
puts "Part 2: #{part2_brightness}" # 14110788
