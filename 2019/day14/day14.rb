require 'pry'

# An edge between a chemical node and one of its required inputs.
class ReactionEdge
  attr_accessor :chem_node, :required_quantity

  def initialize(chem_node:, required_quantity:)
    @chem_node = chem_node
    @required_quantity = required_quantity

    raise "chem node and quantity are both required" if @chem_node.nil? || @required_quantity.nil?
  end
end

# Represents a single chemical node in the dependency graph
class ChemicalReactionNode
  # Unique code for this chemical
  attr_reader :code

  # Quantity generated for input (lowest increment possible)
  attr_accessor :output_quantity

  # Current available units (i.e. leftovers from previous reactions)
  attr_accessor :current_quantity

  def initialize(code:)
    @code = code

    @current_quantity = 0

    @required_inputs = []
  end

  # Add required input for this chemical to be generated
  def add_required_input(input_node, quantity)
    @required_inputs << ReactionEdge.new(chem_node: input_node, required_quantity: quantity)
  end

  # Generate a given quantity of this chemical.
  # The process is:
  #   For each required input, generate the required amount.
  # This generates a recursive call to all dependent nodes, with
  #   the base case being the OreNode.
  def generate(quantity:, output_node: nil)
    # The requested quantity
    needed_quantity = [quantity - @current_quantity, 0].max

    # Update current quantity with what we will use
    @current_quantity = [@current_quantity - quantity, 0].max

    # The multiple that we can generate
    multiple = output_quantity(output_node)

    # Generate enough to at least reach needed quantity
    # This implements the multiple rule
    generate_quantity = (needed_quantity.to_f / multiple).ceil * multiple

    # Make a call to generate new quantities, as we don't have enough in our current quantity.
    generate_new_quantity(generate_quantity)

    # Now that we have generated enough to cover, decrement the rest
    # Any leftovers will remain in @current_quantity
    @current_quantity -= needed_quantity
  end

  def generate_new_quantity(quantity)
    return if quantity.zero?

    @required_inputs.each do |reaction_edge|
      reaction_edge.chem_node.generate(
        quantity: reaction_edge.required_quantity * quantity / @output_quantity,
        output_node: self,
      )
    end
    @current_quantity += quantity
  end

  # Note that most nodes have only a single output, however this
  # method exists so OreNode can override it.
  def output_quantity(output_node)
    @output_quantity
  end
end

class OreNode < ChemicalReactionNode
  # Track quantity of ORE generated (for part 1)
  attr_reader :quantity_generated

  def initialize(code:)
    super

    @quantity_generated = 0

    # Hash of output nodes to the quantity we output
    @output_quantities = {}
  end

  def register_output(output_node, output_quantity)
    @output_quantities[output_node] = output_quantity
  end

  # Override output quantity for Ore, as it differs depending on output node
  def output_quantity(output_node)
    @output_quantities[output_node]
  end

  # Overrides method from superclass, as we can generate infinite Ore,
  # we just need to track it. Note that only valid quantities will be
  # passed to this method, as output_quantity method is used.
  def generate_new_quantity(quantity)
    @quantity_generated += quantity
    @current_quantity += quantity
  end
end

class Nanofactory
  def initialize(input_file)
    @input_file = input_file

    # Store reference to all chem nodes. Key is a chemical code (string),
    # value is an instance of a ChemicalReactionNode
    @chem_nodes = {}

    parse_input!
  end

  # Part 1: How much ORE required to produce ONE unit of FUEL?
  def ore_required
    # Trigger generation of everything required to build 1 FUEL
    fuel_node.generate(quantity: 1)

    # Report how many ORE it took to generate 1 FUEL
    ore_node.quantity_generated
  end

  def fuel_node
    raise "FUEL node missing!" unless @chem_nodes.has_key?("FUEL")
    @chem_nodes["FUEL"]
  end

  def ore_node
    raise "ORE node missing!" unless @chem_nodes.has_key?("ORE")
    @chem_nodes["ORE"]
  end

  private

  ## INPUT PARSING ##########################################################
  # Parses input file, and creates the nodes (i.e. reaction dependency graph)

  def parse_input!
    read_input.strip.split("\n").each { |reaction_str| parse_reaction!(reaction_str) }
  end

  def parse_reaction!(reaction_str)
    input_str, output_str = reaction_str.split(' => ')
    input_chems = parse_chemical_list(input_str)
    # There will always be only one output chemical
    output_chem = parse_chemical_list(output_str).first

    output_chem_node = find_or_create_chem_node(output_chem[:code])
    output_chem_node.output_quantity = output_chem[:quantity]

    input_chems.each do |input_chem|
      input_node = find_or_create_chem_node(input_chem[:code])
      output_chem_node.add_required_input(input_node, input_chem[:quantity])
      input_node.register_output(output_chem_node, input_chem[:quantity]) if input_node.is_a?(OreNode)
    end
  end

  def find_or_create_chem_node(code)
    return @chem_nodes[code] if @chem_nodes.has_key?(code)

    @chem_nodes[code] = case code
    when "ORE"
      OreNode.new(code: code)
    else
      ChemicalReactionNode.new(code: code)
    end
  end

  def parse_chemical_list(chem_list_str)
    chem_list_str.split(', ').map { |chem_str| parse_chemical(chem_str) }
  end

  def parse_chemical(chem_str)
    quantity_str, chem_code = chem_str.split(' ')
    { quantity: quantity_str.to_i, code: chem_code }
  end

  def read_input
    IO.read(@input_file)
  end
end

# Run only if run from console (not when included in specs)
if __FILE__ == $0
  nanofactory = Nanofactory.new('input')
  ore_required = nanofactory.ore_required
  puts "Part 1: #{ore_required} ORE required to create 1 FUEL" # 504284
end
