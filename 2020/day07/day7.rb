require 'set'
require 'ruby-graphviz'
require 'pry'

input = IO.read('./input').strip.split("\n")
# input = IO.read('./input_small').strip.split("\n")
# input = IO.read('./input_small2').strip.split("\n")

Edge = Struct.new(:weight, :node)
Bag = Struct.new(:num, :color)

class Node 
  attr_accessor :color, :edges

  def initialize(color)
    self.color = color
    self.edges = []
  end

  def ==(other)
    color == other.color && edges == other.edges
  end
end

class HandyHaversacks
  SHINY_GOLD = "shiny gold"

  def initialize(rules)
    @nodes_by_color = {}

    initialize_graph!(rules)
  end

  # Part 1: How many nodes can eventually contain a shiny gold bag?
  # General approach: For each node, try to find a path to the shiny gold
  # node. If path found, all nodes along that path can read shiny gold. 
  # Continue until all nodes checked.
  def shiny_gold_reachable_nodes
    # Init
    unvisited_nodes = @nodes_by_color.values
    # Nodes that can reach shiny gold node
    gold_reachable_nodes = Set.new

    until unvisited_nodes.empty?
      next_node = unvisited_nodes.pop

      # Can we find shiny gold?
      path = shiny_gold_path(next_node)

      # Cannot reach or at shiny gold. Try next node
      next if path.empty?

      # We can reach gold! Mark nodes in path as shiny gold reachable
      path.each do |node|
        # Shiny gold bag cannot contain itself
        next if is_shiny_gold_node?(node)

        gold_reachable_nodes << node

        # Mark as visited
        unvisited_nodes.delete(node)
      end
    end

    gold_reachable_nodes
  end

  # Return the nodes that form a path from the from_node to the shiny gold node,
  # if possible. If no path exists, return nil.
  def shiny_gold_path(from_node, current_path=[])
    # At the shiny gold node!
    return current_path + [from_node] if is_shiny_gold_node?(from_node)
    
    # No shiny gold, and no more edges
    return [] if from_node.edges.empty?

    # Search and return valid path if possible
    valid_path = from_node.edges
      .map { |edge| shiny_gold_path(edge.node, current_path) }
      .reject { |path| path.empty? }
      .first

    return [] if valid_path.nil?

    current_path + [from_node] + valid_path
  end

  def is_shiny_gold_node?(node)
    node.color == SHINY_GOLD
  end

  def num_bags_inside_shiny_gold_node
    shiny_gold_node = @nodes_by_color[SHINY_GOLD]

    # Subtract 1 as we don't count the shiny gold bag itself
    num_bags_in_node(shiny_gold_node) - 1
  end

  def num_bags_in_node(node)
    1 + node.edges.sum do |edge|
      edge.weight * num_bags_in_node(edge.node)
    end
  end

  # Try using GraphViz to generate an image of our graph
  # This isn't really too useful, especially for large input...
  def generate_graph_image(filename)
    # Create a new graph
    g = GraphViz.new( :G, :type => :digraph )

    # Create nodes
    graphviz_nodes = {}
    @nodes_by_color.each do |color, node| 
      graphviz_nodes[color] = g.add_nodes(color) 
    end

    # Add edges
    @nodes_by_color.each do |color, node| 
      from_gnode = graphviz_nodes[color]
      node.edges.each do |edge|
        to_gnode = graphviz_nodes[edge.node.color]

        edge_attrs = { weight: edge.weight, label: edge.weight }.compact

        g.add_edges(from_gnode, to_gnode, edge_attrs)
      end
    end

    # Generate output image
    g.output(png: filename)
  end

  private

  # Build our nodes & connect with edges based on the input.
  def initialize_graph!(rules)
    rules.each do |rule|
      bag, linked_bags = rule

      node = find_or_create_node(bag.color)

      edges = linked_bags.map do |linked_bag|
        linked_node = find_or_create_node(linked_bag.color)

        Edge.new(linked_bag.num, linked_node)
      end

      node.edges += edges

      @nodes_by_color[bag.color] = node
    end
  end

  def find_or_create_node(color)
    return @nodes_by_color[color] if @nodes_by_color.key?(color)

    @nodes_by_color[color] = Node.new(color)
  end
end

# Input examples:
#   dark turquoise bags
#   4 dark bronze bags
#   3 posh tan bags.
#   1 dotted blue bag
# Output: <num_bags | nil>, <color>
#        or nil, nil if contains "no other bags"
def parse_bag_description(bag_desc)
  _, num_bags, color = */^(\d*) ?([a-z ]+) bags?\.?$/.match(bag_desc)

  num = num_bags.empty? ? nil : num_bags.to_i
  Bag.new(num, color)
end

def parse_rule(rule)
  bag_input, linked_bags_input = rule.split(" contain ")
  bag = parse_bag_description(bag_input)

  return bag, [] if linked_bags_input == "no other bags."

  linked_bags = linked_bags_input
    .split(", ")
    .map { |linked_bag_input| parse_bag_description(linked_bag_input) }

  return bag, linked_bags
end

input_rules = input.map { |rule| parse_rule(rule) }

handy_haversacks = HandyHaversacks.new(input_rules)

# handy_haversacks.generate_graph_image("graph_small.png")

part1_reachable_nodes = handy_haversacks.shiny_gold_reachable_nodes

part1 = part1_reachable_nodes.size
puts "Part 1: #{part1}" # 101


part2 = handy_haversacks.num_bags_inside_shiny_gold_node
puts "Part 2: #{part2}" # 108636
