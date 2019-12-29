require 'pry'
require './intcode_day13'

input = IO.read('input')
program = Intcode::Helpers.parse_program(input)

Position = Struct.new(:x, :y)

class Game
  attr_accessor :tiles, :score

  TILES = {
    0 => :empty,
    1 => :wall,
    2 => :block,
    3 => :horiz_paddle,
    4 => :ball,
  }
  TILE_IDS = TILES.invert

  # Characters used to display each tile
  TILE_DISPLAY = {
    empty: ' ',
    wall: '█',
    block: '▩',
    horiz_paddle: '▂',
    ball: '●',
  }

  CLEAR_TERMINAL = "\e[H\e[2J"

  # Position given as output to indicate we are receiving a score.
  SCORE_POSITION = Position.new(-1, 0)

  # Positions and the input values we need to pass for each
  JOYSTICK_POSITIONS = {
    neutral: 0,
    left: -1,
    right: 1,
  }

  def initialize(program:, debug: false, quarters: nil, display: false)
    # For part 2
    program[0] = quarters unless quarters.nil?

    @computer = Intcode::Computer.new(
      program: program,
      # Pass joystick position as input when requested
      input_lambda: lambda { joystick_position },
      debug: debug
    )

    # Hash of tile positions to their type
    @tiles = Hash.new(:empty)

    # Game is initialized once we've drawn all initial tiles
    @game_initialized = false
    @score = nil

    # Store some key positions
    @ball_position = nil
    @paddle_position = nil

    # Display gameplay
    @display = display
  end

  def run
    while !@computer.terminated? do
      run_step
    end
  end

  # Run single
  def run_step
    x = @computer.run
    y = @computer.run
    tile_id_or_score = @computer.run
    return if x.nil? # program terminated

    position = Position.new(x, y)

    if position == SCORE_POSITION
      # Input is a score
      @score = tile_id_or_score

      # When we first receive a score, consider game initialized
      @game_initialized = true
    else
      # Input is tile ID
      tile = TILES[tile_id_or_score]
      @tiles[position] = tile

      @ball_position = position if tile == :ball
      @paddle_position = position if tile == :horiz_paddle
    end

    if @game_initialized && @display
      display
      sleep 0.01
    end
  end

  def joystick_position
    return JOYSTICK_POSITIONS[:neutral] if @paddle_position.nil? || @ball_position.nil?

    # Simple logic to move paddle towards ball depending on position
    if @paddle_position.x < @ball_position.x
      JOYSTICK_POSITIONS[:right]
    elsif @paddle_position.x > @ball_position.x
      JOYSTICK_POSITIONS[:left]
    else
      JOYSTICK_POSITIONS[:neutral]
    end
  end

  # Display the current game board
  def display
    puts CLEAR_TERMINAL
    minx = tiles.keys.map(&:x).min
    maxx = tiles.keys.map(&:x).max
    miny = tiles.keys.map(&:y).min
    maxy = tiles.keys.map(&:y).max

    miny.upto(maxy).each do |y|
      minx.upto(maxx).each do |x|
        pos = Position.new(x, y)
        print TILE_DISPLAY[@tiles[pos]]
      end
      print "\n"
    end

    score_padded = "Score: #{@score}".center(41)
    puts <<~STR
      ███████████████████████████████████████████
      ┌─────────────────────────────────────────┐
      │#{score_padded}│
      └─────────────────────────────────────────┘
    STR
  end
end

game1 = Game.new(program: program)
game1.run

part1 = game1.tiles.values.count(:block)
puts "Part 1: #{part1} block tiles" # 452

# Set display to true to see output.
game2 = Game.new(program: program, quarters: 2, display: false)
game2.run

puts "Part 2: Final Score: #{game2.score}" # 21415
