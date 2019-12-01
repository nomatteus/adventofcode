require 'pry'

input = IO.read('./input').strip.split("\n")
# input = IO.read('./input_test').strip.split("\n")

programs = {}

input.each do |line|
  program_details, children = line.split(' -> ')
  children = children&.split(', ') || []
  program = program_details.split[0]
  weight = program_details.split[1][1..-2].to_i

  programs[program] = {
    weight: weight,
    children_names: children
  }
end

root_node_name = (programs.keys - programs.values.collect{ |v| v[:children_names] }.flatten).first
puts "Part 1: root node name is: #{root_node_name}"


class Tree
  attr_accessor :root_node

  def initialize(node_info)
    @node_info = node_info
  end

  def add_node(node_name, weight, parent, children_names)
    node = Node.new(node_name, weight, parent)
    @root_node = node if @root_node.nil?
    children_names.each do |child_name|
      info = @node_info[child_name]
      child_node = self.add_node(child_name, info[:weight], node, info[:children_names])
      node.add_child(child_node)
    end
    node
  end

  def find_unbalanced_sum
    result = get_unbalanced_child(root_node)

    # Answer is weight the heavy node would need to be to balance the tower
    result[:node].weight - result[:balanced_diff]
  end

  def get_unbalanced_child(node, balanced_diff=nil)
    # map a weight sum => child indices with that sum
    sums = {}
    node.children.each_with_index do |child, i|
      sums[child.weight_sum] ||= []
      sums[child.weight_sum] << i
    end

    weights = sums.group_by { |k, v| v.size == 1 ? :heavy : :balanced }
    balanced_weight = weights[:balanced][0][0]

    # Base case: there is no heavy child, so the current node is the unbalanced child
    return { node: node, balanced_diff: balanced_diff } if weights[:heavy].nil?

    index_heavy = weights[:heavy][0][1][0]
    balanced_diff = weights[:heavy][0][0] - balanced_weight
    get_unbalanced_child(node.children[index_heavy], balanced_diff)
  end
end

class Node
  attr_accessor :name, :weight, :parent, :children

  def initialize(name, weight, parent, children=[])
    @name = name
    @weight = weight
    @parent = parent
    @children = children
  end

  def add_child(child_node)
    @children << child_node
  end

  def weight_sum
    @weight + children.sum(&:weight_sum)
  end
end

tree = Tree.new(programs)
root_node = tree.add_node(root_node_name, programs[root_node_name][:weight], nil, programs[root_node_name][:children_names])
part2 = tree.find_unbalanced_sum

puts "Part 2: sum of node should be #{part2}"


