require 'set'
require 'pry'

input = IO.read('./input').strip
# Small test cases given in problem
# input = '9 players; last marble is worth 25 points' # 32
# input = '10 players; last marble is worth 1618 points' # 8317
# input = '13 players; last marble is worth 7999 points' # 146373
# input = '17 players; last marble is worth 1104 points' # 2764
# input = '21 players; last marble is worth 6111 points' # 54718
# input = '30 players; last marble is worth 5807 points' # 37305

num_players, last_marble = input.scan(/\d+/).map(&:to_i)

# We will use a doubly-linked list for our marbles
class Marble
  attr_accessor :prev, :next, :value

  def initialize(value)
    @value = value
  end
end

class MarbleGame
  attr_accessor :scores

  def initialize(num_players, last_marble)
    @player_order = (1..num_players).cycle
    @current_player = nil
    @scores = Hash.new(0)
    @last_marble = last_marble
    initialize_game_state!
  end

  # Play game until last marble
  def play!
    1.upto(@last_marble).each do |value|
      @current_player = @player_order.next
      if should_score?(value)
        score!(value)
      else
        insert_marble(value)
      end
      # puts self
    end
  end

  # Mimick output format used in the problem description
  def to_s
    output = ["[#{@current_player.nil?? '-' : @current_player}] "]
    output << (@first_marble == @current_marble ? "(#{@first_marble.value})" : " #{@first_marble.value} ")
    # Loop through rest until we get back to first marble
    cur = @first_marble.next
    while cur != @first_marble
      output << (cur == @current_marble ? "(#{cur.value})" : " #{cur.value} ")
      cur = cur.next
    end
    output.join
  end

private

  # Process scoring rules for this player:
  #  - Add value of current marble to player's score
  #  - Remove marble 7 counterclockwise to current marble, and add to score
  #  - Set current marble to the one to the right (clockwise) of the above
  def score!(value)
    # Add value of current marble to player's score
    @scores[@current_player] += value

    marble_remove = @current_marble.prev.prev.prev.prev.prev.prev.prev # lol
    @scores[@current_player] += marble_remove.value

    @current_marble = marble_remove.next
    # Modify pointers to skip over the marble we are removing
    marble_remove.prev.next = marble_remove.next
    marble_remove.next.prev = marble_remove.prev
  end

  # Insert marble after current marble
  # Also makes this new marble the new current marble
  def insert_marble(value)
    marble = Marble.new(value)

    clockwise1 = @current_marble.next
    clockwise2 = @current_marble.next.next

    marble.prev = clockwise1
    marble.next = clockwise2

    clockwise1.next = marble
    clockwise2.prev = marble

    @current_marble = marble
  end

  def should_score?(value)
    value % 23 == 0
  end

  def initialize_game_state!
    # ivar for to_s output purpoases
    @first_marble = Marble.new(0)
    @first_marble.next = @first_marble
    @first_marble.prev = @first_marble
    @current_marble = @first_marble
  end

end

game = MarbleGame.new(num_players, last_marble)
game.play!
part1 = game.scores.values.max
puts "Part 1: #{part1}" # 361466


game2 = MarbleGame.new(num_players, last_marble * 100)
game2.play!
part2 = game2.scores.values.max

puts "Part 2: #{part2}" # 2945918550
