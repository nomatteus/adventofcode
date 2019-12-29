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

  def initialize(program:, debug: false)
    @computer = Intcode::Computer.new(program: program, input: [], debug: debug)

    # Hash of tile positions to their type
    @tiles = Hash.new(:empty)
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
end

game = Game.new(program: program)
game.run

part1 = game.tiles.values.count(:block)
puts "Part 1: #{part1} block tiles" # 452
