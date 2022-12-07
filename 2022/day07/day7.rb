require 'pry'
require 'set'

input = IO.read('./input').strip.split("\n")
# input = IO.read('./input_small').strip.split("\n")

ElfFile = Struct.new(:name, :size)

class Directory
  attr_accessor :path, :children, :files

  def initialize(path)
    @path = path
    @children = Set.new
    @files = Set.new
  end

  # Size of all files and child directories
  def size
    @files.sum(&:size) + @children.sum(&:size)
  end
end

current_path = ""
directories = {}

input.each.with_index do |line, i|
  if line.start_with?("$")
    # new command
    _, command, arg = line.split

    case arg
    when "/" then
      current_path = "/"
    when ".." then 
      current_path = current_path.split("/")[...-1].join("/") + "/"
    when nil then
      # noop
    else
      current_path += "#{arg}/"
    end
    directories[current_path] = Directory.new(current_path) unless directories.key?(current_path)
    puts "current_path is now #{current_path}" unless arg.nil?
  else
    # list of directory contents
    if line.start_with?("dir")
      # directory
      _, dir = line.scan(/\w+/)
      target_path = "#{current_path}#{dir}/"
      directories[target_path] = Directory.new(target_path) unless directories.key?(target_path)

      directories[current_path].children << directories[target_path]
    else
      # file
      size, filename = line.split
      directories[current_path].files << ElfFile.new(filename, size.to_i)
    end
  end
end

part1 = directories.values.select { |directory| directory.path != "/" && directory.size <= 100000 }.sum(&:size)

# Part 2:
root_dir = directories["/"]
total_size = root_dir.size
free_space = 70000000 - total_size
# How much more space do we need to free up?
required_space = 30000000 - free_space

part2 = directories.values.sort_by(&:size).find { |dir| dir.size >= required_space }.size

puts "Part 1: #{part1}" # 1306611
puts "Part 2: #{part2}" # 13210366
