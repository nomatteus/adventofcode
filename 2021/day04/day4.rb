require 'pry'
require 'matrix'

input = IO.read('./input').strip
#input = IO.read('./input_small').strip

class Bingo
  # cards is an array of Card objects
  # chosen_nums is the list of numbers to be called
  def initialize(cards, chosen_nums)
    @cards = cards
    # Store in reverse so we can pop off the end
    @chosen_nums = chosen_nums.reverse
  end

  def play!
    # (We assume there's always a winner)
    winner_found = false
    until winner_found do 
      # Choose next num
      num = @chosen_nums.pop

      @cards.map { |card| card.mark!(num) }

      winning_card = @cards.find(&:bingo?)
      winner_found = true if !winning_card.nil?
    end

    # Return winning card score as result
    winning_card.winning_score(num)
  end

  def play_part2!
    # Run all chosen nums to find the last winner
    last_winner = nil
    winner_num = nil
    until @chosen_nums.empty? do 
      # Choose next num
      num = @chosen_nums.pop

      @cards.map { |card| card.mark!(num) }

      winning_cards = @cards.select(&:bingo?)
      unless winning_cards.empty?
        last_winners = winning_cards
        winner_num = num
        # Remove card from list so it's no longer marked
        @cards = @cards - winning_cards
      end
    end

    raise "ended with > 1 winning cards" if last_winners.size > 1

    # Return winning card score as result
    last_winners.first.winning_score(winner_num)
  end
end

class Card
  attr_reader :card_data

  # input is a 2d array representation of cards
  def initialize(card_array)
    @card_array = card_array  
    # Store a hash of card num => data (assuming no numbers can repeat)
    @card_data = {}
    @card_array.each_with_index do |row, i|
      row.each_with_index do |val, j|
        @card_data[val] = {
          pos: [i, j], # row, col
          marked: false,
        }
      end
    end
    # map of position to number
    # e.g. [0, 0] => 123
    @pos_to_num = @card_data.transform_values { |c| c[:pos] }.invert
  end

  # Called to mark a number, if it exists on the card
  def mark!(num)
    return unless @card_data.key?(num)

    @card_data[num][:marked] = true 
  end

  # Does this card have a bingo? (i.e. a winning card?)
  def bingo?
    # Assuming always 5x5 card
    # Check rows
    0.upto(4).each do |row|
      row_coords = ([row]*5).zip(0..4)
      return true if row_coords.all? { |pos| @card_data[@pos_to_num[pos]][:marked] } 
    end
    # cols
    0.upto(4).each do |col|
      col_coords = (0..4).to_a.zip([col] * 5)
      return true if col_coords.all? { |pos| @card_data[@pos_to_num[pos]][:marked] } 
    end
    false
  end

  # Calculate the winning score (sum of all unmarked number, multiplied by the 
  # number just called, i.e. called_num)
  def winning_score(called_num)
    sum_unmarked = @card_data.reject { |num, data| data[:marked] }.sum { |num, data| num }
    sum_unmarked * called_num
  end
end

# Input parsing
nums_input, *cards_input = input.split("\n\n")
chosen_nums = nums_input.split(",").map(&:to_i)
card_arrays = cards_input.map do |card_input|
  card_input.split("\n").map { |c| c.scan(/\d+/).map(&:to_i) }
end


cards1 = card_arrays.map { |ca| Card.new(ca) }
game1 = Bingo.new(cards1, chosen_nums)
part1 = game1.play!

puts "Part 1: #{part1}" # 44736


# Part 2

cards2 = card_arrays.map { |ca| Card.new(ca) }
game2 = Bingo.new(cards2, chosen_nums)
part2 = game2.play_part2! 

puts "Part 2: #{part2}" # 1827
