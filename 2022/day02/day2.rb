require 'pry'

pairs = IO.read('./input').strip.split("\n").map { |line| line.split(' ') }

PLAY_MAP = {
  "A" => :rock,
  "B" => :paper,
  "C" => :scissors,
  "X" => :rock,
  "Y" => :paper,
  "Z" => :scissors,
}

WIN_MAP = {
  rock: :paper,
  paper: :scissors,
  scissors: :rock,
}
LOSE_MAP = WIN_MAP.invert
SHAPE_SCORE = { rock: 1, paper: 2, scissors: 3 }

def calculate_score(shapes)
  shapes.map do |opponent_shape, my_shape|
    score = SHAPE_SCORE[my_shape]
    score += if my_shape == WIN_MAP[opponent_shape] 
      6
    elsif my_shape == opponent_shape
      3
    else
      0
    end
  end
end

shapes_part1 = pairs.map do |opponent, me|
  [PLAY_MAP[opponent], PLAY_MAP[me]]
end

RESULT_MAP = {
  "X" => :lose,
  "Y" => :draw,
  "Z" => :win,
}

shapes_part2 = pairs.map do |opponent, me|
  opponent_shape = PLAY_MAP[opponent]
  result = RESULT_MAP[me]

  my_shape = if result == :draw
    opponent_shape
  elsif result == :win
    WIN_MAP[opponent_shape]
  else
    LOSE_MAP[opponent_shape]
  end

  [opponent_shape, my_shape]
end

part1 = calculate_score(shapes_part1).sum
part2 = calculate_score(shapes_part2).sum

puts "Part 1: #{part1}" # 12156
puts "Part 2: #{part2}" # 10835
