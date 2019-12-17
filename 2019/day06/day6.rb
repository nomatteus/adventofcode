require 'set'

class Node
  attr_reader :id
  attr_accessor :children, :parent

  def initialize(id:, parent: nil)
    @id = id
    @children = Set.new
    @parent = parent
  end
end

input_file = 'input'
lines = IO.read(input_file).strip.split("\n").map { |l| l.split(")") }

# Store reference to our nodes by id
nodes_by_id = {}
# Track seen children nodes to help identify root node
all_nodes = Set.new
children_nodes = Set.new

lines.each do |line|
  # object with id2 orbits id1.
  # id1 -> id2 (id2 is a child of id1)
  id1, id2 = line
  node1 = nodes_by_id[id1] ||= Node.new(id: id1)
  node2 = nodes_by_id[id2] ||= Node.new(id: id2)

  node1.children << node2
  node2.parent = node1

  children_nodes << node2
  all_nodes << node1 << node2
end

root_node = (all_nodes - children_nodes).first

# Cache node depths
@node_depths = {}

def depth(node)
  return 0 if node.parent.nil?

  if !@node_depths.key?(node)
    @node_depths[node] = 1 + depth(node.parent)
  end

  @node_depths[node]
end

part1 = all_nodes.to_a.sum { |n| depth(n) }

puts "Part 1: #{part1}" # 270768

# PART 2

# Idea: Find the first common anscestor node, and then
# calculate distance using the depth:
# depth(you_node.parent) + depth(san_node.parent) - 2 * depth(common_ancestor_node)

you_node = all_nodes.find { |n| n.id == "YOU" }
san_node = all_nodes.find { |n| n.id == "SAN" }

def anscestors(node, current_level=0)
  return [] if node.parent.nil?

  [node.parent] + anscestors(node.parent)
end

# Reverse to make it easier to find the first common ancestor
you_anscestors = anscestors(you_node).reverse
san_anscestors = anscestors(san_node).reverse

first_common_ancestor_found = false
i = 0
latest_match = nil

while !first_common_ancestor_found
  if you_anscestors[i] == san_anscestors[i]
    latest_match = you_anscestors[i]
  else
    # latest_match will be first common ancestor
    first_common_ancestor_found = true
  end

  i += 1
end

first_common_ancestor = latest_match

part2 = depth(you_node.parent) + depth(san_node.parent) - 2 * depth(first_common_ancestor)
puts "Part 2: #{part2}"
