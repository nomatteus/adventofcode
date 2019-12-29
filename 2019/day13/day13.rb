require 'pry'
# Day 9 Intcode works as-is for this problem, so use that
require_relative '../day09/intcode_day9'

input = IO.read('input')
program = Intcode::Helpers.parse_program(input)

Position = Struct.new(:x, :y)

class Game
  attr_accessor :tiles

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

  def initialize(program:, debug: false)
    @computer = Intcode::Computer.new(program: program, input: [], debug: debug)

    # Hash of tile positions to their type
    @tiles = Hash.new(:empty)

    @score = 0
  end

  def run
    while !@computer.terminated? do
      x = @computer.run
      y = @computer.run
      tile_id = @computer.run
      break if x.nil? # program terminated

      position = Position.new(x, y)
      @tiles[position] = TILES[tile_id]
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

game = Game.new(program: program)
game.run

part1 = game.tiles.values.count(:block)
puts "Part 1: #{part1} block tiles" # 452

game.display
