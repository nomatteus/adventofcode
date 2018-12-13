require 'set'
require 'pry'

# Note that it is important to preserve whitespace on input (i.e. be careful about "trim trailing spaces on save option")
input = IO.read('./input').strip.split("\n")
# input = IO.read('./input_small').strip.split("\n")

# Reading in the data into our Grid/Cart classes
CARTS = ['<', '>', '^', 'v'].to_set
DIRECTIONS_MAP = {
  '<' => :left,
  '>' => :right,
  '^' => :up,
  'v' => :down
}
DIRECTION_TO_CART_MAP = DIRECTIONS_MAP.invert

class Cart
  include Comparable

  attr_accessor :x, :y

  def initialize(x, y, dir)
    @x = x
    @y = y
    # Defines which direction we turn when hitting an intersection. Cycle through options continuously.
    @intersection_turn = [:left, :straight, :right].cycle
    @current_dir = dir
  end

  # Pass in a reference to the current grid, so we can know what's next
  def tick(grid)
    # First, get our current grid position char
    current_char = grid[@y][@x]
    case current_char
    when '/', '\\'
      turn_corner(current_char)
      move_straight
    when '+'
      turn(@intersection_turn.next)
      move_straight
    # when ' ' then raise "You're off track! Something went horribly wrong..."
    else 
      # For '|' or '-' we just move straight along
      move_straight
    end
  end

  def to_s
    DIRECTION_TO_CART_MAP[@current_dir]
  end

  def <=>(other_cart)
    [@x, @y] <=> [other_cart.x, other_cart.y]
  end

private 
  
  # Move in a straight direction, depending on @current_dir
  def move_straight
    case @current_dir
    when :left  then @x -= 1
    when :right then @x += 1
    when :up    then @y -= 1
    when :down  then @y += 1
    end
  end

  # We hit a corner, which is \ or /. We will figure out which way to turn,
  # dependent on our current direction.
  # Rules:
  #   for '/' char:
  #     if direction is left or right, turn left
  #     if direction is up or down, turn right
  #   for '\' char:
  #     if direction is left or right, turn right
  #     if direction is up or down, turn left
  def turn_corner(corner_char)
    case corner_char
    when '/'
      if @current_dir == :left || @current_dir == :right
        turn(:left)
      else
        turn(:right)
      end
    when '\\'
      if @current_dir == :left || @current_dir == :right
        turn(:right)
      else
        turn(:left)
      end
    else
      raise "No corner here. Are you living on the edge?"
    end
  end

  # Turn directions given the turn type: :left, :straight (no turn), or :right
  # For left and right turns, follow this turntable :P
  #  char  current dir  |   turn   |  new dir
  # --------------------|----------|----------
  #   >      right      |   left   |    up
  #   <      left       |   right  |    up
  #   >      right      |   right  |   down
  #   <      left       |   left   |   down
  #   ^       up        |   right  |   right
  #   v      down       |   left   |   right
  #   ^       up        |   left   |   left
  #   v      down       |   right  |   left
  def turn(turn_dir)
    return if turn_dir == :straight
    if @current_dir == :right && turn_dir == :left || @current_dir == :left && turn_dir == :right
      @current_dir = :up
    elsif @current_dir == :right && turn_dir == :right || @current_dir == :left && turn_dir == :left
      @current_dir = :down
    elsif @current_dir == :up && turn_dir == :right || @current_dir == :down && turn_dir == :left
      @current_dir = :right
    elsif @current_dir == :up && turn_dir == :left || @current_dir == :down && turn_dir == :right
      @current_dir = :left
    else
      binding.pry
      raise "You took a wrong turn..."
    end
  end
end

class Track
  def initialize(num_rows, num_cols)
    @grid = Array.new(num_cols) { Array.new(num_rows) { ' ' } } 
    @carts = []
  end

  # Set value at a specific position. Used when initializing grid
  def set_val(x, y, val)
    @grid[y][x] = val
  end

  def add_cart(x, y, current_dir)
    @carts << Cart.new(x, y, current_dir)
  end

  # Will return [nil, nil] unless there is a crash at any moment, in which
  # case it returns the position of the first crash
  def tick
    # We must process cart movements from top row first, left to right
    # Then, after each cart movement, we check for a crash at that instant
    @carts.sort.each do |cart|
      cart.tick(@grid)
      crash = crash_pos
      return crash unless crash.nil?
    end
    [nil, nil]
  end

  # Create a string with carts on it for output only (do not modify grid)
  def to_s
    output = Array.new(@grid.first.size) { Array.new(@grid.size) { ' ' } } 
    positions_cart_map = Hash.new(nil)
    @carts.each do |cart|
      # Assume no crash (we check that elsewhere)
      positions_cart_map[[cart.x, cart.y]] = cart
    end

    @grid.each_with_index do |row, y|
      row.each_with_index do |val, x|
        if positions_cart_map.key?([x, y])
          output[y][x] = positions_cart_map[[x, y]].to_s
        else
          output[y][x] = @grid[y][x]
        end
      end
    end
    output.collect(&:join).join("\n")
  end

private

  # If there is a crash, will return 2-element array with coordinates.
  # If no crash, returns nil
  def crash_pos
    cart_coords = Set.new
    @carts.each do |cart|
      coords = [cart.x, cart.y]
      if cart_coords.include? coords
        return coords
      else
        cart_coords << coords
      end
    end
    # No crash
    nil
  end
end

num_rows = input.size
num_cols = input.first.size
track = Track.new(num_rows, num_cols)

input.each_with_index do |row, y|
  row.chars.each_with_index do |val, x|
    if CARTS.include?(val)
      track.add_cart(x, y, DIRECTIONS_MAP[val])
      # Not strictly necessary, but to keep it clean, replace the cart with correct character on our track
      # Note that after reading input, we will not use cart characters at all, instead we will just track
      # their positions.
      val = '|' if ['^', 'v'].include?(val)
      val = '-' if ['<', '>'].include?(val)
    end

    track.set_val(x, y, val)
  end
end

crashx = nil
crashy = nil

loop do 
  crashx, crashy = track.tick
  # Check for a crash
  break unless crashx.nil? && crashy.nil?
end

puts "Part 1: Crashed at #{crashx},#{crashy}" # 71,121
puts "Part 2: #{}"

